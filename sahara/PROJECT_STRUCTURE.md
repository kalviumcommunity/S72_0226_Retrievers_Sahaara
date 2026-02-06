# Sahara Project Structure

## 📁 Complete Directory Structure

```
Sahara/
│
├── 📱 lib/                          # Flutter source code
│   ├── main.dart                    # ✅ App entry point (configured)
│   │
│   ├── 📦 models/                   # Data models
│   │   ├── user_model.dart          # ✅ User data model
│   │   ├── pet_model.dart           # ✅ Pet data model
│   │   ├── caregiver_model.dart     # ⏳ TODO: Create
│   │   ├── booking_model.dart       # ⏳ TODO: Create
│   │   ├── activity_model.dart      # ⏳ TODO: Create
│   │   └── review_model.dart        # ⏳ TODO: Create
│   │
│   ├── 🔄 providers/                # State management (Provider)
│   │   ├── auth_provider.dart       # ⏳ TODO: Create
│   │   ├── caregiver_provider.dart  # ⏳ TODO: Create
│   │   ├── booking_provider.dart    # ⏳ TODO: Create
│   │   └── activity_provider.dart   # ⏳ TODO: Create
│   │
│   ├── 💾 repositories/             # Data layer (Firebase operations)
│   │   ├── auth_repository.dart     # ⏳ TODO: Create
│   │   ├── user_repository.dart     # ⏳ TODO: Create
│   │   ├── caregiver_repository.dart # ⏳ TODO: Create
│   │   ├── booking_repository.dart  # ⏳ TODO: Create
│   │   ├── storage_repository.dart  # ⏳ TODO: Create
│   │   └── review_repository.dart   # ⏳ TODO: Create
│   │
│   ├── 📱 screens/                  # UI screens
│   │   │
│   │   ├── 🔐 auth/                 # Authentication screens
│   │   │   ├── welcome_screen.dart  # ⏳ TODO: Create
│   │   │   ├── role_selection_screen.dart # ⏳ TODO: Create
│   │   │   ├── signup_screen.dart   # ⏳ TODO: Create
│   │   │   ├── login_screen.dart    # ⏳ TODO: Create
│   │   │   └── otp_verification_screen.dart # ⏳ TODO: Create
│   │   │
│   │   ├── 👤 owner/                # Pet owner screens
│   │   │   ├── home_screen.dart     # ⏳ TODO: Create
│   │   │   ├── search_results_screen.dart # ⏳ TODO: Create
│   │   │   ├── caregiver_profile_screen.dart # ⏳ TODO: Create
│   │   │   ├── booking_form_screen.dart # ⏳ TODO: Create
│   │   │   ├── my_bookings_screen.dart # ⏳ TODO: Create
│   │   │   ├── booking_detail_screen.dart # ⏳ TODO: Create
│   │   │   ├── activity_feed_screen.dart # ⏳ TODO: Create
│   │   │   ├── review_screen.dart   # ⏳ TODO: Create
│   │   │   └── pet_profile_form.dart # ⏳ TODO: Create
│   │   │
│   │   ├── 🐕 caregiver/            # Caregiver screens
│   │   │   ├── dashboard_screen.dart # ⏳ TODO: Create
│   │   │   ├── booking_requests_screen.dart # ⏳ TODO: Create
│   │   │   ├── my_schedule_screen.dart # ⏳ TODO: Create
│   │   │   ├── active_session_screen.dart # ⏳ TODO: Create
│   │   │   ├── session_summary_screen.dart # ⏳ TODO: Create
│   │   │   ├── earnings_screen.dart # ⏳ TODO: Create
│   │   │   └── caregiver_profile_setup.dart # ⏳ TODO: Create
│   │   │
│   │   └── 🔗 common/               # Shared screens
│   │       ├── profile_setup_screen.dart # ⏳ TODO: Create
│   │       ├── chat_screen.dart     # ⏳ TODO: Create
│   │       ├── notifications_screen.dart # ⏳ TODO: Create
│   │       ├── profile_view_screen.dart # ⏳ TODO: Create
│   │       └── settings_screen.dart # ⏳ TODO: Create
│   │
│   ├── 🧩 widgets/                  # Reusable widgets
│   │   ├── caregiver_card.dart      # ⏳ TODO: Create
│   │   ├── booking_card.dart        # ⏳ TODO: Create
│   │   ├── activity_update_card.dart # ⏳ TODO: Create
│   │   ├── review_card.dart         # ⏳ TODO: Create
│   │   ├── custom_button.dart       # ⏳ TODO: Create
│   │   ├── custom_text_field.dart   # ⏳ TODO: Create
│   │   ├── loading_indicator.dart   # ⏳ TODO: Create
│   │   └── error_widget.dart        # ⏳ TODO: Create
│   │
│   ├── ⚙️ services/                 # Business logic services
│   │   ├── firebase_service.dart    # ⏳ TODO: Create
│   │   ├── notification_service.dart # ⏳ TODO: Create
│   │   ├── location_service.dart    # ⏳ TODO: Create
│   │   └── image_service.dart       # ⏳ TODO: Create
│   │
│   └── 🛠 utils/                    # Utility files
│       ├── constants.dart           # ✅ App constants
│       ├── validators.dart          # ✅ Input validators
│       ├── theme.dart               # ⏳ TODO: Create
│       └── helpers.dart             # ⏳ TODO: Create
│
├── 🎨 assets/                       # Static assets
│   ├── images/                      # App images
│   │   └── (add images here)
│   └── icons/                       # App icons
│       └── (add icons here)
│
├── 📚 docs/                         # Documentation
│   ├── ARCHITECTURE.md              # ✅ Technical architecture
│   ├── DATABASE_SCHEMA.md           # ✅ Database structure
│   └── SETUP_GUIDE.md               # ✅ Detailed setup guide
│
├── 🧪 test/                         # Unit and widget tests
│   ├── widget_test.dart             # Default test file
│   ├── models/                      # ⏳ TODO: Add model tests
│   ├── providers/                   # ⏳ TODO: Add provider tests
│   └── widgets/                     # ⏳ TODO: Add widget tests
│
├── 📄 Configuration Files
│   ├── pubspec.yaml                 # ✅ Dependencies configured
│   ├── .gitignore                   # ✅ Git ignore rules
│   ├── .env.example                 # ✅ Environment variables template
│   ├── analysis_options.yaml        # Flutter analyzer options
│   └── README.md                    # ✅ Project documentation
│
├── 📖 Documentation Files
│   ├── README.md                    # ✅ Main documentation
│   ├── QUICKSTART.md                # ✅ Quick setup guide
│   ├── PROJECT_SUMMARY.md           # ✅ Project overview
│   ├── TEAM_CHECKLIST.md            # ✅ Week-by-week tasks
│   ├── CONTRIBUTING.md              # ✅ Contribution guidelines
│   └── LICENSE                      # ✅ MIT License
│
├── 🔧 IDE Configuration
│   └── .vscode/
│       ├── settings.json            # ✅ VS Code settings
│       └── launch.json              # ✅ Debug configurations
│
└── 📱 Platform Folders
    ├── android/                     # Android configuration
    ├── ios/                         # iOS configuration
    ├── web/                         # Web configuration
    ├── windows/                     # Windows configuration
    ├── linux/                       # Linux configuration
    └── macos/                       # macOS configuration
```

