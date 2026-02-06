/// Input validation utilities
class Validators {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  /// Validate phone number (Indian format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Indian phone number: +91XXXXXXXXXX or 10 digits
    final phoneRegex = RegExp(r'^(\+91)?[6-9]\d{9}$');

    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate number
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;

    if (double.parse(value!) <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }

  /// Validate hourly rate
  static String? validateHourlyRate(String? value) {
    final numberError = validatePositiveNumber(value, 'Hourly rate');
    if (numberError != null) return numberError;

    final rate = double.parse(value!);

    if (rate < 100) {
      return 'Hourly rate must be at least ₹100';
    }

    if (rate > 2000) {
      return 'Hourly rate must be less than ₹2000';
    }

    return null;
  }

  /// Validate age
  static String? validateAge(String? value) {
    final numberError = validatePositiveNumber(value, 'Age');
    if (numberError != null) return numberError;

    final age = int.parse(value!);

    if (age < 0) {
      return 'Age cannot be negative';
    }

    if (age > 30) {
      return 'Please enter a valid age';
    }

    return null;
  }

  /// Validate weight
  static String? validateWeight(String? value) {
    final numberError = validatePositiveNumber(value, 'Weight');
    if (numberError != null) return numberError;

    final weight = double.parse(value!);

    if (weight > 200) {
      return 'Please enter a valid weight';
    }

    return null;
  }

  /// Validate bio/description
  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bio is required';
    }

    if (value.length < 20) {
      return 'Bio must be at least 20 characters';
    }

    if (value.length > 500) {
      return 'Bio must be less than 500 characters';
    }

    return null;
  }

  /// Validate rating
  static String? validateRating(int? value) {
    if (value == null) {
      return 'Please select a rating';
    }

    if (value < 1 || value > 5) {
      return 'Rating must be between 1 and 5';
    }

    return null;
  }

  /// Validate review comment
  static String? validateReviewComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please write a review';
    }

    if (value.length < 10) {
      return 'Review must be at least 10 characters';
    }

    if (value.length > 500) {
      return 'Review must be less than 500 characters';
    }

    return null;
  }

  /// Validate experience years
  static String? validateExperienceYears(String? value) {
    final numberError = validateNumber(value, 'Experience years');
    if (numberError != null) return numberError;

    final years = int.parse(value!);

    if (years < 0) {
      return 'Experience cannot be negative';
    }

    if (years > 50) {
      return 'Please enter valid experience years';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate date (not in past)
  static String? validateFutureDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);

    if (selectedDate.isBefore(today)) {
      return 'Please select a future date';
    }

    return null;
  }

  /// Validate time slot
  static String? validateTimeSlot(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a time slot';
    }

    // Format: HH:MM-HH:MM
    final timeSlotRegex = RegExp(r'^\d{2}:\d{2}-\d{2}:\d{2}$');

    if (!timeSlotRegex.hasMatch(value)) {
      return 'Invalid time slot format';
    }

    return null;
  }
}
