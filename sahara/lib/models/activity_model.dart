import 'package:cloud_firestore/cloud_firestore.dart';

/// Activity update model for pet care tracking
class ActivityModel {
  final String activityId;
  final String bookingId;
  final String caregiverId;
  final String petId;
  final String type; // 'photo', 'text', 'milestone', 'location'
  final String? description;
  final String? photoUrl;
  final ActivityLocation? location;
  final DateTime timestamp;

  ActivityModel({
    required this.activityId,
    required this.bookingId,
    required this.caregiverId,
    required this.petId,
    required this.type,
    this.description,
    this.photoUrl,
    this.location,
    required this.timestamp,
  });

  /// Create ActivityModel from Firestore document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      activityId: doc.id,
      bookingId: data['bookingId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      petId: data['petId'] ?? '',
      type: data['type'] ?? 'text',
      description: data['description'],
      photoUrl: data['photoUrl'],
      location: data['location'] != null
          ? ActivityLocation.fromMap(data['location'])
          : null,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Convert ActivityModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'bookingId': bookingId,
      'caregiverId': caregiverId,
      'petId': petId,
      'type': type,
      'description': description,
      'photoUrl': photoUrl,
      'location': location?.toMap(),
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

/// Activity location model
class ActivityLocation {
  final double latitude;
  final double longitude;
  final String? address;

  ActivityLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory ActivityLocation.fromMap(Map<String, dynamic> map) {
    return ActivityLocation(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
