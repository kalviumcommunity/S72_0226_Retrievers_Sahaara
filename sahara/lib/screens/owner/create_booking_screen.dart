import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

/// Screen for creating a new booking
class CreateBookingScreen extends StatefulWidget {
  final String caregiverId;
  final double hourlyRate;

  const CreateBookingScreen({
    super.key,
    required this.caregiverId,
    required this.hourlyRate,
  });

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _instructionsController = TextEditingController();
  
  String? _selectedPetId;
  String? _selectedServiceType;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      await petProvider.loadOwnerPets(user.uid);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  double _calculateTotal() {
    if (_startDate == null || _endDate == null || _startTime == null || _endTime == null) {
      return 0;
    }

    final start = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final end = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final hours = end.difference(start).inHours;
    return hours * widget.hourlyRate;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pet')),
      );
      return;
    }
    if (_selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service type')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final start = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final end = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final booking = BookingModel(
      bookingId: '',
      ownerId: user.uid,
      caregiverId: widget.caregiverId,
      petId: _selectedPetId!,
      serviceType: _selectedServiceType!,
      startDate: start,
      endDate: end,
      status: AppConstants.bookingStatusPending,
      totalAmount: _calculateTotal(),
      specialInstructions: _instructionsController.text.trim(),
      createdAt: DateTime.now(),
    );

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final bookingId = await bookingProvider.createBooking(booking);

    setState(() => _isSubmitting = false);

    if (bookingId != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request sent successfully!')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.error ?? 'Failed to create booking'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Pet Selection
            Text(
              'Select Pet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Consumer<PetProvider>(
              builder: (context, petProvider, child) {
                if (petProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pets = petProvider.pets;
                if (pets.isEmpty) {
                  return const Text('No pets found. Please add a pet first.');
                }

                return DropdownButtonFormField<String>(
                  value: _selectedPetId,
                  decoration: const InputDecoration(
                    hintText: 'Choose a pet',
                  ),
                  items: pets.map((pet) {
                    return DropdownMenuItem(
                      value: pet.petId,
                      child: Text('${pet.name} (${pet.breed})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPetId = value);
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a pet';
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Service Type
            Text(
              'Service Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ServiceTypes.all.map((service) {
                final isSelected = _selectedServiceType == service['id'];
                return ChoiceChip(
                  label: Text(service['name']),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedServiceType = selected ? service['id'] : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Start Date & Time
            Text(
              'Start Date & Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate != null
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context, true),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _startTime != null
                          ? _startTime!.format(context)
                          : 'Select Time',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // End Date & Time
            Text(
              'End Date & Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _endDate != null
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context, false),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _endTime != null
                          ? _endTime!.format(context)
                          : 'Select Time',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Special Instructions
            Text(
              'Special Instructions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _instructionsController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Any special requirements or instructions...',
              ),
            ),
            const SizedBox(height: 24),

            // Total Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${_calculateTotal().toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            CustomButton(
              text: 'Send Booking Request',
              onPressed: _isSubmitting ? null : _submitBooking,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }
}
