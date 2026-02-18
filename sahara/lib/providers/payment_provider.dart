import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';
import '../repositories/payment_repository.dart';

/// Provider for payment state management
class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();

  List<PaymentModel> _payments = [];
  PaymentModel? _currentPayment;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _paymentStats;

  // Getters
  List<PaymentModel> get payments => _payments;
  PaymentModel? get currentPayment => _currentPayment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get paymentStats => _paymentStats;

  /// Create a new payment
  Future<String?> createPayment({
    required String bookingId,
    required String ownerId,
    required String caregiverId,
    required double amount,
    required String paymentMethod,
    String? cardLast4,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final payment = PaymentModel(
        id: '',
        bookingId: bookingId,
        ownerId: ownerId,
        caregiverId: caregiverId,
        amount: amount,
        paymentMethod: paymentMethod,
        status: 'pending',
        cardLast4: cardLast4,
        createdAt: DateTime.now(),
      );

      final paymentId = await _paymentRepository.createPayment(payment);
      _currentPayment = payment.copyWith(id: paymentId);

      _isLoading = false;
      notifyListeners();

      return paymentId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Process payment
  Future<bool> processPayment({
    required String paymentId,
    required String paymentMethod,
    String? cardToken,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _paymentRepository.processPayment(
        paymentId: paymentId,
        paymentMethod: paymentMethod,
        cardToken: cardToken,
      );

      if (result['success'] == true) {
        // Refresh current payment
        await getPaymentById(paymentId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get payment by ID
  Future<void> getPaymentById(String paymentId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentPayment = await _paymentRepository.getPaymentById(paymentId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get payment by booking ID
  Future<PaymentModel?> getPaymentByBookingId(String bookingId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final payment = await _paymentRepository.getPaymentByBookingId(bookingId);
      _currentPayment = payment;

      _isLoading = false;
      notifyListeners();

      return payment;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Load user payments
  Future<void> loadUserPayments(String userId, bool isCaregiver) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (isCaregiver) {
        _payments = await _paymentRepository.getCaregiverPayments(userId);
      } else {
        _payments = await _paymentRepository.getOwnerPayments(userId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load payment statistics
  Future<void> loadPaymentStats(String userId, bool isCaregiver) async {
    try {
      if (isCaregiver) {
        _paymentStats =
            await _paymentRepository.getCaregiverPaymentStats(userId);
      } else {
        _paymentStats = await _paymentRepository.getOwnerPaymentStats(userId);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Refund payment
  Future<bool> refundPayment(String paymentId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _paymentRepository.refundPayment(paymentId);

      // Refresh current payment
      await getPaymentById(paymentId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Stream user payments
  Stream<List<PaymentModel>> streamUserPayments(
      String userId, bool isCaregiver) {
    return _paymentRepository.streamUserPayments(userId, isCaregiver);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear current payment
  void clearCurrentPayment() {
    _currentPayment = null;
    notifyListeners();
  }

  /// Get completed payments
  List<PaymentModel> get completedPayments =>
      _payments.where((p) => p.status == 'completed').toList();

  /// Get pending payments
  List<PaymentModel> get pendingPayments =>
      _payments.where((p) => p.status == 'pending').toList();

  /// Get failed payments
  List<PaymentModel> get failedPayments =>
      _payments.where((p) => p.status == 'failed').toList();

  /// Get total earnings (for caregivers)
  double get totalEarnings =>
      completedPayments.fold(0, (sum, p) => sum + p.amount);

  /// Get total spent (for owners)
  double get totalSpent =>
      completedPayments.fold(0, (sum, p) => sum + p.amount);

  /// Get pending amount
  double get pendingAmount =>
      pendingPayments.fold(0, (sum, p) => sum + p.amount);
}
