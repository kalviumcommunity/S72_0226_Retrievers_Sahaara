import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/filter_ui.dart';

/// Filter Demo Screen - Shows how to use the Filter UI
class FilterDemoScreen extends StatefulWidget {
  const FilterDemoScreen({super.key});

  @override
  State<FilterDemoScreen> createState() => _FilterDemoScreenState();
}

class _FilterDemoScreenState extends State<FilterDemoScreen> {
  // Caregiver Search Filters
  late List<FilterOption> _caregiverCategories;
  late List<RangeFilterOption> _caregiverRanges;

  // Service Search Filters
  late List<FilterOption> _serviceCategories;
  late List<RangeFilterOption> _serviceRanges;

  // Pet Search Filters
  late List<FilterOption> _petCategories;
  late List<RangeFilterOption> _petRanges;

  String? _selectedFilterType = 'caregiver';

  @override
  void initState() {
    super.initState();
    _initializeCaregiverFilters();
    _initializeServiceFilters();
    _initializePetFilters();
  }

  void _initializeCaregiverFilters() {
    _caregiverCategories = [
      FilterOption(id: 'exp_beginner', label: 'Beginner'),
      FilterOption(id: 'exp_intermediate', label: 'Intermediate'),
      FilterOption(id: 'exp_expert', label: 'Expert'),
      FilterOption(id: 'verified', label: 'Verified Only'),
      FilterOption(id: 'responding', label: 'Responding'),
    ];

    _caregiverRanges = [
      RangeFilterOption(
        id: 'rating',
        label: 'Rating',
        minValue: 0,
        maxValue: 5,
        currentMin: 0,
        currentMax: 5,
        suffix: '⭐',
        divisions: 10,
      ),
      RangeFilterOption(
        id: 'price',
        label: 'Price per Hour',
        minValue: 100,
        maxValue: 1000,
        currentMin: 100,
        currentMax: 1000,
        suffix: '₹',
        divisions: 9,
      ),
      RangeFilterOption(
        id: 'distance',
        label: 'Distance',
        minValue: 0,
        maxValue: 50,
        currentMin: 0,
        currentMax: 50,
        suffix: ' km',
        divisions: 10,
      ),
    ];
  }

  void _initializeServiceFilters() {
    _serviceCategories = [
      FilterOption(id: 'walking', label: 'Dog Walking'),
      FilterOption(id: 'sitting', label: 'Pet Sitting'),
      FilterOption(id: 'boarding', label: 'Boarding'),
      FilterOption(id: 'grooming', label: 'Grooming'),
      FilterOption(id: 'training', label: 'Training'),
      FilterOption(id: 'emergency', label: '24/7 Available'),
    ];

    _serviceRanges = [
      RangeFilterOption(
        id: 'service_price',
        label: 'Service Price',
        minValue: 50,
        maxValue: 5000,
        currentMin: 50,
        currentMax: 5000,
        suffix: '₹',
        divisions: 10,
      ),
      RangeFilterOption(
        id: 'duration',
        label: 'Duration',
        minValue: 30,
        maxValue: 480,
        currentMin: 30,
        currentMax: 480,
        suffix: ' min',
        divisions: 9,
      ),
    ];
  }

  void _initializePetFilters() {
    _petCategories = [
      FilterOption(id: 'dog', label: 'Dogs'),
      FilterOption(id: 'cat', label: 'Cats'),
      FilterOption(id: 'rabbit', label: 'Rabbits'),
      FilterOption(id: 'bird', label: 'Birds'),
      FilterOption(id: 'other', label: 'Other'),
    ];

    _petRanges = [
      RangeFilterOption(
        id: 'age',
        label: 'Age (years)',
        minValue: 0,
        maxValue: 20,
        currentMin: 0,
        currentMax: 20,
        divisions: 20,
      ),
      RangeFilterOption(
        id: 'weight',
        label: 'Weight (kg)',
        minValue: 1,
        maxValue: 100,
        currentMin: 1,
        currentMax: 100,
        suffix: ' kg',
        divisions: 10,
      ),
    ];
  }

