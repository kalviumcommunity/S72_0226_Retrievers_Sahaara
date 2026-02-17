import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  static final PhoneAuthService _instance = PhoneAuthService._internal();

  factory PhoneAuthService() {
    return _instance;
  }

  PhoneAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  /// Start phone verification
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(PhoneAuthCredential) onVerificationComplete,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          onVerificationComplete(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Sign in with phone credential
  Future<User?> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Sign in with OTP code
  Future<User?> signInWithOTP(String smsCode) async {
    try {
      if (_verificationId == null) {
        throw Exception('Verification ID not set');
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      return await signInWithPhoneCredential(credential);
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  /// Get verification ID
  String? get verificationId => _verificationId;

  /// Clear verification state
  void clearVerification() {
    _verificationId = null;
    _resendToken = null;
  }
}
