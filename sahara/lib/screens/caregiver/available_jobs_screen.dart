import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';

/// Available Jobs Screen - Browse and filter available pet care jobs
class AvailableJobsScreen extends StatefulWidget {
  const AvailableJobsScreen({super.key});

  @override
  State<AvailableJobsScreen> createState() => _AvailableJobsScreenState();
}

class _AvailableJobsScreenState extends State<AvailableJobsScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final List<String> _filters = ['All', 'Walking', 'Daycare', 'Overnight', 'Training'];

  final List<Map<String, dynamic>> _availableJobs = [
    {
      'id': '1',
      'owner': 'Sarah M.',
      'pet': 'Golden Retriever',
      'service': 'Dog Walking',
      'date': '2026-02-18',
      'time': '10:00 AM - 11:00 AM',
      'rate': '₹500',
      'rating': 4.8,
      'distance': '2.3 km away',
      'image': '🐕',
    },
    {
      'id': '2',
      'owner': 'John D.',
      'pet': 'Persian Cat',
      'service': 'Pet Sitting',
      'date': '2026-02-18',
      'time': '2:00 PM - 5:00 PM',
      'rate': '₹300',
      'rating': 4.9,
      'distance': '1.5 km away',
      'image': '🐱',
    },
    {
      'id': '3',
      'owner': 'Emma K.',
      'pet': 'Labrador',
      'service': 'Dog Walking',
      'date': '2026-02-19',
      'time': '9:00 AM - 10:00 AM',
      'rate': '₹550',
      'rating': 4.7,
      'distance': '3.1 km away',
      'image': '🐕',
    },
    {
      'id': '4',
      'owner': 'Michael S.',
      'pet': 'Beagle',
      'service': 'Daycare',
      'date': '2026-02-19',
      'time': '8:00 AM - 6:00 PM',
      'rate': '₹1200',
      'rating': 4.6,
      'distance': '2.8 km away',
      'image': '🐕',
    },
  ];

  Future<void> _refreshJobs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Fetch jobs from Firestore
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jobs refreshed')),
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

  List<Map<String, dynamic>> get _filteredJobs {
    if (_selectedFilter == 'All') {
      return _availableJobs;
    }
    return _availableJobs
        .where((job) => job['service'].contains(_selectedFilter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshJobs,
      backgroundColor: AppTheme.white,
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Filter Chips
            _buildFilterChips(),
            const SizedBox(height: 16),

            // Jobs List
            if (_filteredJobs.isEmpty)
              DashboardEmptyState(
                icon: Icons.work_outline,
                title: 'No jobs available',
                subtitle: 'Check back later for more opportunities',
                actionText: 'Refresh',
                onAction: _refreshJobs,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredJobs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = _filteredJobs[index];
                  return _buildJobCard(job);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by pet, owner, or service...',
          hintStyle: const TextStyle(color: AppTheme.gray400),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppTheme.gray500),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        enabled: !_isLoading,
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppTheme.white : AppTheme.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: isSelected ? AppTheme.primaryColor : AppTheme.gray100,
              onSelected: _isLoading
                  ? null
                  : (selected) {
                      setState(() => _selectedFilter = filter);
                    },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to job details
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
            // Header with pet and rating
            Row(
              children: [
                Text(
                  job['image'],
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['pet'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      Text(
                        'by ${job['owner']}',
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
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.warningColor),
                      const SizedBox(width: 4),
                      Text(
                        job['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service and details
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    job['service'],
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
                      const Icon(Icons.location_on, size: 12, color: AppTheme.gray600),
                      const SizedBox(width: 4),
                      Text(
                        job['distance'],
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

            // Date and time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppTheme.gray500),
                const SizedBox(width: 6),
                Text(
                  job['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 14, color: AppTheme.gray500),
                const SizedBox(width: 6),
                Text(
                  job['time'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Footer with rate and action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['rate'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request sent for ${job['pet']}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
