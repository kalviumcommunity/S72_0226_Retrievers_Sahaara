import 'package:cloud_firestore/cloud_firestore.dart';

/// Booking model representing a service booking
class BookingModel {
  final String bookingId;
  final String ownerId;
  final String caregiverId;
  final String petId;
  final String serviceType; // 'walking', 'daycare', 'overnight', 'training'
  final String status; // 'pending', 'confirmed', 'in-progress', 'completed', 'cancelled'
  final DateTime scheduledDate;
  final int durationHours;
  final double totalAmount;
  final String? specialInstructions;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  BookingModel({
    required this.bookingId,
    required this.ownerId,
    required this.caregiverId,
    required this.petId,
    required this.serviceType,
    this.status = 'pending',
    required this.scheduledDate,
    required this.durationHours,
    required this.totalAmount,
    this.specialInstructions,
    this.cancellationReason,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  /// Create BookingModel from Firestore document
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: doc.id,
      ownerId: data['ownerId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      petId: data['petId'] ?? '',
      serviceType: data['serviceType'] ?? 'walking',
      status: data['status'] ?? 'pending',
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      durationHours: data['durationHours'] ?? 1,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      specialInstructions: data['specialInstructions'],
      cancellationReason: data['cancellationReason'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      confirmedAt: data['confirmedAt'] != null
          ? (data['confirmedAt'] as Timestamp).toDate()
          : null,
      startedAt: data['startedAt'] != null
          ? (data['startedAt'] as Timestamp).toDate()
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      cancelledAt: data['cancelledAt'] != null
          ? (data['cancelledAt'] as Timestamp).toDate()
          : null,
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
      'status': status,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'durationHours': durationHours,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions,
      'cancellationReason': cancellationReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
    };
  }

  /// Create a copy with updated fields
  BookingModel copyWith({
    String? bookingId,
    String? ownerId,
    String? caregiverId,
    String? petId,
    String? serviceType,
    String? status,
    DateTime? scheduledDate,
    int? durationHours,
    double? totalAmount,
    String? specialInstructions,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      ownerId: ownerId ?? this.ownerId,
      caregiverId: caregiverId ?? this.caregiverId,
      petId: petId ?? this.petId,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      durationHours: durationHours ?? this.durationHours,
      totalAmount: totalAmount ?? this.totalAmount,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  /// Get formatted total amount
  String get formattedAmount => '₹${totalAmount.toStringAsFixed(0)}';

  /// Get service type display name
  String get serviceTypeName {
    switch (serviceType) {
      case 'walking':
        return 'Dog Walking';
      case 'daycare':
        return 'Pet Daycare';
      case 'overnight':
        return 'Overnight Stay';
      case 'training':
        return 'Pet Training';
      default:
        return serviceType;
    }
  }

  /// Get status display name
  String get statusName {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in-progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Check if booking can be cancelled
  bool get canBeCancelled {
    return status == 'pending' || status == 'confirmed';
  }

  /// Check if booking is active
  bool get isActive {
    return status == 'confirmed' || status == 'in-progress';
  }
}
