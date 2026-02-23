import 'package:flutter/foundation.dart';
import '../models/favorite_model.dart';
import '../repositories/favorite_repository.dart';

/// Provider for favorites state management
class FavoriteProvider with ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  List<String> _favoriteCaregiverIds = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<String> get favoriteCaregiverIds => _favoriteCaregiverIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Check if caregiver is favorited
  bool isFavorite(String caregiverId) {
    return _favoriteCaregiverIds.contains(caregiverId);
  }

  /// Load favorite caregiver IDs
  Future<void> loadFavorites(String ownerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _favoriteCaregiverIds =
          await _favoriteRepository.getFavoriteCaregiverIds(ownerId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add caregiver to favorites
  Future<bool> addFavorite(String ownerId, String caregiverId) async {
    try {
      await _favoriteRepository.addFavorite(ownerId, caregiverId);

      // Update local list
      if (!_favoriteCaregiverIds.contains(caregiverId)) {
        _favoriteCaregiverIds.add(caregiverId);
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove caregiver from favorites
  Future<bool> removeFavorite(String ownerId, String caregiverId) async {
    try {
      await _favoriteRepository.removeFavorite(ownerId, caregiverId);

      // Update local list
      _favoriteCaregiverIds.remove(caregiverId);
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String ownerId, String caregiverId) async {
    if (isFavorite(caregiverId)) {
      return await removeFavorite(ownerId, caregiverId);
    } else {
      return await addFavorite(ownerId, caregiverId);
    }
  }

  /// Clear favorites
  void clearFavorites() {
    _favoriteCaregiverIds = [];
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
