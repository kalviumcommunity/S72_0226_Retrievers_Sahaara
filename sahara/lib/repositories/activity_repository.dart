import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import '../utils/constants.dart';

/// Repository for activity data operations
class ActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new activity
  Future<String> createActivity(ActivityModel activity) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(activity.bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .add(activity.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  /// Get activities for a booking
  Future<List<ActivityModel>> getBookingActivities(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ActivityModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch activities: $e');
    }
  }

  /// Get activities stream for real-time updates
  Stream<List<ActivityModel>> getBookingActivitiesStream(String bookingId) {
    return _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .collection(AppConstants.activitiesSubcollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromFirestore(doc))
            .toList());
  }

  /// Get activity by ID
  Future<ActivityModel?> getActivityById({
    required String bookingId,
    required String activityId,
  }) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .doc(activityId)
          .get();

      if (doc.exists) {
        return ActivityModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch activity: $e');
    }
  }

  /// Update activity
  Future<void> updateActivity({
    required String bookingId,
    required String activityId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .doc(activityId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  /// Delete activity
  Future<void> deleteActivity({
    required String bookingId,
    required String activityId,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .doc(activityId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  /// Get activities by type
  Future<List<ActivityModel>> getActivitiesByType({
    required String bookingId,
    required String type,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .where('type', isEqualTo: type)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ActivityModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch activities by type: $e');
    }
  }

  /// Get recent activities count
  Future<int> getActivitiesCount(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .collection(AppConstants.activitiesSubcollection)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get activities count: $e');
    }
  }
}
