import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google Sign-In Service
class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();

  factory GoogleSignInService() {
    return _instance;
  }

  GoogleSignInService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current signed-in user
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Check if user is currently signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get the current sign-in account
  GoogleSignInAccount? get signInAccount => _googleSignIn.currentUser;

  /// Sign in with Google
  /// Returns the GoogleSignInAccount if successful, null if cancelled
  Future<GoogleSignInAccount?> signIn() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      return googleUser;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Get Google authentication credentials for Firebase
  /// Should be called after signIn()
  Future<OAuthCredential?> getCredentials() async {
    try {
      final currentUser = _googleSignIn.currentUser;
      if (currentUser == null) {
        throw Exception('User not signed in');
      }

      final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain authentication tokens');
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return credential;
    } catch (e) {
      throw Exception('Failed to get Google credentials: $e');
    }
  }

  /// Authenticate with Firebase using Google credentials
  /// Returns the FirebaseUser if successful
  Future<User?> authenticateWithFirebase() async {
    try {
      final credential = await getCredentials();
      if (credential == null) {
        return null;
      }

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to authenticate with Firebase: $e');
    }
  }

  /// Sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Disconnect Google account from the app
  /// This will require re-authentication on next sign-in
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      throw Exception('Failed to disconnect Google account: $e');
    }
  }

  /// Get user profile information
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final currentUser = _googleSignIn.currentUser;
      if (currentUser == null) {
        return null;
      }

      return {
        'id': currentUser.id,
        'email': currentUser.email,
        'displayName': currentUser.displayName,
        'photoUrl': currentUser.photoUrl,
        'serverAuthCode': currentUser.serverAuthCode,
      };
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Handle authentication errors
  static String handleError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred during Google Sign-In';
  }
}
