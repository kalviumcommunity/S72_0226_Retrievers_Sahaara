import '../models/booking_model.dart';

/// Utility class for exporting booking data
class BookingExportUtil {
  /// Export bookings to CSV format
  static String exportToCSV(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return 'No bookings to export';
    }

    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln(
        'Booking ID,Service Type,Start Date,End Date,Status,Total Amount,Created At');

    // CSV Rows
    for (var booking in bookings) {
      buffer.writeln(
        '${booking.bookingId},'
        '${booking.serviceType},'
        '${_formatDate(booking.startDate)},'
        '${_formatDate(booking.endDate)},'
        '${booking.status},'
        '${booking.totalAmount},'
        '${_formatDate(booking.createdAt)}',
      );
    }

    return buffer.toString();
  }

  /// Export bookings to plain text format
  static String exportToText(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return 'No bookings to export';
    }

    final buffer = StringBuffer();
    buffer.writeln('BOOKING HISTORY REPORT');
    buffer.writeln('Generated: ${_formatDateTime(DateTime.now())}');
    buffer.writeln('Total Bookings: ${bookings.length}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (int i = 0; i < bookings.length; i++) {
      final booking = bookings[i];
      buffer.writeln('Booking ${i + 1}');
      buffer.writeln('-' * 50);
      buffer.writeln('Booking ID: ${booking.bookingId}');
      buffer.writeln('Service Type: ${booking.serviceType}');
      buffer.writeln('Start Date: ${_formatDateTime(booking.startDate)}');
      buffer.writeln('End Date: ${_formatDateTime(booking.endDate)}');
      buffer.writeln('Status: ${booking.status}');
      buffer.writeln('Total Amount: ₹${booking.totalAmount}');
      buffer.writeln('Created At: ${_formatDateTime(booking.createdAt)}');
      if (booking.specialInstructions.isNotEmpty) {
        buffer.writeln('Instructions: ${booking.specialInstructions}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Export bookings summary
  static String exportSummary(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return 'No bookings to summarize';
    }

    final buffer = StringBuffer();
    buffer.writeln('BOOKING SUMMARY');
    buffer.writeln('=' * 50);
    buffer.writeln();

    // Calculate statistics
    final totalBookings = bookings.length;
    final completedBookings =
        bookings.where((b) => b.status == 'completed').length;
    final cancelledBookings =
        bookings.where((b) => b.status == 'cancelled').length;
    final pendingBookings = bookings.where((b) => b.status == 'pending').length;

    final totalAmount = bookings
        .where((b) => b.status == 'completed')
        .fold<double>(0, (sum, b) => sum + b.totalAmount);

    // Service breakdown
    final serviceBreakdown = <String, int>{};
    for (var booking in bookings) {
      serviceBreakdown[booking.serviceType] =
          (serviceBreakdown[booking.serviceType] ?? 0) + 1;
    }

    buffer.writeln('Total Bookings: $totalBookings');
    buffer.writeln('Completed: $completedBookings');
    buffer.writeln('Cancelled: $cancelledBookings');
    buffer.writeln('Pending: $pendingBookings');
    buffer.writeln('Total Amount Spent: ₹${totalAmount.toStringAsFixed(2)}');
    buffer.writeln();

    buffer.writeln('Service Breakdown:');
    serviceBreakdown.forEach((service, count) {
      buffer.writeln('  $service: $count bookings');
    });
    buffer.writeln();

    buffer.writeln('Date Range:');
    if (bookings.isNotEmpty) {
      final dates = bookings.map((b) => b.createdAt).toList()..sort();
      buffer.writeln('  From: ${_formatDate(dates.first)}');
      buffer.writeln('  To: ${_formatDate(dates.last)}');
    }

    return buffer.toString();
  }

  /// Format date
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Format date and time
  static String _formatDateTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${_formatDate(date)} ${hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')} $period';
  }

  /// Get file name for export
  static String getExportFileName(String format) {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    return 'bookings_$dateStr.$format';
  }
}
