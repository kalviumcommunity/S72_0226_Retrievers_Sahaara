import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/caregiver_provider.dart';
import '../../models/caregiver_model.dart';
import '../../models/user_model.dart';
import '../../widgets/search_filters.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';
import 'caregiver_detail_screen.dart';

/// Screen for searching and filtering caregivers
class CaregiverSearchScreen extends StatefulWidget {
  const CaregiverSearchScreen({super.key});

  @override
  State<CaregiverSearchScreen> createState() => _CaregiverSearchScreenState();
}

class _CaregiverSearchScreenState extends State<CaregiverSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCaregivers();
  }

  Future<void> _loadCaregivers() async {
    final provider = Provider.of<CaregiverProvider>(context, listen: false);
    await provider.loadCaregivers();
  }

  void _showFilters() {
    final provider = Provider.of<CaregiverProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFiltersWidget(
        selectedServices: provider.selectedServices,
        selectedPetTypes: provider.selectedPetTypes,
        minRating: provider.minRating,
        maxHourlyRate: provider.maxHourlyRate,
        minExperience: provider.minExperience,
        onServicesChanged: provider.updateServiceFilters,
        onPetTypesChanged: provider.updatePetTypeFilters,
        onRatingChanged: provider.updateRatingFilter,
        onHourlyRateChanged: provider.updateHourlyRateFilter,
        onExperienceChanged: provider.updateExperienceFilter,
        onApply: provider.applyFilters,
        onClear: provider.clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Caregivers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
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
                hintText: 'Search by name or location...',
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
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Results
          Expanded(
            child: Consumer<CaregiverProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: LoadingSkeleton(height: 120),
                    ),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${provider.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCaregivers,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final caregivers = provider.caregivers;

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
                    padding: const EdgeInsets.all(16),
                    itemCount: caregivers.length,
                    itemBuilder: (context, index) {
                      final item = caregivers[index];
                      final caregiver = item['caregiver'] as CaregiverModel;
                      final user = item['user'] as UserModel;
                      
                      return _buildCaregiverCard(caregiver, user);
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

  Widget _buildCaregiverCard(CaregiverModel caregiver, UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaregiverDetailScreen(
                caregiverId: caregiver.caregiverId,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                backgroundImage: user.profilePhoto != null
                    ? NetworkImage(user.profilePhoto!)
                    : null,
                child: user.profilePhoto == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (caregiver.verificationStatus == 'verified')
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          caregiver.stats.averageRating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${caregiver.stats.totalReviews} reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Experience & Rate
                    Row(
                      children: [
                        Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${caregiver.experienceYears} years',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                        Text(
                          '${caregiver.hourlyRate.toStringAsFixed(0)}/hr',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Services
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: caregiver.servicesOffered.take(3).map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
