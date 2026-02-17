import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/caregiver_provider.dart';
import '../../models/caregiver_model.dart';
import '../../models/user_model.dart';
import '../../widgets/loading_skeleton.dart';

/// Screen for viewing detailed caregiver profile
class CaregiverDetailScreen extends StatefulWidget {
  final String caregiverId;

  const CaregiverDetailScreen({
    super.key,
    required this.caregiverId,
  });

  @override
  State<CaregiverDetailScreen> createState() => _CaregiverDetailScreenState();
}

class _CaregiverDetailScreenState extends State<CaregiverDetailScreen> {
  Map<String, dynamic>? _caregiverData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaregiverDetails();
  }

  Future<void> _loadCaregiverDetails() async {
    final provider = Provider.of<CaregiverProvider>(context, listen: false);
    final data = await provider.getCaregiverDetails(widget.caregiverId);
    
    setState(() {
      _caregiverData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_caregiverData == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Caregiver not found'),
        ),
      );
    }

    final caregiver = _caregiverData!['caregiver'] as CaregiverModel;
    final user = _caregiverData!['user'] as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(caregiver, user),
            
            // Stats
            _buildStats(caregiver),
            
            const Divider(height: 32),
            
            // About
            _buildSection(
              'About',
              Text(caregiver.bio),
            ),
            
            const Divider(height: 32),
            
            // Services
            _buildSection(
              'Services Offered',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: caregiver.servicesOffered.map((service) {
                  return Chip(
                    label: Text(service),
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
            ),
            
            const Divider(height: 32),
            
            // Pet Types
            _buildSection(
              'Pet Types Handled',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: caregiver.petTypesHandled.map((type) {
                  return Chip(
                    label: Text(type),
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
            ),
            
            const Divider(height: 32),
            
            // Reviews Section
            _buildSection(
              'Reviews',
              Column(
                children: [
                  const Text('No reviews yet'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // TODO: View all reviews
                    },
                    child: const Text('View All Reviews'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(caregiver),
    );
  }

  Widget _buildHeader(CaregiverModel caregiver, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Profile Photo
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: user.profilePhoto != null
                    ? NetworkImage(user.profilePhoto!)
                    : null,
                child: user.profilePhoto == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              if (caregiver.verificationStatus == 'verified')
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Location
          if (user.location != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    user.location!.address,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Text(
                caregiver.stats.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' (${caregiver.stats.totalReviews} reviews)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(CaregiverModel caregiver) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.work_outline,
            label: 'Experience',
            value: '${caregiver.experienceYears} years',
          ),
          _buildStatItem(
            icon: Icons.currency_rupee,
            label: 'Hourly Rate',
            value: '₹${caregiver.hourlyRate.toStringAsFixed(0)}',
          ),
          _buildStatItem(
            icon: Icons.check_circle_outline,
            label: 'Completed',
            value: '${caregiver.stats.completedBookings}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildBottomBar(CaregiverModel caregiver) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Message caregiver
              },
              icon: const Icon(Icons.message),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Book caregiver
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
