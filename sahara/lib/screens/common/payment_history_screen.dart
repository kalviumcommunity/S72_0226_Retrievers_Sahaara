import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/payment_model.dart';
import '../../providers/payment_provider.dart';
import '../../providers/user_provider.dart';

/// Screen to view payment history
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPayments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userProvider = context.read<UserProvider>();
    final paymentProvider = context.read<PaymentProvider>();

    await userProvider.getUserById(userId);
    final isCaregiver = userProvider.currentUser?.role == 'caregiver';

    await paymentProvider.loadUserPayments(userId, isCaregiver);
    await paymentProvider.loadPaymentStats(userId, isCaregiver);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
            Tab(text: 'Failed'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatsCard(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPaymentList(null),
                      _buildPaymentList('completed'),
                      _buildPaymentList('pending'),
                      _buildPaymentList('failed'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsCard() {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        final stats = paymentProvider.paymentStats;
        if (stats == null) return const SizedBox.shrink();

        final userProvider = context.read<UserProvider>();
        final isCaregiver = userProvider.currentUser?.role == 'caregiver';

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  isCaregiver ? 'Total Earnings' : 'Total Spent',
                  '₹${(isCaregiver ? stats['totalEarnings'] : stats['totalSpent']).toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  Colors.green,
                ),
                _buildStatItem(
                  'Pending',
                  '₹${stats['pendingAmount'].toStringAsFixed(2)}',
                  Icons.pending,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Transactions',
                  '${stats['totalTransactions']}',
                  Icons.receipt_long,
                  Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
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
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentList(String? statusFilter) {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        List<PaymentModel> payments = paymentProvider.payments;

        if (statusFilter != null) {
          payments = payments.where((p) => p.status == statusFilter).toList();
        }

        if (payments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No payments found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadPayments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return _buildPaymentCard(payments[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    Color statusColor;
    IconData statusIcon;

    switch (payment.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'refunded':
        statusColor = Colors.blue;
        statusIcon = Icons.refresh;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          payment.paymentMethodDisplay,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Transaction ID: ${payment.transactionId ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(payment.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${payment.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                payment.statusDisplay,
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showPaymentDetails(payment),
      ),
    );
  }

  void _showPaymentDetails(PaymentModel payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Amount', '₹${payment.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Payment Method', payment.paymentMethodDisplay),
              _buildDetailRow('Status', payment.statusDisplay),
              _buildDetailRow('Transaction ID', payment.transactionId ?? 'N/A'),
              _buildDetailRow('Created', _formatDate(payment.createdAt)),
              if (payment.completedAt != null)
                _buildDetailRow('Completed', _formatDate(payment.completedAt!)),
              if (payment.refundedAt != null)
                _buildDetailRow('Refunded', _formatDate(payment.refundedAt!)),
              if (payment.failureReason != null)
                _buildDetailRow('Failure Reason', payment.failureReason!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
