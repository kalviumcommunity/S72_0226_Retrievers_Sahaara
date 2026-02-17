import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../services/notification_service.dart';

/// Notification permissions and settings screen for testing
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String? _fcmToken;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    if (!mounted) return;

    try {
      final token = await NotificationService().getDeviceToken();
      if (mounted) {
        setState(() {
          _fcmToken = token;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Status Card
            _buildStatusCard(),
            const SizedBox(height: 24),

            // FCM Token Card
            if (_fcmToken != null) _buildTokenCard(),
            const SizedBox(height: 24),

            // Notification Settings
            _buildSettingsSection(),
            const SizedBox(height: 24),

            // Topic Subscriptions
            _buildTopicsSection(),
            const SizedBox(height: 24),

            // Test Notifications
            _buildTestSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: AppTheme.successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications Enabled',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),
                Text(
                  _isLoading
                      ? 'Initializing...'
                      : 'You will receive push notifications',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.check_circle, color: AppTheme.successColor),
        ],
      ),
    );
  }

  Widget _buildTokenCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.key,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Device Token (FCM)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _fcmToken!.substring(0, 50) + '...',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: AppTheme.gray600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.content_copy, size: 16),
                label: const Text('Copy'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'All Notifications',
          subtitle: 'Receive all notification types',
          value: _notificationsEnabled,
          onChanged: (val) {
            setState(() => _notificationsEnabled = val);
          },
        ),
        _buildSettingItem(
          icon: Icons.volume_up,
          title: 'Sound',
          subtitle: 'Play sound for notifications',
          value: _soundEnabled,
          onChanged: (val) {
            setState(() => _soundEnabled = val);
          },
        ),
        _buildSettingItem(
          icon: Icons.vibration,
          title: 'Vibration',
          subtitle: 'Vibrate on new notification',
          value: _vibrationEnabled,
          onChanged: (val) {
            setState(() => _vibrationEnabled = val);
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic Subscriptions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            spacing: 8,
            children: [
              _buildTopicItem(
                topic: 'role_owner',
                description: 'Owner-specific notifications',
                icon: Icons.person,
                color: AppTheme.primaryColor,
              ),
              _buildTopicItem(
                topic: 'pet_owners',
                description: 'Booking requests & updates',
                icon: Icons.notifications_active,
                color: AppTheme.successColor,
              ),
              _buildTopicItem(
                topic: 'new_caregivers',
                description: 'New caregivers in your area',
                icon: Icons.people,
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicItem({
    required String topic,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.gray500,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.check_circle, size: 16, color: AppTheme.successColor),
      ],
    );
  }

  Widget _buildTestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Test Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Send Test Notification'),
            onPressed: () async {
              await NotificationService().sendTestNotification();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test notification sent'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.warningColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: AppTheme.warningColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Keep the app open to see test notification appear in the system tray',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.warningColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
