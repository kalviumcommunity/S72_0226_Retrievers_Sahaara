import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/caregiver_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/caregiver_card.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../utils/constants.dart';
import 'caregiver_detail_screen.dart';

/// Screen for searching and filtering caregivers
class CaregiverSearchScreen extends StatefulWidget {
  const CaregiverSearchScreen({super.key});

  @override
  State<CaregiverSearchScreen> createState() => _CaregiverSearchScreenState();
}

class _CaregiverSearchScreenState extends State<CaregiverSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadCaregivers();
  }

  Future<void> _loadCaregivers() async {
    final caregiverProvider = Provider.of<CaregiverProvider>(context, listen: false);
    await caregiverProvider.loadCaregivers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Caregivers'),
        actions: [
          Consumer<CaregiverProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                      });
                    },
                  ),
                  if (provider.activeFilterCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.activeFilterCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search caregivers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Filters Section
          if (_showFilters) _buildFiltersSection(),

          // Caregivers List
          Expanded(
            child: Consumer<CaregiverProvider>(
              builder: (context, caregiverProvider, child) {
                if (caregiverProvider.isLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const LoadingSkeleton(
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                }

                if (caregiverProvider.error != null) {
                  return ErrorState(
                    message: caregiverProvider.error!,
                    onRetry: _loadCaregivers,
                  );
                }

                final caregivers = caregiverProvider.caregivers;

                if (caregivers.isEmpty) {
                  return const EmptyState(
                    icon: Icons.person_search,
                    message: 'No caregivers found',
                    description: 'Try adjusting your filters',
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadCaregivers,
                  child: ListView.builder(
                    itemCount: caregivers.length,
                    itemBuilder: (context, index) {
                      final caregiver = caregivers[index];
                      
                      return Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          // Load user profile for caregiver
                          userProvider.loadUserProfile(caregiver.userId);
                          final userProfile = userProvider.getUserById(caregiver.userId);
                          
                          return CaregiverCard(
                            caregiver: caregiver,
                            userProfile: userProfile,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CaregiverDetailScreen(
                                    caregiver: caregiver,
                                    userProfile: userProfile,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Consumer<CaregiverProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      provider.clearFilters();
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Service Type Filter
              const Text(
                'Service Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ServiceTypes.all.map((service) {
                  final isSelected = provider.selectedService == service['id'];
                  return FilterChip(
                    label: Text(service['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      provider.setServiceFilter(selected ? service['id'] : null);
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Pet Type Filter
              const Text(
                'Pet Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: PetTypes.all.map((petType) {
                  final isSelected = provider.selectedPetType == petType['id'];
                  return FilterChip(
                    label: Text(petType['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      provider.setPetTypeFilter(selected ? petType['id'] : null);
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Rating Filter
              Row(
                children: [
                  const Text(
                    'Minimum Rating',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    provider.minRating > 0
                        ? '${provider.minRating.toStringAsFixed(1)}+'
                        : 'Any',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Slider(
                value: provider.minRating,
                min: 0,
                max: 5,
                divisions: 10,
                label: provider.minRating.toStringAsFixed(1),
                onChanged: (value) {
                  provider.setRatingFilter(value);
                },
              ),
              
              const SizedBox(height: 8),
              
              // Price Range Filter
              Row(
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${provider.minPrice.toInt()} - ₹${provider.maxPrice.toInt()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(provider.minPrice, provider.maxPrice),
                min: 0,
                max: 2000,
                divisions: 20,
                labels: RangeLabels(
                  '₹${provider.minPrice.toInt()}',
                  '₹${provider.maxPrice.toInt()}',
                ),
                onChanged: (values) {
                  provider.setPriceRange(values.start, values.end);
                },
              ),
              
              const SizedBox(height: 8),
              
              // Sort By
              Row(
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'rating',
                          label: Text('Rating'),
                          icon: Icon(Icons.star, size: 16),
                        ),
                        ButtonSegment(
                          value: 'price_low',
                          label: Text('Price ↑'),
                        ),
                        ButtonSegment(
                          value: 'price_high',
                          label: Text('Price ↓'),
                        ),
                      ],
                      selected: {provider.sortBy},
                      onSelectionChanged: (Set<String> selected) {
                        provider.setSortBy(selected.first);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
