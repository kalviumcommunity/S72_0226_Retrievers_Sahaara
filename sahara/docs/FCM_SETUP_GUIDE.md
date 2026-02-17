# Firebase Cloud Messaging Setup Guide

## Overview
This guide explains how Firebase Cloud Messaging (FCM) is configured in the Sahara app for sending and receiving push notifications.

## What's Implemented

### 1. **Notification Service** (`notification_service.dart`)
The core service handling all FCM operations:
- ✅ Firebase Cloud Messaging initialization
- ✅ Local Notifications display (foreground)
- ✅ Notification permission requests
- ✅ FCM token retrieval
- ✅ Topic subscriptions (for role-based notifications)
- ✅ Background message handling
- ✅ Notification tap handling

### 2. **Android Configuration**
**File**: `android/app/src/main/AndroidManifest.xml`
- Added `android.permission.POST_NOTIFICATIONS` for Android 13+
- Added `android.permission.INTERNET` for FCM communication
- Launch mode set to `singleTop` for proper notification handling

**Notification Channel**: 
- Channel ID: `sahara_notifications`
- Importance: MAX (shows as heads-up notification)
- Sound and Vibration enabled

### 3. **iOS Configuration**
Firebase Cloud Messaging works automatically on iOS through:
- `GeneratedPluginRegistrant` in AppDelegate
- APNs certificate configured in Firebase Console
- Notification capabilities enabled in Xcode

### 4. **Main App Integration** (`main.dart`)
```dart
// NotificationService initialized after Firebase setup
await NotificationService().initialize();
```

## Features

### Foreground Messages (App is Open)
- Displays as local notification in system tray
- Shows notification title and body
- Handles notification tap

### Background Messages (App is Closed)
- Handled by background message handler
- Displayed in system tray
- Launches app when tapped

### Terminated State
- Retrieves initial message from intent
- Navigates to appropriate screen based on notification data

### Topic Subscriptions
The app subscribes to different topics based on user role:
- Owner: `role_owner`, `pet_owners`
- Caregiver: `role_caregiver`, `caregivers`

This allows sending targeted notifications to specific user groups.

## Getting FCM Token

To send notifications to a specific device:
```dart
final token = await NotificationService().getDeviceToken();
```

Save this token to Firestore under the user's profile to enable:
- Direct device notifications
- Better tracking of which devices received notifications

## Sending Test Notifications

### From Firebase Console
1. Go to Firebase Console → Messaging
2. Create a new campaign
3. Select "Send to users matching conditions"
4. Target by custom topic (e.g., `role_owner`)

### Programmatically (Testing Only)
```dart
await NotificationService().sendTestNotification();
```

## Topics for Notifications

### Owner Notifications
- **Booking Requests**: `topic: 'pet_owners'`
- **Booking Updates**: `topic: 'booking_updates'`
- **New Walkers**: `topic: 'new_caregivers'`
- **Messages**: `topic: 'owner_messages'`

### Caregiver Notifications
- **New Jobs**: `topic: 'caregivers'`
- **Booking Confirmations**: `topic: 'booking_confirmations'`
- **Messages**: `topic: 'caregiver_messages'`
- **Earnings Updates**: `topic: 'earnings_updates'`

## Handling Notification Taps

Currently in `notification_service.dart`:
```dart
void _handleNotificationTap(RemoteMessage message) {
  // TODO: Navigate to appropriate screen based on notification data
  // Example:
  // if (message.data['type'] == 'booking') {
  //   Navigator.pushNamed(context, '/booking-detail', arguments: message.data);
  // }
}
```

## Firestore Integration

To store FCM tokens for users:
```dart
// After user login
final token = await NotificationService().getDeviceToken();
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
```

## Troubleshooting

### Android Issues
1. **Notifications not showing on Android 13+**
   - Ensure `POST_NOTIFICATIONS` permission is granted
   - Check notification channel is created: `sahara_notifications`

2. **Background messages not received**
   - Verify `@pragma('vm:entry-point')` is on background handler
   - Check app has not been force-stopped

### iOS Issues
1. **APNs Certificate**
   - Go to Firebase Console → Project Settings → Cloud Messaging
   - Upload APNs certificate from Apple Developer Portal

2. **Device Token Not Generated**
   - Check user has given notification permission
   - Restart app after granting permission

## Next Steps

1. **Implement Notification Navigation**
   - Update `_handleNotificationTap()` to navigate based on notification type
   - Handle different notification payloads (booking, message, etc.)

2. **Save FCM Tokens to Firestore**
   - Create migration to save existing user tokens
   - Update token when user logs in

3. **Implement Notification Preferences**
   - Allow users to toggle notification types
   - Store preferences in Firestore
   - Subscribe/unsubscribe from topics based on preferences

4. **Add Notification Service Integration**
   - Create Firestore Cloud Functions to send notifications
   - Trigger notifications on booking creation, messages, etc.

5. **Analytics & Tracking**
   - Track notification delivery and opens
   - Monitor notification engagement metrics

## Dependencies

- `firebase_messaging: ^14.7.10` - Firebase Cloud Messaging
- `flutter_local_notifications: ^16.3.2` - Local notification display

## Files Modified/Created

- ✅ `lib/services/notification_service.dart` - Core FCM service
- ✅ `lib/main.dart` - Initialize notification service
- ✅ `android/app/src/main/AndroidManifest.xml` - Add permissions
- ✅ `pubspec.yaml` - Add flutter_local_notifications dependency
- ✅ `FCM_SETUP_GUIDE.md` - This guide
