import 'package:cloud_firestore/cloud_firestore.dart';

/// Caregiver model representing professional caregiver profiles
class CaregiverModel {
  final String caregiverId;
  final String userId;
  final String bio;
  final int experienceYears;
  final double hourlyRate;
  final List<String> servicesOffered;
  final List<String> petTypesHandled;
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final bool isActive;
  final CaregiverStats stats;
  final DateTime createdAt;
  final DateTime? lastActive;

  CaregiverModel({
    required this.caregiverId,
    required this.userId,
    required this.bio,
    required this.experienceYears,
    required this.hourlyRate,
    required this.servicesOffered,
    required this.petTypesHandled,
    this.verificationStatus = 'pending',
    this.isActive = true,
    required this.stats,
    required this.createdAt,
    this.lastActive,
  });

  /// Create CaregiverModel from Firestore document
  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiverModel(
      caregiverId: doc.id,
      userId: data['userId'] ?? '',
      bio: data['bio'] ?? '',
      experienceYears: data['experienceYears'] ?? 0,
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      servicesOffered: List<String>.from(data['servicesOffered'] ?? []),
      petTypesHandled: List<String>.from(data['petTypesHandled'] ?? []),
      verificationStatus: data['verificationStatus'] ?? 'pending',
      isActive: data['isActive'] ?? true,
      stats: CaregiverStats.fromMap(data['stats'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert CaregiverModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'caregiverId': caregiverId,
      'userId': userId,
      'bio': bio,
      'experienceYears': experienceYears,
      'hourlyRate': hourlyRate,
      'servicesOffered': servicesOffered,
      'petTypesHandled': petTypesHandled,
      'verificationStatus': verificationStatus,
      'isActive': isActive,
      'stats': stats.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }

  /// Create a copy with updated fields
  CaregiverModel copyWith({
    String? caregiverId,
    String? userId,
    String? bio,
    int? experienceYears,
    double? hourlyRate,
    List<String>? servicesOffered,
    List<String>? petTypesHandled,
    String? verificationStatus,
    bool? isActive,
    CaregiverStats? stats,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return CaregiverModel(
      caregiverId: caregiverId ?? this.caregiverId,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      experienceYears: experienceYears ?? this.experienceYears,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      petTypesHandled: petTypesHandled ?? this.petTypesHandled,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isActive: isActive ?? this.isActive,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

/// Caregiver statistics model
class CaregiverStats {
  final int totalBookings;
  final int completedBookings;
  final double averageRating;
  final int totalReviews;
  final int responseTimeMinutes;

  CaregiverStats({
    this.totalBookings = 0,
    this.completedBookings = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.responseTimeMinutes = 0,
  });

  factory CaregiverStats.fromMap(Map<String, dynamic> map) {
    return CaregiverStats(
      totalBookings: map['totalBookings'] ?? 0,
      completedBookings: map['completedBookings'] ?? 0,
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      responseTimeMinutes: map['responseTimeMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'responseTimeMinutes': responseTimeMinutes,
    };
  }
}
