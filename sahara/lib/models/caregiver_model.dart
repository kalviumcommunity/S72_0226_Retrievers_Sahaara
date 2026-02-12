import 'package:cloud_firestore/cloud_firestore.dart';

/// Caregiver model representing professional caregiver profiles
class CaregiverModel {
  final String caregiverId;
  final String userId; // Reference to user document
  final String bio;
  final int yearsOfExperience;
  final double hourlyRate;
  final List<String> servicesOffered;
  final List<String> petTypesHandled;
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final double rating;
  final int totalReviews;
  final int totalBookings;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? verifiedAt;

  CaregiverModel({
    required this.caregiverId,
    required this.userId,
    required this.bio,
    required this.yearsOfExperience,
    required this.hourlyRate,
    required this.servicesOffered,
    required this.petTypesHandled,
    this.verificationStatus = 'pending',
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalBookings = 0,
    this.isAvailable = true,
    required this.createdAt,
    this.verifiedAt,
  });

  /// Create CaregiverModel from Firestore document
  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiverModel(
      caregiverId: doc.id,
      userId: data['userId'] ?? '',
      bio: data['bio'] ?? '',
      yearsOfExperience: data['yearsOfExperience'] ?? 0,
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      servicesOffered: List<String>.from(data['servicesOffered'] ?? []),
      petTypesHandled: List<String>.from(data['petTypesHandled'] ?? []),
      verificationStatus: data['verificationStatus'] ?? 'pending',
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      totalBookings: data['totalBookings'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      verifiedAt: data['verifiedAt'] != null
          ? (data['verifiedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert CaregiverModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'caregiverId': caregiverId,
      'userId': userId,
      'bio': bio,
      'yearsOfExperience': yearsOfExperience,
      'hourlyRate': hourlyRate,
      'servicesOffered': servicesOffered,
      'petTypesHandled': petTypesHandled,
      'verificationStatus': verificationStatus,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalBookings': totalBookings,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    };
  }

  /// Create a copy with updated fields
  CaregiverModel copyWith({
    String? caregiverId,
    String? userId,
    String? bio,
    int? yearsOfExperience,
    double? hourlyRate,
    List<String>? servicesOffered,
    List<String>? petTypesHandled,
    String? verificationStatus,
    double? rating,
    int? totalReviews,
    int? totalBookings,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? verifiedAt,
  }) {
    return CaregiverModel(
      caregiverId: caregiverId ?? this.caregiverId,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      petTypesHandled: petTypesHandled ?? this.petTypesHandled,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  /// Check if caregiver is verified
  bool get isVerified => verificationStatus == 'verified';

  /// Get formatted hourly rate
  String get formattedRate => '₹${hourlyRate.toStringAsFixed(0)}/hr';

  /// Get experience text
  String get experienceText {
    if (yearsOfExperience == 0) return 'New caregiver';
    if (yearsOfExperience == 1) return '1 year experience';
    return '$yearsOfExperience years experience';
  }
}
