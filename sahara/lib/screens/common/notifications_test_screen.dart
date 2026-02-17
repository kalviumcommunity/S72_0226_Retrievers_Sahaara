import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/notifications_provider.dart';
import '../../services/notification_service.dart';

/// Notifications Test Screen - Test and manage local notifications
class NotificationsTestScreen extends StatefulWidget {
  const NotificationsTestScreen({super.key});

  @override
  State<NotificationsTestScreen> createState() =>
      _NotificationsTestScreenState();
}

class _NotificationsTestScreenState extends State<NotificationsTestScreen> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
  }

  void _showSimpleNotification() {
    _notificationService.sendTestNotification();
  }

  void _showBookingNotification() {
    _notificationService.showBookingNotification(
      petName: 'Golden Retriever',
      ownerName: 'Sarah Johnson',
      service: 'Dog Walking',
    );
  }

  void _showMessageNotification() {
    _notificationService.showMessageNotification(
      senderName: 'John Doe',
      message: 'Hi! Are you available for pet sitting this weekend?',
    );
  }

  void _showReviewNotification() {
    _notificationService.showReviewNotification(
      reviewerName: 'Emma Wilson',
      rating: 5.0,
    );
  }

  void _showEarningsNotification() {
    _notificationService.showEarningsNotification(
      amount: '500',
      reason: 'Dog walking completed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications Test'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Local Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap below to trigger different notification types:',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray500,
              ),
            ),
            const SizedBox(height: 24),

            // Simple Notification
            _buildNotificationButton(
              title: 'Test Notification',
              description: 'A simple test notification',
              icon: Icons.notifications,
              onPressed: _showSimpleNotification,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 12),

            // Booking Notification
            _buildNotificationButton(
              title: 'Booking Request',
              description: 'New pet care booking request',
              icon: Icons.pets,
              onPressed: _showBookingNotification,
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 12),

            // Message Notification
            _buildNotificationButton(
              title: 'Message',
              description: 'New message from pet owner',
              icon: Icons.message,
              onPressed: _showMessageNotification,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(height: 12),

            // Review Notification
            _buildNotificationButton(
              title: 'Review',
              description: 'New review from pet owner',
              icon: Icons.star,
              onPressed: _showReviewNotification,
              color: AppTheme.warningColor,
            ),
            const SizedBox(height: 12),

            // Earnings Notification
            _buildNotificationButton(
              title: 'Earnings',
              description: 'New earnings update',
              icon: Icons.attach_money,
              onPressed: _showEarningsNotification,
              color: Colors.green,
            ),
            const SizedBox(height: 24),

            // Notification Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.blue100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
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
                        'How it works',
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
                    '• Notifications will appear in your device\'s notification center\n'
                    '• Android: Check notification panel\n'
                    '• iOS: Check notification center or banner\n'
                    '• Tap the notification to see if it triggers navigation\n'
                    '• Notifications from Firebase will show up here too',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notification History
            Consumer<NotificationsProvider>(
              builder: (context, notificationsProvider, child) {
                final history = notificationsProvider.notificationHistory;
                final unreadCount = notificationsProvider.getUnreadCount();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification History',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.black,
                              ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$unreadCount new',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (history.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.gray100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 48,
                                color: AppTheme.gray400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: history.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final notification = history[index];
                          return _buildNotificationHistoryItem(
                            notification: notification,
                            index: index,
                            onMarkRead: () {
                              notificationsProvider.markAsRead(index);
                            },
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationHistoryItem({
    required Map<String, dynamic> notification,
    required int index,
    required VoidCallback onMarkRead,
  }) {
    final isRead = notification['read'] ?? false;
    final type = notification['type'] ?? 'unknown';
    final title = notification['title'] ?? 'Notification';
    final timestamp = notification['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);

    Color typeColor = AppTheme.primaryColor;
    IconData typeIcon = Icons.notifications;

    switch (type) {
      case 'booking':
        typeColor = AppTheme.successColor;
        typeIcon = Icons.pets;
        break;
      case 'message':
        typeColor = AppTheme.secondaryColor;
        typeIcon = Icons.message;
        break;
      case 'review':
        typeColor = AppTheme.warningColor;
        typeIcon = Icons.star;
        break;
      case 'earnings':
        typeColor = Colors.green;
        typeIcon = Icons.attach_money;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.white : AppTheme.blue50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRead ? AppTheme.borderColor : typeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(typeIcon, color: typeColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            GestureDetector(
              onTap: onMarkRead,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.check, color: typeColor, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
