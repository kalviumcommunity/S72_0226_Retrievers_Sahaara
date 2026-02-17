import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart';

/// FCM Token Manager - Manages FCM token storage and subscriptions
class FCMTokenManager {
  static final FCMTokenManager _instance = FCMTokenManager._internal();

  factory FCMTokenManager() {
    return _instance;
  }

  FCMTokenManager._internal();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Save FCM token to Firestore for current user
  Future<bool> saveFCMToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ No user logged in');
        return false;
      }

      final token = await NotificationService().getDeviceToken();
      if (token == null) {
        debugPrint('❌ Failed to get FCM token');
        return false;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        'deviceLocale': WidgetsBinding.instance.window.locale.toString(),
      });

      debugPrint('✅ FCM token saved for user: ${user.uid}');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving FCM token: $e');
      return false;
    }
  }

  /// Get FCM tokens for a specific user
  Future<List<String>> getUserFCMTokens(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final tokens = <String>[];

      if (doc.exists && doc['fcmToken'] != null) {
        tokens.add(doc['fcmToken']);
      }

      return tokens;
    } catch (e) {
      debugPrint('❌ Error getting user FCM tokens: $e');
      return [];
    }
  }

  /// Subscribe to role-based notification topics
  Future<void> subscribeToRoleTopics(String role) async {
    try {
      await NotificationService().subscribeToRoleTopics(role);

      // Also subscribe to general topics based on role
      switch (role) {
        case 'owner':
          await NotificationService().subscribeTopic('booking_updates');
          await NotificationService().subscribeTopic('owner_messages');
          break;
        case 'caregiver':
          await NotificationService().subscribeTopic('new_jobs');
          await NotificationService().subscribeTopic('caregiver_messages');
          break;
      }

      debugPrint('✅ Subscribed to topics for role: $role');
    } catch (e) {
      debugPrint('❌ Error subscribing to role topics: $e');
    }
  }

  /// Save notification preferences to Firestore
  Future<bool> saveNotificationPreferences({
    bool enabled = true,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    List<String>? preferredTopics,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update({
        'notificationPreferences': {
          'enabled': enabled,
          'soundEnabled': soundEnabled,
          'vibrationEnabled': vibrationEnabled,
          'preferredTopics': preferredTopics ?? [],
          'updatedAt': FieldValue.serverTimestamp(),
        },
      });

      debugPrint('✅ Notification preferences saved');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving preferences: $e');
      return false;
    }
  }

  /// Get notification preferences for current user
  Future<Map<String, dynamic>?> getNotificationPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return doc['notificationPreferences'] as Map<String, dynamic>?;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error getting preferences: $e');
      return null;
    }
  }

  /// Handle token refresh
  Future<void> handleTokenRefresh() async {
    debugPrint('🔄 Refreshing FCM token...');
    await saveFCMToken();
  }

  /// Delete FCM token on logout
  Future<bool> deleteFCMToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return true;

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
      });

      debugPrint('✅ FCM token deleted for user: ${user.uid}');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting FCM token: $e');
      return false;
    }
  }

  /// Send test notification to a specific user
  /// Note: This is for backend integration, typically called from Cloud Functions
  Future<void> sendTestNotificationToUser(String userId) async {
    try {
      // This would typically be called from a Cloud Function
      // For testing, you can use Firebase Console → Messaging
      debugPrint('📧 Test notification triggered for user: $userId');
    } catch (e) {
      debugPrint('❌ Error sending test notification: $e');
    }
  }
}
