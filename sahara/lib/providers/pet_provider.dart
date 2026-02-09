import 'package:flutter/foundation.dart';
import '../models/pet_model.dart';
import '../repositories/pet_repository.dart';

/// Provider for managing pet data state
class PetProvider extends ChangeNotifier {
  final PetRepository _petRepository = PetRepository();

  List<PetModel> _pets = [];
  PetModel? _selectedPet;
  bool _isLoading = false;
  String? _error;

  List<PetModel> get pets => _pets;
  PetModel? get selectedPet => _selectedPet;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all pets for an owner
  Future<void> loadOwnerPets(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pets = await _petRepository.getOwnerPets(ownerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load a single pet
  Future<void> loadPet(String petId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedPet = await _petRepository.getPet(petId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new pet
  Future<bool> addPet(PetModel pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _petRepository.createPet(pet);
      // Reload pets
      await loadOwnerPets(pet.ownerId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update a pet
  Future<bool> updatePet(String petId, PetModel pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _petRepository.updatePet(petId, pet);
      // Reload pets
      await loadOwnerPets(pet.ownerId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a pet
  Future<bool> deletePet(String petId, String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _petRepository.deletePet(petId);
      // Reload pets
      await loadOwnerPets(ownerId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Select a pet
  void selectPet(PetModel pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear data
  void clear() {
    _pets = [];
    _selectedPet = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
