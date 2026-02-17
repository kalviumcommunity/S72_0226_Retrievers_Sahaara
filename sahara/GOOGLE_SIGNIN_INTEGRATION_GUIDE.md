# Google Sign-In Integration Guide

## Overview

This guide explains how to set up and use Google Sign-In authentication in the Sahara app.

## Features

✅ Google authentication with Firebase  
✅ Automatic user profile creation  
✅ Role-based user management  
✅ Secure credential handling  
✅ Error handling and validation  
✅ Loading states and UI feedback  

## Architecture

### Components

**1. GoogleSignInService** (`lib/services/google_sign_in_service.dart`)
- Singleton service for Google Sign-In operations
- Handles authentication flow
- Manages user sessions
- Provides credential exchange for Firebase

**2. GoogleSignInButton** (`lib/widgets/google_sign_in_button.dart`)
- Reusable UI component
- Two variants: outlined (default) and filled
- Loading state support
- Icon with fallback
- Full width and compact options

**3. AuthRepository** (`lib/repositories/auth_repository.dart`)
- Firebase integration
- User document creation in Firestore
- Last active tracking
- Error handling

**4. AuthProvider** (`lib/providers/auth_provider.dart`)
- State management using Provider
- Sign-in method delegation
- Loading and error states
- User session listening

## Setup Instructions

### Prerequisites

1. **Firebase Project**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Create a new project (or use existing)
   - Enable Google Sign-In in Authentication

2. **Google Cloud Console**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create OAuth 2.0 credentials
   - Download credentials JSON

3. **Android Setup**
   - See `ANDROID_GOOGLE_SIGNIN_CONFIG.md`
   - Get SHA-1 fingerprint
   - Add to Firebase Console
   - Configure strings.xml

4. **iOS Setup**
   - See `IOS_GOOGLE_SIGNIN_CONFIG.md`
   - Download GoogleService-Info.plist
   - Update Info.plist
   - Configure URL schemes

### Step-by-Step Configuration

#### 1. Firebase Console Setup

```bash
# In Firebase Console:
1. Select your Sahara project
2. Go to Authentication
3. Click "Sign-in method"
4. Click "Google"
5. Enable it
6. Copy the Web Client ID
```

#### 2. Android Configuration

```bash
# Get SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android

# Add to Firebase Console:
# Project Settings > Your App > SHA certificate fingerprints
```

**Update strings.xml:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="google_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
</resources>
```

#### 3. iOS Configuration

```bash
# Download GoogleService-Info.plist from Firebase
# Place in ios/Runner/ directory
# Add to Xcode project (Runner target)

# Update Info.plist:
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_PROJECT_ID.apps.googleusercontent.com</string>
        </array>
    </dict>
</array>

<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
```

#### 4. Dependencies

All required dependencies are already in `pubspec.yaml`:
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.16.0
google_sign_in: ^6.2.1
cloud_firestore: ^4.14.0
provider: ^6.1.1
```

## Usage

### Basic Implementation

```dart
// In your login screen
import 'package:provider/provider.dart';
import 'package:sahara/providers/auth_provider.dart';
import 'package:sahara/widgets/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  final String role;

  const LoginScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return GoogleSignInButton(
          onPressed: () async {
            final success = await authProvider.signInWithGoogle(role: role);
            if (success) {
              // Navigate to home
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            }
          },
          isLoading: authProvider.isLoading,
        );
      },
    );
  }
}
```

### Using GoogleSignInService Directly

```dart
import 'package:sahara/services/google_sign_in_service.dart';

final googleService = GoogleSignInService();

// Sign in
final googleUser = await googleService.signIn();

// Get profile
final profile = await googleService.getUserProfile();

// Get credentials for Firebase
final credential = await googleService.getCredentials();

// Sign out
await googleService.signOut();
```

## Button Variants

### Full Width Button (Default)

```dart
GoogleSignInButton(
  onPressed: _handleGoogleSignIn,
  isLoading: isLoading,
  text: 'Continue with Google',
  variant: ButtonVariant.outlined,
)
```

### Filled Button

