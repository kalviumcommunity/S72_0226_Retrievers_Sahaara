import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';

/// Provider for managing booking state
class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();

  List<BookingModel> _bookings = [];
  BookingModel? _selectedBooking;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BookingModel> get bookings => _bookings;
  BookingModel? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get upcoming bookings
  List<BookingModel> get upcomingBookings {
    final now = DateTime.now();
    return _bookings
        .where((b) => 
            b.scheduledDate.isAfter(now) && 
            (b.status == 'pending' || b.status == 'confirmed'))
        .toList();
  }

  /// Get past bookings
  List<BookingModel> get pastBookings {
    final now = DateTime.now();
    return _bookings
        .where((b) => 
            b.scheduledDate.isBefore(now) || 
            b.status == 'completed' || 
            b.status == 'cancelled')
        .toList();
  }

  /// Get active bookings
  List<BookingModel> get activeBookings {
    return _bookings
        .where((b) => b.status == 'in-progress')
        .toList();
  }

  /// Load bookings for owner
  Future<void> loadOwnerBookings(String ownerId) async {
    _setLoading(true);
    _error = null;

    try {
      _bookings = await _bookingRepository.getOwnerBookings(ownerId);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Load bookings for caregiver
  Future<void> loadCaregiverBookings(String caregiverId) async {
    _setLoading(true);
    _error = null;

    try {
      _bookings = await _bookingRepository.getCaregiverBookings(caregiverId);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Load booking by ID
  Future<void> loadBookingById(String bookingId) async {
    _setLoading(true);
    _error = null;

    try {
      _selectedBooking = await _bookingRepository.getBookingById(bookingId);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  /// Create a new booking
  Future<bool> createBooking(BookingModel booking) async {
    _setLoading(true);
    _error = null;

    try {
      final bookingId = await _bookingRepository.createBooking(booking);
      
      // Reload bookings
      await loadOwnerBookings(booking.ownerId);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Update booking status
  Future<bool> updateBookingStatus(
    String bookingId,
    String newStatus,
  ) async {
    _setLoading(true);
    _error = null;

    try {
      await _bookingRepository.updateBookingStatus(bookingId, newStatus);
      
      // Update local booking
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: newStatus);
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Cancel booking
  Future<bool> cancelBooking(
    String bookingId,
    String cancellationReason,
  ) async {
    _setLoading(true);
    _error = null;

    try {
      await _bookingRepository.cancelBooking(bookingId, cancellationReason);
      
      // Update local booking
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: 'cancelled',
          cancellationReason: cancellationReason,
        );
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Get bookings by status
  List<BookingModel> getBookingsByStatus(String status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Calculate total earnings (for caregivers)
  double get totalEarnings {
    return _bookings
        .where((b) => b.status == 'completed')
        .fold(0.0, (sum, b) => sum + b.totalAmount);
  }

  /// Get booking count by status
  int getBookingCountByStatus(String status) {
    return _bookings.where((b) => b.status == status).length;
  }
}
