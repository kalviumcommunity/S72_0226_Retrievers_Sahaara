# Filter UI Documentation

Comprehensive guide for using the reusable Filter UI component with chips and sliders.

## Overview

The Filter UI component provides a flexible, Material Design 3-compliant filtering solution with:
- **Chip-based category filters** - Interactive toggle buttons for categorical selection
- **Range sliders** - Smooth numerical range selection (price, distance, rating, etc.)
- **Active filters display** - Shows currently applied filters
- **Clear/Apply actions** - Easy filter management
- **Bottom sheet integration** - Mobile-optimized presentation

---

## Component Structure

### Main Components

#### 1. **FilterOption** (Model)
Represents a categorical filter option:

```dart
FilterOption(
  id: 'verified',
  label: 'Verified Only',
  isSelected: false,
)
```

**Properties:**
- `id` - Unique identifier
- `label` - Display text
- `isSelected` - Current selection state

#### 2. **RangeFilterOption** (Model)
Represents a numerical range filter:

```dart
RangeFilterOption(
  id: 'price',
  label: 'Price per Hour',
  minValue: 100,
  maxValue: 1000,
  currentMin: 100,
  currentMax: 1000,
  suffix: '₹',
  divisions: 9,
)
```

**Properties:**
- `id` - Unique identifier
- `label` - Display label
- `minValue` / `maxValue` - Range boundaries
- `currentMin` / `currentMax` - Current slider positions
- `suffix` - Unit display (₹, km, %, etc.)
- `divisions` - Number of discrete slider steps

#### 3. **FilterPanel** (Widget)
Main filter UI component with chips and sliders:

```dart
FilterPanel(
  categoryFilters: [...],
  rangeFilters: [...],
  onCategoryChanged: (option) { },
  onRangeChanged: (option) { },
  onClearFilters: () { },
  showCloseButton: true,
  title: 'Filters',
)
```

#### 4. **FilterBottomSheet** (Widget)
Draggable bottom sheet wrapper for FilterPanel:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => FilterBottomSheet(
    categoryFilters: [...],
    rangeFilters: [...],
    title: 'Search Filters',
  ),
)
```

#### 5. **ActiveFiltersRow** (Widget)
Horizontal display of active filters with clear button:

```dart
ActiveFiltersRow(
  selectedCategories: categoryFilters,
  appliedRanges: rangeFilters,
  onClear: () { },
)
```

---

## Usage Examples

### Example 1: Caregiver Search Filters

```dart
import 'package:sahara/widgets/filter_ui.dart';

class CaregiverSearchScreen extends StatefulWidget {
  @override
  State<CaregiverSearchScreen> createState() => _CaregiverSearchScreenState();
}

class _CaregiverSearchScreenState extends State<CaregiverSearchScreen> {
  late List<FilterOption> categoryFilters;
  late List<RangeFilterOption> rangeFilters;

