import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../providers/payment_provider.dart';
import '../../providers/booking_provider.dart';

/// Screen for processing payment
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

            // Process Payment Button
            _buildProcessButton(),
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
          Icons.money,
          'Pay in cash when service is completed',
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'card',
          'Credit/Debit Card',
          Icons.credit_card,
          'Pay securely with your card',
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'wallet',
          'Digital Wallet',
          Icons.account_balance_wallet,
          'Pay using UPI, PayTM, or other wallets',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
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
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 32,
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
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
            _buildAmountRow(
              'Total Amount',
              total,
              isTotal: true,
            ),
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
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? Theme.of(context).primaryColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _selectedPaymentMethod == 'cash'
                    ? 'Confirm Booking'
                    : 'Pay ₹${(widget.booking.totalAmount * 1.18).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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

      // Calculate total with tax
      final totalAmount = widget.booking.totalAmount * 1.18;

      // Create payment record
      final paymentId = await paymentProvider.createPayment(
        bookingId: widget.booking.id,
        ownerId: widget.booking.ownerId,
        caregiverId: widget.booking.caregiverId,
        amount: totalAmount,
        paymentMethod: _selectedPaymentMethod,
      );

      if (paymentId == null) {
        throw Exception('Failed to create payment');
      }

      // Process payment if not cash
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

        if (mounted) {
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
                    ? 'Your booking has been confirmed. Please pay in cash when the service is completed.'
                    : 'Your payment has been processed successfully. The caregiver will be notified.',
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
        }
      } else {
        throw Exception(paymentProvider.error ?? 'Payment failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
