import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for payment transactions
class PaymentModel {
  final String id;
  final String bookingId;
  final String ownerId;
  final String caregiverId;
  final double amount;
  final String paymentMethod; // 'card', 'wallet', 'cash'
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final String? transactionId;
  final String? cardLast4;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? refundedAt;

  PaymentModel({
    required this.id,
    required this.bookingId,
    required this.ownerId,
    required this.caregiverId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    this.cardLast4,
    this.failureReason,
    required this.createdAt,
    this.completedAt,
    this.refundedAt,
  });

  /// Create from Firestore document
  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      caregiverId: data['caregiverId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'cash',
      status: data['status'] ?? 'pending',
      transactionId: data['transactionId'],
      cardLast4: data['cardLast4'],
      failureReason: data['failureReason'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      refundedAt: data['refundedAt'] != null
          ? (data['refundedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'bookingId': bookingId,
      'ownerId': ownerId,
      'caregiverId': caregiverId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'cardLast4': cardLast4,
      'failureReason': failureReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'refundedAt':
          refundedAt != null ? Timestamp.fromDate(refundedAt!) : null,
    };
  }

  /// Create a copy with updated fields
  PaymentModel copyWith({
    String? id,
    String? bookingId,
    String? ownerId,
    String? caregiverId,
    double? amount,
    String? paymentMethod,
    String? status,
    String? transactionId,
    String? cardLast4,
    String? failureReason,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? refundedAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      ownerId: ownerId ?? this.ownerId,
      caregiverId: caregiverId ?? this.caregiverId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      cardLast4: cardLast4 ?? this.cardLast4,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      refundedAt: refundedAt ?? this.refundedAt,
    );
  }

  /// Check if payment is completed
  bool get isCompleted => status == 'completed';

  /// Check if payment is pending
  bool get isPending => status == 'pending';

  /// Check if payment failed
  bool get isFailed => status == 'failed';

  /// Check if payment is refunded
  bool get isRefunded => status == 'refunded';

  /// Get payment method display name
  String get paymentMethodDisplay {
    switch (paymentMethod) {
      case 'card':
        return cardLast4 != null ? 'Card ending in $cardLast4' : 'Credit/Debit Card';
      case 'wallet':
        return 'Digital Wallet';
      case 'cash':
        return 'Cash on Service';
      default:
        return paymentMethod;
    }
  }

  /// Get status display name
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }
}
