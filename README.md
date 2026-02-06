# Sahara - Pet Discovery & Monitoring Platform

**Team Retrievers** | Kalvium Sprint #2

A Flutter + Firebase mobile application connecting pet owners with verified caregivers through real-time monitoring.

---

## 🚀 Quick Start

```bash
cd sahara
flutter pub get
flutter run -d chrome
```

---

## 📚 Documentation

All project documentation is in the `sahara/` folder:

- **[sahara/README.md](sahara/README.md)** - Complete project documentation
- **[sahara/QUICKSTART.md](sahara/QUICKSTART.md)** - 10-minute setup guide
- **[sahara/TEAM_CHECKLIST.md](sahara/TEAM_CHECKLIST.md)** - Week-by-week tasks
- **[sahara/PROJECT_SUMMARY.md](sahara/PROJECT_SUMMARY.md)** - Project overview
- **[sahara/docs/SETUP_GUIDE.md](sahara/docs/SETUP_GUIDE.md)** - Detailed setup
- **[sahara/docs/ARCHITECTURE.md](sahara/docs/ARCHITECTURE.md)** - Technical architecture
- **[sahara/docs/DATABASE_SCHEMA.md](sahara/docs/DATABASE_SCHEMA.md)** - Database structure

---

## 🎯 Project Structure

```
sahara/                    # Main Flutter project
├── lib/                   # Source code
├── docs/                  # Documentation
├── assets/                # Images & icons
└── test/                  # Tests
```

---

## ✅ Current Status

- ✅ Project setup complete
- ✅ App running successfully
- ✅ Ready for Firebase configuration
- ✅ Ready for feature development

---

## 🔥 Firebase Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

Create Firebase project named **"Sahara"** and enable:
- Authentication (Email/Password, Google)
- Firestore Database
- Storage

---

## 👥 Team Roles

1. **Authentication & Profiles** - User auth, pet profiles
2. **Discovery & Booking** - Caregiver search, booking system
3. **Monitoring & Reviews** - Real-time updates, reviews

See [sahara/TEAM_CHECKLIST.md](sahara/TEAM_CHECKLIST.md) for detailed tasks.

---

## 🛠 Development Commands

```bash
flutter run              # Run app
flutter analyze          # Check for issues
flutter test             # Run tests
flutter pub get          # Get dependencies
```

---

**Start building with [sahara/TEAM_CHECKLIST.md](sahara/TEAM_CHECKLIST.md)** 🐾