  @override
  void initState() {
    super.initState();
    
    categoryFilters = [
      FilterOption(id: 'verified', label: 'Verified Only'),
      FilterOption(id: 'exp_expert', label: 'Expert Level'),
      FilterOption(id: 'responding', label: 'Responding'),
      FilterOption(id: 'insured', label: 'Insured'),
    ];

    rangeFilters = [
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
        label: 'Price per Hour',
        minValue: 100,
        maxValue: 1000,
        currentMin: 100,
        currentMax: 1000,
        suffix: '₹',
      ),
      RangeFilterOption(
        id: 'distance',
        label: 'Distance',
        minValue: 0,
        maxValue: 50,
        currentMin: 0,
        currentMax: 50,
        suffix: ' km',
      ),
    ];
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        categoryFilters: categoryFilters,
        rangeFilters: rangeFilters,
        title: 'Find Caregiver',
        onCategoryChanged: (option) {
          setState(() {
            final index = categoryFilters
                .indexWhere((f) => f.id == option.id);
            if (index != -1) {
              categoryFilters[index] = option;
            }
          });
          _applyFilters();
        },
        onRangeChanged: (option) {
          setState(() {
            final index = rangeFilters
                .indexWhere((f) => f.id == option.id);
            if (index != -1) {
              rangeFilters[index] = option;
            }
          });
        },
      ),
    );
  }

  void _applyFilters() {
    // Apply filters to search query
    // Call API with selected filters
    print('Filters applied');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Caregiver'),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          // Show active filters
          ActiveFiltersRow(
            selectedCategories: categoryFilters,
            appliedRanges: rangeFilters,
            onClear: () {
              setState(() {
                categoryFilters = categoryFilters
                    .map((f) => f.copyWith(isSelected: false))
                    .toList();
              });
            },
          ),
          
          // Search results list
          Expanded(
            child: ListView(
              children: [
                // Caregiver cards
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Pet Search Filters

```dart
List<FilterOption> petFilters = [
  FilterOption(id: 'dog', label: 'Dogs'),
  FilterOption(id: 'cat', label: 'Cats'),
  FilterOption(id: 'rabbit', label: 'Rabbits'),
  FilterOption(id: 'bird', label: 'Birds'),
];

List<RangeFilterOption> petRanges = [
  RangeFilterOption(
    id: 'age',
    label: 'Age',
    minValue: 0,
    maxValue: 20,
    currentMin: 0,
    currentMax: 20,
    suffix: ' years',
    divisions: 20,
  ),
  RangeFilterOption(
    id: 'weight',
    label: 'Weight',
    minValue: 1,
    maxValue: 100,
    currentMin: 1,
    currentMax: 100,
    suffix: ' kg',
    divisions: 10,
  ),
];
```

### Example 3: Service Search Filters

```dart
List<FilterOption> serviceCategories = [
  FilterOption(id: 'walking', label: 'Dog Walking'),
  FilterOption(id: 'sitting', label: 'Pet Sitting'),
  FilterOption(id: 'boarding', label: 'Boarding'),
  FilterOption(id: 'grooming', label: 'Grooming'),
  FilterOption(id: 'training', label: 'Training'),
  FilterOption(id: '24_7', label: '24/7 Available'),
];

List<RangeFilterOption> serviceRanges = [
  RangeFilterOption(
    id: 'price',
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
    suffix: ' minutes',
    divisions: 9,
  ),
  RangeFilterOption(
    id: 'rating',
    label: 'Minimum Rating',
    minValue: 0,
    maxValue: 5,
    currentMin: 0,
    currentMax: 5,
    suffix: '⭐',
  ),
];
```

---

## Chip Filter Behavior

### Single Selection (if needed)

Modify the `_toggleCategory` method to allow only one selection:

```dart
void _toggleCategory(FilterOption option) {
  setState(() {
    if (option.isSelected) {
      // If clicking selected chip, deselect it
      categoryFilters = categoryFilters
          .map((f) => f.copyWith(isSelected: false))
          .toList();
    } else {
      // Single selection mode
      categoryFilters = categoryFilters
          .map((f) => f.copyWith(
            isSelected: f.id == option.id,
          ))
          .toList();
    }
  });
}
```

### Multiple Selection (Default)

Current implementation supports multiple selections. Users can select many chips simultaneously.

---

## Range Slider Customization

### Price Filter Example

```dart
RangeFilterOption(
  id: 'price_range',
  label: 'Your Budget',
  minValue: 0,
  maxValue: 10000,
  currentMin: 500,
  currentMax: 5000,
  suffix: '₹',
  divisions: 100, // More precise control
)
```

### Distance Filter Example

```dart
RangeFilterOption(
  id: 'distance',
  label: 'Search Radius',
  minValue: 0,
  maxValue: 100,
  currentMin: 0,
  currentMax: 25,
  suffix: ' km',
  divisions: 20,
)
```

### Rating Filter Example

```dart
RangeFilterOption(
  id: 'min_rating',
  label: 'Minimum Rating',
  minValue: 0,
  maxValue: 5,
  currentMin: 3,
  currentMax: 5,
  suffix: '⭐',
  divisions: 10,
)
```

---

## Styling & Customization

### Color Customization

Update FilterPanel in filter_ui.dart:

```dart
FilterPanel(
  categoryFilters: filters,
  backgroundColor: Colors.white,
  // Chips are colored using AppTheme.primaryColor
  // To change: modify chip colors in _buildCategoryChip()
)
```

### Theme Colors Used

- **Primary**: `AppTheme.primaryColor` - Selected chip border & text
- **Secondary**: `AppTheme.gray*` - Unselected states
- **Error**: `AppTheme.errorColor` - Clear button
- **Background**: `AppTheme.white` - Filter panel background

### Custom Styling Example

Extend FilterPanel to customize colors:

```dart
class CustomFilterPanel extends FilterPanel {
  final Color primaryColor;
  
  const CustomFilterPanel({
    required super.categoryFilters,
    required this.primaryColor,
  });
  
  @override
  Widget _buildCategoryChip(FilterOption filter) {
    // Custom chip styling with primaryColor
  }
}
```

---

## Testing

### Using the Demo Screen

The app includes a demo screen at `/filter-demo` showing:
- All filter types (Caregivers, Services, Pets)
- Interactive chip selection
- Range slider interaction
- Applied filter preview
- Filter clearing

**Access:** Navigate to FilterDemoScreen or route `/filter-demo`

---

## Best Practices

### ✅ Do

1. **Initialize in StatefulWidget.initState()**
   ```dart
   @override
   void initState() {
     super.initState();
     categoryFilters = [
       FilterOption(id: 'a', label: 'Option A'),
     ];
   }
   ```

2. **Update state in callbacks**
   ```dart
   onCategoryChanged: (option) {
     setState(() {
       // Update your filter list
     });
   }
   ```

3. **Call API after filter changes**
   ```dart
   onRangeChanged: (option) {
     setState(() { /* update */ });
     _performSearch(); // API call
   }
   ```

4. **Use meaningful filter IDs**
   ```dart
   FilterOption(
     id: 'verified_only', // Clear, unique ID
     label: 'Verified Caregivers',
   )
   ```

### ❌ Don't

1. **Don't modify filters outside callbacks**
   ```dart
   // ❌ Wrong
   categoryFilters[0].isSelected = true;
   
   // ✅ Correct
   categoryFilters[0] = categoryFilters[0].copyWith(isSelected: true);
   ```

2. **Don't forget setState() when updating**
   ```dart
   // ❌ Won't update UI
   categoryFilters = newFilters;
   
   // ✅ Updates UI
   setState(() {
     categoryFilters = newFilters;
   });
   ```

3. **Don't use same ID for different filters**
   ```dart
   // ❌ Conflict
   FilterOption(id: 'price', label: 'Price'),
   RangeFilterOption(id: 'price', label: 'Price Range'),
   
   // ✅ Unique IDs
   FilterOption(id: 'category_price', ...),
   RangeFilterOption(id: 'range_price', ...),
   ```

---

## API Integration Example

```dart
Future<void> _applyFilters() async {
  // Build filter parameters
  final selectedCategories = categoryFilters
      .where((f) => f.isSelected)
      .map((f) => f.id)
      .toList();

  final priceFilter = rangeFilters
      .firstWhere((f) => f.id == 'price');

  // Make API request
  try {
    final results = await caregiverRepository.searchCaregivers(
      categories: selectedCategories,
      minPrice: priceFilter.currentMin.toInt(),
      maxPrice: priceFilter.currentMax.toInt(),
    );
    
    setState(() {
      _searchResults = results;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Search failed: $e')),
    );
  }
}
```

---

## Performance Considerations

### Filter Panel Optimization

- Uses `SingleChildScrollView` for scrollable filters
- Efficient `ListView.builder` for large filter lists
- RangeSlider updates only on drag completion
- State updates batched in `setState()` call

### Large Filter Lists

For > 50 filter options, consider:

```dart
// Add search within filters
TextField(
  onChanged: (query) {
    setState(() {
      _filteredOptions = categoryFilters
          .where((f) => f.label
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  },
)
```

---

## Troubleshooting

### Issue: Chips don't update on selection
**Solution:** Always use `.copyWith()` when updating FilterOption:
```dart
filterOption = filterOption.copyWith(isSelected: true);
```

### Issue: RangeSlider not updating
**Solution:** Ensure `onChanged` callback updates state:
```dart
onChanged: (RangeValues values) {
  setState(() {
    rangeFilter = rangeFilter.copyWith(
      currentMin: values.start,
      currentMax: values.end,
    );
  });
}
```

### Issue: Applied filter count not showing
**Solution:** Check `showFilterCount` property is `true`:
```dart
FilterPanel(
  categoryFilters: filters,
  showFilterCount: true, // Must be true
)
```

---

## Files Reference

- **Widget:** `lib/widgets/filter_ui.dart`
- **Demo:** `lib/screens/common/filter_demo_screen.dart`
- **Routes:** `lib/utils/routes.dart` (route: `/filter-demo`)

---

**Last Updated:** February 17, 2026
