# 🐾 Sahara - Pet Discovery & Monitoring Platform

**Trusted Pet Discovery & Monitoring**

Sahara is a comprehensive Flutter application that connects pet owners with trusted caregivers, providing a safe and reliable platform for pet care services with real-time monitoring capabilities.

---

## 📱 About

Sahara bridges the gap between pet owners seeking reliable care and professional caregivers offering their services. The platform features:

- **For Pet Owners:** Find trusted caregivers, book services, monitor your pets in real-time
- **For Caregivers:** Manage bookings, provide updates, build your professional profile
- **Real-time Monitoring:** Photo updates, activity tracking, and instant messaging
- **Secure Platform:** Firebase authentication, verified profiles, and secure payments

---

## ✨ Features

### Authentication & Profiles
- ✅ Email/Password authentication
- ✅ Google Sign-In integration
- ✅ Role-based access (Owner/Caregiver)
- ✅ Complete profile management
- ✅ Photo upload with compression
- ✅ GPS location services
- ✅ Phone verification (ready)

### Pet Management
- ✅ Add multiple pets
- ✅ Pet profiles with photos
- ✅ Medical information tracking
- ✅ Special needs documentation
- ✅ Pet list and detail views
- ✅ Edit and delete pets

### Caregiver Features
- ✅ Professional profile setup
- ✅ Services offered selection
- ✅ Hourly rate management
- ✅ Experience tracking
- ✅ Stats dashboard
- ✅ Booking management (ready)

### User Experience
- ✅ Role-based home screens
- ✅ Navigation drawer
- ✅ Settings management
- ✅ Loading skeletons
- ✅ Empty states
- ✅ Error handling
- ✅ Smooth animations
- ✅ Pull-to-refresh

### Coming Soon (Week 2+)
- 🔄 Caregiver discovery & search
- 🔄 Booking system
- 🔄 Real-time chat
- 🔄 Activity updates
- 🔄 Reviews & ratings
- 🔄 Payment integration
- 🔄 Notifications

---

## 🏗️ Architecture

### Design Pattern
- **MVVM (Model-View-ViewModel)** with Repository pattern
- **Provider** for state management
- **Service Layer** for business logic
- **Clean Architecture** principles

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   └── pet_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   └── pet_provider.dart
├── repositories/             # Data layer
│   ├── auth_repository.dart
│   ├── user_repository.dart
│   └── pet_repository.dart
├── services/                 # Business logic
│   ├── image_service.dart
│   └── location_service.dart
├── screens/                  # UI screens
│   ├── auth/                # Authentication screens
│   ├── common/              # Shared screens
│   ├── owner/               # Pet owner screens
│   └── caregiver/           # Caregiver screens
├── widgets/                  # Reusable widgets
│   ├── loading_skeleton.dart
│   ├── empty_state.dart
│   ├── error_state.dart
│   └── custom_button.dart
└── utils/                    # Utilities
    ├── constants.dart
    ├── validators.dart
    └── page_transitions.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/kalviumcommunity/S72_0226_Retrievers_Sahaara.git
   cd S72_0226_Retrievers_Sahaara/sahara
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

4. **Create .env file** (optional)
   ```bash
   cp .env.example .env
   # Add your API keys
   ```

5. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

---

## 🔧 Configuration

### Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)

2. Enable Authentication:
   - Email/Password
   - Google Sign-In

3. Create Firestore Database:
   - Start in test mode (update rules later)
   - Create collections: `users`, `pets`, `caregivers`

4. Enable Firebase Storage:
   - For profile photos and pet images

5. Run FlutterFire configuration:
   ```bash
   flutterfire configure
   ```

### Environment Variables

Create a `.env` file in the root directory:
```env
# Firebase (optional - handled by flutterfire)
FIREBASE_API_KEY=your_api_key
FIREBASE_APP_ID=your_app_id

# Google Maps (for location services)
GOOGLE_MAPS_API_KEY=your_maps_key
```

---

## 📦 Dependencies

### Core
- `flutter` - UI framework
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage

### State Management
- `provider` - State management

### UI/UX
- `cached_network_image` - Image caching
- `image_picker` - Photo selection
- `geolocator` - GPS location
- `geocoding` - Address conversion

### Utilities
- `intl` - Internationalization
- `uuid` - Unique IDs
- `timeago` - Time formatting

---

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Test Structure
```
test/
├── unit/                    # Unit tests
├── widget/                  # Widget tests
└── integration/             # Integration tests
```

---

## 📱 Screens

### Authentication Flow
1. **Welcome Screen** - App introduction
2. **Role Selection** - Choose Owner or Caregiver
3. **Signup/Login** - Email or Google authentication
4. **Profile Setup** - Complete user profile
5. **Pet/Caregiver Profile** - Role-specific setup

### Owner Screens
- **Home Dashboard** - Quick actions and pet overview
- **Pet List** - View all pets
- **Pet Detail** - Full pet information
- **Pet Form** - Add/edit pets
- **Profile View** - User profile
- **Settings** - App settings

### Caregiver Screens
- **Home Dashboard** - Stats and schedule
- **Professional Profile** - Services and rates
- **Bookings** - Manage bookings (coming soon)
- **Schedule** - View schedule (coming soon)
- **Profile View** - User profile
- **Settings** - App settings

---

## 🎨 Design System

### Colors
- **Primary:** Indigo (#6366F1)
- **Secondary:** Purple
- **Success:** Green
- **Warning:** Orange
- **Error:** Red

### Typography
- **Headings:** Bold, 24-32px
- **Body:** Regular, 16px
- **Caption:** Regular, 14px

### Components
- **Buttons:** Rounded (16px), Full-width
- **Cards:** Elevated, Rounded (12px)
- **Inputs:** Outlined, Rounded (12px)

---

## 🔐 Security

### Authentication
- Firebase Authentication
- Email verification
- Password reset
- Re-authentication for sensitive actions

### Data Security
- Firestore security rules
- User data isolation
- Role-based access control
- Secure file uploads

### Best Practices
- Input validation
- Error handling
- Secure storage
- HTTPS only

---

## 📚 Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [Setup Guide](docs/SETUP_GUIDE.md)
- [Contributing Guide](CONTRIBUTING.md)

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Write documentation

---

## 📄 License

This project is part of the Kalvium S72 curriculum.

---

## 👥 Team

**Team Retrievers**
- **Gaurav** - Authentication & Profile Management
- **Team Member 2** - Discovery & Booking System
- **Team Member 3** - Monitoring & Reviews

---

## 📞 Support

For support, email: support@sahara.app

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Kalvium for the opportunity
- All contributors and testers

---

## 📊 Project Status

**Week 1: Complete ✅**
- Authentication system
- Profile management
- Pet management
- Home screens
- Settings & polish

**Week 2: In Progress 🔄**
- Caregiver discovery
- Booking system
- Real-time chat

**Week 3: Planned 📅**
- Activity monitoring
- Reviews & ratings
- Payment integration

---

**Built with ❤️ by Team Retrievers**
