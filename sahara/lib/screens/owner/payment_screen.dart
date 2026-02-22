import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

/// Screen for processing payment for a booking
class PaymentScreen extends StatefulWidget {
  final BookingModel booking;

  const PaymentScreen({
    super.key,
    required this.booking,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            _buildBookingSummaryCard(),
            const SizedBox(height: 24),

            // Payment Method Selection
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),

            // Amount Breakdown
            _buildAmountBreakdown(),
            const SizedBox(height: 32),

            // Pay Button
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Service', widget.booking.serviceType),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Date',
              '${widget.booking.startTime.day}/${widget.booking.startTime.month}/${widget.booking.startTime.year}',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Time',
              '${_formatTime(widget.booking.startTime)} - ${_formatTime(widget.booking.endTime)}',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Duration',
              '${widget.booking.duration.toStringAsFixed(1)} hours',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodOption(
          'cash',
          'Cash on Service',
          'Pay when service is completed',
          Icons.money,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'card',
          'Credit/Debit Card',
          'Pay securely with your card',
          Icons.credit_card,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'wallet',
          'Digital Wallet',
          'Pay with UPI, PayTM, etc.',
          Icons.account_balance_wallet,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountBreakdown() {
    final subtotal = widget.booking.totalAmount;
    final tax = subtotal * 0.18; // 18% GST
    final total = subtotal + tax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildAmountRow('Subtotal', subtotal),
            const SizedBox(height: 8),
            _buildAmountRow('GST (18%)', tax),
            const Divider(height: 24),
            _buildAmountRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : Colors.grey.shade700,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Theme.of(context).primaryColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final total = widget.booking.totalAmount * 1.18;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _selectedPaymentMethod == 'cash'
                    ? 'Confirm Booking'
                    : 'Pay ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final paymentProvider = context.read<PaymentProvider>();
      final bookingProvider = context.read<BookingProvider>();

      // Create payment record
      final paymentId = await paymentProvider.createPayment(
        bookingId: widget.booking.id,
        ownerId: widget.booking.ownerId,
        caregiverId: widget.booking.caregiverId,
        amount: widget.booking.totalAmount * 1.18,
        paymentMethod: _selectedPaymentMethod,
      );

      if (paymentId == null) {
        throw Exception('Failed to create payment');
      }

      // Process payment (for card/wallet, for cash it stays pending)
      bool paymentSuccess = true;
      if (_selectedPaymentMethod != 'cash') {
        paymentSuccess = await paymentProvider.processPayment(
          paymentId: paymentId,
          paymentMethod: _selectedPaymentMethod,
        );
      }

      if (paymentSuccess) {
        // Update booking status to confirmed
        await bookingProvider.updateBookingStatus(
          widget.booking.id,
          'confirmed',
        );

        if (!mounted) return;

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Payment Successful'),
              ],
            ),
            content: Text(
              _selectedPaymentMethod == 'cash'
                  ? 'Booking confirmed! You can pay cash when the service is completed.'
                  : 'Your payment has been processed successfully. Booking confirmed!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close payment screen
                  Navigator.of(context).pop(); // Close booking screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception(paymentProvider.error ?? 'Payment failed');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
