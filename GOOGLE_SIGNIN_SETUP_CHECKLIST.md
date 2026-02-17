# Google Sign-In Setup Checklist

## Pre-Implementation ✅

- [x] Dependencies installed (check `pubspec.yaml`)
- [x] AuthRepository supports Google Sign-In
- [x] AuthProvider has `signInWithGoogle()` method
- [x] GoogleSignInService created
- [x] Button widgets created
- [x] Login/Signup screens updated
- [x] Documentation completed

---

## Firebase Console Setup

### 1. Create Firebase Project
- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Create Project" or select existing
- [ ] Name your project (e.g., "Sahara Pet Care")
- [ ] Enable Google Analytics (optional)
- [ ] Create project

### 2. Add Android App
- [ ] Click "+ Add app" → "Android"
- [ ] Enter package name: `com.example.sahara` (or your package)
- [ ] Enter SHA-1 fingerprint (see Android setup below)
- [ ] Download `google-services.json`
- [ ] Place in `android/app/`

### 3. Add iOS App
- [ ] Click "+ Add app" → "iOS"
- [ ] Enter bundle ID: `com.example.sahara` (or your bundle)
- [ ] Download `GoogleService-Info.plist`
- [ ] Add to Xcode project (see iOS setup below)

### 4. Enable Google Sign-In
- [ ] Go to "Authentication" section
- [ ] Click "Get started"
- [ ] Click "Google" sign-in method
- [ ] Enable it
- [ ] Add app name (e.g., "Sahara")
- [ ] Add support email
- [ ] Save

---

## Android Setup

### Get SHA-1 Fingerprint

```bash
# For debug key:
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android

# Copy the SHA-1 value
# Example: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
```

### Add SHA-1 to Firebase

- [ ] Go to Firebase Console → Project Settings
- [ ] Click on your Android app
- [ ] Scroll to "SHA certificate fingerprints"
- [ ] Click "Add fingerprint"
- [ ] Paste the SHA-1 from above
- [ ] Click "Save"

### Update strings.xml

- [ ] Open `android/app/src/main/res/values/strings.xml`
- [ ] Add your Google Client ID:
  ```xml
  <string name="google_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
  ```
- [ ] Get Web Client ID from Google Cloud Console → OAuth 2.0 Credentials

### Check Permissions

- [ ] Open `android/app/src/main/AndroidManifest.xml`
- [ ] Verify `<uses-permission android:name="android.permission.INTERNET" />`
- [ ] Should already be there

### Gradle Dependencies

- [ ] Open `android/app/build.gradle`
- [ ] Verify Google Play Services are available
- [ ] Should work with current dependencies

### Testing

- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run on Android device/emulator with Google Play Services
- [ ] Test Google Sign-In flow

---

## iOS Setup

### Get GoogleService-Info.plist

- [ ] Go to Firebase Console → Project Settings
- [ ] Download `GoogleService-Info.plist`
- [ ] Open Xcode: `ios/Runner.xcworkspace` (not .xcodeproj)
- [ ] Drag and drop `GoogleService-Info.plist` into Xcode
- [ ] Check "Copy items if needed"
- [ ] Select "Runner" target
- [ ] Click "Finish"

### Update Info.plist

- [ ] Open `ios/Runner/Info.plist` in Xcode
- [ ] Add URL scheme:
  ```xml
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
  ```
- [ ] Add Google Client ID:
  ```xml
  <key>GIDClientID</key>
  <string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
  ```

### Xcode Setup

- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Select "Runner" project
- [ ] Select "Runner" target
- [ ] Go to "Signing & Capabilities"
- [ ] Verify Team is set (for app signing)
- [ ] Add "Sign in with Apple" capability (recommended)
- [ ] Verify iOS Deployment Target >= 11.0
- [ ] Go to "Build Settings"
- [ ] Verify Swift Language Version is set

### CocoaPods

- [ ] Run `cd ios && pod install`
- [ ] Run `cd .. && flutter clean && flutter pub get`

### Testing

- [ ] Run on physical iOS device (Simulator may have limitations)
- [ ] Test Google Sign-In flow

---

## Google Cloud Console Setup

### Create OAuth Credentials

- [ ] Go to https://console.cloud.google.com/
- [ ] Select your project
- [ ] Go to "Credentials" → "OAuth consent screen"
- [ ] Configure consent screen (User Type: External)
  - [ ] Add app name
  - [ ] Add user support email
  - [ ] Add developer contact info
  - [ ] Click "Save and Continue"
- [ ] Skip scopes (not needed for basic sign-in)
- [ ] Add test users if in development
- [ ] Go back to "Credentials"
- [ ] Click "Create Credentials" → "OAuth 2.0 Client IDs"
- [ ] Select "Web application"
- [ ] Add authorized redirect URIs (for development):
  ```
  http://localhost:7357
  ```
- [ ] Click "Create"
- [ ] Copy your Client ID and Client Secret
- [ ] Click "Create Credentials" → "OAuth 2.0 Client IDs" (again)
- [ ] Select "Android"
- [ ] Enter package name and SHA-1
- [ ] Click "Create"
- [ ] Click "Create Credentials" → "OAuth 2.0 Client IDs" (again)
- [ ] Select "iOS"
- [ ] Enter bundle ID
- [ ] Click "Create"

