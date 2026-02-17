import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';

/// Caregiver Schedule Screen - View booked jobs and manage schedule
class CaregiverScheduleScreen extends StatefulWidget {
  const CaregiverScheduleScreen({super.key});

  @override
  State<CaregiverScheduleScreen> createState() =>
      _CaregiverScheduleScreenState();
}

class _CaregiverScheduleScreenState extends State<CaregiverScheduleScreen> {
  String _selectedTab = 'Upcoming';
  bool _isLoading = false;

  final List<String> _tabs = ['Upcoming', 'Completed', 'Cancelled'];

  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'owner': 'Sarah M.',
      'pet': 'Golden Retriever',
      'service': 'Dog Walking',
      'date': '2026-02-18',
      'startTime': '10:00 AM',
      'endTime': '11:00 AM',
      'rate': '₹500',
      'status': 'upcoming',
      'image': '🐕',
    },
    {
      'id': '2',
      'owner': 'John D.',
      'pet': 'Persian Cat',
      'service': 'Pet Sitting',
      'date': '2026-02-18',
      'startTime': '2:00 PM',
      'endTime': '5:00 PM',
      'rate': '₹300',
      'status': 'upcoming',
      'image': '🐱',
    },
    {
      'id': '3',
      'owner': 'Emma K.',
      'pet': 'Labrador',
      'service': 'Dog Walking',
      'date': '2026-02-17',
      'startTime': '9:00 AM',
      'endTime': '10:00 AM',
      'rate': '₹550',
      'status': 'completed',
      'image': '🐕',
    },
    {
      'id': '4',
      'owner': 'Michael S.',
      'pet': 'Beagle',
      'service': 'Daycare',
      'date': '2026-02-16',
      'startTime': '8:00 AM',
      'endTime': '6:00 PM',
      'rate': '₹1200',
      'status': 'completed',
      'image': '🐕',
    },
  ];

  Future<void> _refreshSchedule() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Fetch bookings from Firestore
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule refreshed')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((booking) {
      final status = booking['status'];
      if (_selectedTab == 'Upcoming') return status == 'upcoming';
      if (_selectedTab == 'Completed') return status == 'completed';
      if (_selectedTab == 'Cancelled') return status == 'cancelled';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshSchedule,
      backgroundColor: AppTheme.white,
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Selection
            _buildTabBar(),
            const SizedBox(height: 16),

            // Bookings List
            if (_filteredBookings.isEmpty)
              DashboardEmptyState(
                icon: Icons.calendar_month,
                title: 'No ${_selectedTab.toLowerCase()} bookings',
                subtitle: 'Your ${_selectedTab.toLowerCase()} bookings will appear here',
                actionText: 'Find Jobs',
                onAction: () {
                  // Will be handled by parent navigation
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredBookings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = _filteredBookings[index];
                  return _buildBookingCard(booking);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(4),
      ),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = tab == _selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: _isLoading
                  ? null
                  : () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: isSelected
                      ? Border.all(
                          color: AppTheme.primaryColor,
                          width: 1.5,
                        )
                      : null,
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.gray600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final statusColor = booking['status'] == 'completed'
        ? AppTheme.successColor
        : booking['status'] == 'cancelled'
            ? AppTheme.errorColor
            : AppTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to booking details
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with pet info and status
            Row(
              children: [
                Text(
                  booking['image'],
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['pet'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      Text(
                        'by ${booking['owner']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking['status'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service and date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking['service'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: AppTheme.gray600),
                      const SizedBox(width: 4),
                      Text(
                        booking['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time and rate
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppTheme.gray500),
                const SizedBox(width: 6),
                Text(
                  '${booking['startTime']} - ${booking['endTime']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                  ),
                ),
                const Spacer(),
                Text(
                  booking['rate'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action buttons
            if (booking['status'] == 'upcoming')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Booking cancelled for ${booking['pet']}',
                            ),
                          ),
                        );
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ready for ${booking['pet']}',
                            ),
                          ),
                        );
                      },
                      child: const Text('Mark Ready'),
                    ),
                  ),
                ],
              )
            else if (booking['status'] == 'completed')
              ElevatedButton(
                onPressed: () {
                  // Navigate to review/rating
                },
                child: const Text('View Details'),
              ),
          ],
        ),
      ),
    );
  }
}
