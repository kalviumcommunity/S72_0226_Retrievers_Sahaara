import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for favorite caregivers
class FavoriteModel {
  final String id;
  final String ownerId;
  final String caregiverId;
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.ownerId,
    required this.caregiverId,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory FavoriteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'caregiverId': caregiverId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
