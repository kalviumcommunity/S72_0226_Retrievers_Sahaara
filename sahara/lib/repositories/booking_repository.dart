import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../utils/constants.dart';

/// Repository for booking data operations
class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new booking
  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.bookingsCollection)
          .add(booking.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .get();

      if (doc.exists) {
        return BookingModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Get bookings for owner
  Future<List<BookingModel>> getOwnerBookings(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch owner bookings: $e');
    }
  }

  /// Get bookings for caregiver
  Future<List<BookingModel>> getCaregiverBookings(String caregiverId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch caregiver bookings: $e');
    }
  }

  /// Get bookings by status
  Future<List<BookingModel>> getBookingsByStatus({
    required String userId,
    required String status,
    bool isCaregiver = false,
  }) async {
    try {
      final field = isCaregiver ? 'caregiverId' : 'ownerId';
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where(field, isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by status: $e');
    }
  }

  /// Get upcoming bookings
  Future<List<BookingModel>> getUpcomingBookings(String userId, {bool isCaregiver = false}) async {
    try {
      final field = isCaregiver ? 'caregiverId' : 'ownerId';
      final now = DateTime.now();
      
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where(field, isEqualTo: userId)
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('startDate')
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming bookings: $e');
    }
  }

  /// Get active bookings (in-progress)
  Future<List<BookingModel>> getActiveBookings(String userId, {bool isCaregiver = false}) async {
    try {
      final field = isCaregiver ? 'caregiverId' : 'ownerId';
      
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where(field, isEqualTo: userId)
          .where('status', isEqualTo: AppConstants.bookingStatusInProgress)
          .orderBy('startDate')
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch active bookings: $e');
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      final updateData = <String, dynamic>{'status': status};
      
      if (status == AppConstants.bookingStatusConfirmed) {
        updateData['confirmedAt'] = Timestamp.now();
      } else if (status == AppConstants.bookingStatusCompleted) {
        updateData['completedAt'] = Timestamp.now();
      } else if (status == AppConstants.bookingStatusCancelled) {
        updateData['cancelledAt'] = Timestamp.now();
      }

      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Cancel booking
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'status': AppConstants.bookingStatusCancelled,
        'cancelledAt': Timestamp.now(),
        'cancellationReason': reason,
      });
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Update booking
  Future<void> updateBooking({
    required String bookingId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  /// Delete booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  /// Check for booking conflicts
  Future<bool> hasConflict({
    required String caregiverId,
    required DateTime startDate,
    required DateTime endDate,
    String? excludeBookingId,
  }) async {
    try {
      var query = _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .where('status', whereIn: ['pending', 'confirmed', 'in-progress']);

      final snapshot = await query.get();
      
      for (final doc in snapshot.docs) {
        if (excludeBookingId != null && doc.id == excludeBookingId) {
          continue;
        }
        
        final booking = BookingModel.fromFirestore(doc);
        
        // Check for overlap
        if (startDate.isBefore(booking.endDate) && endDate.isAfter(booking.startDate)) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      throw Exception('Failed to check booking conflicts: $e');
    }
  }
}