---

## 📊 File Status Legend

- ✅ **Created and Configured** - Ready to use
- ⏳ **TODO** - Needs to be created by team
- 📁 **Directory** - Folder structure in place

---

## 🎯 Priority Files to Create

### Week 1 Priority (Authentication)

**Team Member 1:**
1. `lib/repositories/auth_repository.dart`
2. `lib/providers/auth_provider.dart`
3. `lib/screens/auth/welcome_screen.dart`
4. `lib/screens/auth/signup_screen.dart`
5. `lib/screens/auth/login_screen.dart`

### Week 2 Priority (Discovery & Booking)

**Team Member 2:**
1. `lib/models/caregiver_model.dart`
2. `lib/models/booking_model.dart`
3. `lib/repositories/caregiver_repository.dart`
4. `lib/screens/owner/home_screen.dart`
5. `lib/screens/owner/search_results_screen.dart`

### Week 3 Priority (Monitoring)

**Team Member 3:**
1. `lib/models/activity_model.dart`
2. `lib/repositories/storage_repository.dart`
3. `lib/screens/caregiver/active_session_screen.dart`
4. `lib/screens/owner/activity_feed_screen.dart`

---

## 📦 Dependencies Configured

### Firebase
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage
- `firebase_messaging` - Push notifications

### State Management
- `provider` - State management

