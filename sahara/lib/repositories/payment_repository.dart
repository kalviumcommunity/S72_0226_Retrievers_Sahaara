import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';
import '../utils/constants.dart';

/// Repository for payment data operations
class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new payment
  Future<String> createPayment(PaymentModel payment) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.paymentsCollection)
          .add(payment.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Get payment by ID
  Future<PaymentModel?> getPaymentById(String paymentId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.paymentsCollection)
          .doc(paymentId)
          .get();

      if (!doc.exists) return null;
      return PaymentModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  /// Get payment by booking ID
  Future<PaymentModel?> getPaymentByBookingId(String bookingId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.paymentsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return PaymentModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get payment by booking: $e');
    }
  }

  /// Get all payments for an owner
  Future<List<PaymentModel>> getOwnerPayments(String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.paymentsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get owner payments: $e');
    }
  }

  /// Get all payments for a caregiver
  Future<List<PaymentModel>> getCaregiverPayments(String caregiverId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.paymentsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get caregiver payments: $e');
    }
  }

  /// Update payment status
  Future<void> updatePaymentStatus({
    required String paymentId,
    required String status,
    String? transactionId,
    String? failureReason,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
      };

      if (status == 'completed') {
        updateData['completedAt'] = Timestamp.now();
        if (transactionId != null) {
          updateData['transactionId'] = transactionId;
        }
      } else if (status == 'failed' && failureReason != null) {
        updateData['failureReason'] = failureReason;
      } else if (status == 'refunded') {
        updateData['refundedAt'] = Timestamp.now();
      }

      await _firestore
          .collection(AppConstants.paymentsCollection)
          .doc(paymentId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Process payment (simulated for now)
  Future<Map<String, dynamic>> processPayment({
    required String paymentId,
    required String paymentMethod,
    String? cardToken,
  }) async {
    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate payment success (90% success rate)
      final isSuccess = DateTime.now().millisecond % 10 != 0;

      if (isSuccess) {
        // Generate mock transaction ID
        final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

        // Update payment status
        await updatePaymentStatus(
          paymentId: paymentId,
          status: 'completed',
          transactionId: transactionId,
        );

        return {
          'success': true,
          'transactionId': transactionId,
          'message': 'Payment processed successfully',
        };
      } else {
        // Payment failed
        await updatePaymentStatus(
          paymentId: paymentId,
          status: 'failed',
          failureReason: 'Payment declined by bank',
        );

        return {
          'success': false,
          'message': 'Payment declined. Please try another payment method.',
        };
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  /// Refund payment
  Future<void> refundPayment(String paymentId) async {
    try {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw Exception('Payment not found');
      }

      if (payment.status != 'completed') {
        throw Exception('Only completed payments can be refunded');
      }

      await updatePaymentStatus(
        paymentId: paymentId,
        status: 'refunded',
      );
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }

  /// Get payment statistics for caregiver
  Future<Map<String, dynamic>> getCaregiverPaymentStats(
      String caregiverId) async {
    try {
      final payments = await getCaregiverPayments(caregiverId);

      final completedPayments =
          payments.where((p) => p.status == 'completed').toList();

      final totalEarnings =
          completedPayments.fold<double>(0, (sum, p) => sum + p.amount);

      final pendingPayments =
          payments.where((p) => p.status == 'pending').toList();

      final pendingAmount =
          pendingPayments.fold<double>(0, (sum, p) => sum + p.amount);

      return {
        'totalEarnings': totalEarnings,
        'completedCount': completedPayments.length,
        'pendingAmount': pendingAmount,
        'pendingCount': pendingPayments.length,
        'totalTransactions': payments.length,
      };
    } catch (e) {
      throw Exception('Failed to get payment stats: $e');
    }
  }

  /// Get payment statistics for owner
  Future<Map<String, dynamic>> getOwnerPaymentStats(String ownerId) async {
    try {
      final payments = await getOwnerPayments(ownerId);

      final completedPayments =
          payments.where((p) => p.status == 'completed').toList();

      final totalSpent =
          completedPayments.fold<double>(0, (sum, p) => sum + p.amount);

      final pendingPayments =
          payments.where((p) => p.status == 'pending').toList();

      final pendingAmount =
          pendingPayments.fold<double>(0, (sum, p) => sum + p.amount);

      return {
        'totalSpent': totalSpent,
        'completedCount': completedPayments.length,
        'pendingAmount': pendingAmount,
        'pendingCount': pendingPayments.length,
        'totalTransactions': payments.length,
      };
    } catch (e) {
      throw Exception('Failed to get payment stats: $e');
    }
  }

  /// Stream payments for a user (owner or caregiver)
  Stream<List<PaymentModel>> streamUserPayments(
      String userId, bool isCaregiver) {
    final field = isCaregiver ? 'caregiverId' : 'ownerId';

    return _firestore
        .collection(AppConstants.paymentsCollection)
        .where(field, isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList());
  }
}
