import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../models/earnings_model.dart';
import '../../widgets/earnings_widgets.dart';

/// Earnings Summary Screen - Complete earnings dashboard
class EarningsSummaryScreen extends StatefulWidget {
  const EarningsSummaryScreen({super.key});

  @override
  State<EarningsSummaryScreen> createState() => _EarningsSummaryScreenState();
}

class _EarningsSummaryScreenState extends State<EarningsSummaryScreen> {
  bool _isLoading = false;

  // Mock data
  late EarningsModel _earningsData;

  @override
  void initState() {
    super.initState();
    _initializeEarningsData();
  }

  void _initializeEarningsData() {
    _earningsData = EarningsModel(
      totalEarnings: 15420.50,
      thisMonthEarnings: 4850.00,
      availableBalance: 3500.00,
      pendingBalance: 350.00,
      lastPayoutDate: DateTime.now().subtract(const Duration(days: 5)),
      recentTransactions: [
        Transaction(
          id: '1',
          type: 'booking',
          amount: 500.00,
          date: DateTime.now(),
          description: 'Dog Walking - 2 hours',
          bookingId: 'B001',
        ),
        Transaction(
          id: '2',
          type: 'booking',
          amount: 300.00,
          date: DateTime.now().subtract(const Duration(days: 1)),
          description: 'Pet Sitting',
          bookingId: 'B002',
        ),
        Transaction(
          id: '3',
          type: 'payout',
          amount: 5000.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          description: 'Monthly Payout',
        ),
        Transaction(
          id: '4',
          type: 'booking',
          amount: 250.00,
          date: DateTime.now().subtract(const Duration(days: 7)),
          description: 'Dog Grooming',
          bookingId: 'B003',
        ),
      ],
    );
  }

  Future<void> _refreshEarnings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Fetch earnings data from Firestore
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Earnings refreshed')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEarnings,
        backgroundColor: AppTheme.white,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              EarningsSummaryCard(
                totalEarnings: _earningsData.totalEarnings,
                thisMonthEarnings: _earningsData.thisMonthEarnings,
                availableBalance: _earningsData.availableBalance,
                onViewDetails: () {
                  // TODO: Navigate to detailed earnings view
                },
              ),
              const SizedBox(height: 24),

              // Stats Grid
              EarningsStatsGrid(
                pendingBalance: _earningsData.pendingBalance,
                completedBookings: 28,
                averagePerBooking: 540.00,
                lastPayoutDate: _formatLastPayout(_earningsData.lastPayoutDate),
              ),
              const SizedBox(height: 24),

              // Weekly Earnings Chart
              EarningsChart(
                weeklyEarnings: [450, 620, 380, 700, 550, 480, 520],
                weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
              ),
              const SizedBox(height: 24),

              // Payout Card
              PayoutCard(
                availableBalance: _earningsData.availableBalance,
                pendingBalance: _earningsData.pendingBalance,
                onWithdraw: () {
                  _showWithdrawDialog();
                },
              ),
              const SizedBox(height: 24),

              // Recent Transactions
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
              ),
              const SizedBox(height: 12),
              if (_earningsData.recentTransactions.isEmpty)
                EmptyEarningsState(
                  title: 'No transactions yet',
                  subtitle: 'Your transaction history will appear here',
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _earningsData.recentTransactions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final transaction = _earningsData.recentTransactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onTap: () {
                        // TODO: Show transaction details
                      },
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastPayout(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Earnings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '₹${_earningsData.availableBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'The amount will be transferred to your registered bank account within 2-3 business days.',
              style: Theme.of(context).textTheme.bodySmall,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Withdrawal initiated successfully'),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
