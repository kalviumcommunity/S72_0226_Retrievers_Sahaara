import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Reusable Google Sign-In Button Widget
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullWidth;
  final String text;
  final ButtonVariant variant;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.text = 'Continue with Google',
    this.variant = ButtonVariant.outlined,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContent = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGoogleIcon(),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTheme.labelMedium.copyWith(
                    color: variant == ButtonVariant.filled
                        ? AppTheme.white
                        : AppTheme.gray900,
                  ),
                ),
              ),
            ],
          );

    final baseButton = variant == ButtonVariant.filled
        ? ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.white,
              foregroundColor: AppTheme.gray900,
              elevation: 0,
              side: const BorderSide(color: AppTheme.borderColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusLarge,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingLarge,
                vertical: AppTheme.paddingSmall,
              ),
            ),
            child: buttonContent,
          )
        : OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.gray900,
              side: const BorderSide(color: AppTheme.borderColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusLarge,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingLarge,
                vertical: AppTheme.paddingSmall,
              ),
            ),
            child: buttonContent,
          );

    return fullWidth
        ? SizedBox(
            width: double.infinity,
            height: 56,
            child: baseButton,
          )
        : baseButton;
  }

  /// Build Google icon with fallback
  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.asset(
          'assets/icons/google.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback: Display a colored circle with 'G'
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Google Sign-In button variants
enum ButtonVariant {
  /// White background with border (default)
  outlined,

  /// Colored background with Google branding
  filled,
}

/// Compact Google Sign-In Button (icon only)
class GoogleSignInIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final double size;

  const GoogleSignInIconButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(color: AppTheme.borderColor, width: 1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: Image.asset(
                    'assets/icons/google.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
