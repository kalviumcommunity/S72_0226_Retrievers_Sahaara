import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';

/// Owner Profile Screen
class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool _isLoading = false;

  Future<void> _refreshProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.currentUser;
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (user != null && mounted) {
        await userProvider.loadUserProfile(user.userId);
      }
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile refreshed')),
        );
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
        title: const Text('My Profile'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        backgroundColor: AppTheme.white,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.currentUser;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                        backgroundImage: user?.profilePhoto != null
                            ? NetworkImage(user!.profilePhoto!)
                            : null,
                        child: user?.profilePhoto == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Pet Owner',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppTheme.successColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Verified Owner',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        icon: Icons.pets,
                        title: 'Pets',
                        value: '0',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        icon: Icons.star,
                        title: 'Rating',
                        value: '4.8',
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Info sections
                InfoBanner(
                  icon: Icons.phone,
                  title: 'Phone: ${user?.phone ?? 'Not provided'}',
                  message: 'Verified${user?.phoneVerified == true ? ' ✓' : ''}',
                  backgroundColor: AppTheme.infoColor,
                  textColor: AppTheme.infoColor,
                ),
                const SizedBox(height: 12),
                InfoBanner(
                  icon: Icons.location_on,
                  title: 'Location',
                  message: user?.location?.address ?? 'Not provided',
                  backgroundColor: AppTheme.secondaryColor,
                  textColor: AppTheme.secondaryColor,
                ),
                const SizedBox(height: 20),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Edit profile
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: View security settings
                    },
                    icon: const Icon(Icons.security),
                    label: const Text('Security Settings'),
                  ),
                  ),
                ),
              ],
            );
            },
          ),
        ),
      ),
    );
  }
}
