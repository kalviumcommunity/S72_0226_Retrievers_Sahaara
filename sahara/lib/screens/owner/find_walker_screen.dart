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
  bool _isLoading = false;
  final List<String> _filters = ['All', 'Near Me', 'Ratings', 'Available'];

  Future<void> _refreshWalkers() async {
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
        title: const Text('Find a Walker'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWalkers,
        backgroundColor: AppTheme.white,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Search by name or location',
                  prefixIcon: _isLoading
                      ? const SizedBox(
                          width: 4,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                ),
              ),
              const SizedBox(height: 16),
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
                        onSelected: _isLoading
                            ? null
                            : (selected) {
                                setState(() {
                                  _selectedFilter = selected ? filter : 'All';
                                });
                                _refreshWalkers();
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
              DashboardEmptyState(
                icon: Icons.person_search,
                title: _isLoading ? 'Loading caregivers...' : 'No caregivers found',
                subtitle: _isLoading ? 'Please wait' : 'Adjust your filters or check back later',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
