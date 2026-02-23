/// Model for analytics data
class AnalyticsModel {
  final int totalBookings;
  final int completedBookings;
  final int cancelledBookings;
  final int pendingBookings;
  final double totalAmount;
  final double averageRating;
  final int totalReviews;
  final Map<String, int> bookingsByService;
  final Map<String, double> revenueByService;
  final List<MonthlyData> monthlyData;

  AnalyticsModel({
    required this.totalBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.pendingBookings,
    required this.totalAmount,
    required this.averageRating,
    required this.totalReviews,
    required this.bookingsByService,
    required this.revenueByService,
    required this.monthlyData,
  });

  /// Calculate completion rate
  double get completionRate {
    if (totalBookings == 0) return 0;
    return (completedBookings / totalBookings) * 100;
  }

  /// Calculate cancellation rate
  double get cancellationRate {
    if (totalBookings == 0) return 0;
    return (cancelledBookings / totalBookings) * 100;
  }

  /// Get most popular service
  String get mostPopularService {
    if (bookingsByService.isEmpty) return 'None';
    return bookingsByService.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get highest revenue service
  String get highestRevenueService {
    if (revenueByService.isEmpty) return 'None';
    return revenueByService.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

/// Model for monthly analytics data
class MonthlyData {
  final String month;
  final int year;
  final int bookings;
  final double revenue;

  MonthlyData({
    required this.month,
    required this.year,
    required this.bookings,
    required this.revenue,
  });

  /// Get month name
  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthIndex = int.tryParse(month) ?? 1;
    return months[monthIndex - 1];
  }

  /// Get display label
  String get label => '$monthName $year';
}

/// Model for service analytics
class ServiceAnalytics {
  final String serviceName;
  final int bookingCount;
  final double revenue;
  final double averageRating;

  ServiceAnalytics({
    required this.serviceName,
    required this.bookingCount,
    required this.revenue,
    required this.averageRating,
  });

  /// Calculate percentage of total bookings
  double getPercentage(int totalBookings) {
    if (totalBookings == 0) return 0;
    return (bookingCount / totalBookings) * 100;
  }
}

/// Model for pet analytics (for owners)
class PetAnalytics {
  final String petId;
  final String petName;
  final int bookingCount;
  final double totalSpent;
  final String favoriteService;

  PetAnalytics({
    required this.petId,
    required this.petName,
    required this.bookingCount,
    required this.totalSpent,
    required this.favoriteService,
  });
}

/// Model for caregiver client analytics
class ClientAnalytics {
  final String ownerId;
  final String ownerName;
  final int bookingCount;
  final double totalRevenue;
  final double averageRating;

  ClientAnalytics({
    required this.ownerId,
    required this.ownerName,
    required this.bookingCount,
    required this.totalRevenue,
    required this.averageRating,
  });
}
