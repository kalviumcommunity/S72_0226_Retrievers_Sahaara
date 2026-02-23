import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/caregiver_provider.dart';
import '../../models/caregiver_model.dart';
import 'caregiver_detail_screen.dart';

/// Screen to view favorite caregivers
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<CaregiverModel> _favoriteCaregivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    final favoriteProvider = context.read<FavoriteProvider>();
    await favoriteProvider.loadFavorites(user.uid);

    // Load caregiver details
    final caregiverProvider = context.read<CaregiverProvider>();
    final favoriteIds = favoriteProvider.favoriteCaregiverIds;

    final caregivers = <CaregiverModel>[];
    for (var id in favoriteIds) {
      final caregiver = await caregiverProvider.getCaregiverById(id);
      if (caregiver != null) {
        caregivers.add(caregiver);
      }
    }

    setState(() {
      _favoriteCaregivers = caregivers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Caregivers'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteCaregivers.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favoriteCaregivers.length,
                    itemBuilder: (context, index) {
                      return _buildCaregiverCard(_favoriteCaregivers[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorite Caregivers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add caregivers to favorites for quick access',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard(CaregiverModel caregiver) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CaregiverDetailScreen(caregiverId: caregiver.userId),
            ),
          );

          // Refresh if caregiver was unfavorited
          if (result == true) {
            _loadFavorites();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 30,
                backgroundImage: caregiver.photoUrl != null
                    ? NetworkImage(caregiver.photoUrl!)
                    : null,
                child: caregiver.photoUrl == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),

              // Caregiver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            caregiver.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (caregiver.isVerified)
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${caregiver.averageRating.toStringAsFixed(1)} (${caregiver.totalReviews})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '₹${caregiver.hourlyRate}/hr',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${caregiver.experienceYears} years exp • ${caregiver.completedBookings} jobs',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite Button
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  final favoriteProvider = context.read<FavoriteProvider>();
                  final success = await favoriteProvider.removeFavorite(
                    user.uid,
                    caregiver.userId,
                  );

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed from favorites'),
                      ),
                    );
                    _loadFavorites();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
