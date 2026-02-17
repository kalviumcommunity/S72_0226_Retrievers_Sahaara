import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging Service for handling push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize Firebase Cloud Messaging and Local Notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission
      await _requestNotificationPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Set up Firebase messaging handlers
      _setupFirebaseMessaging();

      _isInitialized = true;
      debugPrint('✅ Notification Service Initialized');
    } catch (e) {
      debugPrint('❌ Error initializing Notification Service: $e');
    }
  }

  /// Request notification permissions
  Future<bool> _requestNotificationPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carefullyProvisioned: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permission granted');
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('⚠️  Provisional notification permission granted');
        return true;
      } else {
        debugPrint('❌ Notification permission denied');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    try {
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosInitSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      await _localNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      debugPrint('✅ Local Notifications Initialized');
    } catch (e) {
      debugPrint('❌ Error initializing local notifications: $e');
    }
  }

  /// Create notification channel for Android 8.0+
  Future<void> _createNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'sahara_notifications',
        'Sahara Notifications',
        description: 'Notifications for Sahara Pet Care App',
        importance: Importance.max,
        playSound: true,
        showBadge: true,
        enableVibration: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      debugPrint('✅ Notification Channel Created');
    } catch (e) {
      debugPrint('❌ Error creating notification channel: $e');
    }
  }

  /// Set up Firebase Messaging handlers
  void _setupFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📬 Foreground message received: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle message open from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('📬 App opened from notification: ${message.messageId}');
        _handleNotificationTap(message);
      }
    });

    // Handle message open from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 Message opened from background: ${message.messageId}');
      _handleNotificationTap(message);
    });
  }

  /// Get FCM device token
  Future<String?> getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('📱 FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Handle foreground messages - show local notification
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        await _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'sahara_notifications',
              'Sahara Notifications',
              channelDescription: 'Notifications for Sahara Pet Care App',
              smallIcon: '@mipmap/ic_launcher',
              priority: Priority.high,
              importance: Importance.max,
              playSound: true,
              enableVibration: true,
              showProgress: false,
              ticker: notification.title,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 1,
            ),
          ),
          payload: message.data.isEmpty
              ? null
              : (message.data..addAll(message.notification?.toMap() ?? {}))
                  .toString(),
        );
      }
    } catch (e) {
      debugPrint('❌ Error handling foreground message: $e');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('🎯 Notification tapped: ${message.messageId}');
    // TODO: Navigate to appropriate screen based on notification data
    // Example: if (message.data['type'] == 'booking') navigate to booking details
  }

  /// Handle local notification tap
  Future<void> _onNotificationTap(
      NotificationResponse notificationResponse) async {
    debugPrint('🎯 Local notification tapped');
    // TODO: Handle navigation based on notification type
  }

  /// Send test notification (for testing purposes)
  Future<void> sendTestNotification() async {
    try {
      await _localNotificationsPlugin.show(
        0,
        'Test Notification',
        'This is a test notification from Sahara',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'sahara_notifications',
            'Sahara Notifications',
            channelDescription: 'Notifications for Sahara Pet Care App',
            smallIcon: '@mipmap/ic_launcher',
            priority: Priority.high,
            importance: Importance.max,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            badgeNumber: 1,
          ),
        ),
      );
      debugPrint('✅ Test notification sent');
    } catch (e) {
      debugPrint('❌ Error sending test notification: $e');
    }
  }

  /// Subscribe to topic for targeted notifications
  Future<void> subscribeTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to user role topics
  Future<void> subscribeToRoleTopics(String role) async {
    try {
      // Subscribe to role-specific topic
      await subscribeTopic('role_$role');

      // Subscribe based on role
      switch (role) {
        case 'owner':
          await subscribeTopic('pet_owners');
          break;
        case 'caregiver':
          await subscribeTopic('caregivers');
          break;
      }

      debugPrint('✅ Subscribed to role topics for: $role');
    } catch (e) {
      debugPrint('❌ Error subscribing to role topics: $e');
    }
  }
}

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 Background message received: ${message.messageId}');
  // Display notification for background messages
  // This will be shown in the system tray
}
