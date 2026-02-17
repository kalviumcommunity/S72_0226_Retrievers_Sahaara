import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/common/home_router.dart';

/// Authentication Wrapper - Routes user based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Not authenticated - show login/signup
        if (!authProvider.isAuthenticated) {
          return const RoleSelectionScreen();
        }

        // Authenticated - show home
        return const HomeRouter();
      },
    );
  }
}