### UI & Utilities
- `image_picker` - Image selection
- `cached_network_image` - Image caching
- `geolocator` - Location services
- `geocoding` - Address lookup
- `intl` - Internationalization
- `uuid` - Unique ID generation
- `timeago` - Time formatting

---

## 🔥 Firebase Collections Structure

```
Firestore Database:
├── users/
│   └── {userId}
├── caregivers/
│   └── {userId}
├── pets/
│   └── {petId}
├── bookings/
│   ├── {bookingId}
│   └── activities/
│       └── {activityId}
├── reviews/
│   └── {reviewId}
└── chats/
    ├── {chatId}
    └── messages/
        └── {messageId}
```

---

## 🎨 Assets Organization

### Images Folder
```
assets/images/
├── logo.png                 # App logo
├── splash_bg.png            # Splash screen background
├── placeholder_user.png     # User placeholder
├── placeholder_pet.png      # Pet placeholder
└── onboarding/              # Onboarding images
    ├── welcome_1.png
    ├── welcome_2.png
    └── welcome_3.png
```

### Icons Folder
```
assets/icons/
├── app_icon.png             # App icon
├── walking.png              # Walking service icon
├── daycare.png              # Daycare service icon
├── overnight.png            # Overnight service icon
└── training.png             # Training service icon
```

---

## 🧪 Testing Structure

```
test/
├── models/
│   ├── user_model_test.dart
│   ├── pet_model_test.dart
│   ├── caregiver_model_test.dart
│   └── booking_model_test.dart
├── providers/
│   ├── auth_provider_test.dart
│   ├── caregiver_provider_test.dart
│   └── booking_provider_test.dart
├── repositories/
│   ├── auth_repository_test.dart
│   └── booking_repository_test.dart
└── widgets/
    ├── caregiver_card_test.dart
    └── booking_card_test.dart
```

---

## 📝 Code Organization Best Practices

### File Naming Convention
- Use `snake_case` for file names
- Example: `caregiver_profile_screen.dart`

### Class Naming Convention
- Use `PascalCase` for class names
- Example: `CaregiverProfileScreen`

### Import Organization
```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:provider/provider.dart';

// 4. Local imports
import '../models/user_model.dart';
```

---

## 🚀 Getting Started

1. **Read Documentation**
   - Start with `QUICKSTART.md`
   - Review `TEAM_CHECKLIST.md` for your tasks

2. **Set Up Firebase**
   - Run `flutterfire configure`
   - Enable services in Firebase Console

3. **Start Coding**
   - Pick your role from TEAM_CHECKLIST.md
   - Create files in priority order
   - Follow coding standards in CONTRIBUTING.md

4. **Test Regularly**
   - Run `flutter analyze`
   - Test on real devices
   - Fix issues as you go

---

## 📞 Questions?

Refer to:
- `README.md` - Project overview
- `docs/ARCHITECTURE.md` - Technical details
- `docs/DATABASE_SCHEMA.md` - Database structure
- `CONTRIBUTING.md` - Coding standards

---

**Project structure is ready! Start building! 🐾**
