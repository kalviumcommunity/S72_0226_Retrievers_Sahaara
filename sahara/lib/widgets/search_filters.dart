import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget for filtering caregiver search results
class SearchFiltersWidget extends StatefulWidget {
  final List<String> selectedServices;
  final List<String> selectedPetTypes;
  final double? minRating;
  final double? maxHourlyRate;
  final int? minExperience;
  final Function(List<String>) onServicesChanged;
  final Function(List<String>) onPetTypesChanged;
  final Function(double?) onRatingChanged;
  final Function(double?) onHourlyRateChanged;
  final Function(int?) onExperienceChanged;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const SearchFiltersWidget({
    super.key,
    required this.selectedServices,
    required this.selectedPetTypes,
    required this.minRating,
    required this.maxHourlyRate,
    required this.minExperience,
    required this.onServicesChanged,
    required this.onPetTypesChanged,
    required this.onRatingChanged,
    required this.onHourlyRateChanged,
    required this.onExperienceChanged,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  late List<String> _services;
  late List<String> _petTypes;
  late double? _rating;
  late double? _hourlyRate;
  late int? _experience;

  @override
  void initState() {
    super.initState();
    _services = List.from(widget.selectedServices);
    _petTypes = List.from(widget.selectedPetTypes);
    _rating = widget.minRating;
    _hourlyRate = widget.maxHourlyRate;
    _experience = widget.minExperience;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _services = [];
                    _petTypes = [];
                    _rating = null;
                    _hourlyRate = null;
                    _experience = null;
                  });
                  widget.onClear();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Services
          Text(
            'Services',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ServiceTypes.all.map((service) {
              final isSelected = _services.contains(service['id']);
              return FilterChip(
                label: Text(service['name']),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _services.add(service['id']);
                    } else {
                      _services.remove(service['id']);
                    }
                  });
                  widget.onServicesChanged(_services);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Pet Types
          Text(
            'Pet Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: PetTypes.all.map((petType) {
              final isSelected = _petTypes.contains(petType['id']);
              return FilterChip(
                label: Text(petType['name']),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _petTypes.add(petType['id']);
                    } else {
                      _petTypes.remove(petType['id']);
                    }
                  });
                  widget.onPetTypesChanged(_petTypes);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Rating
          Text(
            'Minimum Rating',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Slider(
            value: _rating ?? 0,
            min: 0,
            max: 5,
            divisions: 10,
            label: _rating != null ? _rating!.toStringAsFixed(1) : 'Any',
            onChanged: (value) {
              setState(() {
                _rating = value > 0 ? value : null;
              });
              widget.onRatingChanged(_rating);
            },
          ),
          const SizedBox(height: 16),
          
          // Hourly Rate
          Text(
            'Maximum Hourly Rate: ₹${_hourlyRate?.toStringAsFixed(0) ?? 'Any'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Slider(
            value: _hourlyRate ?? AppConstants.maxHourlyRate,
            min: AppConstants.minHourlyRate,
            max: AppConstants.maxHourlyRate,
            divisions: 19,
            label: _hourlyRate != null ? '₹${_hourlyRate!.toStringAsFixed(0)}' : 'Any',
            onChanged: (value) {
              setState(() {
                _hourlyRate = value;
              });
              widget.onHourlyRateChanged(_hourlyRate);
            },
          ),
          const SizedBox(height: 16),
          
          // Experience
          Text(
            'Minimum Experience: ${_experience ?? 'Any'} years',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Slider(
            value: (_experience ?? 0).toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            label: _experience != null ? '$_experience years' : 'Any',
            onChanged: (value) {
              setState(() {
                _experience = value.toInt() > 0 ? value.toInt() : null;
              });
              widget.onExperienceChanged(_experience);
            },
          ),
          const SizedBox(height: 24),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
