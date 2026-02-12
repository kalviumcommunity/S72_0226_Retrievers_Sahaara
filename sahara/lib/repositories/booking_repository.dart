import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../utils/constants.dart';

/// Repository for handling booking data operations
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

      if (!doc.exists) return null;
      return BookingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Get all bookings for an owner
  Future<List<BookingModel>> getOwnerBookings(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('scheduledDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch owner bookings: $e');
    }
  }

  /// Get all bookings for a caregiver
  Future<List<BookingModel>> getCaregiverBookings(String caregiverId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .orderBy('scheduledDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch caregiver bookings: $e');
    }
  }

  /// Get upcoming bookings for an owner
  Future<List<BookingModel>> getUpcomingOwnerBookings(String ownerId) async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .where('scheduledDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('scheduledDate')
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming bookings: $e');
    }
  }

  /// Get upcoming bookings for a caregiver
  Future<List<BookingModel>> getUpcomingCaregiverBookings(String caregiverId) async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('caregiverId', isEqualTo: caregiverId)
          .where('scheduledDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('scheduledDate')
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming caregiver bookings: $e');
    }
  }

  /// Get bookings by status
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    String status,
    {bool isCaregiver = false}
  ) async {
    try {
      final field = isCaregiver ? 'caregiverId' : 'ownerId';
      final snapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where(field, isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('scheduledDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by status: $e');
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(
    String bookingId,
    String newStatus,
  ) async {
    try {
      final updateData = <String, dynamic>{
        'status': newStatus,
      };

      // Add timestamp based on status
      if (newStatus == 'confirmed') {
        updateData['confirmedAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == 'in-progress') {
        updateData['startedAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == 'completed') {
        updateData['completedAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == 'cancelled') {
        updateData['cancelledAt'] = FieldValue.serverTimestamp();
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
  Future<void> cancelBooking(
    String bookingId,
    String cancellationReason,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'status': AppConstants.bookingStatusCancelled,
        'cancellationReason': cancellationReason,
        'cancelledAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
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

  /// Get booking stream for real-time updates
  Stream<BookingModel?> getBookingStream(String bookingId) {
    return _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return BookingModel.fromFirestore(doc);
    });
  }

  /// Get owner bookings stream
  Stream<List<BookingModel>> getOwnerBookingsStream(String ownerId) {
    return _firestore
        .collection(AppConstants.bookingsCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }

  /// Get caregiver bookings stream
  Stream<List<BookingModel>> getCaregiverBookingsStream(String caregiverId) {
    return _firestore
        .collection(AppConstants.bookingsCollection)
        .where('caregiverId', isEqualTo: caregiverId)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }
}