---

## App Configuration

### Update Package Name (if needed)

If using a different package name than `com.example.sahara`:

- [ ] Update `pubspec.yaml` with `description`
- [ ] Update `android/app/build.gradle` → `applicationId`
- [ ] Update `ios/Runner/Info.plist` → `CFBundleIdentifier`
- [ ] Update all imports in code

### Add Google Icon (Optional)

- [ ] Create `assets/icons/` directory
- [ ] Add `google.png` icon (24x24 or 48x48 PNG)
  - Download from: https://developers.google.com/identity/branding
  - Or create your own
- [ ] Reference in `pubspec.yaml` assets section (already done)

---

## Testing & Verification

### Test Checklist

- [ ] Run app on Android device/emulator
- [ ] Tap "Continue with Google" button
- [ ] Google Sign-In dialog appears
- [ ] Select a Google account
- [ ] Successfully logged in
- [ ] User document created in Firestore
- [ ] Run app on iOS device
- [ ] Repeat above steps
- [ ] Test "Sign Out" functionality
- [ ] Test repeated sign-in with same account
- [ ] Test error handling (cancel sign-in)

### Verify Firestore

- [ ] Go to Firebase Console
- [ ] Go to "Firestore Database"
- [ ] Check "users" collection
- [ ] Verify new user document created with:
  - [ ] `userId` (Firebase UID)
  - [ ] `email` (from Google account)
  - [ ] `name` (from Google account)
  - [ ] `role` (from sign-in flow)
  - [ ] `createdAt` (timestamp)
  - [ ] `lastActive` (timestamp)

### Monitor Logs

- [ ] Android: `flutter logs` or Logcat
- [ ] iOS: `flutter logs` or Xcode console
- [ ] Firebase Console → Authentication → logs
- [ ] Check for any errors

---

## Troubleshooting

### Android Issues

| Error | Solution |
|-------|----------|
| "INVALID_CLIENT" | Update SHA-1 in Firebase Console |
| "android.gms.common.GooglePlayServicesNotAvailableException" | Use emulator with Play Services or physical device |
| "User cancelled" | Normal - user chose not to sign in |
| "Permission denied" | Make sure Emulator has Play Services installed |

### iOS Issues

| Error | Solution |
|-------|----------|
| "Nil URL scheme" | Add CFBundleURLTypes to Info.plist |
| "Error loading config" | Verify GoogleService-Info.plist is in Xcode target |
| "Cannot connect" | Use physical device instead of Simulator |
| "Client ID mismatch" | Check GIDClientID matches your credentials |

### Common Issues

| Issue | Solution |
|-------|----------|
| Button not responding | Check Firebase setup and Client ID |
| No error message shown | Check `authProvider.error` is being displayed |
| Icon not showing | Place google.png in assets/icons/ |
| User not created in Firestore | Check Firestore Security Rules |

---

## Post-Implementation

### Deploy to Production

- [ ] Remove test users from Google Cloud Console
- [ ] Set OAuth consent screen to "Production"
- [ ] Get app signed for production (Android)
- [ ] Generate new SHA-1 for production key
- [ ] Add production SHA-1 to Firebase Console
- [ ] Update app signing certificate in Xcode
- [ ] Test on production apps before release

### Monitoring

- [ ] Set up Firebase Analytics
- [ ] Monitor authentication events
- [ ] Track sign-in success rates
- [ ] Monitor error rates
- [ ] Set up alerts for anomalies

### Security Review

- [ ] Review Firestore Security Rules
- [ ] Ensure sensitive data is protected
- [ ] Enable API restrictions in Google Cloud
- [ ] Review app permissions
- [ ] Audit user access patterns

---

## Documentation Reference

- 📖 [Full Integration Guide](GOOGLE_SIGNIN_INTEGRATION_GUIDE.md)
- 🤖 [Android Configuration](ANDROID_GOOGLE_SIGNIN_CONFIG.md)
- 🍎 [iOS Configuration](IOS_GOOGLE_SIGNIN_CONFIG.md)
- 📝 [Implementation Summary](GOOGLE_SIGNIN_IMPLEMENTATION_SUMMARY.md)
- ⚡ [Quick Reference](GOOGLE_SIGNIN_QUICK_REFERENCE.md)

---

## Support Resources

- [Google Sign-In Documentation](https://developers.google.com/identity/sign-in)
- [Firebase Authentication](https://firebase.flutter.dev/)
- [google_sign_in Package](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)

---

## Quick Links

| Platform | Action |
|----------|--------|
| Firebase | [Go to Console](https://console.firebase.google.com/) |
| Google Cloud | [Go to Console](https://console.cloud.google.com/) |
| Package Docs | [google_sign_in](https://pub.dev/packages/google_sign_in) |
| Flutter Docs | [Firebase Auth](https://firebase.flutter.dev/docs/auth/overview) |

---

**Status:** Ready for Implementation ✅  
**Last Updated:** February 17, 2026

---

## Notes

- Keep your Client IDs and secrets secure
- Never commit sensitive files to version control
- Use environment variables for production
- Test thoroughly before releasing
- Monitor user feedback for issues
