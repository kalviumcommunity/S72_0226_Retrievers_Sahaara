import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';
import '../../services/image_service.dart';
import '../../services/location_service.dart';
import '../../widgets/custom_button.dart';

/// Screen for caregivers to add activity updates
class AddActivityScreen extends StatefulWidget {
  final String bookingId;
  final String petId;

  const AddActivityScreen({
    super.key,
    required this.bookingId,
    required this.petId,
  });

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImageService _imageService = ImageService();
  final LocationService _locationService = LocationService();

  String _selectedType = 'text';
  File? _selectedImage;
  bool _isSubmitting = false;
  bool _includeLocation = false;
  ActivityLocation? _currentLocation;

  final List<Map<String, dynamic>> _activityTypes = [
    {'id': 'text', 'name': 'Text Update', 'icon': Icons.text_fields},
    {'id': 'photo', 'name': 'Photo', 'icon': Icons.photo_camera},
    {'id': 'milestone', 'name': 'Milestone', 'icon': Icons.star},
    {'id': 'location', 'name': 'Location', 'icon': Icons.location_on},
  ];

  Future<void> _pickImage() async {
    final image = await _imageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _selectedType = 'photo';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLocation = ActivityLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        );
        _includeLocation = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location captured')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    }
  }

  Future<void> _submitActivity() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == 'photo' && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? photoUrl;
      if (_selectedImage != null) {
        photoUrl = await _imageService.uploadImage(
          _selectedImage!,
          'activities/${widget.bookingId}',
        );
      }

      final activity = ActivityModel(
        activityId: '',
        bookingId: widget.bookingId,
        caregiverId: user.uid,
        petId: widget.petId,
        type: _selectedType,
        description: _descriptionController.text.trim(),
        photoUrl: photoUrl,
        location: _includeLocation ? _currentLocation : null,
        timestamp: DateTime.now(),
      );

      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      final activityId = await activityProvider.createActivity(activity);

      setState(() => _isSubmitting = false);

      if (activityId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity added successfully!')),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(activityProvider.error ?? 'Failed to add activity'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
        title: const Text('Add Activity Update'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Activity Type Selection
            Text(
              'Activity Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _activityTypes.map((type) {
                final isSelected = _selectedType == type['id'];
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(type['name']),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type['id'];
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Photo Selection
            if (_selectedType == 'photo') ...[
              Text(
                'Photo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              if (_selectedImage != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No photo selected',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: Text(_selectedImage != null ? 'Change Photo' : 'Select Photo'),
              ),
              const SizedBox(height: 24),
            ],

            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What\'s happening with the pet?',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Location Toggle
            CheckboxListTile(
              title: const Text('Include Location'),
              subtitle: _currentLocation != null
                  ? Text(_currentLocation!.address ?? 'Location captured')
                  : const Text('Add current location to update'),
              value: _includeLocation,
              onChanged: (value) {
                if (value == true && _currentLocation == null) {
                  _getCurrentLocation();
                } else {
                  setState(() {
                    _includeLocation = value ?? false;
                  });
                }
              },
              secondary: const Icon(Icons.location_on),
            ),
            const SizedBox(height: 24),

            // Submit Button
            CustomButton(
              text: 'Post Update',
              onPressed: _isSubmitting ? null : _submitActivity,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
