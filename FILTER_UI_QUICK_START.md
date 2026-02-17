# Filter UI - Quick Start Guide

TL;DR version for using the Filter UI component in your screens.

---

## 30-Second Setup

### Step 1: Import
```dart
import 'package:sahara/widgets/filter_ui.dart';
```

### Step 2: Define Filters
```dart
@override
void initState() {
  super.initState();
  
  categoryFilters = [
    FilterOption(id: 'option1', label: 'Option 1'),
    FilterOption(id: 'option2', label: 'Option 2'),
  ];

  rangeFilters = [
    RangeFilterOption(
      id: 'price',
      label: 'Price',
      minValue: 0,
      maxValue: 1000,
      currentMin: 0,
      currentMax: 1000,
      suffix: '₹',
    ),
  ];
}
```

### Step 3: Show Filter Panel
```dart
ElevatedButton(
  onPressed: _showFilters,
  child: const Text('Filters'),
)

void _showFilters() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(
      categoryFilters: categoryFilters,
      rangeFilters: rangeFilters,
      onCategoryChanged: (option) => setState(() {
        final index = categoryFilters.indexWhere((f) => f.id == option.id);
        categoryFilters[index] = option;
      }),
      onRangeChanged: (option) => setState(() {
        final index = rangeFilters.indexWhere((f) => f.id == option.id);
        rangeFilters[index] = option;
      }),
    ),
  );
}
```

### Step 4: Display Active Filters
```dart
ActiveFiltersRow(
  selectedCategories: categoryFilters,
  appliedRanges: rangeFilters,
  onClear: () => setState(() {
    categoryFilters = categoryFilters
        .map((f) => f.copyWith(isSelected: false))
        .toList();
  }),
)
```

---

## Copy-Paste Templates

### Template 1: Search Screen with Filters

```dart
import 'package:flutter/material.dart';
import 'package:sahara/widgets/filter_ui.dart';

class SearchCaregiverScreen extends StatefulWidget {
  @override
  State<SearchCaregiverScreen> createState() => _SearchCaregiverScreenState();
}

class _SearchCaregiverScreenState extends State<SearchCaregiverScreen> {
  late List<FilterOption> filters;
  late List<RangeFilterOption> ranges;

  @override
  void initState() {
    super.initState();
    
    filters = [
      FilterOption(id: 'verified', label: 'Verified'),
      FilterOption(id: 'experienced', label: 'Experienced'),
    ];

    ranges = [
      RangeFilterOption(
        id: 'rating',
        label: 'Rating',
        minValue: 0,
        maxValue: 5,
        currentMin: 0,
        currentMax: 5,
        suffix: '⭐',
      ),
      RangeFilterOption(
        id: 'price',
        label: 'Price',
        minValue: 100,
        maxValue: 1000,
        currentMin: 100,
        currentMax: 1000,
        suffix: '₹',
      ),
    ];
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        categoryFilters: filters,
        rangeFilters: ranges,
        title: 'Find Caregivers',
        onCategoryChanged: (option) => setState(() {
          final i = filters.indexWhere((f) => f.id == option.id);
          filters[i] = option;
        }),
        onRangeChanged: (option) => setState(() {
          final i = ranges.indexWhere((f) => f.id == option.id);
          ranges[i] = option;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          ActiveFiltersRow(
            selectedCategories: filters,
            appliedRanges: ranges,
            onClear: () => setState(() {
              filters = filters.map((f) => f.copyWith(isSelected: false)).toList();
            }),
          ),
          Expanded(child: ListView(children: [])),
        ],
      ),
    );
  }
}
```

### Template 2: Inline Filter Panel

```dart
Column(
  children: [
    FilterPanel(
      categoryFilters: filters,
      rangeFilters: ranges,
      showCloseButton: false,
      backgroundColor: Colors.grey[100],
      onCategoryChanged: (option) => setState(() {
        final i = filters.indexWhere((f) => f.id == option.id);
        filters[i] = option;
      }),
    ),
  ],
)
```

---

## Common Filter Configurations

### Caregiver Filters
```dart
List<FilterOption> caregiverFilters = [
  FilterOption(id: 'verified', label: 'Verified ✓'),
  FilterOption(id: 'exp_1', label: '1+ Years'),
  FilterOption(id: 'exp_3', label: '3+ Years'),
  FilterOption(id: 'exp_5', label: '5+ Years'),
];

List<RangeFilterOption> caregiverRanges = [
  RangeFilterOption(
    id: 'rating', label: 'Rating', minValue: 0, maxValue: 5,
    currentMin: 0, currentMax: 5, suffix: '⭐', divisions: 10,
  ),
  RangeFilterOption(
    id: 'price', label: 'Price/Hour', minValue: 100, maxValue: 1000,
    currentMin: 100, currentMax: 1000, suffix: '₹', divisions: 9,
  ),
  RangeFilterOption(
    id: 'distance', label: 'Distance', minValue: 0, maxValue: 50,
    currentMin: 0, currentMax: 50, suffix: 'km', divisions: 10,
  ),
];
```

