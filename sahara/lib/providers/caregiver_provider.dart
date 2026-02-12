import 'package:flutter/foundation.dart';
import '../models/caregiver_model.dart';
import '../repositories/caregiver_repository.dart';

/// Provider for managing caregiver state
class CaregiverProvider extends ChangeNotifier {
  final CaregiverRepository _caregiverRepository = CaregiverRepository();

  List<CaregiverModel> _caregivers = [];
  List<CaregiverModel> _filteredCaregivers = [];
  CaregiverModel? _selectedCaregiver;
  bool _isLoading = false;
  String? _error;

  // Filter states
  String? _selectedService;
  String? _selectedPetType;
  double _minRating = 0.0;
  double _minPrice = 0.0;
  double _maxPrice = 2000.0;
  String _sortBy = 'rating'; // 'rating', 'price_low', 'price_high'

  // Getters
  List<CaregiverModel> get caregivers => _filteredCaregivers;
  CaregiverModel? get selectedCaregiver => _selectedCaregiver;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedService => _selectedService;
  String? get selectedPetType => _selectedPetType;
  double get minRating => _minRating;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  /// Load all verified caregivers
  Future<void> loadCaregivers() async {
    _setLoading(true);
    _error = null;

    try {
      _caregivers = await _caregiverRepository.getVerifiedCaregivers();
      _applyFilters();
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Load caregiver by ID
  Future<void> loadCaregiverById(String caregiverId) async {
    _setLoading(true);
    _error = null;

    try {
      _selectedCaregiver = await _caregiverRepository.getCaregiverById(caregiverId);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Search caregivers by service type
  Future<void> searchByService(String serviceType) async {
    _setLoading(true);
    _error = null;
    _selectedService = serviceType;

    try {
      _caregivers = await _caregiverRepository.searchByService(serviceType);
      _applyFilters();
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Search caregivers by pet type
  Future<void> searchByPetType(String petType) async {
    _setLoading(true);
    _error = null;
    _selectedPetType = petType;

    try {
      _caregivers = await _caregiverRepository.searchByPetType(petType);
      _applyFilters();
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Set service filter
  void setServiceFilter(String? service) {
    _selectedService = service;
    _applyFilters();
  }

  /// Set pet type filter
  void setPetTypeFilter(String? petType) {
    _selectedPetType = petType;
    _applyFilters();
  }

  /// Set rating filter
  void setRatingFilter(double rating) {
    _minRating = rating;
    _applyFilters();
  }

  /// Set price range filter
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  /// Set sort option
  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedService = null;
    _selectedPetType = null;
    _minRating = 0.0;
    _minPrice = 0.0;
    _maxPrice = 2000.0;
    _sortBy = 'rating';
    _applyFilters();
  }

  /// Apply filters to caregiver list
  void _applyFilters() {
    _filteredCaregivers = List.from(_caregivers);

    // Filter by service
    if (_selectedService != null) {
      _filteredCaregivers = _filteredCaregivers
          .where((c) => c.servicesOffered.contains(_selectedService))
          .toList();
    }

    // Filter by pet type
    if (_selectedPetType != null) {
      _filteredCaregivers = _filteredCaregivers
          .where((c) => c.petTypesHandled.contains(_selectedPetType))
          .toList();
    }

    // Filter by rating
    if (_minRating > 0) {
      _filteredCaregivers = _filteredCaregivers
          .where((c) => c.rating >= _minRating)
          .toList();
    }

    // Filter by price range
    _filteredCaregivers = _filteredCaregivers
        .where((c) => c.hourlyRate >= _minPrice && c.hourlyRate <= _maxPrice)
        .toList();

    // Sort
    switch (_sortBy) {
      case 'rating':
        _filteredCaregivers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        _filteredCaregivers.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
      case 'price_high':
        _filteredCaregivers.sort((a, b) => b.hourlyRate.compareTo(a.hourlyRate));
        break;
    }

    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (_selectedService != null) count++;
    if (_selectedPetType != null) count++;
    if (_minRating > 0) count++;
    if (_minPrice > 0 || _maxPrice < 2000) count++;
    return count;
  }
}
