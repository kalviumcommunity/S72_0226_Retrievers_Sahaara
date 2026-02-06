# 🚀 Sahara - Quick Start Guide

## Get Started in 3 Steps

### Step 1: Navigate to Project
```bash
cd sahara
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Set Up Firebase
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase (creates firebase_options.dart)
flutterfire configure
```

**In Firebase Console:**
1. Create project named **"Sahara"**
2. Enable Authentication (Email/Password, Google)
3. Create Firestore Database (test mode)
4. Create Storage bucket (test mode)

### Step 4: Update Code
Uncomment Firebase initialization in `sahara/lib/main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 5: Run the App
```bash
flutter run
```

---

## 📚 Documentation

- **[README.md](README.md)** - Project overview
- **[sahara/README.md](sahara/README.md)** - Complete documentation
- **[sahara/QUICKSTART.md](sahara/QUICKSTART.md)** - Detailed quick start
- **[sahara/TEAM_CHECKLIST.md](sahara/TEAM_CHECKLIST.md)** - Your tasks
- **[RENAME_SUMMARY.md](RENAME_SUMMARY.md)** - Rename details

---

## 🎯 Your Role

Check **[sahara/TEAM_CHECKLIST.md](sahara/TEAM_CHECKLIST.md)** for:
- Your specific tasks
- Week-by-week breakdown
- Code examples
- Deliverables

---

## 🐛 Issues?

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check for problems
flutter doctor
flutter analyze
```

---

**Ready to build Sahara! 🐾**
