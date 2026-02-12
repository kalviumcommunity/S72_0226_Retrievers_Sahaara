import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/caregiver_model.dart';
import '../utils/constants.dart';

/// Repository for handling caregiver data operations
class CaregiverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all caregivers
  Future<List<CaregiverModel>> getAllCaregivers() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch caregivers: $e');
    }
  }

  /// Get verified caregivers only
  Future<List<CaregiverModel>> getVerifiedCaregivers() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch verified caregivers: $e');
    }
  }

  /// Get caregiver by ID
  Future<CaregiverModel?> getCaregiverById(String caregiverId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .get();

      if (!doc.exists) return null;
      return CaregiverModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch caregiver: $e');
    }
  }

  /// Get caregiver by user ID
  Future<CaregiverModel?> getCaregiverByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return CaregiverModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to fetch caregiver by user ID: $e');
    }
  }

  /// Search caregivers by service type
  Future<List<CaregiverModel>> searchByService(String serviceType) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('servicesOffered', arrayContains: serviceType)
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search caregivers by service: $e');
    }
  }

  /// Search caregivers by pet type
  Future<List<CaregiverModel>> searchByPetType(String petType) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('petTypesHandled', arrayContains: petType)
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search caregivers by pet type: $e');
    }
  }

  /// Filter caregivers by minimum rating
  Future<List<CaregiverModel>> filterByRating(double minRating) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('rating', isGreaterThanOrEqualTo: minRating)
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter caregivers by rating: $e');
    }
  }

  /// Filter caregivers by hourly rate range
  Future<List<CaregiverModel>> filterByPriceRange({
    required double minRate,
    required double maxRate,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('hourlyRate', isGreaterThanOrEqualTo: minRate)
          .where('hourlyRate', isLessThanOrEqualTo: maxRate)
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('hourlyRate')
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter caregivers by price: $e');
    }
  }

  /// Update caregiver availability
  Future<void> updateAvailability(String caregiverId, bool isAvailable) async {
    try {
      await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .update({'isAvailable': isAvailable});
    } catch (e) {
      throw Exception('Failed to update availability: $e');
    }
  }

  /// Update caregiver rating
  Future<void> updateRating(
    String caregiverId,
    double newRating,
    int totalReviews,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .update({
        'rating': newRating,
        'totalReviews': totalReviews,
      });
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  /// Increment total bookings
  Future<void> incrementBookings(String caregiverId) async {
    try {
      await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .update({
        'totalBookings': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment bookings: $e');
    }
  }
}