  void _showCaregiverFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        categoryFilters: _caregiverCategories,
        rangeFilters: _caregiverRanges,
        title: 'Caregiver Filters',
        onCategoryChanged: (option) {
          setState(() {
            final index = _caregiverCategories.indexWhere((f) => f.id == option.id);
            if (index != -1) {
              _caregiverCategories[index] = option;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${option.label}: ${option.isSelected ? 'Selected' : 'Deselected'}')),
          );
        },
        onRangeChanged: (option) {
          setState(() {
            final index = _caregiverRanges.indexWhere((f) => f.id == option.id);
            if (index != -1) {
              _caregiverRanges[index] = option;
            }
          });
        },
      ),
    );
  }

  void _showServiceFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        categoryFilters: _serviceCategories,
        rangeFilters: _serviceRanges,
        title: 'Service Filters',
        onCategoryChanged: (option) {
          setState(() {
            final index = _serviceCategories.indexWhere((f) => f.id == option.id);
            if (index != -1) {
              _serviceCategories[index] = option;
            }
          });
        },
      ),
    );
  }

  void _showPetFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        categoryFilters: _petCategories,
        rangeFilters: _petRanges,
        title: 'Pet Filters',
        onCategoryChanged: (option) {
          setState(() {
            final index = _petCategories.indexWhere((f) => f.id == option.id);
            if (index != -1) {
              _petCategories[index] = option;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter UI Demo'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter Type Selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Filter Type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterTypeButton(
                          'Caregivers',
                          'caregiver',
                          Icons.people,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFilterTypeButton(
                          'Services',
                          'service',
                          Icons.home_repair_service,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFilterTypeButton(
                          'Pets',
                          'pet',
                          Icons.pets,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: AppTheme.borderColor),

            // Filter Preview Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applied Filters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActiveFiltersPreview(),
                  const SizedBox(height: 24),
                  Text(
                    'Filter Options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterPreview(),
                ],
              ),
            ),

            // Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 12,
                children: [
                  _buildInfoCard(
                    'Chip Filters',
                    'Click chips to toggle categories on/off',
                    Icons.label,
                    AppTheme.primaryColor,
                  ),
                  _buildInfoCard(
                    'Range Sliders',
                    'Drag to adjust min/max values for numeric ranges',
                    Icons.show_chart,
                    AppTheme.secondaryColor,
                  ),
                  _buildInfoCard(
                    'Clear & Apply',
                    'Use buttons to clear all or apply selected filters',
                    Icons.settings,
                    AppTheme.warningColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTypeButton(String label, String value, IconData icon) {
    final isSelected = _selectedFilterType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.gray100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.white : AppTheme.gray700,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.white : AppTheme.gray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersPreview() {
    List<FilterOption> selected = [];
    
    if (_selectedFilterType == 'caregiver') {
      selected = _caregiverCategories.where((f) => f.isSelected).toList();
    } else if (_selectedFilterType == 'service') {
      selected = _serviceCategories.where((f) => f.isSelected).toList();
    } else if (_selectedFilterType == 'pet') {
      selected = _petCategories.where((f) => f.isSelected).toList();
    }

    if (selected.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.gray50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Center(
          child: Text(
            'No filters applied. Tap "Open Filters" to add some!',
            style: TextStyle(
              color: AppTheme.gray500,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selected.map((filter) => Chip(
        label: Text(filter.label),
        onDeleted: () => setState(() {
          if (_selectedFilterType == 'caregiver') {
            final index = _caregiverCategories.indexWhere((f) => f.id == filter.id);
            _caregiverCategories[index] = filter.copyWith(isSelected: false);
          } else if (_selectedFilterType == 'service') {
            final index = _serviceCategories.indexWhere((f) => f.id == filter.id);
            _serviceCategories[index] = filter.copyWith(isSelected: false);
          } else if (_selectedFilterType == 'pet') {
            final index = _petCategories.indexWhere((f) => f.id == filter.id);
            _petCategories[index] = filter.copyWith(isSelected: false);
          }
        }),
        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        labelStyle: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      )).toList(),
    );
  }

  Widget _buildFilterPreview() {
    Widget preview;
    VoidCallback onTap;

    if (_selectedFilterType == 'caregiver') {
      preview = _buildCategoryPreview(_caregiverCategories);
      onTap = _showCaregiverFilters;
    } else if (_selectedFilterType == 'service') {
      preview = _buildCategoryPreview(_serviceCategories);
      onTap = _showServiceFilters;
    } else {
      preview = _buildCategoryPreview(_petCategories);
      onTap = _showPetFilters;
    }

    return Column(
      children: [
        preview,
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.tune),
            label: const Text('Open Filters'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPreview(List<FilterOption> categories) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: categories.take(3).map((cat) => Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: cat.isSelected ? AppTheme.primaryColor : AppTheme.gray300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              cat.label,
              style: TextStyle(
                fontSize: 12,
                color: cat.isSelected ? AppTheme.primaryColor : AppTheme.gray700,
                fontWeight: cat.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
