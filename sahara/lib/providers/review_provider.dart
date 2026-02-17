import 'package:flutter/foundation.dart';
import '../models/review_model.dart';
import '../repositories/review_repository.dart';

/// Provider for review state management
class ReviewProvider with ChangeNotifier {
  final ReviewRepository _repository = ReviewRepository();

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  String? _error;

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load reviews for a caregiver
  Future<void> loadCaregiverReviews(String caregiverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _repository.getCaregiverReviews(caregiverId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load reviews by owner
  Future<void> loadOwnerReviews(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _repository.getOwnerReviews(ownerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get review by booking ID
  Future<ReviewModel?> getReviewByBookingId(String bookingId) async {
    try {
      return await _repository.getReviewByBookingId(bookingId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Create a new review
  Future<String?> createReview(ReviewModel review) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reviewId = await _repository.createReview(review);
      _isLoading = false;
      notifyListeners();
      return reviewId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update review
  Future<bool> updateReview({
    required String reviewId,
    required ReviewModel review,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateReview(
        reviewId: reviewId,
        review: review,
      );

      // Update local list
      final index = _reviews.indexWhere((r) => r.reviewId == reviewId);
      if (index != -1) {
        _reviews[index] = review;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete review
  Future<bool> deleteReview(String reviewId, String caregiverId) async {
    try {
      await _repository.deleteReview(reviewId, caregiverId);

      // Remove from local list
      _reviews.removeWhere((r) => r.reviewId == reviewId);
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get average rating
  Future<double> getCaregiverAverageRating(String caregiverId) async {
    try {
      return await _repository.getCaregiverAverageRating(caregiverId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    }
  }

  /// Get review count
  Future<int> getCaregiverReviewCount(String caregiverId) async {
    try {
      return await _repository.getCaregiverReviewCount(caregiverId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear data
  void clear() {
    _reviews = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
