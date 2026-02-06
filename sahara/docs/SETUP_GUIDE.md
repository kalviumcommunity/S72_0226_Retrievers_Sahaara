# Sahara Setup Guide

Complete step-by-step guide to set up the Sahara project from scratch.

---

## Prerequisites

Before starting, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (3.10.8 or higher)
   - Download: https://docs.flutter.dev/get-started/install
   - Verify: `flutter --version`

2. **Dart SDK** (included with Flutter)
   - Verify: `dart --version`

3. **Git**
   - Download: https://git-scm.com/downloads
   - Verify: `git --version`

4. **Node.js & npm** (for Firebase CLI)
   - Download: https://nodejs.org/
   - Verify: `node --version` and `npm --version`

5. **IDE** (choose one)
   - Android Studio with Flutter plugin
   - VS Code with Flutter and Dart extensions

6. **Android SDK** (for Android development)
   - Installed via Android Studio
   - Set ANDROID_HOME environment variable

7. **Xcode** (for iOS development - Mac only)
   - Download from Mac App Store

---

## Step 1: Verify Flutter Installation

Run Flutter doctor to check your setup:

```bash
flutter doctor
```

Expected output should show:
- ✅ Flutter (Channel stable)
- ✅ Android toolchain
- ✅ Xcode (Mac only)
- ✅ VS Code or Android Studio
- ✅ Connected device

Fix any issues before proceeding.

---

## Step 2: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/team-retrievers/Sahara.git

# Navigate to project directory
cd Sahara

# Check current branch
git branch
```

---

## Step 3: Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# Verify packages are installed
flutter pub outdated
```

This will download all dependencies listed in `pubspec.yaml`.

---

## Step 4: Firebase Setup

### 4.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Enter project name: **"Sahara"**
4. Disable Google Analytics (optional for development)
5. Click **"Create project"**

### 4.2 Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Verify installation
firebase --version

# Login to Firebase
firebase login
```

### 4.3 Install FlutterFire CLI

```bash
# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version
```

### 4.4 Configure Firebase for Flutter

```bash
# Run FlutterFire configuration
flutterfire configure

# Select your Firebase project: Sahara
# Choose platforms: Android, iOS
# This creates firebase_options.dart automatically
```

This command will:
- Create `firebase_options.dart` in `lib/`
- Configure Android (`google-services.json`)
- Configure iOS (`GoogleService-Info.plist`)

---

## Step 5: Enable Firebase Services

### 5.1 Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable **Email/Password**:
   - Toggle to enable
   - Click "Save"
5. Enable **Google Sign-In**:
   - Toggle to enable
   - Enter support email
   - Click "Save"

### 5.2 Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Choose location closest to your users (e.g., asia-south1)
5. Click **"Enable"**

### 5.3 Set Up Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click **"Get started"**
3. Select **"Start in test mode"** (for development)
4. Use default bucket location
5. Click **"Done"**

### 5.4 Enable Cloud Messaging

1. In Firebase Console, go to **Cloud Messaging**
2. The service is automatically enabled
3. Note down the Server Key (for later use)

---

## Step 6: Configure Security Rules

### 6.1 Firestore Security Rules

1. Go to **Firestore Database** → **Rules** tab
2. Replace with the following rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    match /caregivers/{caregiverId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(caregiverId);
    }
    
    match /pets/{petId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if isAuthenticated() && 
                                resource.data.ownerId == request.auth.uid;
    }
    
    match /bookings/{bookingId} {
      allow read: if isAuthenticated() && 
                     (resource.data.ownerId == request.auth.uid || 
                      resource.data.caregiverId == request.auth.uid);
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && 
                       (resource.data.ownerId == request.auth.uid || 
                        resource.data.caregiverId == request.auth.uid);
      
      match /activities/{activityId} {
        allow read: if isAuthenticated();
        allow create: if isAuthenticated();
      }
    }
    
    match /reviews/{reviewId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.ownerId);
    }
    
    match /chats/{chatId} {
      allow read, write: if isAuthenticated() && 
                            request.auth.uid in resource.data.participants;
      
      match /messages/{messageId} {
        allow read, write: if isAuthenticated();
      }
    }
  }
}
```

3. Click **"Publish"**

### 6.2 Storage Security Rules

