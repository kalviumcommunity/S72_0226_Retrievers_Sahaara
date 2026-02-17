import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Data model for filter options
class FilterOption {
  final String id;
  final String label;
  final bool isSelected;

  FilterOption({
    required this.id,
    required this.label,
    this.isSelected = false,
  });

  FilterOption copyWith({bool? isSelected}) {
    return FilterOption(
      id: id,
      label: label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Data model for range slider filter
class RangeFilterOption {
  final String id;
  final String label;
  final double minValue;
  final double maxValue;
  final double currentMin;
  final double currentMax;
  final String? suffix;
  final int divisions;

  RangeFilterOption({
    required this.id,
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.currentMin,
    required this.currentMax,
    this.suffix,
    this.divisions = 10,
  });

  RangeFilterOption copyWith({
    double? currentMin,
    double? currentMax,
  }) {
    return RangeFilterOption(
      id: id,
      label: label,
      minValue: minValue,
      maxValue: maxValue,
      currentMin: currentMin ?? this.currentMin,
      currentMax: currentMax ?? this.currentMax,
      suffix: suffix,
      divisions: divisions,
    );
  }
}

/// Callback for filter changes
typedef FilterCallback = void Function(FilterOption option);
typedef RangeFilterCallback = void Function(RangeFilterOption option);
typedef ClearCallback = void Function();

/// Reusable Filter UI Widget with Chips and Sliders
class FilterPanel extends StatefulWidget {
  /// Chip-based category filters
  final List<FilterOption> categoryFilters;

  /// Range sliders for numeric filters
  final List<RangeFilterOption> rangeFilters;

  /// Callback when category filter changes
  final FilterCallback? onCategoryChanged;

  /// Callback when range filter changes
  final RangeFilterCallback? onRangeChanged;

  /// Callback to clear all filters
  final ClearCallback? onClearFilters;

  /// Show close button or not
  final bool showCloseButton;

  /// Header title
  final String? title;

  /// Background color
  final Color backgroundColor;

  /// Whether to show applied filter count
  final bool showFilterCount;

  const FilterPanel({
    super.key,
    required this.categoryFilters,
    this.rangeFilters = const [],
    this.onCategoryChanged,
    this.onRangeChanged,
    this.onClearFilters,
    this.showCloseButton = false,
    this.title = 'Filters',
    this.backgroundColor = AppTheme.white,
    this.showFilterCount = true,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late List<FilterOption> _categoryFilters;
  late List<RangeFilterOption> _rangeFilters;

  @override
  void initState() {
    super.initState();
    _categoryFilters = List.from(widget.categoryFilters);
    _rangeFilters = List.from(widget.rangeFilters);
  }

  int get _appliedFilterCount {
    int count = _categoryFilters.where((f) => f.isSelected).length;
    count += _rangeFilters.where((f) => 
      f.currentMin != f.minValue || f.currentMax != f.maxValue
    ).length;
    return count;
  }

  void _toggleCategory(FilterOption option) {
    setState(() {
      final index = _categoryFilters.indexWhere((f) => f.id == option.id);
      if (index != -1) {
        _categoryFilters[index] = option.copyWith(isSelected: !option.isSelected);
        widget.onCategoryChanged?.call(_categoryFilters[index]);
      }
    });
  }

  void _updateRangeFilter(RangeFilterOption option) {
    setState(() {
      final index = _rangeFilters.indexWhere((f) => f.id == option.id);
      if (index != -1) {
        _rangeFilters[index] = option;
        widget.onRangeChanged?.call(option);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _categoryFilters = _categoryFilters
          .map((f) => f.copyWith(isSelected: false))
          .toList();
      _rangeFilters = _rangeFilters
          .map((f) => f.copyWith(
            currentMin: f.minValue,
            currentMax: f.maxValue,
          ))
          .toList();
    });
    widget.onClearFilters?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title ?? 'Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                    if (widget.showFilterCount && _appliedFilterCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _appliedFilterCount.toString(),
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (widget.showCloseButton)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.borderColor),

          // Scrollable filters
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filters (Chips)
                  if (_categoryFilters.isNotEmpty) ...[
                    _buildCategoryFiltersSection(),
                    const SizedBox(height: 24),
                  ],

                  // Range Filters (Sliders)
                  if (_rangeFilters.isNotEmpty) ...[
                    _buildRangeFiltersSection(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Clear Button
                if (_appliedFilterCount > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAllFilters,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),

                // Apply Button (or spacing)
                if (_appliedFilterCount > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      _appliedFilterCount > 0 ? 'Apply Filters' : 'Done',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categoryFilters
              .map((filter) => _buildCategoryChip(filter))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(FilterOption filter) {
    return FilterChip(
      label: Text(filter.label),
      selected: filter.isSelected,
      onSelected: (_) => _toggleCategory(filter),
      backgroundColor: AppTheme.white,
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.1),
      side: BorderSide(
        color: filter.isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
        width: filter.isSelected ? 2 : 1,
      ),
      labelStyle: TextStyle(
        color: filter.isSelected ? AppTheme.primaryColor : AppTheme.gray700,
        fontWeight: filter.isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildRangeFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Range Filters',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 16),
        ..._rangeFilters.map((filter) => [
          _buildRangeFilterCard(filter),
          const SizedBox(height: 12),
        ]).expand((element) => element),
      ],
    );
  }

  Widget _buildRangeFilterCard(RangeFilterOption filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filter.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${filter.currentMin.toStringAsFixed(0)}${filter.suffix ?? ''} - ${filter.currentMax.toStringAsFixed(0)}${filter.suffix ?? ''}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: RangeValues(filter.currentMin, filter.currentMax),
          min: filter.minValue,
          max: filter.maxValue,
          divisions: filter.divisions,
          labels: RangeLabels(
            filter.currentMin.toStringAsFixed(0),
            filter.currentMax.toStringAsFixed(0),
          ),
          onChanged: (RangeValues values) {
            _updateRangeFilter(
              filter.copyWith(
                currentMin: values.start,
                currentMax: values.end,
              ),
            );
          },
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.gray200,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filter.minValue.toStringAsFixed(0)}${filter.suffix ?? ''}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.gray500,
                ),
              ),
              Text(
                '${filter.maxValue.toStringAsFixed(0)}${filter.suffix ?? ''}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bottom Sheet Filter Dialog
class FilterBottomSheet extends StatelessWidget {
  final List<FilterOption> categoryFilters;
  final List<RangeFilterOption> rangeFilters;
  final FilterCallback? onCategoryChanged;
  final RangeFilterCallback? onRangeChanged;
  final ClearCallback? onClearFilters;
  final String? title;

  const FilterBottomSheet({
    super.key,
    required this.categoryFilters,
    this.rangeFilters = const [],
    this.onCategoryChanged,
    this.onRangeChanged,
    this.onClearFilters,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return FilterPanel(
          categoryFilters: categoryFilters,
          rangeFilters: rangeFilters,
          onCategoryChanged: onCategoryChanged,
          onRangeChanged: onRangeChanged,
          onClearFilters: onClearFilters,
          showCloseButton: true,
          title: title,
        );
      },
    );
  }
}

/// Quick Filter Chips Row (for displaying active filters)
class ActiveFiltersRow extends StatelessWidget {
  final List<FilterOption> selectedCategories;
  final List<RangeFilterOption> appliedRanges;
  final VoidCallback? onClear;

  const ActiveFiltersRow({
    super.key,
    required this.selectedCategories,
    this.appliedRanges = const [],
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final activeFilters = selectedCategories.where((f) => f.isSelected).toList();

    if (activeFilters.isEmpty && appliedRanges.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          ...activeFilters.map((filter) => Chip(
            label: Text(filter.label),
            onDeleted: () => {},
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            labelStyle: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
            ),
          )),
          if (activeFilters.isNotEmpty && onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.errorColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.close,
                      size: 14,
                      color: AppTheme.errorColor,
                    ),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
