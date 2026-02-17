import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';

/// Find Walker/Caregiver Screen
class FindWalkerScreen extends StatefulWidget {
  const FindWalkerScreen({super.key});

  @override
  State<FindWalkerScreen> createState() => _FindWalkerScreenState();
}

class _FindWalkerScreenState extends State<FindWalkerScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Near Me', 'Ratings', 'Available'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Find a Walker'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                filled: true,
                fillColor: AppTheme.white,
              ),
            ),
            const SizedBox(height: 16),
            // Filters
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = selected ? filter : 'All';
                        });
                      },
                      backgroundColor: AppTheme.white,
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.white : AppTheme.gray600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Caregiver list
            DashboardEmptyState(
              icon: Icons.person_search,
              title: 'No caregivers found',
              subtitle: 'Adjust your filters or check back later',
            ),
          ],
        ),
      ),
    );
  }
}
