import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../repositories/user_repository.dart';
import '../../services/image_service.dart';
import '../../services/location_service.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../models/user_model.dart';
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
  final _imageService = ImageService();
  final _locationService = LocationService();
  bool _isLoading = false;
  File? _selectedImage;
  String? _profilePhotoUrl;

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
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null) as ImageProvider?,
                        child: _selectedImage == null && user?.photoURL == null
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
                        child: GestureDetector(
                          onTap: _showImageSourceDialog,
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
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Center(
                  child: TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.upload),
                    label: Text(_selectedImage != null ? 'Change Photo' : 'Upload Photo'),
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: _getCurrentLocation,
                      tooltip: 'Use current location',
                    ),
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

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera);
              },
            ),
            if (_selectedImage != null || _profilePhotoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _profilePhotoUrl = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imageService.pickImage(
        showDialog: false,
        source: source,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      final locationData = await _locationService.getCurrentLocationWithAddress();
      
      if (mounted) {
        setState(() {
          _addressController.text = locationData['address'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location detected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
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

  Future<void> _handlePhotoUpload() async {
    await _showImageSourceDialog();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Upload profile photo if selected
      String? photoUrl;
      if (_selectedImage != null) {
        photoUrl = await _imageService.uploadImage(
          imageFile: _selectedImage!,
          path: 'users/${user.uid}/profile.jpg',
        );
      }

      // Get coordinates from address
      GeoPoint? geopoint;
      try {
        geopoint = await _locationService.getCoordinatesFromAddress(
          _addressController.text.trim(),
        );
      } catch (e) {
        // If geocoding fails, use default coordinates
        geopoint = const GeoPoint(0, 0);
      }

      // Update user profile
      await _userRepository.updateUserProfile(
        userId: user.uid,
        phone: _phoneController.text.trim(),
        profilePhoto: photoUrl,
        location: UserLocation(
          address: _addressController.text.trim(),
          geopoint: geopoint ?? const GeoPoint(0, 0),
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
