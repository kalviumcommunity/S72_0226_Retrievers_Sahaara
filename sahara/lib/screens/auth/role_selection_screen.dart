import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../../utils/constants.dart';

/// Screen for selecting user role (Owner or Caregiver)
class RoleSelectionScreen extends StatefulWidget {
  final bool isLogin;

  const RoleSelectionScreen({
    super.key,
    this.isLogin = false,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLogin ? 'Sign In' : 'Get Started'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Title
              Text(
                'I am a...',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Select your role to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Pet Owner Card
              _buildRoleCard(
                role: AppConstants.roleOwner,
                title: 'Pet Owner',
                description: 'Find trusted caregivers for your pets',
                icon: Icons.home,
                color: Colors.blue,
              ),
              
              const SizedBox(height: 20),
              
              // Caregiver Card
              _buildRoleCard(
                role: AppConstants.roleCaregiver,
                title: 'Pet Caregiver',
                description: 'Offer your pet care services',
                icon: Icons.pets,
                color: Colors.green,
              ),
              
              const Spacer(),
              
              // Continue Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedRole == null ? null : _handleContinue,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Check Icon
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedRole == null) return;

    if (widget.isLogin) {
      // Navigate to Login Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(role: _selectedRole!),
        ),
      );
    } else {
      // Navigate to Signup Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(role: _selectedRole!),
        ),
      );
    }
  }
}
