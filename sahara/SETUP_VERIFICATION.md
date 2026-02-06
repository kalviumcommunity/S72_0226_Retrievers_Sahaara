# Sahara Setup Verification Guide

Use this checklist to verify your development environment is properly configured.

---

## ✅ Pre-Setup Verification

### 1. Flutter Installation

```bash
flutter --version
```

**Expected Output:**
```
Flutter 3.10.8 or higher
Dart 3.x.x or higher
```

✅ **Status**: Flutter 3.38.9 detected (✓ Compatible)

---

### 2. Flutter Doctor

```bash
flutter doctor
```

**Required Checks:**
- ✅ Flutter (Channel stable)
- ✅ Android toolchain
- ✅ VS Code or Android Studio
- ✅ Connected device (optional for now)

**Action**: Fix any ❌ issues before proceeding

---

### 3. Project Dependencies

```bash
cd Sahara
flutter pub get
```

**Expected Output:**
```
Resolving dependencies...
Got dependencies!
```

**Action**: Ensure no errors in dependency resolution

---

## 🔥 Firebase Setup Verification

### 1. Firebase CLI Installation

```bash
firebase --version
```

**Expected Output:**
```
13.x.x or higher
```

**If not installed:**
```bash
npm install -g firebase-tools
```

---

### 2. FlutterFire CLI Installation

```bash
flutterfire --version
```

**Expected Output:**
```
0.x.x or higher
```

**If not installed:**
```bash
dart pub global activate flutterfire_cli
```

---

### 3. Firebase Login

```bash
firebase login
```

**Expected**: Browser opens for Google authentication

---

### 4. Firebase Configuration

```bash
flutterfire configure
```

**Expected**:
- Select or create "Sahara" project
- Choose Android and iOS platforms
- Creates `lib/firebase_options.dart`

**Verify File Created:**
```bash
# Windows
dir lib\firebase_options.dart

# Mac/Linux
ls lib/firebase_options.dart
```

---

### 5. Firebase Console Setup

Visit: https://console.firebase.google.com

**Checklist:**

#### Authentication
- [ ] Go to Authentication → Sign-in method
- [ ] Enable Email/Password
- [ ] Enable Google Sign-In
- [ ] Add support email for Google Sign-In

#### Firestore Database
- [ ] Go to Firestore Database
- [ ] Click "Create database"
- [ ] Select "Start in test mode"
- [ ] Choose location (e.g., asia-south1)
- [ ] Database created successfully

#### Storage
- [ ] Go to Storage
- [ ] Click "Get started"
- [ ] Select "Start in test mode"
- [ ] Default bucket created

#### Cloud Messaging
- [ ] Go to Cloud Messaging
- [ ] Service automatically enabled
- [ ] Note: No additional setup needed for now

---

## 📱 Android Setup Verification

### 1. Android SDK

```bash
flutter doctor -v
```

**Check for:**
- Android SDK location
- Android SDK version (33 or higher)
- Android SDK Command-line Tools

---

### 2. Google Services File

**Verify file exists:**
```bash
# Windows
dir android\app\google-services.json

# Mac/Linux
ls android/app/google-services.json
```

**If missing:**
1. Go to Firebase Console → Project Settings
2. Under "Your apps" → Android app
3. Download `google-services.json`
4. Place in `android/app/` folder

---

### 3. Android Emulator (Optional)

```bash
flutter emulators
```

**Expected**: List of available emulators

**To launch:**
```bash
flutter emulators --launch <emulator_id>
```

---

## 🍎 iOS Setup Verification (Mac Only)

### 1. Xcode Installation

```bash
xcode-select --version
```

**Expected**: Version number displayed

---

### 2. CocoaPods Installation

```bash
pod --version
```

**Expected**: Version 1.11.0 or higher

**If not installed:**
```bash
sudo gem install cocoapods
```

---

### 3. iOS Pods Installation

```bash
cd ios
pod install
cd ..
```

**Expected**: Pods installed successfully

---

### 4. Google Services File

**Verify file exists:**
```bash
ls ios/Runner/GoogleService-Info.plist
```

**If missing:**
1. Go to Firebase Console → Project Settings
2. Under "Your apps" → iOS app
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/` folder

---

## 🧪 Code Verification

### 1. Update main.dart

**File**: `lib/main.dart`

**Uncomment these lines:**

```dart
// BEFORE (commented)
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

