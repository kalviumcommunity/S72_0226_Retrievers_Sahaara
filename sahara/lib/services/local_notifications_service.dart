import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

typedef SelectNotificationCallback = void Function(String? payload);

/// Local Notifications Service - Handles all local notification operations
class LocalNotificationsService {
  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();

  factory LocalNotificationsService() {
    return _instance;
  }

  LocalNotificationsService._internal();

  static const String channelId = 'sahara_notifications';
  static const String channelName = 'Sahara Notifications';
  static const String channelDescription =
      'Notifications from Sahara Pet Care App';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late SelectNotificationCallback _selectNotificationCallback;

  /// Initialize local notifications
  Future<void> initialize(
    SelectNotificationCallback selectNotificationCallback,
  ) async {
    _selectNotificationCallback = selectNotificationCallback;

    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_notification');

    // iOS initialization settings
    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Initialize plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create Android notification channel
    await _createAndroidNotificationChannel();

    // Request iOS permissions
    await _requestIOSPermissions();
  }

  /// Handle notification taps on iOS
  Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    _selectNotificationCallback(payload);
  }

  /// Handle notification response (tap)
  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    _selectNotificationCallback(notificationResponse.payload);
  }

  /// Create Android notification channel
  Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request iOS permissions
  Future<void> _requestIOSPermissions() async {
    final platform = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (platform != null) {
      final granted = await platform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (granted ?? false) {
        print('iOS notification permissions granted');
      }
    }
  }

  /// Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show a notification with big text (Android only)
  Future<void> showBigTextNotification({
    required int id,
    required String title,
    required String body,
    required String bigBody,
    String? payload,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        bigBody,
        contentTitle: title,
        htmlFormatBigText: true,
        htmlFormatContent: true,
      ),
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show a notification with progress (Android only)
  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
    String? payload,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      onlyAlertOnce: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show a booking notification
  Future<void> showBookingNotification({
    required int id,
    required String title,
    required String petName,
    required String ownerName,
    required String service,
    String? payload,
  }) async {
    final body = '$petName • $service';
    final bigBody = 'Pet Owner: $ownerName\nService: $service\nPet: $petName';

    await showBigTextNotification(
      id: id,
      title: title,
      body: body,
      bigBody: bigBody,
      payload: payload,
    );
  }

  /// Show a message notification
  Future<void> showMessageNotification({
    required int id,
    required String senderName,
    required String message,
    String? payload,
  }) async {
    await showNotification(
      id: id,
      title: 'Message from $senderName',
      body: message,
      payload: payload,
    );
  }

  /// Show a review notification
  Future<void> showReviewNotification({
    required int id,
    required String reviewerName,
    required double rating,
    String? payload,
  }) async {
    final stars = '⭐' * rating.toInt();
    final body = '$reviewerName rated ${rating.toStringAsFixed(1)} $stars';

    await showNotification(
      id: id,
      title: 'New Review',
      body: body,
      payload: payload,
    );
  }

  /// Show earnings notification
  Future<void> showEarningsNotification({
    required int id,
    required String amount,
    required String reason,
    String? payload,
  }) async {
    await showNotification(
      id: id,
      title: 'Earnings Update',
      body: 'You earned ₹$amount • $reason',
      payload: payload,
    );
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Handle FCM message and show local notification
  Future<void> handleFCMMessage(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      final title = notification.title ?? 'Sahara';
      final body = notification.body ?? '';

      // Determine notification type from data
      final type = data['type'] ?? 'default';

      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      switch (type) {
        case 'booking':
          await showBookingNotification(
            id: notificationId,
            title: title,
            petName: data['petName'] ?? 'Pet',
            ownerName: data['ownerName'] ?? 'Owner',
            service: data['service'] ?? 'Service',
            payload: data['payload'],
          );
          break;

        case 'message':
          await showMessageNotification(
            id: notificationId,
            senderName: data['senderName'] ?? 'Someone',
            message: body,
            payload: data['payload'],
          );
          break;

        case 'review':
          final rating = double.tryParse(data['rating'] ?? '0') ?? 0;
          await showReviewNotification(
            id: notificationId,
            reviewerName: data['reviewerName'] ?? 'User',
            rating: rating,
            payload: data['payload'],
          );
          break;

        case 'earnings':
          await showEarningsNotification(
            id: notificationId,
            amount: data['amount'] ?? '0',
            reason: data['reason'] ?? 'Booking completed',
            payload: data['payload'],
          );
          break;

        default:
          await showNotification(
            id: notificationId,
            title: title,
            body: body,
            payload: data['payload'],
          );
      }
    }
  }

  /// Setup FCM notification handler
  Future<void> setupFCMNotificationHandler() async {
    // Handle notifications when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Handling a foreground message: ${message.messageId}');
      handleFCMMessage(message);
    });

    // Handle notifications when app is in background but still running
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  /// Background message handler (top-level function)
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Background message handling is done by Firebase automatically
  }
}

/// Top-level function for background message handling (required by FCM)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}
