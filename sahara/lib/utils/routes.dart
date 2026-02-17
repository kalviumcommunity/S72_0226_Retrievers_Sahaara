/// App Routes - Centralized route management
class AppRoutes {
  AppRoutes._();

  // ============ SPLASH & ONBOARDING ============
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ============ AUTH ROUTES ============
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';

  // ============ HOME ROUTES ============
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookings = '/bookings';
  static const String messages = '/messages';
  static const String profile = '/profile';

  // ============ PROFILE ROUTES ============
  static const String editProfile = '/edit-profile';
  static const String profileSetup = '/profile-setup';
  static const String accountSettings = '/account-settings';
  static const String preferences = '/preferences';
  static const String notifications = '/notifications';
  static const String privacySettings = '/privacy-settings';

  // ============ PET ROUTES ============
  static const String petList = '/pets';
  static const String petDetail = '/pet-detail';
  static const String addPet = '/add-pet';
  static const String editPet = '/edit-pet';

  // ============ CAREGIVER ROUTES ============
  static const String caregiverList = '/caregivers';
  static const String caregiverProfile = '/caregiver-profile';
  static const String becomeCaregiver = '/become-caregiver';

  // ============ BOOKING ROUTES ============
  static const String bookingDetails = '/booking-detail';
  static const String createBooking = '/create-booking';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String trackBooking = '/track-booking';

  // ============ REVIEW & RATING ROUTES ============
  static const String reviews = '/reviews';
  static const String addReview = '/add-review';
  static const String editReview = '/edit-review';

  // ============ CHAT ROUTES ============
  static const String chatList = '/chats';
  static const String chatDetail = '/chat-detail';

  // ============ SUPPORT ROUTES ============
  static const String help = '/help';
  static const String faq = '/faq';
  static const String contactSupport = '/contact-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';

  // ============ ERROR ROUTES ============
  static const String notFound = '/404';
  static const String error = '/error';
}

/// Navigation helper for cleaner navigation calls
class NavigationService {
  NavigationService._();

  /// Navigate to a named route
  static Future<dynamic> navigateTo(
    dynamic context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  static Future<dynamic> navigateAndReplace(
    dynamic context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and clear all previous routes
  static Future<dynamic> navigateAndClearStack(
    dynamic context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous screen
  static void goBack(dynamic context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  /// Can go back
  static bool canGoBack(dynamic context) {
    return Navigator.canPop(context);
  }

  /// Go back multiple times
  static void goBackMultiple(dynamic context, int count) {
    for (int i = 0; i < count; i++) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}