```dart
GoogleSignInButton(
  onPressed: _handleGoogleSignIn,
  isLoading: isLoading,
  variant: ButtonVariant.filled,
)
```

### Compact Icon Button

```dart
GoogleSignInIconButton(
  onPressed: _handleGoogleSignIn,
  isLoading: isLoading,
  size: 48,
)
```

## Error Handling

```dart
try {
  final success = await authProvider.signInWithGoogle(role: 'owner');
  
  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.error ?? 'Sign-in failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
} catch (e) {
  print('Error: $e');
}
```

## Firebase Firestore User Document

When a user signs in with Google, the following document is created:

```json
{
  "userId": "firebase-uid",
  "email": "user@example.com",
  "name": "User Name",
  "role": "owner|caregiver",
  "phone": "",
  "phoneVerified": false,
  "profilePhoto": null,
  "location": null,
  "createdAt": "2026-02-17T...",
  "lastActive": "2026-02-17T..."
}
```

## Best Practices

1. **Always use Consumer or Provider.listen**
   - Scope auth operations with Consumer
   - Listen to auth state changes

2. **Handle Loading States**
   - Disable buttons during loading
   - Show progress indicators
   - Provide user feedback

3. **Error Messages**
   - Display user-friendly messages
   - Log errors for debugging
   - Handle specific Firebase errors

4. **Session Management**
   - Check authentication state on app launch
   - Handle session expiry gracefully
   - Implement auto-logout if needed

5. **Security**
   - Never expose credentials
   - Use HTTPS only
   - Validate user input
   - Implement rate limiting

## Troubleshooting

### "Error: INVALID_CLIENT"
- Check Client ID in Android strings.xml
- Verify SHA-1 fingerprint in Firebase Console
- Ensure Web Client ID is used (not Android Client ID)

### iOS: "Nil URL scheme"
- Add CFBundleURLTypes to Info.plist
- Check format: `com.googleusercontent.apps.xxx.apps.googleusercontent.com`
- Ensure GoogleService-Info.plist is in target

### Android: "User cancelled"
- This is normal - user chose to cancel sign-in
- Provide clear UI for retry

### "Permission Denied"
- Check iOS capabilities (Sign in with Apple)
- Verify Android permissions in AndroidManifest.xml
- Ensure `android.permission.INTERNET` is declared

### Emulator Issues
- Use Android Emulator with Google Play Services
- iOS Simulator may have limitations with Google Sign-In
- Test on physical devices for best results

## Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sahara/services/google_sign_in_service.dart';

void main() {
  group('GoogleSignInService', () {
    test('should return null if user cancels sign-in', () async {
      // Test implementation
    });

    test('should get credentials successfully', () async {
      // Test implementation
    });
  });
}
```

### Widget Tests

```dart
testWidgets('GoogleSignInButton should show loading', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: GoogleSignInButton(
        onPressed: () {},
        isLoading: true,
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Security Considerations

1. **Client ID Management**
   - Never hardcode sensitive IDs
   - Use environment variables or Firebase Console
   - Restrict API key usage

2. **Credential Handling**
   - Access tokens are short-lived
   - ID tokens should not be reused
   - Always refresh when needed

3. **User Data**
   - Validate user email before use
   - Hash sensitive information in Firestore
   - Use Firestore Security Rules

4. **Network Security**
   - Always use HTTPS
   - Implement SSL pinning
   - Monitor suspicious activities

## Next Steps

1. ✅ Implement Google Sign-In service
2. ✅ Add button widget
3. ✅ Configure Android and iOS
4. ⬜ Test on physical devices
5. ⬜ Implement Sign-Out functionality
6. ⬜ Add profile completion flow
7. ⬜ Implement "Sign in with Apple" (iOS)

## References

- [Firebase Authentication Documentation](https://firebase.flutter.dev/docs/auth/overview)
- [Google Sign-In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Firebase Console](https://console.firebase.google.com/)

## Support

For issues or questions:
1. Check Firebase Console logs
2. Enable Debug Mode in GoogleSignInService
3. Review platform-specific logs (Logcat for Android, Xcode console for iOS)
4. Check Firebase documentation

---

**Last Updated:** February 17, 2026  
**Status:** ✅ Ready for Implementation