1. Go to **Storage** → **Rules** tab
2. Replace with the following rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    match /users/{userId}/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    match /pets/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated();
    }
    
    match /activities/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated();
    }
    
    match /documents/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated();
    }
  }
}
```

3. Click **"Publish"**

---

## Step 7: Create Firestore Indexes

For efficient queries, create composite indexes:

1. Go to **Firestore Database** → **Indexes** tab
2. Click **"Add index"**
3. Create the following indexes:

### Index 1: Caregivers Search
- Collection: `caregivers`
- Fields:
  - `verificationStatus` (Ascending)
  - `stats.averageRating` (Descending)
  - `isActive` (Ascending)

### Index 2: Owner Bookings
- Collection: `bookings`
- Fields:
  - `ownerId` (Ascending)
  - `status` (Ascending)
  - `scheduledDate` (Descending)

### Index 3: Caregiver Bookings
- Collection: `bookings`
- Fields:
  - `caregiverId` (Ascending)
  - `status` (Ascending)
  - `scheduledDate` (Descending)

### Index 4: Reviews
- Collection: `reviews`
- Fields:
  - `caregiverId` (Ascending)
  - `createdAt` (Descending)

---

## Step 8: Android Configuration

### 8.1 Update AndroidManifest.xml

Add permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <application
        android:label="Sahara"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Rest of the configuration -->
    </application>
</manifest>
```

### 8.2 Update build.gradle

Ensure minimum SDK version in `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

---

## Step 9: iOS Configuration (Mac Only)

### 9.1 Update Info.plist

Add permissions in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Sahara needs camera access to upload pet photos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Sahara needs photo library access to select pet photos</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Sahara needs location access to find nearby caregivers</string>
```

### 9.2 Install CocoaPods

```bash
cd ios
pod install
cd ..
```

---

## Step 10: Run the Application

### 10.1 Check Connected Devices

```bash
flutter devices
```

### 10.2 Run on Android

```bash
# Run on connected Android device/emulator
flutter run

# Or specify device
flutter run -d <device-id>
```

### 10.3 Run on iOS (Mac only)

```bash
# Run on connected iOS device/simulator
flutter run

# Or specify device
flutter run -d <device-id>
```

### 10.4 Hot Reload

While the app is running:
- Press `r` for hot reload
- Press `R` for hot restart
- Press `q` to quit

---

## Step 11: Verify Setup

### Test Checklist

- [ ] App launches without errors
- [ ] Splash screen displays
- [ ] Firebase connection successful
- [ ] No console errors
- [ ] Hot reload works

---

## Troubleshooting

### Common Issues

#### 1. Firebase not initialized

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**:
```dart
// Ensure Firebase is initialized in main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

#### 2. Google Services missing

**Error**: `google-services.json is missing`

**Solution**:
- Re-run `flutterfire configure`
- Manually download from Firebase Console → Project Settings

#### 3. Gradle build fails

**Error**: `Execution failed for task ':app:processDebugGoogleServices'`

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 4. CocoaPods issues (iOS)

**Error**: `CocoaPods not installed`

**Solution**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

#### 5. Permission denied

**Error**: `Permission denied` when running commands

**Solution**:
```bash
# Make gradlew executable
chmod +x android/gradlew
```

---

## Next Steps

After successful setup:

1. **Read Documentation**
   - [Architecture Guide](ARCHITECTURE.md)
   - [Database Schema](DATABASE_SCHEMA.md)

2. **Start Development**
   - Follow the Sprint Roadmap in README.md
   - Assign tasks to team members
   - Create feature branches

3. **Set Up Version Control**
   ```bash
   git checkout -b develop
   git push -u origin develop
   ```

4. **Configure CI/CD** (Optional)
   - Set up GitHub Actions
   - Configure automated testing

---

## Useful Commands

```bash
# Check Flutter version
flutter --version

# Update Flutter
flutter upgrade

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Run tests
flutter test

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

---

## Support

If you encounter issues:

1. Check [Flutter Documentation](https://docs.flutter.dev)
2. Check [Firebase Documentation](https://firebase.google.com/docs)
3. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
4. Contact team members
5. Create an issue in the repository

---

**Setup Complete! 🎉**

You're now ready to start developing Sahara!
