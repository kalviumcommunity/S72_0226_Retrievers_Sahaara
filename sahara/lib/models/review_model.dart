import 'package:cloud_firestore/cloud_firestore.dart';

/// Review model for caregiver ratings
class ReviewModel {
  final String reviewId;
  final String bookingId;
  final String caregiverId;
  final String ownerId;
  final String petId;
  final double rating;
  final String? comment;
  final List<String> tags; // e.g., 'punctual', 'caring', 'professional'
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.reviewId,
    required this.bookingId,
    required this.caregiverId,
    required this.ownerId,
    required this.petId,
    required this.rating,
    this.comment,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
  });

  /// Create ReviewModel from Firestore document
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewId: doc.id,
      bookingId: data['bookingId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      petId: data['petId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'],
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert ReviewModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'bookingId': bookingId,
      'caregiverId': caregiverId,
      'ownerId': ownerId,
      'petId': petId,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Create a copy with updated fields
  ReviewModel copyWith({
    String? reviewId,
    String? bookingId,
    String? caregiverId,
    String? ownerId,
    String? petId,
    double? rating,
    String? comment,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      bookingId: bookingId ?? this.bookingId,
      caregiverId: caregiverId ?? this.caregiverId,
      ownerId: ownerId ?? this.ownerId,
      petId: petId ?? this.petId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