// AFTER (uncommented)
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

### 2. Code Analysis

```bash
flutter analyze
```

**Expected**: No issues found (or only info messages)

---

### 3. Code Formatting

```bash
flutter format lib/
```

**Expected**: Files formatted successfully

---

## 🚀 Run Verification

### 1. Check Connected Devices

```bash
flutter devices
```

**Expected**: At least one device listed
- Android emulator
- iOS simulator (Mac only)
- Physical device
- Chrome (web)

---

### 2. Run the App

```bash
flutter run
```

**Expected**:
- App builds successfully
- No compilation errors
- Splash screen displays
- "Sahara" logo visible
- No Firebase errors in console

---

### 3. Hot Reload Test

**While app is running:**
1. Press `r` in terminal
2. **Expected**: App reloads instantly
3. Press `R` for hot restart
4. **Expected**: App restarts

---

## ✅ Final Verification Checklist

### Environment Setup
- [ ] Flutter installed (3.10.8+)
- [ ] Flutter doctor shows no critical issues
- [ ] Android SDK configured
- [ ] Xcode installed (Mac only)
- [ ] VS Code or Android Studio installed

### Firebase Setup
- [ ] Firebase CLI installed
- [ ] FlutterFire CLI installed
- [ ] Firebase project "Sahara" created
- [ ] `firebase_options.dart` exists
- [ ] Authentication enabled
- [ ] Firestore database created
- [ ] Storage bucket created
- [ ] `google-services.json` in place (Android)
- [ ] `GoogleService-Info.plist` in place (iOS)

### Project Setup
- [ ] Dependencies installed (`flutter pub get`)
- [ ] No analyzer errors (`flutter analyze`)
- [ ] Code formatted (`flutter format lib/`)
- [ ] main.dart Firebase code uncommented
- [ ] App runs successfully (`flutter run`)
- [ ] Splash screen displays correctly
- [ ] Hot reload works

### Documentation Read
- [ ] README.md reviewed
- [ ] QUICKSTART.md reviewed
- [ ] TEAM_CHECKLIST.md reviewed
- [ ] Your role and tasks identified

---

## 🐛 Common Issues & Solutions

### Issue 1: Firebase not initialized

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**:
1. Ensure `firebase_options.dart` exists
2. Uncomment Firebase initialization in `main.dart`
3. Rebuild app: `flutter clean && flutter run`

---

### Issue 2: Google Services file missing

**Error**: `google-services.json is missing`

**Solution**:
1. Download from Firebase Console
2. Place in `android/app/` folder
3. Rebuild app

---

### Issue 3: Gradle build fails

**Error**: Various Gradle errors

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

### Issue 4: CocoaPods issues (iOS)

**Error**: Pod installation fails

**Solution**:
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

---

### Issue 5: FlutterFire command not found

**Error**: `flutterfire: command not found`

**Solution**:
```bash
# Add Dart pub global to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Or on Windows, add to System Environment Variables:
# %USERPROFILE%\AppData\Local\Pub\Cache\bin
```

---

## 📊 Setup Status

### Current Status
- ✅ Project structure created
- ✅ Dependencies configured
- ✅ Documentation complete
- ✅ Utility files created
- ⏳ Firebase configuration (your next step)
- ⏳ Code implementation

### Next Steps
1. Complete Firebase setup
2. Uncomment Firebase code in main.dart
3. Run the app
4. Start implementing features

---

## 🎯 Success Criteria

Your setup is complete when:

1. ✅ `flutter doctor` shows no critical issues
2. ✅ `flutter run` launches the app successfully
3. ✅ Splash screen displays "Sahara" logo
4. ✅ No Firebase initialization errors
5. ✅ Hot reload works (press 'r')
6. ✅ No console errors or warnings

---

## 📞 Need Help?

### Quick Fixes
```bash
# Clean everything and start fresh
flutter clean
flutter pub get
flutter run

# Check for issues
flutter doctor -v
flutter analyze

# Update Flutter
flutter upgrade
```

### Resources
- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)

### Team Support
- Check TEAM_CHECKLIST.md for your tasks
- Ask team members in chat
- Create GitHub issue for bugs

---

## 🎉 Setup Complete!

Once all checkboxes are ✅, you're ready to start development!

**Next**: Open TEAM_CHECKLIST.md and start your Week 1 tasks!

---

**Happy Coding! 🐾**
