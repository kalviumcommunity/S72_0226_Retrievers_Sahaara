import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class PhoneAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const PhoneAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: const Icon(Icons.phone),
        label: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Continue with Phone'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.borderRadiusLarge,
          ),
        ),
      ),
    );
  }
}
