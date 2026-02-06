# Sahara Architecture Documentation

## Overview

Sahara follows the **MVVM (Model-View-ViewModel)** architecture pattern with the **Repository Pattern** for data management. This architecture ensures separation of concerns, testability, and maintainability.

## Architecture Layers

```
┌─────────────────────────────────────────────────┐
│         PRESENTATION LAYER (Flutter)            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ Screens  │  │ Widgets  │  │  Themes  │     │
│  └────┬─────┘  └────┬─────┘  └──────────┘     │
│       │             │                           │
│       └─────────────┴──────────┐               │
│                                 │               │
│       ┌─────────────────────────▼─────────┐    │
│       │   STATE MANAGEMENT (Provider)     │    │
│       │  (AuthProvider, BookingProvider)  │    │
│       └─────────────────┬─────────────────┘    │
└─────────────────────────┼──────────────────────┘
                          │
┌─────────────────────────▼──────────────────────┐
│         BUSINESS LOGIC LAYER                   │
│  ┌──────────────────────────────────────┐     │
│  │      Repository Classes              │     │
│  │  (AuthRepo, UserRepo, BookingRepo)   │     │
│  └──────────────────┬───────────────────┘     │
└─────────────────────┼──────────────────────────┘
                      │
┌─────────────────────▼──────────────────────────┐
│           DATA LAYER (Firebase)                │
│  ┌────────────┐ ┌──────────┐ ┌────────────┐  │
│  │  Firebase  │ │  Cloud   │ │  Firebase  │  │
│  │    Auth    │ │Firestore │ │  Storage   │  │
│  └────────────┘ └──────────┘ └────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────┐     │
│  │      Cloud Functions (Optional)      │     │
│  │  - Send notifications                │     │
│  │  - Process payments                  │     │
│  │  - Generate analytics                │     │
│  └──────────────────────────────────────┘     │
└─────────────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Presentation Layer (UI)

**Components:**
- Screens (full-page views)
- Widgets (reusable UI components)
- Themes (styling and design system)

**Responsibilities:**
- Display UI to users
- Capture user input (taps, forms, gestures)
- Listen to state changes from Providers
- Show loading states and error messages
- Navigate between screens

**Example:**
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caregiverProvider = Provider.of<CaregiverProvider>(context);
    
    if (caregiverProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      itemCount: caregiverProvider.caregivers.length,
      itemBuilder: (context, index) {
        return CaregiverCard(caregiver: caregiverProvider.caregivers[index]);
      },
    );
  }
}
```

### 2. State Management Layer (Provider)

**Components:**
- AuthProvider
- CaregiverProvider
- BookingProvider
- ActivityProvider

**Responsibilities:**
- Hold app state (user data, bookings, caregiver lists)
- Notify UI when data changes
- Manage loading and error states
- Cache data to reduce Firebase reads
- Coordinate between UI and business logic

**Example:**
```dart
class CaregiverProvider extends ChangeNotifier {
  List<Caregiver> _caregivers = [];
  bool _isLoading = false;
  String? _error;

  List<Caregiver> get caregivers => _caregivers;
  bool get isLoading => _isLoading;

  Future<void> fetchCaregivers() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _caregivers = await _caregiverRepository.getCaregivers();
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
```

### 3. Business Logic Layer (Repositories)

**Components:**
- AuthRepository
- UserRepository
- BookingRepository
- StorageRepository

**Responsibilities:**
- Handle all Firebase operations (CRUD)
- Implement business rules (validation, filtering)
- Transform Firebase data into app models
- Error handling and retry logic
- Abstract data sources from UI

**Example:**
```dart
class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('ownerId', isEqualTo: userId)
          .orderBy('scheduledDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Booking.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }
}
```

### 4. Data Layer (Firebase)

**Components:**
- Firebase Auth (authentication)
- Cloud Firestore (database)
- Firebase Storage (file storage)
- Cloud Functions (backend logic)

**Responsibilities:**
- User authentication and session management
- Real-time database with offline support
- Image and file hosting
- Backend automation and triggers

## Data Flow Example

### Booking a Caregiver

1. **User Action**: User taps "Book Now" button (UI)
2. **Provider Call**: BookingScreen calls `BookingProvider.createBooking()`
3. **Repository Call**: Provider calls `BookingRepository.createBooking(data)`
4. **Firebase Write**: Repository validates data and writes to Firestore
5. **Cloud Function**: Firestore triggers Cloud Function to notify caregiver
6. **Response**: Repository returns success/failure to Provider
7. **State Update**: Provider updates state and notifies UI
8. **UI Update**: UI shows success message or error dialog

## State Management Strategy

### Why Provider?

**Benefits:**
- Simple to learn for students
- Officially recommended by Flutter team
- Good performance with rebuild optimization
- Works well with Firebase real-time updates
- Less boilerplate than Bloc or Redux

### Provider Setup

```dart
// main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => CaregiverProvider()),
    ChangeNotifierProvider(create: (_) => BookingProvider()),
    ChangeNotifierProvider(create: (_) => ActivityProvider()),
  ],
  child: MyApp(),
)
```

## Real-Time Updates

### Firestore Listeners

For real-time features (activity feed, chat), we use Firestore's `StreamBuilder`:

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingId)
      .collection('activities')
      .orderBy('timestamp', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    final activities = snapshot.data!.docs
        .map((doc) => Activity.fromFirestore(doc))
        .toList();
    
    return ActivityFeed(activities: activities);
  },
)
```

## Error Handling

### Repository Level
```dart
try {
  // Firebase operation
} on FirebaseAuthException catch (e) {
  throw AuthException(e.message ?? 'Authentication failed');
} on FirebaseException catch (e) {
  throw DataException(e.message ?? 'Database error');
} catch (e) {
  throw UnknownException('An unexpected error occurred');
}
```

### Provider Level
```dart
Future<void> fetchData() async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  
  try {
    _data = await repository.getData();
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### UI Level
```dart
if (provider.error != null) {
  return ErrorWidget(message: provider.error!);
}
```

## Performance Optimization

### 1. Pagination
```dart
Query query = FirebaseFirestore.instance
    .collection('caregivers')
    .limit(20);

if (lastDocument != null) {
  query = query.startAfterDocument(lastDocument);
}
```

### 2. Caching
```dart
// Enable offline persistence
FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### 3. Image Optimization
```dart
// Compress images before upload
final compressedImage = await FlutterImageCompress.compressWithFile(
  file.path,
  quality: 70,
  minWidth: 1024,
  minHeight: 1024,
);
```

## Security Considerations

### 1. Authentication
- Use Firebase Auth for secure authentication
- Implement phone number verification
- Store sensitive data server-side only

### 2. Firestore Rules
- Validate user permissions
- Restrict read/write access
- Validate data structure

### 3. Storage Rules
- Restrict file uploads by user
- Limit file sizes
- Validate file types

## Testing Strategy

### Unit Tests
- Test models and data transformations
- Test repository methods
- Test business logic

### Widget Tests
- Test individual widgets
- Test user interactions
- Test state changes

### Integration Tests
- Test complete user flows
- Test Firebase integration
- Test navigation

## Scalability Considerations

### Current MVP
- Suitable for 1,000-10,000 users
- Basic Firestore queries
- Client-side business logic

### Future Scale
- Cloud Functions for complex operations
- Firestore indexes for efficient queries
- CDN for image delivery
- Caching strategies
- Load balancing

## Conclusion

This architecture provides:
- ✅ Clear separation of concerns
- ✅ Easy to test and maintain
- ✅ Scalable for future growth
- ✅ Real-time capabilities
- ✅ Offline support
- ✅ Type-safe data models
