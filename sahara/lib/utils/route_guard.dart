import 'package:flutter/material.dart';

/// Route guard for protected routes
class RouteGuard {
  static Future<bool> canNavigate(
    BuildContext context,
    bool isAuthenticated,
  ) async {
    if (!isAuthenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/role-selection',
        (route) => false,
      );
      return false;
    }
    return true;
  }

  /// Check if user has required role
  static Future<bool> canNavigateWithRole(
    BuildContext context,
    bool isAuthenticated,
    String requiredRole,
    String userRole,
  ) async {
    if (!isAuthenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/role-selection',
        (route) => false,
      );
      return false;
    }

    if (userRole != requiredRole) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access denied')),
      );
      return false;
    }

    return true;
  }
}
