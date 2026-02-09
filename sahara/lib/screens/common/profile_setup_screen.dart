import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/user_repository.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../owner/pet_profile_form.dart';
import '../caregiver/caregiver_profile_setup.dart';

/// Profile setup screen for completing user profile after signup
class ProfileSetupScreen extends StatefulWidget {
  final String role;

  const ProfileSetupScreen({
    super.key,
    required this.role,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _userRepository = UserRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
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
                  value: 0.5,
                  backgroundColor: Colors.grey[200],
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Almost There!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Complete your profile to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Profile Photo Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Center(
                  child: TextButton.icon(
                    onPressed: _handlePhotoUpload,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Photo'),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Name Field (Read-only, from auth)
                TextFormField(
                  initialValue: user?.displayName ?? '',
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Email Field (Read-only, from auth)
                TextFormField(
                  initialValue: user?.email ?? '',
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+91 XXXXX XXXXX',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validatePhone,
                ),
                
                const SizedBox(height: 16),
                
                // Address Field
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your address',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => Validators.validateRequired(value, 'Address'),
                ),
                
                const SizedBox(height: 32),
                
                // Continue Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Skip for now
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

  Future<void> _handlePhotoUpload() async {
    // TODO: Implement photo upload with image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo upload will be implemented with image_picker'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Update user profile
      await _userRepository.updateUserProfile(
        userId: user.uid,
        phone: _phoneController.text.trim(),
        location: UserLocation(
          address: _addressController.text.trim(),
          geopoint: const GeoPoint(0, 0), // TODO: Get actual location
        ),
      );

      if (mounted) {
        // Navigate based on role
        if (widget.role == AppConstants.roleOwner) {
          // Navigate to Pet Profile Form
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PetProfileForm(),
            ),
          );
        } else {
          // Navigate to Caregiver Profile Setup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CaregiverProfileSetup(),
            ),
          );
        }
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
    // Navigate based on role without saving
    if (widget.role == AppConstants.roleOwner) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PetProfileForm(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CaregiverProfileSetup(),
        ),
      );
    }
  }
}
