import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';

/// Provider for booking state management
class BookingProvider with ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  List<BookingModel> _bookings = [];
  List<BookingModel> _upcomingBookings = [];
  List<BookingModel> _activeBookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  List<BookingModel> get upcomingBookings => _upcomingBookings;
  List<BookingModel> get activeBookings => _activeBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load bookings for owner
  Future<void> loadOwnerBookings(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _repository.getOwnerBookings(ownerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load bookings for caregiver
  Future<void> loadCaregiverBookings(String caregiverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _repository.getCaregiverBookings(caregiverId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load upcoming bookings
  Future<void> loadUpcomingBookings(String userId, {bool isCaregiver = false}) async {
    try {
      _upcomingBookings = await _repository.getUpcomingBookings(userId, isCaregiver: isCaregiver);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Load active bookings
  Future<void> loadActiveBookings(String userId, {bool isCaregiver = false}) async {
    try {
      _activeBookings = await _repository.getActiveBookings(userId, isCaregiver: isCaregiver);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Create a new booking
  Future<String?> createBooking(BookingModel booking) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check for conflicts
      final hasConflict = await _repository.hasConflict(
        caregiverId: booking.caregiverId,
        startDate: booking.startDate,
        endDate: booking.endDate,
      );

      if (hasConflict) {
        _error = 'Caregiver is not available for the selected time slot';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final bookingId = await _repository.createBooking(booking);
      _isLoading = false;
      notifyListeners();
      return bookingId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      return await _repository.getBookingById(bookingId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Confirm booking (caregiver action)
  Future<bool> confirmBooking(String bookingId) async {
    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'confirmed',
      );
      
      // Update local list
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: 'confirmed',
          confirmedAt: DateTime.now(),
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Start booking (caregiver action)
  Future<bool> startBooking(String bookingId) async {
    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'in-progress',
      );
      
      // Update local list
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: 'in-progress');
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Complete booking
  Future<bool> completeBooking(String bookingId) async {
    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'completed',
      );
      
      // Update local list
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: 'completed',
          completedAt: DateTime.now(),
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cancel booking
  Future<bool> cancelBooking(String bookingId, String reason) async {
    try {
      await _repository.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );
      
      // Update local list
      final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: 'cancelled',
          cancelledAt: DateTime.now(),
          cancellationReason: reason,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get bookings by status
  List<BookingModel> getBookingsByStatus(String status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
