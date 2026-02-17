import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';
import 'caregiver_booking_detail_screen.dart';

/// Screen for caregivers to view and manage their bookings
class CaregiverBookingsScreen extends StatefulWidget {
  const CaregiverBookingsScreen({super.key});

  @override
  State<CaregiverBookingsScreen> createState() => _CaregiverBookingsScreenState();
}

class _CaregiverBookingsScreenState extends State<CaregiverBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      await provider.loadCaregiverBookings(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LoadingSkeleton(height: 140),
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBookings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(provider.bookings),
              _buildBookingsList(provider.getBookingsByStatus('pending')),
              _buildBookingsList(provider.getBookingsByStatus('confirmed')),
              _buildBookingsList(provider.getBookingsByStatus('in-progress')),
              _buildBookingsList(provider.getBookingsByStatus('completed')),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const EmptyState(
        icon: Icons.calendar_today,
        message: 'No bookings found',
        description: 'Booking requests will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaregiverBookingDetailScreen(
                bookingId: booking.bookingId,
              ),
            ),
          ).then((_) => _loadBookings());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.serviceType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.startDate.day}/${booking.startDate.month}/${booking.startDate.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.startDate.hour}:${booking.startDate.minute.toString().padLeft(2, '0')} - ${booking.endDate.hour}:${booking.endDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.durationInHours} hours',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  const Icon(Icons.currency_rupee, size: 16, color: Colors.grey),
                  Text(
                    booking.totalAmount.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              // Quick actions for pending bookings
              if (booking.status == 'pending') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectBooking(booking.bookingId),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptBooking(booking.bookingId),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
              
              // Quick action for confirmed bookings
              if (booking.status == 'confirmed') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startBooking(booking.bookingId),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Service'),
                  ),
                ),
              ],
              
              // Quick action for in-progress bookings
              if (booking.status == 'in-progress') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _completeBooking(booking.bookingId),
                    icon: const Icon(Icons.check),
                    label: const Text('Complete Service'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'in-progress':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.grey;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _acceptBooking(String bookingId) async {
    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.confirmBooking(bookingId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking accepted successfully')),
      );
      _loadBookings();
    }
  }

  Future<void> _rejectBooking(String bookingId) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _RejectBookingDialog(),
    );

    if (reason != null && reason.isNotEmpty) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      final success = await provider.cancelBooking(bookingId, reason);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking rejected')),
        );
        _loadBookings();
      }
    }
  }

  Future<void> _startBooking(String bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Service'),
        content: const Text('Are you ready to start this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      final success = await provider.startBooking(bookingId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service started')),
        );
        _loadBookings();
      }
    }
  }

  Future<void> _completeBooking(String bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Service'),
        content: const Text('Mark this service as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      final success = await provider.completeBooking(bookingId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service completed successfully')),
        );
        _loadBookings();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _RejectBookingDialog extends StatefulWidget {
  @override
  State<_RejectBookingDialog> createState() => _RejectBookingDialogState();
}

class _RejectBookingDialogState extends State<_RejectBookingDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reject Booking'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please provide a reason for rejection:'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Reason for rejection...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Reject'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
