import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/analytics_provider.dart';
import '../../models/analytics_model.dart';

/// Screen for owner analytics dashboard
class OwnerAnalyticsScreen extends StatefulWidget {
  const OwnerAnalyticsScreen({super.key});

  @override
  State<OwnerAnalyticsScreen> createState() => _OwnerAnalyticsScreenState();
}

class _OwnerAnalyticsScreenState extends State<OwnerAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final analyticsProvider = context.read<AnalyticsProvider>();
    await analyticsProvider.loadOwnerAnalytics(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Analytics'),
        elevation: 0,
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analyticsProvider, child) {
          if (analyticsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (analyticsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(analyticsProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAnalytics,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final analytics = analyticsProvider.analytics;
          if (analytics == null) {
            return const Center(child: Text('No analytics data available'));
          }

          return RefreshIndicator(
            onRefresh: _loadAnalytics,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOverviewCards(analytics),
                const SizedBox(height: 24),
                _buildBookingsChart(analytics),
                const SizedBox(height: 24),
                _buildServiceBreakdown(analytics),
                const SizedBox(height: 24),
                _buildPetAnalytics(analyticsProvider.petAnalytics),
                const SizedBox(height: 24),
                _buildMonthlyTrend(analytics.monthlyData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(AnalyticsModel analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Bookings',
                analytics.totalBookings.toString(),
                Icons.calendar_today,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completed',
                analytics.completedBookings.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Spent',
                '₹${analytics.totalAmount.toStringAsFixed(0)}',
                Icons.account_balance_wallet,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Avg Rating',
                analytics.averageRating.toStringAsFixed(1),
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsChart(AnalyticsModel analytics) {
    final total = analytics.totalBookings;
    final completed = analytics.completedBookings;
    final cancelled = analytics.cancelledBookings;
    final pending = analytics.pendingBookings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (total > 0) ...[
              _buildProgressBar(
                'Completed',
                completed,
                total,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildProgressBar(
                'Pending',
                pending,
                total,
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildProgressBar(
                'Cancelled',
                cancelled,
                total,
                Colors.red,
              ),
            ] else
              const Text('No bookings yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      String label, int value, int total, Color color) {
    final percentage = (value / total * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value ($percentage%)'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / total,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildServiceBreakdown(AnalyticsModel analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (analytics.bookingsByService.isNotEmpty)
              ...analytics.bookingsByService.entries.map((entry) {
                final service = entry.key;
                final count = entry.value;
                final revenue = analytics.revenueByService[service] ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatServiceName(service),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '$count bookings • ₹${revenue.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text('No service data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildPetAnalytics(List<PetAnalytics> petAnalytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pet Analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (petAnalytics.isNotEmpty)
              ...petAnalytics.map((pet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.pets,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.petName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${pet.bookingCount} bookings • ₹${pet.totalSpent.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Favorite: ${_formatServiceName(pet.favoriteService)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text('No pet data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrend(List<MonthlyData> monthlyData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (monthlyData.isNotEmpty)
              ...monthlyData.map((data) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          data.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: data.bookings / 10,
                                    backgroundColor: Colors.grey.shade200,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${data.bookings}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${data.revenue.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text('No monthly data available'),
          ],
        ),
      ),
    );
  }

  String _formatServiceName(String service) {
    return service
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
