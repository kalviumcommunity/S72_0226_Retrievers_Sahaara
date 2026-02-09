import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../owner/owner_home_screen.dart';
import '../caregiver/caregiver_home_screen.dart';
import '../auth/welcome_screen.dart';

/// Routes user to appropriate home screen based on role
class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  State<HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      // Not logged in, go to welcome screen
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    // Load user profile to get role
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserProfile(user.uid);

    if (mounted) {
      setState(() {
        _userRole = userProvider.currentUser?.role;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const WelcomeScreen();
    }

    // Route based on role
    if (_userRole == AppConstants.roleOwner) {
      return const OwnerHomeScreen();
    } else if (_userRole == AppConstants.roleCaregiver) {
      return const CaregiverHomeScreen();
    } else {
      // Default to welcome if role is unknown
      return const WelcomeScreen();
    }
  }
}
