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
  final List<String> _tabs = ['Active', 'Completed', 'Cancelled'];

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
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.white,
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = tab;
                      });
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
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DashboardEmptyState(
                icon: Icons.calendar_today,
                title: 'No $_selectedTab bookings',
                subtitle: 'Your bookings will appear here',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