### Service Filters
```dart
List<FilterOption> serviceFilters = [
  FilterOption(id: 'walking', label: '🚶 Walking'),
  FilterOption(id: 'sitting', label: '🏠 Sitting'),
  FilterOption(id: 'boarding', label: '🏨 Boarding'),
  FilterOption(id: 'grooming', label: '✂️ Grooming'),
];

List<RangeFilterOption> serviceRanges = [
  RangeFilterOption(
    id: 'price', label: 'Price', minValue: 50, maxValue: 5000,
    currentMin: 50, currentMax: 5000, suffix: '₹', divisions: 10,
  ),
  RangeFilterOption(
    id: 'duration', label: 'Duration', minValue: 30, maxValue: 480,
    currentMin: 30, currentMax: 480, suffix: 'min', divisions: 9,
  ),
];
```

### Pet Filters
```dart
List<FilterOption> petFilters = [
  FilterOption(id: 'dog', label: '🐕 Dogs'),
  FilterOption(id: 'cat', label: '🐈 Cats'),
  FilterOption(id: 'rabbit', label: '🐰 Rabbits'),
  FilterOption(id: 'bird', label: '🦜 Birds'),
];

List<RangeFilterOption> petRanges = [
  RangeFilterOption(
    id: 'age', label: 'Age', minValue: 0, maxValue: 20,
    currentMin: 0, currentMax: 20, suffix: 'years', divisions: 20,
  ),
  RangeFilterOption(
    id: 'weight', label: 'Weight', minValue: 1, maxValue: 100,
    currentMin: 1, currentMax: 100, suffix: 'kg', divisions: 10,
  ),
];
```

---

## Common Patterns

### Pattern 1: Get Selected Categories
```dart
List<String> getSelectedIds() {
  return filters
      .where((f) => f.isSelected)
      .map((f) => f.id)
      .toList();
}

// Usage
final selectedCategories = getSelectedIds(); // ['verified', 'experienced']
```

### Pattern 2: Get Range Values
```dart
Map<String, dynamic> getRangeValues() {
  return {
    for (var range in ranges)
      range.id: {
        'min': range.currentMin,
        'max': range.currentMax,
      }
  };
}

// Usage
final rangeMap = getRangeValues();
// Output: {'rating': {'min': 2, 'max': 5}, 'price': {'min': 200, 'max': 800}}
```

### Pattern 3: Clear Specific Category
```dart
void clearCategory(String id) {
  setState(() {
    final index = filters.indexWhere((f) => f.id == id);
    if (index != -1) {
      filters[index] = filters[index].copyWith(isSelected: false);
    }
  });
}
```

### Pattern 4: Reset All Filters
```dart
void resetAll() {
  setState(() {
    filters = filters.map((f) => f.copyWith(isSelected: false)).toList();
    ranges = ranges.map((r) => r.copyWith(
      currentMin: r.minValue,
      currentMax: r.maxValue,
    )).toList();
  });
}
```

### Pattern 5: API Integration
```dart
Future<void> applyAndSearch() async {
  final selectedIds = filters
      .where((f) => f.isSelected)
      .map((f) => f.id)
      .toList();

  final priceRange = ranges.firstWhere((r) => r.id == 'price');

  try {
    final results = await api.search(
      categories: selectedIds,
      minPrice: priceRange.currentMin.toInt(),
      maxPrice: priceRange.currentMax.toInt(),
    );
    
    setState(() => _results = results);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

---

## Property Reference

### FilterPanel Properties
```dart
FilterPanel(
  categoryFilters: [],           // Required: List of category options
  rangeFilters: [],              // Optional: List of range sliders
  onCategoryChanged: (option){}, // Optional: Category selection callback
  onRangeChanged: (option) {},   // Optional: Range change callback
  onClearFilters: () {},         // Optional: Clear all callback
  showCloseButton: false,        // Optional: Show close button
  title: 'Filters',              // Optional: Header title
  backgroundColor: white,        // Optional: Panel background
  showFilterCount: true,         // Optional: Show applied count badge
)
```

### FilterOption Properties
```dart
FilterOption(
  id: 'unique_id',          // Required: Unique identifier
  label: 'Display Name',    // Required: What user sees
  isSelected: false,        // Optional: Current state
)
```

### RangeFilterOption Properties
```dart
RangeFilterOption(
  id: 'unique_id',          // Required
  label: 'Price',           // Required
  minValue: 100,            // Required: Slider minimum
  maxValue: 1000,           // Required: Slider maximum
  currentMin: 100,          // Required: Current min value
  currentMax: 1000,         // Required: Current max value
  suffix: '₹',              // Optional: Unit (₹, km, %, etc)
  divisions: 9,             // Optional: Number of steps
)
```

---

## Testing Your Filters

1. **View Demo**
   - Route: `/filter-demo`
   - Shows all filter types and interactions

2. **Test Locally**
   ```bash
   cd sahara
   flutter run
   # Navigate to /filter-demo
   ```

3. **Check Applied Filters**
   - Click chips to select/deselect
   - Drag sliders to change ranges
   - See active filters update
   - Tap "Clear All" to reset

---

## Files Included

- `lib/widgets/filter_ui.dart` - Main component
- `lib/screens/common/filter_demo_screen.dart` - Demo & reference
- `FILTER_UI_DOCUMENTATION.md` - Full documentation

---

## Support

For questions or issues:
1. Check `FILTER_UI_DOCUMENTATION.md` for detailed docs
2. Review `filter_demo_screen.dart` for implementation examples
3. Check existing usage in other screens

---

**Ready to use?** Copy the template and customize for your screen! 🚀
