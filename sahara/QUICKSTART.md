# Sahara Quick Start Guide

Get Sahara up and running in 10 minutes!

---

## 🚀 Quick Setup (5 Steps)

### Step 1: Install Flutter

```bash
# Check if Flutter is installed
flutter --version

# If not installed, download from:
# https://docs.flutter.dev/get-started/install
```

### Step 2: Clone and Install

```bash
# Clone the repository
git clone https://github.com/team-retrievers/Sahara.git
cd Sahara

# Install dependencies
flutter pub get
```

### Step 3: Firebase Setup

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
1. Create new project "Sahara"
2. Enable Authentication (Email/Password, Google)
3. Create Firestore Database (test mode)
4. Create Storage bucket (test mode)

### Step 4: Update main.dart

Uncomment Firebase initialization in `lib/main.dart`:

```dart
// Remove the // comments from these lines:
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 5: Run the App

```bash
# Check connected devices
flutter devices

# Run the app
flutter run
```

---

## 🎯 What's Next?

### Week 1: Authentication
- [ ] Create login screen
- [ ] Create signup screen
- [ ] Implement Firebase Auth
- [ ] Add user profile setup

### Week 2: Core Features
- [ ] Build caregiver discovery
- [ ] Create booking system
- [ ] Add search and filters

### Week 3: Real-Time Features
- [ ] Implement activity updates
- [ ] Add photo uploads
- [ ] Create activity feed

### Week 4: Polish
- [ ] Add reviews system
- [ ] Implement chat
- [ ] Test and fix bugs

---

## 📚 Essential Reading

1. **[README.md](README.md)** - Project overview
2. **[SETUP_GUIDE.md](docs/SETUP_GUIDE.md)** - Detailed setup
3. **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Technical architecture
4. **[DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)** - Database structure

---

## 🛠 Common Commands

```bash
# Run app
flutter run

# Hot reload (while running)
Press 'r' in terminal

# Run tests
flutter test

# Check for issues
flutter analyze

# Format code
flutter format lib/

# Clean build
flutter clean

# Build APK
flutter build apk
```

---

## 🐛 Troubleshooting

### Firebase not initialized
```dart
// Make sure this is in main.dart before runApp()
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Gradle build fails
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### CocoaPods issues (iOS)
```bash
cd ios
pod install
cd ..
```

---

## 💡 Tips

1. **Use Hot Reload**: Press 'r' to see changes instantly
2. **Check Flutter Doctor**: Run `flutter doctor` regularly
3. **Read Error Messages**: They usually tell you what's wrong
4. **Use VS Code Extensions**: Flutter and Dart extensions are helpful
5. **Test on Real Device**: Better than emulator for testing

---

## 🤝 Team Collaboration

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature

# Make changes and commit
git add .
git commit -m "Add: your feature"

# Push to GitHub
git push origin feature/your-feature

# Create Pull Request on GitHub
```

### Daily Standup Questions
1. What did you work on yesterday?
2. What will you work on today?
3. Any blockers?

---

## 📞 Need Help?

- **Documentation**: Check `docs/` folder
- **Issues**: Create GitHub issue
- **Team**: Ask in team chat
- **Flutter Docs**: https://docs.flutter.dev
- **Firebase Docs**: https://firebase.google.com/docs

---

**Ready to build Sahara? Let's go! 🐾**
