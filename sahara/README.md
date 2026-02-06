# 🐾 Sahara - Trusted Pet Discovery & Monitoring Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Team Retrievers** | Kalvium Sprint #2 - Simulated Work Environment

Sahara is a mobile application that bridges the trust gap in urban pet care services by connecting pet owners with verified caregivers and providing real-time activity monitoring during pet care sessions.

---

## 📋 Table of Contents

- [Problem Statement](#-problem-statement)
- [Solution](#-solution)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Firebase Setup](#-firebase-setup)
- [Development Workflow](#-development-workflow)
- [Team Roles](#-team-roles)
- [Sprint Roadmap](#-sprint-roadmap)
- [Contributing](#-contributing)

---

## 🎯 Problem Statement

Urban pet owners face critical challenges:

- **Safety Concerns**: Lack of identity verification increases risk
- **Trust Deficit**: Cannot verify caregiver credentials or background
- **Information Blackout**: No real-time updates during pet walks
- **Discovery Challenges**: Difficulty finding qualified caregivers
- **Communication Gaps**: Poor coordination between owners and caregivers

---

## 💡 Solution

Sahara is a two-sided marketplace that:

✅ Connects pet owners with **verified caregivers**  
✅ Provides **real-time monitoring** with photos and updates  
✅ Enables **secure bookings** with in-app scheduling  
✅ Offers **location-based discovery** with ratings and reviews  
✅ Facilitates **direct communication** between parties

---

## ✨ Features

### For Pet Owners
- 🔐 Secure authentication (Email/Password, Google Sign-In)
- 🐕 Pet profile management with photos
- 🔍 Search verified caregivers by location, rating, availability
- 📅 Book pet care services with flexible scheduling
- 📸 Receive real-time photos and updates during sessions
- ⭐ Rate and review caregivers
- 💬 In-app messaging with caregivers

### For Caregivers
- ✅ Professional profile with verification badge
- 📄 Upload credentials and certifications
- 📆 Set availability and service areas
- 💰 Manage bookings and earnings
- 📷 Share live updates during pet care sessions
- 🌟 Build reputation through reviews

---

## 🛠 Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter (Dart) | Cross-platform mobile UI |
| **Authentication** | Firebase Auth | User identity & sessions |
| **Database** | Cloud Firestore | Real-time NoSQL database |
| **Storage** | Firebase Storage | Image uploads |
| **Backend Logic** | Cloud Functions | Server-side operations |
| **State Management** | Provider | App state handling |

**Architecture Pattern**: MVVM with Repository Pattern

---

## 📁 Project Structure

```
sahara/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── user_model.dart
│   │   ├── caregiver_model.dart
│   │   ├── pet_model.dart
│   │   ├── booking_model.dart
│   │   └── review_model.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   ├── caregiver_provider.dart
│   │   ├── booking_provider.dart
│   │   └── activity_provider.dart
│   ├── repositories/             # Data layer
│   │   ├── auth_repository.dart
│   │   ├── user_repository.dart
│   │   ├── booking_repository.dart
│   │   └── storage_repository.dart
│   ├── screens/                  # UI screens
│   │   ├── auth/                 # Authentication screens
│   │   ├── owner/                # Pet owner screens
│   │   ├── caregiver/            # Caregiver screens
│   │   └── common/               # Shared screens
│   ├── widgets/                  # Reusable widgets
│   │   ├── caregiver_card.dart
│   │   ├── booking_card.dart
│   │   └── custom_button.dart
│   ├── services/                 # Business logic
│   │   ├── firebase_service.dart
│   │   └── notification_service.dart
│   └── utils/                    # Utilities
│       ├── constants.dart
│       ├── validators.dart
│       └── theme.dart
├── assets/
│   ├── images/                   # App images
│   └── icons/                    # App icons
├── docs/                         # Documentation
│   ├── ARCHITECTURE.md
│   ├── DATABASE_SCHEMA.md
│   └── API_REFERENCE.md
├── test/                         # Unit tests
└── pubspec.yaml                  # Dependencies
```

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:

- ✅ Flutter SDK (3.10.8 or higher)
- ✅ Dart SDK (included with Flutter)
- ✅ Android Studio or VS Code with Flutter extensions
- ✅ Git
- ✅ Firebase CLI: `npm install -g firebase-tools`
- ✅ A Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/team-retrievers/sahara.git
   cd sahara
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Ensure all checkmarks are green (or at least Flutter and one IDE).

4. **Configure Firebase** (See [Firebase Setup](#-firebase-setup) section)

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔥 Firebase Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name it "Sahara"
4. Disable Google Analytics (optional for MVP)

### Step 2: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Step 3: Configure Firebase for Flutter

```bash
flutterfire configure
```

- Select your Firebase project
- Choose platforms (Android, iOS)
- This creates `firebase_options.dart` automatically

### Step 4: Enable Firebase Services

In Firebase Console, enable:

1. **Authentication**
   - Go to Authentication → Sign-in method
   - Enable Email/Password
   - Enable Google Sign-In

2. **Firestore Database**
   - Go to Firestore Database
   - Create database in **test mode**
   - Choose location closest to your users

3. **Storage**
   - Go to Storage
   - Get started with default bucket
   - Start in **test mode**

4. **Cloud Messaging** (for notifications)
   - Go to Cloud Messaging
   - Enable the service

### Step 5: Configure Security Rules

**Firestore Rules** (Database → Rules):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /caregivers/{caregiverId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == caregiverId;
    }
    
    match /pets/{petId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /bookings/{bookingId} {
      allow read: if request.auth != null && 
                     (resource.data.ownerId == request.auth.uid || 
                      resource.data.caregiverId == request.auth.uid);
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
  }
}
```

**Storage Rules** (Storage → Rules):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 💻 Development Workflow

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Hot reload (during development)
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal
```

### Building the App

```bash
# Build APK for Android
flutter build apk

# Build App Bundle for Android
flutter build appbundle

# Build for iOS
flutter build ios
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/user_model_test.dart
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check for outdated packages
flutter pub outdated
```

---

## 👥 Team Roles

### Team Member 1: Authentication & Profile Management
**Responsibilities:**
- Firebase Auth integration
- Sign up/Login screens
- User profile screens
- Pet profile creation
- Caregiver profile setup
- AuthProvider implementation

### Team Member 2: Discovery & Booking System
**Responsibilities:**
- Caregiver search and filters
- Firestore queries and indexes
- Booking form and flow
- My Bookings screen
- CaregiverProvider and BookingProvider
- Chat functionality

### Team Member 3: Real-Time Monitoring & Reviews
**Responsibilities:**
- Activity update upload
- Real-time feed with StreamBuilder
- Firebase Storage integration
- Review and rating system
- ActivityProvider
- Push notifications

---

## 📅 Sprint Roadmap

### Week 1: Foundation & Authentication
- [x] Set up Flutter project with Firebase
- [ ] Implement authentication (Email/Password, Google)
- [ ] Create user profile screens
- [ ] Set up Firestore collections and security rules
- [ ] Implement basic navigation

### Week 2: Core Booking Features
- [ ] Build caregiver discovery and search UI
- [ ] Implement Firestore queries with filters
- [ ] Create booking form and confirmation flow
- [ ] Develop booking list screens
- [ ] Add basic chat functionality

### Week 3: Real-Time Monitoring
- [ ] Implement activity update upload
- [ ] Create real-time activity feed UI
- [ ] Add Firebase Storage integration
- [ ] Build session start/end functionality
- [ ] Implement push notifications

### Week 4: Polish & Testing
- [ ] Add ratings and reviews system
- [ ] Implement caregiver verification UI
- [ ] Create dashboard widgets
- [ ] Test all user flows end-to-end
- [ ] Fix bugs and improve UI/UX
- [ ] Prepare presentation

---

## 🤝 Contributing

### Git Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes and commit**
   ```bash
   git add .
   git commit -m "Add: your feature description"
   ```

3. **Push to your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**
   - Go to GitHub repository
   - Click "New Pull Request"
   - Select your branch
   - Add description and request review

### Commit Message Convention

- `Add:` New feature
- `Fix:` Bug fix
- `Update:` Update existing feature
- `Refactor:` Code refactoring
- `Docs:` Documentation changes
- `Style:` Code style changes
- `Test:` Add or update tests

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design Guidelines](https://m3.material.io)
- [Project Documentation](docs/)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact

**Team Retrievers**  
Kalvium Sprint #2 Project

For questions or support, please contact the team members or create an issue in the repository.

---

**Made with ❤️ by Team Retrievers**
