// ANDROID CONFIGURATION FOR GOOGLE SIGN-IN
// ==========================================

// File: android/app/build.gradle
// Dependencies are already configured in pubspec.yaml

/*
 * Ensure your app/build.gradle has:
 * - Google Play Services
 * - Firebase dependencies
 * 
 * Example:
 * dependencies {
 *   implementation 'com.google.android.gms:play-services-auth:20.7.0'
 *   implementation 'com.google.firebase:firebase-core'
 * }
 */

// File: android/app/src/main/AndroidManifest.xml
// Should include:
/*
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.sahara">
    
    <!-- Internet permission for authentication -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- ... rest of manifest ... -->
</manifest>
*/

// CONFIGURATION STEPS:
// ====================
// 1. Create OAuth 2.0 Credentials in Google Cloud Console
// 2. Get SHA-1 fingerprint of your signing key:
//    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
// 3. Add SHA-1 to Firebase Console
// 4. Enable Google Sign-In in Firebase Authentication
// 5. Get Web Client ID from Google Cloud Console (used for Android)
// 6. Update strings.xml with your client ID

// TESTING:
// ========
// Use Firebase Test Lab to test on various Android devices
// Or use Android Emulator with Google Play Services installed
