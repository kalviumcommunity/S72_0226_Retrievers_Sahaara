import 'package:flutter/foundation.dart';
import '../repositories/caregiver_repository.dart';

/// Provider for caregiver state management
class CaregiverProvider with ChangeNotifier {
  final CaregiverRepository _repository = CaregiverRepository();

  List<Map<String, dynamic>> _caregivers = [];
  List<Map<String, dynamic>> _filteredCaregivers = [];
  bool _isLoading = false;
  String? _error;

  // Filter state
  List<String> _selectedServices = [];
  List<String> _selectedPetTypes = [];
  double? _minRating;
  double? _maxHourlyRate;
  int? _minExperience;

  List<Map<String, dynamic>> get caregivers => _filteredCaregivers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get selectedServices => _selectedServices;
  List<String> get selectedPetTypes => _selectedPetTypes;
  double? get minRating => _minRating;
  double? get maxHourlyRate => _maxHourlyRate;
  int? get minExperience => _minExperience;

  /// Load all caregivers
  Future<void> loadCaregivers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _caregivers = await _repository.getAllCaregiversWithUserDetails();
      _filteredCaregivers = List.from(_caregivers);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply filters to caregivers
  Future<void> applyFilters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _filteredCaregivers = await _repository.filterCaregivers(
        services: _selectedServices.isNotEmpty ? _selectedServices : null,
        petTypes: _selectedPetTypes.isNotEmpty ? _selectedPetTypes : null,
        minRating: _minRating,
        maxHourlyRate: _maxHourlyRate,
        minExperience: _minExperience,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update service filters
  void updateServiceFilters(List<String> services) {
    _selectedServices = services;
    notifyListeners();
  }

  /// Update pet type filters
  void updatePetTypeFilters(List<String> petTypes) {
    _selectedPetTypes = petTypes;
    notifyListeners();
  }

  /// Update rating filter
  void updateRatingFilter(double? rating) {
    _minRating = rating;
    notifyListeners();
  }

  /// Update hourly rate filter
  void updateHourlyRateFilter(double? rate) {
    _maxHourlyRate = rate;
    notifyListeners();
  }

  /// Update experience filter
  void updateExperienceFilter(int? years) {
    _minExperience = years;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedServices = [];
    _selectedPetTypes = [];
    _minRating = null;
    _maxHourlyRate = null;
    _minExperience = null;
    _filteredCaregivers = List.from(_caregivers);
    notifyListeners();
  }

  /// Get caregiver with user details by ID
  Future<Map<String, dynamic>?> getCaregiverDetails(String caregiverId) async {
    try {
      return await _repository.getCaregiverWithUserDetails(caregiverId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
