import 'package:flutter/material.dart';
import '../services/notifications_manager.dart';

/// Notifications Provider - Manages notification state and operations
class NotificationsProvider with ChangeNotifier {
  final NotificationsManager _notificationsManager = NotificationsManager();

  bool _isInitialized = false;
  bool _notificationsEnabled = true;
  List<Map<String, dynamic>> _notificationHistory = [];

  bool get isInitialized => _isInitialized;
  bool get notificationsEnabled => _notificationsEnabled;
  List<Map<String, dynamic>> get notificationHistory => _notificationHistory;

  /// Initialize notifications
  Future<void> initialize(
    BuildContext context,
    void Function(String?) onNotificationTap,
  ) async {
    try {
      await _notificationsManager.initialize(context, onNotificationTap);
      _isInitialized = true;
      notifyListeners();
      print('Notifications initialized');
    } catch (e) {
      print('Error initializing notifications: $e');
      rethrow;
    }
  }

  /// Toggle notifications
  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    if (!enabled) {
      // Cancel all notifications when disabled
      // This would call _notificationsManager.cancelAllNotifications()
    }
    notifyListeners();
  }

  /// Show simple notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notificationsManager.showNotification(
      title: title,
      body: body,
      payload: payload,
    );

    _addToHistory(
      type: 'simple',
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  /// Show booking notification
  Future<void> showBookingNotification({
    required String title,
    required String petName,
    required String ownerName,
    required String service,
    String? payload,
  }) async {
    await _notificationsManager.showBookingNotification(
      title: title,
      petName: petName,
      ownerName: ownerName,
      service: service,
      payload: payload,
    );

    _addToHistory(
      type: 'booking',
      title: title,
      details: '$petName • $ownerName • $service',
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  /// Show message notification
  Future<void> showMessageNotification({
    required String senderName,
    required String message,
    String? payload,
  }) async {
    await _notificationsManager.showMessageNotification(
      senderName: senderName,
      message: message,
      payload: payload,
    );

    _addToHistory(
      type: 'message',
      title: 'Message from $senderName',
      body: message,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  /// Show review notification
  Future<void> showReviewNotification({
    required String reviewerName,
    required double rating,
    String? payload,
  }) async {
    await _notificationsManager.showReviewNotification(
      reviewerName: reviewerName,
      rating: rating,
      payload: payload,
    );

    _addToHistory(
      type: 'review',
      title: 'New Review',
      details: '$reviewerName • $rating stars',
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  /// Show earnings notification
  Future<void> showEarningsNotification({
    required String amount,
    required String reason,
    String? payload,
  }) async {
    await _notificationsManager.showEarningsNotification(
      amount: amount,
      reason: reason,
      payload: payload,
    );

    _addToHistory(
      type: 'earnings',
      title: 'Earnings Update',
      details: '₹$amount • $reason',
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) async {
    await _notificationsManager.subscribeToTopic(topic);
  }

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationsManager.unsubscribeFromTopic(topic);
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    return await _notificationsManager.getFCMToken();
  }

  /// Clear notification history
  void clearHistory() {
    _notificationHistory.clear();
    notifyListeners();
  }

  /// Add to notification history
  void _addToHistory({
    required String type,
    required String title,
    String? body,
    String? details,
    required DateTime timestamp,
  }) {
    _notificationHistory.insert(0, {
      'type': type,
      'title': title,
      'body': body,
      'details': details,
      'timestamp': timestamp,
      'read': false,
    });

    // Keep only last 50 notifications
    if (_notificationHistory.length > 50) {
      _notificationHistory = _notificationHistory.take(50).toList();
    }
  }

  /// Mark notification as read
  void markAsRead(int index) {
    if (index >= 0 && index < _notificationHistory.length) {
      _notificationHistory[index]['read'] = true;
      notifyListeners();
    }
  }

  /// Get unread notification count
  int getUnreadCount() {
    return _notificationHistory.where((n) => !n['read']).length;
  }
}
