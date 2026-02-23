import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/analytics_provider.dart';
import '../../models/analytics_model.dart';

/// Screen for caregiver analytics dashboard
class CaregiverAnalyticsScreen extends StatefulWidget {
  const CaregiverAnalyticsScreen({super.key});

  @override
  State<CaregiverAnalyticsScreen> createState() =>
      _CaregiverAnalyticsScreenState();
}

class _CaregiverAnalyticsScreenState extends State<CaregiverAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final analyticsProvider = context.read<AnalyticsProvider>();
    await analyticsProvider.loadCaregiverAnalytics(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Analytics'),
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
                _buildPerformanceMetrics(analytics),
                const SizedBox(height: 24),
                _buildServiceBreakdown(analytics),
                const SizedBox(height: 24),
                _buildTopClients(analyticsProvider.clientAnalytics),
                const SizedBox(height: 24),
                _buildMonthlyRevenue(analytics.monthlyData),
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
                'Total Earnings',
                '₹${analytics.totalAmount.toStringAsFixed(0)}',
                Icons.account_balance_wallet,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completed Jobs',
                analytics.completedBookings.toString(),
                Icons.check_circle,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Average Rating',
                '${analytics.averageRating.toStringAsFixed(1)} ⭐',
                Icons.star,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Reviews',
                analytics.totalReviews.toString(),
                Icons.rate_review,
                Colors.purple,
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
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

  Widget _buildPerformanceMetrics(AnalyticsModel analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'Completion Rate',
              '${analytics.completionRate.toStringAsFixed(1)}%',
              analytics.completionRate,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              'Cancellation Rate',
              '${analytics.cancellationRate.toStringAsFixed(1)}%',
              analytics.cancellationRate,
              Colors.red,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    'Pending',
                    analytics.pendingBookings.toString(),
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    'Cancelled',
                    analytics.cancelledBookings.toString(),
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    'Total Jobs',
                    analytics.totalBookings.toString(),
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
      String label, String value, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBreakdown(AnalyticsModel analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Performance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (analytics.bookingsByService.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Top: ${_formatServiceName(analytics.mostPopularService)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (analytics.bookingsByService.isNotEmpty)
              ...analytics.bookingsByService.entries.map((entry) {
                final service = entry.key;
                final count = entry.value;
                final revenue = analytics.revenueByService[service] ?? 0;
                final percentage =
                    (count / analytics.totalBookings * 100).toStringAsFixed(0);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatServiceName(service),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '₹${revenue.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: count / analytics.totalBookings,
                              backgroundColor: Colors.grey.shade200,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count jobs ($percentage%)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              const Text('No service data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopClients(List<ClientAnalytics> clients) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Clients',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (clients.isNotEmpty)
              ...clients.take(5).map((client) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Text(
                          client.ownerName[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.ownerName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${client.bookingCount} bookings • ${client.averageRating.toStringAsFixed(1)} ⭐',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${client.totalRevenue.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              const Text('No client data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenue(List<MonthlyData> monthlyData) {
    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxRevenue = monthlyData
        .map((d) => d.revenue)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend (Last 6 Months)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: monthlyData.map((data) {
                  final heightPercentage =
                      maxRevenue > 0 ? data.revenue / maxRevenue : 0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (data.revenue > 0)
                            Text(
                              '₹${(data.revenue / 1000).toStringAsFixed(1)}k',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            height: 150 * heightPercentage,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6),
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.monthName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
