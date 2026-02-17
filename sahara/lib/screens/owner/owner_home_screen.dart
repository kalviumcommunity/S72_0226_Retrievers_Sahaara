import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';
import '../common/user_profile_view.dart';
import '../common/settings_screen.dart';
import 'pet_list_screen.dart';
import 'pet_profile_form.dart';

/// Owner home screen with dashboard and navigation
class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      
      await Future.wait([
        userProvider.loadUserProfile(user.uid),
        petProvider.loadOwnerPets(user.uid),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sahara Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
              const SizedBox(height: 24),
              _buildMyPetsSection(),
              const SizedBox(height: 24),
              _buildUpcomingBookingsSection(),
              const SizedBox(height: 24),
              _buildHelpSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PetProfileForm(),
            ),
          ).then((_) => _loadData());
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;
          
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                accountName: Text(
                  user?.name ?? 'Pet Owner',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: user?.profilePhoto != null
                      ? NetworkImage(user!.profilePhoto!)
                      : null,
                  child: user?.profilePhoto == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.pets),
                title: const Text('My Pets'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PetListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Bookings'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to bookings
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Find Caregivers'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to caregiver search
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('Messages'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to messages
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileView(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to help
                },
              ),
            ],
          );
        },
      ),
    );
  }
begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: AppTheme.white.withValues(alpha: 0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      firstName,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your pets are waiting for you! 🐾',
                      style: TextStyle(
                        color: AppTheme.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 48,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            QuickActionButton(
              icon: Icons.search,
              label: 'Find\nCaregiver',
              color: AppTheme.infoColor,
              onTap: () {
                // TODO: Navigate to caregiver search
              },
            ),
            QuickActionButton(
              icon: Icons.calendar_today,
              label: 'Book\nService',
              color: AppTheme.successColor,
              onTap: () {
                // TODO: Navigate to booking
              },
            ),
            QuickActionButton(
              icon: Icons.pets,
              label: 'My\nPets',
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PetListScreen(),
                  ),
                );
              },
            ),
            QuickActionButton(
              icon: Icons.chat_bubble,
              label: 'Messages',
              color: AppTheme.accentColor,
              onTap: () {
                // TODO: Navigate to messages
              },
            ),
          ],
        ),
      ]           // TODO: Navigate to caregiver search
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_today,
                label: 'Book Service',
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate to booking
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.pets,
                label: 'My Pets',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PetListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.chat_bubble,
                label: 'Messages',
                color: Colors.purple,
                onTap: () {
                  // TODO: Navigate to messages
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Bord  color: AppTheme.black,
                      ),
                ),
                if (pets.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PetListScreen(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (pets.isEmpty)
              DashboardEmptyState(
                icon: Icons.pets,
                title: 'No pets yet',
                subtitle: 'Add your first pet to get started',
                buttonText: 'Add Pet',
                onButtonTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PetProfileForm(),
                    ),
                  ).then((_) => _loadData());
                },
              )
            else
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length > 5 ? 5 : pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return DashboardPetCard(
                      pet: pet,
                      onTap: () {
                        // TODO: Navigate to pet detail
                      }lDirection: Axis.horizontal,
                  itemCount: pets.length > 5 ? 5 : pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: pet.photo != null
                                ? NetworkImage(pet.photo!)
                                : null,
                            child: pet.photo == null
                                ? Icon(Icons.pets, size: 32, color: Colors.grey[400])
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            pet.breed,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Bookings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No upcoming bookings',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to find caregivers
                  },
                  child: const Text('Find a Caregiver'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Bookings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        DashboardEmptyState(
          icon: Icons.calendar_today_outlined,
          title: 'No bookings yet',
          subtitle: 'Book a caregiver for your pets',
          buttonText: 'Find Caregiver',
          onButtonTap: () {
            // TODO: Navigate to find caregivers
          },
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Help & Tips',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        InfoBanner(
          icon: Icons.lightbulb,
          title: 'Tip of the Day',
          message: 'Keep your pet\'s profile updated for better caregiver matches',
          backgroundColor: AppTheme.warningColor,
          textColor: AppTheme.warningColor