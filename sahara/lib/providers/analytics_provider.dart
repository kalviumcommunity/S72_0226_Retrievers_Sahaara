import 'package:flutter/foundation.dart';
import '../models/analytics_model.dart';
import '../repositories/analytics_repository.dart';

/// Provider for analytics state management
class AnalyticsProvider with ChangeNotifier {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  AnalyticsModel? _analytics;
  List<PetAnalytics> _petAnalytics = [];
  List<ClientAnalytics> _clientAnalytics = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  AnalyticsModel? get analytics => _analytics;
  List<PetAnalytics> get petAnalytics => _petAnalytics;
  List<ClientAnalytics> get clientAnalytics => _clientAnalytics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load owner analytics
  Future<void> loadOwnerAnalytics(String ownerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _analytics = await _analyticsRepository.getOwnerAnalytics(ownerId);
      _petAnalytics = await _analyticsRepository.getPetAnalytics(ownerId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load caregiver analytics
  Future<void> loadCaregiverAnalytics(String caregiverId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _analytics =
          await _analyticsRepository.getCaregiverAnalytics(caregiverId);
      _clientAnalytics =
          await _analyticsRepository.getClientAnalytics(caregiverId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear analytics data
  void clearAnalytics() {
    _analytics = null;
    _petAnalytics = [];
    _clientAnalytics = [];
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
