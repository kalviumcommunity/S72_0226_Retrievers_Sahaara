import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';

/// My Bookings Screen
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedTab = 'Active';
  bool _isLoading = false;
  final List<String> _tabs = ['Active', 'Completed', 'Cancelled'];

  Future<void> _refreshBookings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
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
        title: const Text('My Bookings'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        backgroundColor: AppTheme.white,
        color: AppTheme.primaryColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.white,
              child: Row(
                children: _tabs.map((tab) {
                  final isSelected = _selectedTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedTab = tab;
                              });
                              _refreshBookings();
                            },
                      child: Column(
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppTheme.primaryColor : AppTheme.gray500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isSelected)
                            Container(
                              height: 2,
                              color: AppTheme.primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: DashboardEmptyState(
                  icon: _isLoading ? Icons.hourglass_empty : Icons.calendar_today,
                  title: _isLoading ? 'Loading bookings...' : 'No $_selectedTab bookings',
                  subtitle: _isLoading ? 'Please wait' : 'Your bookings will appear here',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
