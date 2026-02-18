import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../utils/constants.dart';

/// Repository for review data operations
class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new review
  Future<String> createReview(ReviewModel review) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.reviewsCollection)
          .add(review.toMap());

      // Update caregiver stats
      await _updateCaregiverStats(review.caregiverId);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  /// Get review by ID
  Future<ReviewModel?> getReviewById(String reviewId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(reviewId)
          .get();

      if (doc.exists) {
        return ReviewModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch review: $e');
    }
  }

  /// Get review by booking ID
  Future<ReviewModel?> getReviewByBookingId(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ReviewModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch review by booking: $e');
    }
  }

  /// Get reviews for a caregiver
  Future<List<ReviewModel>> getCaregiverReviews(String caregiverId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch caregiver reviews: $e');
    }
  }

  /// Get reviews by owner
  Future<List<ReviewModel>> getOwnerReviews(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch owner reviews: $e');
    }
  }

  /// Update review
  Future<void> updateReview({
    required String reviewId,
    required ReviewModel review,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(reviewId)
          .update(review.toMap());

      // Update caregiver stats
      await _updateCaregiverStats(review.caregiverId);
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  /// Delete review
  Future<void> deleteReview(String reviewId, String caregiverId) async {
    try {
      await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(reviewId)
          .delete();

      // Update caregiver stats
      await _updateCaregiverStats(caregiverId);
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  /// Get average rating for caregiver
  Future<double> getCaregiverAverageRating(String caregiverId) async {
    try {
      final reviews = await getCaregiverReviews(caregiverId);
      if (reviews.isEmpty) return 0.0;

      final sum = reviews.fold<double>(0, (sum, review) => sum + review.rating);
      return sum / reviews.length;
    } catch (e) {
      throw Exception('Failed to calculate average rating: $e');
    }
  }

  /// Get review count for caregiver
  Future<int> getCaregiverReviewCount(String caregiverId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get review count: $e');
    }
  }

  /// Update caregiver stats after review changes
  Future<void> _updateCaregiverStats(String caregiverId) async {
    try {
      final reviews = await getCaregiverReviews(caregiverId);
      
      if (reviews.isEmpty) {
        // Reset stats if no reviews
        await _firestore
            .collection(AppConstants.caregiversCollection)
            .doc(caregiverId)
            .update({
          'stats.averageRating': 0.0,
          'stats.totalReviews': 0,
        });
        return;
      }

      final averageRating = reviews.fold<double>(
            0,
            (sum, review) => sum + review.rating,
          ) /
          reviews.length;

      await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .update({
        'stats.averageRating': averageRating,
        'stats.totalReviews': reviews.length,
      });
    } catch (e) {
      // Log error but don't throw to prevent review operation failure
      print('Failed to update caregiver stats: $e');
    }
  }

  /// Get reviews with pagination
  Future<List<ReviewModel>> getReviewsPaginated({
    required String caregiverId,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _firestore
          .collection(AppConstants.reviewsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated reviews: $e');
    }
  }
}
