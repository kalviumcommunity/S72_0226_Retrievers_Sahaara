import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing both pet owners and caregivers
class UserModel {
  final String userId;
  final String email;
  final String role; // 'owner' or 'caregiver'
  final String name;
  final String phone;
  final bool phoneVerified;
  final String? profilePhoto;
  final UserLocation? location;
  final DateTime createdAt;
  final DateTime lastActive;

  UserModel({
    required this.userId,
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    this.phoneVerified = false,
    this.profilePhoto,
    this.location,
    required this.createdAt,
    required this.lastActive,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'owner',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      phoneVerified: data['phoneVerified'] ?? false,
      profilePhoto: data['profilePhoto'],
      location: data['location'] != null
          ? UserLocation.fromMap(data['location'])
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
    );
  }

  /// Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'phoneVerified': phoneVerified,
      'profilePhoto': profilePhoto,
      'location': location?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? role,
    String? name,
    String? phone,
    bool? phoneVerified,
    String? profilePhoto,
    UserLocation? location,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

/// User location model
class UserLocation {
  final String address;
  final GeoPoint geopoint;

  UserLocation({
    required this.address,
    required this.geopoint,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      address: map['address'] ?? '',
      geopoint: map['geopoint'] as GeoPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'geopoint': geopoint,
    };
  }
}
