import 'package:cloud_firestore/cloud_firestore.dart';

/// Booking model for pet care services
class BookingModel {
  final String bookingId;
  final String ownerId;
  final String caregiverId;
  final String petId;
  final String serviceType;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double totalAmount;
  final String? specialInstructions;
  final BookingLocation? location;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  BookingModel({
    required this.bookingId,
    required this.ownerId,
    required this.caregiverId,
    required this.petId,
    required this.serviceType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalAmount,
    this.specialInstructions,
    this.location,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  /// Create BookingModel from Firestore document
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: doc.id,
      ownerId: data['ownerId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      petId: data['petId'] ?? '',
      serviceType: data['serviceType'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      specialInstructions: data['specialInstructions'],
      location: data['location'] != null
          ? BookingLocation.fromMap(data['location'])
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      confirmedAt: data['confirmedAt'] != null
          ? (data['confirmedAt'] as Timestamp).toDate()
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      cancelledAt: data['cancelledAt'] != null
          ? (data['cancelledAt'] as Timestamp).toDate()
          : null,
      cancellationReason: data['cancellationReason'],
    );
  }

  /// Convert BookingModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'ownerId': ownerId,
      'caregiverId': caregiverId,
      'petId': petId,
      'serviceType': serviceType,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions,
      'location': location?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
    };
  }

  /// Create a copy with updated fields
  BookingModel copyWith({
    String? bookingId,
    String? ownerId,
    String? caregiverId,
    String? petId,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalAmount,
    String? specialInstructions,
    BookingLocation? location,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      ownerId: ownerId ?? this.ownerId,
      caregiverId: caregiverId ?? this.caregiverId,
      petId: petId ?? this.petId,
      serviceType: serviceType ?? this.serviceType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  /// Calculate duration in hours
  int get durationInHours {
    return endDate.difference(startDate).inHours;
  }

  /// Calculate duration in days
  int get durationInDays {
    return endDate.difference(startDate).inDays;
  }

  /// Check if booking is active
  bool get isActive {
    return status == 'confirmed' || status == 'in-progress';
  }

  /// Check if booking can be cancelled
  bool get canBeCancelled {
    return status == 'pending' || status == 'confirmed';
  }
}

/// Booking location model
class BookingLocation {
  final String address;
  final GeoPoint geopoint;
  final String? additionalInfo;

  BookingLocation({
    required this.address,
    required this.geopoint,
    this.additionalInfo,
  });

  factory BookingLocation.fromMap(Map<String, dynamic> map) {
    return BookingLocation(
      address: map['address'] ?? '',
      geopoint: map['geopoint'] as GeoPoint,
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'geopoint': geopoint,
      'additionalInfo': additionalInfo,
    };
  }
}
