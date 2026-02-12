import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/caregiver_model.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../models/pet_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/constants.dart';

/// Screen for creating a new booking
class BookingFormScreen extends StatefulWidget {
  final CaregiverModel caregiver;
  final UserModel? userProfile;

  const BookingFormScreen({
    super.key,
    required this.caregiver,
    this.userProfile,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _specialInstructionsController = TextEditingController();

  String? _selectedPetId;
  String? _selectedServiceType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _durationHours = 1;

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

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Caregiver Info Card
              _buildCaregiverCard(),

              const SizedBox(height: 24),

              // Select Pet
              const Text(
                'Select Pet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Consumer<PetProvider>(
                builder: (context, petProvider, child) {
                  if (petProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pets = petProvider.pets;

                  if (pets.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please add a pet profile first',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedPetId,
                    decoration: InputDecoration(
                      hintText: 'Choose your pet',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: pets.map((pet) {
                      return DropdownMenuItem(
                        value: pet.petId,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: pet.photo != null
                                  ? NetworkImage(pet.photo!)
                                  : null,
                              child: pet.photo == null
                                  ? const Icon(Icons.pets, size: 16)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Text('${pet.name} (${pet.type})'),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPetId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a pet';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Select Service
              const Text(
                'Select Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.caregiver.servicesOffered.map((service) {
                  final isSelected = _selectedServiceType == service;
                  return ChoiceChip(
                    label: Text(_getServiceName(service)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedServiceType = selected ? service : null;
                      });
                    },
                    avatar: Icon(
                      _getServiceIcon(service),
                      size: 18,
                    ),
                  );
                }).toList(),
              ),
              if (_selectedServiceType == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a service',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Select Date
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Choose date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Select Time
              const Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Choose time',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedTime != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Duration
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: _durationHours > 1
                        ? () {
                            setState(() {
                              _durationHours--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_durationHours ${_durationHours == 1 ? "hour" : "hours"}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _durationHours < 12
                        ? () {
                            setState(() {
                              _durationHours++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Special Instructions
              const Text(
                'Special Instructions (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specialInstructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Any special care instructions for your pet...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hourly Rate:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          widget.caregiver.formattedRate,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Duration:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '$_durationHours ${_durationHours == 1 ? "hour" : "hours"}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${(widget.caregiver.hourlyRate * _durationHours).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Consumer<BookingProvider>(
                  builder: (context, bookingProvider, child) {
                    return ElevatedButton(
                      onPressed: bookingProvider.isLoading
                          ? null
                          : _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: bookingProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirm Booking',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaregiverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: widget.userProfile?.profilePhoto != null
                ? NetworkImage(widget.userProfile!.profilePhoto!)
                : null,
            child: widget.userProfile?.profilePhoto == null
                ? const Icon(Icons.person, size: 32)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userProfile?.name ?? 'Caregiver',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      widget.caregiver.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${widget.caregiver.experienceText}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Combine date and time
    final scheduledDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Create booking
    final booking = BookingModel(
      bookingId: '',
      ownerId: user.uid,
      caregiverId: widget.caregiver.caregiverId,
      petId: _selectedPetId!,
      serviceType: _selectedServiceType!,
      scheduledDate: scheduledDateTime,
      durationHours: _durationHours,
      totalAmount: widget.caregiver.hourlyRate * _durationHours,
      specialInstructions: _specialInstructionsController.text.trim().isNotEmpty
          ? _specialInstructionsController.text.trim()
          : null,
      createdAt: DateTime.now(),
    );

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final success = await bookingProvider.createBooking(booking);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingProvider.error ?? 'Failed to create booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'walking':
        return Icons.directions_walk;
      case 'daycare':
        return Icons.home;
      case 'overnight':
        return Icons.hotel;
      case 'training':
        return Icons.school;
      default:
        return Icons.pets;
    }
  }

  String _getServiceName(String service) {
    switch (service) {
      case 'walking':
        return 'Dog Walking';
      case 'daycare':
        return 'Pet Daycare';
      case 'overnight':
        return 'Overnight Stay';
      case 'training':
        return 'Pet Training';
      default:
        return service;
    }
  }
}
