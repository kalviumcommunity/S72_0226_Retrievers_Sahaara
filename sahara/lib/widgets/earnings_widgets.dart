import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/earnings_model.dart';

/// Earnings Summary Card - Shows total earnings overview
class EarningsSummaryCard extends StatelessWidget {
  final double totalEarnings;
  final double thisMonthEarnings;
  final double availableBalance;
  final VoidCallback? onViewDetails;

  const EarningsSummaryCard({
    super.key,
    required this.totalEarnings,
    required this.thisMonthEarnings,
    required this.availableBalance,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.successColor,
              AppTheme.successColor.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.successColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: AppTheme.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '₹${totalEarnings.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month',
                        style: TextStyle(
                          color: AppTheme.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${thisMonthEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppTheme.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available',
                          style: TextStyle(
                            color: AppTheme.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${availableBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Earnings Stats Grid - Shows breakdown of earnings
class EarningsStatsGrid extends StatelessWidget {
  final double pendingBalance;
  final int completedBookings;
  final double averagePerBooking;
  final String lastPayoutDate;

  const EarningsStatsGrid({
    super.key,
    required this.pendingBalance,
    required this.completedBookings,
    required this.averagePerBooking,
    required this.lastPayoutDate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatItem(
          title: 'Pending',
          value: '₹${pendingBalance.toStringAsFixed(2)}',
          icon: Icons.schedule,
          color: AppTheme.warningColor,
        ),
        _buildStatItem(
          title: 'Completed',
          value: completedBookings.toString(),
          icon: Icons.check_circle,
          color: AppTheme.successColor,
        ),
        _buildStatItem(
          title: 'Per Booking',
          value: '₹${averagePerBooking.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: AppTheme.primaryColor,
        ),
        _buildStatItem(
          title: 'Last Payout',
          value: lastPayoutDate,
          icon: Icons.event,
          color: AppTheme.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Earnings Chart - Simple bar chart representation
class EarningsChart extends StatelessWidget {
  final List<double> weeklyEarnings;
  final List<String> weekDays;

  const EarningsChart({
    super.key,
    required this.weeklyEarnings,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final maxEarning = weeklyEarnings.isNotEmpty
        ? weeklyEarnings.reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Earnings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              weeklyEarnings.length,
              (index) {
                final earning = weeklyEarnings[index];
                final height = (earning / (maxEarning > 0 ? maxEarning : 1)) * 100;

                return Column(
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weekDays[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Max: ₹${maxEarning.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.gray500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Transaction List Item
class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'booking';
    final icon = _getIcon(transaction.type);
    final color = isCredit ? AppTheme.successColor : AppTheme.errorColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  Text(
                    _formatDate(transaction.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.add_circle;
      case 'payout':
        return Icons.send;
      case 'refund':
        return Icons.undo;
      default:
        return Icons.transaction;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Empty Earnings State
class EmptyEarningsState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyEarningsState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.trending_up,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.gray500,
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Payout Card - Shows pending and available balance
class PayoutCard extends StatelessWidget {
  final double availableBalance;
  final double pendingBalance;
  final VoidCallback? onWithdraw;

  const PayoutCard({
    super.key,
    required this.availableBalance,
    required this.pendingBalance,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payout Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${availableBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppTheme.borderColor,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${pendingBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (availableBalance > 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onWithdraw,
                child: const Text('Withdraw'),
              ),
            ),
        ],
      ),
    );
  }
}
