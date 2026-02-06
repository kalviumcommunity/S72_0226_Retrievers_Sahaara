/// App-wide constants and configuration values
class AppConstants {
  // App Information
  static const String appName = 'Sahara';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Trusted Pet Discovery & Monitoring';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String caregiversCollection = 'caregivers';
  static const String petsCollection = 'pets';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  static const String chatsCollection = 'chats';
  static const String activitiesSubcollection = 'activities';
  static const String messagesSubcollection = 'messages';

  // Firebase Storage Paths
  static const String userPhotosPath = 'users';
  static const String petPhotosPath = 'pets';
  static const String activityPhotosPath = 'activities';
  static const String documentsPath = 'documents';
  static const String certificatesPath = 'certificates';

  // User Roles
  static const String roleOwner = 'owner';
  static const String roleCaregiver = 'caregiver';

  // Booking Status
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusConfirmed = 'confirmed';
  static const String bookingStatusInProgress = 'in-progress';
  static const String bookingStatusCompleted = 'completed';
  static const String bookingStatusCancelled = 'cancelled';

  // Service Types
  static const String serviceWalking = 'walking';
  static const String serviceDaycare = 'daycare';
  static const String serviceOvernight = 'overnight';
  static const String serviceTraining = 'training';

  // Pet Types
  static const String petTypeDog = 'dog';
  static const String petTypeCat = 'cat';
  static const String petTypeBird = 'bird';
  static const String petTypeOther = 'other';

  // Verification Status
  static const String verificationPending = 'pending';
  static const String verificationVerified = 'verified';
  static const String verificationRejected = 'rejected';

  // Activity Types
  static const String activityTypePhoto = 'photo';
  static const String activityTypeText = 'text';
  static const String activityTypeMilestone = 'milestone';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxBioLength = 500;
  static const int maxMessageLength = 1000;
  static const int minRating = 1;
  static const int maxRating = 5;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Location
  static const double defaultSearchRadiusKm = 10.0;
  static const double maxSearchRadiusKm = 50.0;

  // Pricing
  static const double minHourlyRate = 100.0;
  static const double maxHourlyRate = 2000.0;

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 70;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;

  // Time
  static const int sessionTimeoutMinutes = 30;
  static const int notificationDelaySeconds = 5;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorPermission = 'Permission denied.';
  static const String errorNotFound = 'Resource not found.';

  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successBooking = 'Booking created successfully!';
  static const String successReview = 'Review submitted successfully!';
  static const String successUpdate = 'Updated successfully!';
}

/// Service type options
class ServiceTypes {
  static const List<Map<String, dynamic>> all = [
    {
      'id': AppConstants.serviceWalking,
      'name': 'Walking',
      'icon': 'directions_walk',
      'description': 'Daily walks for your pet',
    },
    {
      'id': AppConstants.serviceDaycare,
      'name': 'Daycare',
      'icon': 'home',
      'description': 'Full day pet care',
    },
    {
      'id': AppConstants.serviceOvernight,
      'name': 'Overnight Stay',
      'icon': 'hotel',
      'description': 'Overnight pet boarding',
    },
    {
      'id': AppConstants.serviceTraining,
      'name': 'Training',
      'icon': 'school',
      'description': 'Pet training sessions',
    },
  ];
}

/// Pet type options
class PetTypes {
  static const List<Map<String, dynamic>> all = [
    {
      'id': AppConstants.petTypeDog,
      'name': 'Dog',
      'icon': 'pets',
    },
    {
      'id': AppConstants.petTypeCat,
      'name': 'Cat',
      'icon': 'pets',
    },
    {
      'id': AppConstants.petTypeBird,
      'name': 'Bird',
      'icon': 'flutter_dash',
    },
    {
      'id': AppConstants.petTypeOther,
      'name': 'Other',
      'icon': 'pets',
    },
  ];
}

/// Common dog breeds
class DogBreeds {
  static const List<String> popular = [
    'Golden Retriever',
    'Labrador Retriever',
    'German Shepherd',
    'Beagle',
    'Pug',
    'Shih Tzu',
    'Pomeranian',
    'Husky',
    'Rottweiler',
    'Doberman',
    'Indie Dog',
    'Mixed Breed',
    'Other',
  ];
}

/// Common cat breeds
class CatBreeds {
  static const List<String> popular = [
    'Persian',
    'Siamese',
    'Maine Coon',
    'British Shorthair',
    'Bengal',
    'Ragdoll',
    'Indie Cat',
    'Mixed Breed',
    'Other',
  ];
}
