import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notifications_service.dart';

/// Notifications Manager - Coordinates FCM and local notifications
class NotificationsManager {
  static final NotificationsManager _instance = NotificationsManager._internal();

  factory NotificationsManager() {
    return _instance;
  }

  NotificationsManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationsService _localNotificationsService =
      LocalNotificationsService();

  late BuildContext _context;

  /// Initialize notifications manager
  Future<void> initialize(
    BuildContext context,
    void Function(String?) onNotificationTap,
  ) async {
    _context = context;

    // Initialize local notifications
    await _localNotificationsService.initialize(onNotificationTap);

    // Request notification permissions
    await _requestPermissions();

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Setup FCM notification handling
    await _localNotificationsService.setupFCMNotificationHandler();

    // Handle notification when app is opened from terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data['payload']);
    }

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data['payload']);
    });
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carefullyProvisionalAlert: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User declined or has not yet granted notification permissions.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      print('Notification permission not determined.');
    } else {
      print('Notification permissions granted.');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // Parse payload and navigate to appropriate screen
      // Example: payload could be '/earnings-summary' or 'booking:123'
      // This would be handled by your router
      print('Notification tapped with payload: $payload');
    }
  }

  /// Show simple notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotificationsService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Show booking notification
  Future<void> showBookingNotification({
    required String title,
    required String petName,
    required String ownerName,
    required String service,
    String? payload,
  }) async {
    await _localNotificationsService.showBookingNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      petName: petName,
      ownerName: ownerName,
      service: service,
      payload: payload,
    );
  }

  /// Show message notification
  Future<void> showMessageNotification({
    required String senderName,
    required String message,
    String? payload,
  }) async {
    await _localNotificationsService.showMessageNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      senderName: senderName,
      message: message,
      payload: payload,
    );
  }

  /// Show review notification
  Future<void> showReviewNotification({
    required String reviewerName,
    required double rating,
    String? payload,
  }) async {
    await _localNotificationsService.showReviewNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      reviewerName: reviewerName,
      rating: rating,
      payload: payload,
    );
  }

  /// Show earnings notification
  Future<void> showEarningsNotification({
    required String amount,
    required String reason,
    String? payload,
  }) async {
    await _localNotificationsService.showEarningsNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      amount: amount,
      reason: reason,
      payload: payload,
    );
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}
