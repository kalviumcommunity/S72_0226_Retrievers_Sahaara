import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analytics_model.dart';
import '../utils/constants.dart';

/// Repository for analytics data operations
class AnalyticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get owner analytics
  Future<AnalyticsModel> getOwnerAnalytics(String ownerId) async {
    try {
      // Get all bookings for owner
      final bookingsSnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final bookings = bookingsSnapshot.docs;
      final totalBookings = bookings.length;

      // Calculate booking counts by status
      final completedBookings = bookings
          .where((doc) => doc.data()['status'] == 'completed')
          .length;
      final cancelledBookings = bookings
          .where((doc) => doc.data()['status'] == 'cancelled')
          .length;
      final pendingBookings = bookings
          .where((doc) => doc.data()['status'] == 'pending')
          .length;

      // Calculate total amount spent
      final totalAmount = bookings
          .where((doc) => doc.data()['status'] == 'completed')
          .fold<double>(
              0, (sum, doc) => sum + (doc.data()['totalAmount'] ?? 0));

      // Get bookings by service
      final bookingsByService = <String, int>{};
      final revenueByService = <String, double>{};

      for (var doc in bookings) {
        final service = doc.data()['serviceType'] as String? ?? 'unknown';
        final amount = (doc.data()['totalAmount'] ?? 0).toDouble();
        final status = doc.data()['status'] as String?;

        bookingsByService[service] = (bookingsByService[service] ?? 0) + 1;

        if (status == 'completed') {
          revenueByService[service] =
              (revenueByService[service] ?? 0) + amount;
        }
      }

      // Get monthly data (last 6 months)
      final monthlyData = await _getMonthlyData(ownerId, false);

      // Get average rating from reviews
      final reviewsSnapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final reviews = reviewsSnapshot.docs;
      final totalReviews = reviews.length;
      final averageRating = totalReviews > 0
          ? reviews.fold<double>(
                  0, (sum, doc) => sum + (doc.data()['rating'] ?? 0)) /
              totalReviews
          : 0.0;

      return AnalyticsModel(
        totalBookings: totalBookings,
        completedBookings: completedBookings,
        cancelledBookings: cancelledBookings,
        pendingBookings: pendingBookings,
        totalAmount: totalAmount,
        averageRating: averageRating,
        totalReviews: totalReviews,
        bookingsByService: bookingsByService,
        revenueByService: revenueByService,
        monthlyData: monthlyData,
      );
    } catch (e) {
      throw Exception('Failed to get owner analytics: $e');
    }
  }

  /// Get caregiver analytics
  Future<AnalyticsModel> getCaregiverAnalytics(String caregiverId) async {
    try {
      // Get all bookings for caregiver
      final bookingsSnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .get();

      final bookings = bookingsSnapshot.docs;
      final totalBookings = bookings.length;

      // Calculate booking counts by status
      final completedBookings = bookings
          .where((doc) => doc.data()['status'] == 'completed')
          .length;
      final cancelledBookings = bookings
          .where((doc) => doc.data()['status'] == 'cancelled')
          .length;
      final pendingBookings = bookings
          .where((doc) => doc.data()['status'] == 'pending')
          .length;

      // Calculate total earnings
      final totalAmount = bookings
          .where((doc) => doc.data()['status'] == 'completed')
          .fold<double>(
              0, (sum, doc) => sum + (doc.data()['totalAmount'] ?? 0));

      // Get bookings by service
      final bookingsByService = <String, int>{};
      final revenueByService = <String, double>{};

      for (var doc in bookings) {
        final service = doc.data()['serviceType'] as String? ?? 'unknown';
        final amount = (doc.data()['totalAmount'] ?? 0).toDouble();
        final status = doc.data()['status'] as String?;

        bookingsByService[service] = (bookingsByService[service] ?? 0) + 1;

        if (status == 'completed') {
          revenueByService[service] =
              (revenueByService[service] ?? 0) + amount;
        }
      }

      // Get monthly data (last 6 months)
      final monthlyData = await _getMonthlyData(caregiverId, true);

      // Get average rating from reviews
      final reviewsSnapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .get();

      final reviews = reviewsSnapshot.docs;
      final totalReviews = reviews.length;
      final averageRating = totalReviews > 0
          ? reviews.fold<double>(
                  0, (sum, doc) => sum + (doc.data()['rating'] ?? 0)) /
              totalReviews
          : 0.0;

      return AnalyticsModel(
        totalBookings: totalBookings,
        completedBookings: completedBookings,
        cancelledBookings: cancelledBookings,
        pendingBookings: pendingBookings,
        totalAmount: totalAmount,
        averageRating: averageRating,
        totalReviews: totalReviews,
        bookingsByService: bookingsByService,
        revenueByService: revenueByService,
        monthlyData: monthlyData,
      );
    } catch (e) {
      throw Exception('Failed to get caregiver analytics: $e');
    }
  }

  /// Get monthly data for last 6 months
  Future<List<MonthlyData>> _getMonthlyData(
      String userId, bool isCaregiver) async {
    final now = DateTime.now();
    final monthlyData = <MonthlyData>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(now.year, now.month - i + 1, 1);

      final field = isCaregiver ? 'caregiverId' : 'ownerId';

      final bookingsSnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where(field, isEqualTo: userId)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(month))
          .where('createdAt', isLessThan: Timestamp.fromDate(nextMonth))
          .get();

      final bookings = bookingsSnapshot.docs;
      final bookingCount = bookings.length;

      final revenue = bookings
          .where((doc) => doc.data()['status'] == 'completed')
          .fold<double>(
              0, (sum, doc) => sum + (doc.data()['totalAmount'] ?? 0));

      monthlyData.add(MonthlyData(
        month: month.month.toString(),
        year: month.year,
        bookings: bookingCount,
        revenue: revenue,
      ));
    }

    return monthlyData;
  }

  /// Get pet analytics for owner
  Future<List<PetAnalytics>> getPetAnalytics(String ownerId) async {
    try {
      // Get all bookings for owner
      final bookingsSnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final petBookings = <String, List<Map<String, dynamic>>>{};

      // Group bookings by pet
      for (var doc in bookingsSnapshot.docs) {
        final petId = doc.data()['petId'] as String?;
        if (petId != null) {
          petBookings.putIfAbsent(petId, () => []);
          petBookings[petId]!.add(doc.data());
        }
      }

      // Calculate analytics for each pet
      final petAnalyticsList = <PetAnalytics>[];

      for (var entry in petBookings.entries) {
        final petId = entry.key;
        final bookings = entry.value;

        // Get pet name
        final petDoc =
            await _firestore.collection(AppConstants.petsCollection).doc(petId).get();
        final petName = petDoc.data()?['name'] ?? 'Unknown Pet';

        // Calculate total spent
        final totalSpent = bookings
            .where((b) => b['status'] == 'completed')
            .fold<double>(0, (sum, b) => sum + (b['totalAmount'] ?? 0));

        // Find favorite service
        final serviceCounts = <String, int>{};
        for (var booking in bookings) {
          final service = booking['serviceType'] as String? ?? 'unknown';
          serviceCounts[service] = (serviceCounts[service] ?? 0) + 1;
        }

        final favoriteService = serviceCounts.isNotEmpty
            ? serviceCounts.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key
            : 'None';

        petAnalyticsList.add(PetAnalytics(
          petId: petId,
          petName: petName,
          bookingCount: bookings.length,
          totalSpent: totalSpent,
          favoriteService: favoriteService,
        ));
      }

      return petAnalyticsList;
    } catch (e) {
      throw Exception('Failed to get pet analytics: $e');
    }
  }

  /// Get client analytics for caregiver
  Future<List<ClientAnalytics>> getClientAnalytics(String caregiverId) async {
    try {
      // Get all bookings for caregiver
      final bookingsSnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .get();

      final clientBookings = <String, List<Map<String, dynamic>>>{};

      // Group bookings by owner
      for (var doc in bookingsSnapshot.docs) {
        final ownerId = doc.data()['ownerId'] as String?;
        if (ownerId != null) {
          clientBookings.putIfAbsent(ownerId, () => []);
          clientBookings[ownerId]!.add(doc.data());
        }
      }

      // Calculate analytics for each client
      final clientAnalyticsList = <ClientAnalytics>[];

      for (var entry in clientBookings.entries) {
        final ownerId = entry.key;
        final bookings = entry.value;

        // Get owner name
        final ownerDoc =
            await _firestore.collection(AppConstants.usersCollection).doc(ownerId).get();
        final ownerName = ownerDoc.data()?['name'] ?? 'Unknown Owner';

        // Calculate total revenue
        final totalRevenue = bookings
            .where((b) => b['status'] == 'completed')
            .fold<double>(0, (sum, b) => sum + (b['totalAmount'] ?? 0));

        // Get average rating from this client
        final reviewsSnapshot = await _firestore
            .collection(AppConstants.reviewsCollection)
            .where('caregiverId', isEqualTo: caregiverId)
            .where('ownerId', isEqualTo: ownerId)
            .get();

        final reviews = reviewsSnapshot.docs;
        final averageRating = reviews.isNotEmpty
            ? reviews.fold<double>(
                    0, (sum, doc) => sum + (doc.data()['rating'] ?? 0)) /
                reviews.length
            : 0.0;

        clientAnalyticsList.add(ClientAnalytics(
          ownerId: ownerId,
          ownerName: ownerName,
          bookingCount: bookings.length,
          totalRevenue: totalRevenue,
          averageRating: averageRating,
        ));
      }

      // Sort by total revenue (highest first)
      clientAnalyticsList.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

      return clientAnalyticsList;
    } catch (e) {
      throw Exception('Failed to get client analytics: $e');
    }
  }
}
