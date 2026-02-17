import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/notifications_provider.dart';
import '../../services/notification_service.dart';

/// Notifications Settings Screen - Manage notification preferences and settings
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  late NotificationService _notificationService;

  bool _allNotifications = true;
  bool _bookingNotifications = true;
  bool _messageNotifications = true;
  bool _reviewNotifications = true;
  bool _earningsNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _badgeEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
  }

  void _toggleAllNotifications(bool value) {
    setState(() {
      _allNotifications = value;
      if (!value) {
        _bookingNotifications = false;
        _messageNotifications = false;
        _reviewNotifications = false;
        _earningsNotifications = false;
      } else {
        _bookingNotifications = true;
        _messageNotifications = true;
        _reviewNotifications = true;
        _earningsNotifications = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: Consumer<NotificationsProvider>(
        builder: (context, notificationsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notifications Status
                _buildStatusCard(notificationsProvider),
                const SizedBox(height: 24),

                // Main Setting
                Text(
                  'Notification Types',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                ),
                const SizedBox(height: 12),

                // All Notifications
                _buildSwitchTile(
                  title: 'All Notifications',
                  subtitle: 'Enable or disable all notifications',
                  value: _allNotifications,
                  onChanged: _toggleAllNotifications,
                  icon: Icons.notifications,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 12),

                if (_allNotifications) ...[
                  // Booking Notifications
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildSwitchTile(
                      title: 'Booking Requests',
                      subtitle: 'Get notified of new booking requests',
                      value: _bookingNotifications,
                      onChanged: (value) {
                        setState(() => _bookingNotifications = value);
                      },
                      icon: Icons.pets,
                      color: AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Message Notifications
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildSwitchTile(
                      title: 'Messages',
                      subtitle: 'Get notified of new messages',
                      value: _messageNotifications,
                      onChanged: (value) {
                        setState(() => _messageNotifications = value);
                      },
                      icon: Icons.message,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Review Notifications
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildSwitchTile(
                      title: 'Reviews & Ratings',
                      subtitle: 'Get notified of new reviews',
                      value: _reviewNotifications,
                      onChanged: (value) {
                        setState(() => _reviewNotifications = value);
                      },
                      icon: Icons.star,
                      color: AppTheme.warningColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Earnings Notifications
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildSwitchTile(
                      title: 'Earnings',
                      subtitle: 'Get notified of earnings updates',
                      value: _earningsNotifications,
                      onChanged: (value) {
                        setState(() => _earningsNotifications = value);
                      },
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Notification Sounds & Vibrations
                Text(
                  'Sound & Vibration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                ),
                const SizedBox(height: 12),

                _buildSwitchTile(
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() => _soundEnabled = value);
                  },
                  icon: Icons.volume_up,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 8),

                _buildSwitchTile(
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() => _vibrationEnabled = value);
                  },
                  icon: Icons.vibration,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(height: 8),

                _buildSwitchTile(
                  title: 'Badge',
                  subtitle: 'Show app badge count',
                  value: _badgeEnabled,
                  onChanged: (value) {
                    setState(() => _badgeEnabled = value);
                  },
                  icon: Icons.badge,
                  color: AppTheme.warningColor,
                ),
                const SizedBox(height: 24),

                // Test Section
                Text(
                  'Test Notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                ),
                const SizedBox(height: 12),

                Column(
                  spacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _notificationService.sendTestNotification(),
                      icon: const Icon(Icons.notifications),
                      label: const Expanded(child: Text('Test Notification')),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _notificationService.showBookingNotification(
                        petName: 'Test Pet',
                        ownerName: 'Test Owner',
                        service: 'Test Service',
                      ),
                      icon: const Icon(Icons.pets),
                      label: const Expanded(child: Text('Test Booking Notification')),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Information Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.gray50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Notification Permissions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sahara needs permission to send notifications. '
                        'To enable notifications:\n\n'
                        'iOS: Settings > Sahara > Notifications\n'
                        'Android: Settings > Apps > Sahara > Notification',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray700,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(NotificationsProvider notificationsProvider) {
    final unreadCount = notificationsProvider.getUnreadCount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notificationsProvider.isInitialized
                    ? 'Active'
                    : 'Initializing...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'unread',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
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
                const SizedBox(height: 2),
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
            activeColor: color,
          ),
        ],
      ),
    );
  }
}
