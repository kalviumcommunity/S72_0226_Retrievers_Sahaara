import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

/// Caregiver profile setup screen
class CaregiverProfileSetup extends StatefulWidget {
  const CaregiverProfileSetup({super.key});

  @override
  State<CaregiverProfileSetup> createState() => _CaregiverProfileSetupState();
}

class _CaregiverProfileSetupState extends State<CaregiverProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  
  final List<String> _selectedServices = [];
  final List<String> _selectedPetTypes = [];
  bool _isLoading = false;

  final List<Map<String, dynamic>> _availableServices = [
    {'id': AppConstants.serviceWalking, 'name': 'Walking', 'icon': Icons.directions_walk},
    {'id': AppConstants.serviceDaycare, 'name': 'Daycare', 'icon': Icons.home},
    {'id': AppConstants.serviceOvernight, 'name': 'Overnight', 'icon': Icons.hotel},
    {'id': AppConstants.serviceTraining, 'name': 'Training', 'icon': Icons.school},
  ];

  @override
  void dispose() {
    _bioController.dispose();
    _experienceController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Indicator
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey[200],
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Professional Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Tell pet owners about your experience',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Bio
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Bio *',
                    hintText: 'Tell us about yourself and your experience with pets...',
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateBio,
                ),
                
                const SizedBox(height: 16),
                
                // Experience Years
                TextFormField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Years of Experience *',
                    hintText: '3',
                    prefixIcon: const Icon(Icons.work_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateExperienceYears,
                ),
                
                const SizedBox(height: 16),
                
                // Hourly Rate
                TextFormField(
                  controller: _hourlyRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Hourly Rate (₹) *',
                    hintText: '400',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: 'Recommended: ₹300 - ₹800 per hour',
                  ),
                  validator: Validators.validateHourlyRate,
                ),
                
                const SizedBox(height: 24),
                
                // Services Offered
                Text(
                  'Services Offered *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableServices.map((service) {
                    final isSelected = _selectedServices.contains(service['id']);
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            service['icon'],
                            size: 18,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(service['name']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedServices.add(service['id']);
                          } else {
                            _selectedServices.remove(service['id']);
                          }
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    );
                  }).toList(),
                ),
                
                if (_selectedServices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please select at least one service',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Pet Types Handled
                Text(
                  'Pet Types You Handle *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PetTypes.all.map((petType) {
                    final isSelected = _selectedPetTypes.contains(petType['id']);
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pets,
                            size: 18,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(petType['name']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPetTypes.add(petType['id']);
                          } else {
                            _selectedPetTypes.remove(petType['id']);
                          }
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.secondary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    );
                  }).toList(),
                ),
                
                if (_selectedPetTypes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please select at least one pet type',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your profile will be reviewed before going live',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Complete Setup',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: _handleSkip,
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one service'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedPetTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one pet type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Create caregiver profile in Firestore
      await FirebaseFirestore.instance
          .collection('caregivers')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'bio': _bioController.text.trim(),
        'experienceYears': int.parse(_experienceController.text),
        'hourlyRate': double.parse(_hourlyRateController.text),
        'servicesOffered': _selectedServices,
        'petTypesHandled': _selectedPetTypes,
        'verificationStatus': AppConstants.verificationPending,
        'isActive': true,
        'stats': {
          'totalBookings': 0,
          'completedBookings': 0,
          'cancelledBookings': 0,
          'averageRating': 0.0,
          'totalReviews': 0,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile created! Pending verification.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen (TODO: implement home screen)
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSkip() {
    // Navigate to home screen (TODO: implement home screen)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
