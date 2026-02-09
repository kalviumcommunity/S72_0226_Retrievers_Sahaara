import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../repositories/pet_repository.dart';
import '../../services/image_service.dart';
import '../../models/pet_model.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

/// Form for creating/editing pet profiles
class PetProfileForm extends StatefulWidget {
  final PetModel? existingPet;

  const PetProfileForm({
    super.key,
    this.existingPet,
  });

  @override
  State<PetProfileForm> createState() => _PetProfileFormState();
}

class _PetProfileFormState extends State<PetProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _specialNeedsController = TextEditingController();
  final _medicalInfoController = TextEditingController();
  final _petRepository = PetRepository();
  final _imageService = ImageService();

  String _selectedType = AppConstants.petTypeDog;
  String _selectedGender = 'male';
  bool _isLoading = false;
  File? _selectedImage;
  String? _petPhotoUrl;

  @override
  void initState() {
    super.initState();
    if (widget.existingPet != null) {
      _loadExistingPet();
    }
  }

  void _loadExistingPet() {
    final pet = widget.existingPet!;
    _nameController.text = pet.name;
    _breedController.text = pet.breed;
    _ageController.text = pet.age.toString();
    _weightController.text = pet.weight.toString();
    _specialNeedsController.text = pet.specialNeeds ?? '';
    _medicalInfoController.text = pet.medicalInfo ?? '';
    _selectedType = pet.type;
    _selectedGender = pet.gender;
    _petPhotoUrl = pet.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _specialNeedsController.dispose();
    _medicalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pet Profile' : 'Add Your Pet'),
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
                // Progress Indicator (only for new pets)
                if (!isEditing) ...[
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[200],
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Title
                Text(
                  isEditing ? 'Update Pet Details' : 'Tell us about your pet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Pet Photo
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_petPhotoUrl != null
                                ? NetworkImage(_petPhotoUrl!)
                                : null) as ImageProvider?,
                        child: _selectedImage == null && _petPhotoUrl == null
                            ? Icon(
                                Icons.pets,
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
                    label: Text(_selectedImage != null || _petPhotoUrl != null
                        ? 'Change Pet Photo'
                        : 'Upload Pet Photo'),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Pet Name
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Pet Name *',
                    hintText: 'e.g., Bruno',
                    prefixIcon: const Icon(Icons.pets),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateName,
                ),
                
                const SizedBox(height: 16),
                
                // Pet Type
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Pet Type *',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: PetTypes.all.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['id'] as String,
                      child: Text(type['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Breed
                TextFormField(
                  controller: _breedController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Breed *',
                    hintText: _selectedType == AppConstants.petTypeDog
                        ? 'e.g., Golden Retriever'
                        : 'e.g., Persian',
                    prefixIcon: const Icon(Icons.info_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => Validators.validateRequired(value, 'Breed'),
                ),
                
                const SizedBox(height: 16),
                
                // Age and Weight Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age (years) *',
                          hintText: '2',
                          prefixIcon: const Icon(Icons.cake_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: Validators.validateAge,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg) *',
                          hintText: '30',
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: Validators.validateWeight,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Gender
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender *',
                    prefixIcon: const Icon(Icons.wc_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Special Needs
                TextFormField(
                  controller: _specialNeedsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Special Needs (Optional)',
                    hintText: 'e.g., Scared of loud noises, prefers quiet parks',
                    prefixIcon: const Icon(Icons.warning_amber_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Medical Info
                TextFormField(
                  controller: _medicalInfoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Medical Information (Optional)',
                    hintText: 'e.g., Vaccinated, no allergies',
                    prefixIcon: const Icon(Icons.medical_information_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEditing ? 'Update Pet' : 'Add Pet',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                if (!isEditing) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _handleSkip,
                    child: const Text('Skip for now'),
                  ),
                ],
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
            if (_selectedImage != null || _petPhotoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _petPhotoUrl = null;
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

  Future<void> _handlePhotoUpload() async {
    await _showImageSourceDialog();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Upload pet photo if selected
      String? photoUrl = _petPhotoUrl;
      if (_selectedImage != null) {
        final petId = widget.existingPet?.petId ?? DateTime.now().millisecondsSinceEpoch.toString();
        photoUrl = await _imageService.uploadImage(
          imageFile: _selectedImage!,
          path: 'pets/$petId/photo.jpg',
        );
      }

      final pet = PetModel(
        petId: widget.existingPet?.petId ?? '',
        ownerId: user.uid,
        name: _nameController.text.trim(),
        type: _selectedType,
        breed: _breedController.text.trim(),
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        gender: _selectedGender,
        photo: photoUrl,
        specialNeeds: _specialNeedsController.text.trim().isEmpty
            ? null
            : _specialNeedsController.text.trim(),
        medicalInfo: _medicalInfoController.text.trim().isEmpty
            ? null
            : _medicalInfoController.text.trim(),
        createdAt: widget.existingPet?.createdAt ?? DateTime.now(),
      );

      if (widget.existingPet != null) {
        // Update existing pet
        await _petRepository.updatePet(widget.existingPet!.petId, pet);
      } else {
        // Create new pet
        await _petRepository.createPet(pet);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingPet != null
                ? 'Pet profile updated!'
                : 'Pet profile created!'),
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
