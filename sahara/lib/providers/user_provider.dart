import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// Provider for managing user profile state
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.getUserProfile(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profilePhoto,
    UserLocation? location,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userRepository.updateUserProfile(
        userId: userId,
        name: name,
        phone: phone,
        profilePhoto: profilePhoto,
        location: location,
      );

      // Reload profile
      await loadUserProfile(userId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear user data
  void clear() {
    _currentUser = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
