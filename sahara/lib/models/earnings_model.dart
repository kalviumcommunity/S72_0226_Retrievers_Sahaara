/// Earnings data model
class EarningsModel {
  final double totalEarnings;
  final double thisMonthEarnings;
  final double availableBalance;
  final double pendingBalance;
  final DateTime lastPayoutDate;
  final List<Transaction> recentTransactions;

  EarningsModel({
    required this.totalEarnings,
    required this.thisMonthEarnings,
    required this.availableBalance,
    required this.pendingBalance,
    required this.lastPayoutDate,
    required this.recentTransactions,
  });
}

/// Transaction model for earnings history
class Transaction {
  final String id;
  final String type; // 'booking', 'payout', 'refund'
  final double amount;
  final DateTime date;
  final String description;
  final String? bookingId;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    this.bookingId,
  });
}
