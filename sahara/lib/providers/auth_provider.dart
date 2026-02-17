import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Sign up with email and password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        role: role,
      );

      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle({required String role}) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authRepository.signInWithGoogle(role: role);

      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _error = null;

    try {
      await _authRepository.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _error = null;

    try {
      await _authRepository.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Sign in with phone number
  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(dynamic) onVerificationComplete,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _authRepository.signInWithPhone(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onError: (error) {
          _error = error;
          onError(error);
        },
        onVerificationComplete: onVerificationComplete,
      );
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Verify OTP
  Future<bool> verifyOTP({
    required String otp,
    required String name,
    required String role,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authRepository.verifyOTP(
        otp: otp,
        name: name,
        role: role,
      );
      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
