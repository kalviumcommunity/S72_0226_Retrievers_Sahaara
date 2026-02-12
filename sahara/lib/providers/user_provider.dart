import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// Provider for managing user profile state
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _currentUser;
  final Map<String, UserModel> _userCache = {}; // Cache for multiple users
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get user by ID from cache
  UserModel? getUserById(String userId) {
    return _userCache[userId];
  }

  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    // Check cache first
    if (_userCache.containsKey(userId)) {
      _currentUser = _userCache[userId];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.getUserProfile(userId);
      if (_currentUser != null) {
        _userCache[userId] = _currentUser!;
      }
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
