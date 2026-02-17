# Firebase Cloud Messaging Setup Checklist

## 📋 Prerequisites

Before setting up FCM in the Sahara app, ensure you have:

- [x] Firebase project created in Firebase Console
- [x] Firebase Core dependencies in pubspec.yaml
- [x] GoogleServices files downloaded:
  - `google-services.json` (Android)
  - `GoogleService-Info.plist` (iOS)

## ✅ Phase 1: Firebase Console Configuration

### 1.1 Enable Firebase Cloud Messaging
- [ ] Go to [Firebase Console](https://console.firebase.google.com)
- [ ] Select your Sahara project
- [ ] Navigate to **Build** → **Messaging**
- [ ] Click **Enable Firebase Cloud Messaging**

### 1.2 Configure Android Credentials (Optional but Recommended)
- [ ] Go to **Project Settings** → **Cloud Messaging**
- [ ] Under **Android Configuration**:
  - [ ] Go to [Google Cloud Console](https://console.cloud.google.com)
  - [ ] Create a Firebase Cloud Messaging API credential
  - [ ] Download the server API key
- [ ] Add the server API key to Firebase Console

### 1.3 Configure iOS APNs Certificate
- [ ] Go to **Project Settings** → **Cloud Messaging**
- [ ] Under **Apple Configuration**:
  - [ ] Go to [Apple Developer Portal](https://developer.apple.com)
  - [ ] Create APNs Certificate (Production and Development)
  - [ ] Download the .p8 key file
  - [ ] Upload to Firebase Console
- [ ] Note: APNs certificates are required for iOS push notifications

## ✅ Phase 2: App Configuration (COMPLETED)

### 2.1 Dependencies
- [x] Added `firebase_messaging: ^14.7.10`
- [x] Added `flutter_local_notifications: ^16.3.2`

### 2.2 Android Configuration
- [x] AndroidManifest.xml updated with:
  - [x] `android.permission.POST_NOTIFICATIONS`
  - [x] `android.permission.INTERNET`
  - [x] `singleTop` launch mode configured

### 2.3 iOS Configuration
- [x] AppDelegate.swift properly configured
- [x] GeneratedPluginRegistrant handles FCM
- [ ] Request user APNS permission (iOS 13+)

### 2.4 Notification Service
- [x] Created `NotificationService` singleton
- [x] Configured foreground message handling
- [x] Configured background message handling
- [x] Local notifications display with sound & vibration
- [x] FCM token retrieval implemented

### 2.5 Main App Integration
- [x] NotificationService initialized in `main()`
- [x] Firebase initialized before notifications

## ✅ Phase 3: User Setup (TO DO)

### 3.1 Save FCM Tokens to Firestore
After user login, save their FCM token:

```dart
// In auth_provider.dart or auth_repository.dart after successful login
import 'services/fcm_token_manager.dart';

// Save FCM token after user creation/login
final success = await FCMTokenManager().saveFCMToken();

// Subscribe to role-based topics
if (userRole == 'owner') {
  await FCMTokenManager().subscribeToRoleTopics('owner');
} else if (userRole == 'caregiver') {
  await FCMTokenManager().subscribeToRoleTopics('caregiver');
}
```

### 3.2 Delete FCM Token on Logout
```dart
// In auth_provider.dart signOut() method
await FCMTokenManager().deleteFCMToken();
```

### 3.3 Firestore Schema Update
Update user documents to include FCM token tracking:

```
users/
├── userId/
│   ├── name
│   ├── email
│   ├── role
│   ├── fcmToken (string) ← Add this
│   ├── fcmTokenUpdatedAt (timestamp) ← Add this
│   └── notificationPreferences
│       ├── enabled (boolean)
│       ├── soundEnabled (boolean)
│       ├── vibrationEnabled (boolean)
│       └── updatedAt (timestamp)
```

## ✅ Phase 4: Testing

### 4.1 Test Notification Display
- [x] NotificationSettingsScreen created for testing
- [x] Send test notification button implemented
- [x] FCM token display in settings

### 4.2 Test via Firebase Console
1. Go to **Messaging** → **Create campaign**
2. Select **Firebase Cloud Messaging**
3. Write your notification:
   - Title: "Test Notification"
   - Body: "This is a test from Firebase"
4. Click **Send test message**
5. Enter your FCM token (copy from NotificationSettingsScreen)
6. Click **Send**

### 4.3 Test via Cloud Functions (Backend)
Create a Cloud Function to send notifications:

```typescript
// functions/src/sendNotification.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendNotificationToUser = functions.firestore
    .document("bookings/{bookingId}")
    .onCreate(async (snap, context) => {
        const booking = snap.data();
        const ownerId = booking.ownerId;

        try {
            const userDoc = await admin
                .firestore()
                .collection("users")
                .doc(ownerId)
                .get();

            const fcmToken = userDoc.data()?.fcmToken;

            if (!fcmToken) {
                console.log(`No FCM token for user ${ownerId}`);
                return;
            }

            const message = {
                notification: {
                    title: "New Booking Request",
                    body: `Check out the new booking request for ${booking.petName}`,
                },
                data: {
                    type: "booking",
                    bookingId: context.params.bookingId,
                },
                token: fcmToken,
            };

            await admin.messaging().send(message);
            console.log("Notification sent successfully");
        } catch (error) {
            console.error("Error sending notification:", error);
        }
    });
```

## ✅ Phase 5: Notification Handling (TO DO)

### 5.1 Implement Navigation on Notification Tap
Update `_handleNotificationTap()` in `notification_service.dart`:

```dart
void _handleNotificationTap(RemoteMessage message) {
  final type = message.data['type'];
  final id = message.data['id'];

  switch (type) {
    case 'booking':
      // Navigate to booking details
      navigatorKey.currentState?.pushNamed(
        '/booking-detail',
        arguments: {'bookingId': id},
      );
      break;
    case 'message':
      // Navigate to chat
      navigatorKey.currentState?.pushNamed(
        '/chat-detail',
        arguments: {'chatId': id},
      );
      break;
    // Add more cases as needed
  }
}
```

### 5.2 Update Routes
Add navigation key to MaterialApp for notification navigation:

```dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

MaterialApp(
  navigatorKey: navigatorKey,
  // ... rest of config
)
```

## ✅ Phase 6: Notification Types to Implement

### Owner-Facing Notifications
- [ ] New booking request from caregiver
- [ ] Booking confirmation
- [ ] Caregiver cancellation
- [ ] New review/rating received
- [ ] Message from caregiver
- [ ] Booking reminder (24 hours before)

### Caregiver-Facing Notifications
- [ ] New job available nearby
- [ ] Booking request accepted
- [ ] Booking confirmed by owner
- [ ] Booking reminder
- [ ] Message from owner
- [ ] Review reminder
- [ ] Earnings payout processed

## 📱 Testing on Real Devices

### Android Testing
1. Install Flutter app on Android device
2. Open **NotificationSettingsScreen** from settings
3. Copy the FCM token
4. Go to Firebase Console → Messaging → Send test message
5. Paste token and send
6. Verify notification appears

**Common Issues:**
- Notification doesn't appear: Check if app is in foreground (will show in tray)
- No vibration: Check Android version and app permissions
- Silent notification: Ensure notification sound is enabled

### iOS Testing
1. Install app on iOS device (simulator won't receive push notifications)
2. Ensure APNs certificate is uploaded to Firebase
3. Open **NotificationSettingsScreen**
4. Copy FCM token
5. Send test message via Firebase Console

**Common Issues:**
- App crashes on launch: Check APNs certificate validity
- No notification: Verify device allowed notifications
- No sound: Check iOS notification settings

## 🔐 Security Considerations

### 1. Firestore Rules for Tokens
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/update their own fcmToken
    match /users/{userId} {
      allow read, update: if request.auth.uid == userId;
      // Only allow updates to fcmToken and notificationPreferences
      allow update: if request.resource.data.diff(resource.data)
                        .affectedKeys()
                        .hasOnly(['fcmToken', 'fcmTokenUpdatedAt', 'notificationPreferences']);
    }
  }
}
```

### 2. Token Rotation
- Refresh token every 30 days or after Force Stop
- Delete token on logout
- Store token with timestamp to track freshness

### 3. Sensitive Data
- Never include sensitive information in notification title/body
- Use notification data field for IDs only
- Fetch sensitive data from Firestore after notification tap

## 🚀 Deployment Checklist

- [ ] All Firestore schema updates complete
- [ ] Cloud Functions deployed for notifications
- [ ] iOS APNs certificate uploaded
- [ ] Android credentials configured
- [ ] Test notifications working on both platforms
- [ ] Notification navigation routing complete
- [ ] User notification preferences stored
- [ ] Error handling and logging in place
- [ ] Performance tested with high notification volume

## 📚 Useful Resources

- [Firebase Cloud Messaging Documentation](https://firebase.flutter.dev/docs/messaging/overview)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Console Cloud Messaging](https://console.firebase.google.com)
- [Apple APNs Setup](https://developer.apple.com)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)

## 🆘 Troubleshooting

### Token Not Generated
```
Solution:
1. Check notification permission granted
2. Restart app
3. Verify Firebase initialized before NotificationService
4. Check device has internet connection
```

### Notifications Not Appearing
```
Solution (Android):
1. App is open? Implement foreground handler ✅ (Done)
2. Notification channel created? ✅ (Done)
3. POST_NOTIFICATIONS permission? ✅ (Done)
4. Device notifications enabled? Check Settings

Solution (iOS):
1. APNs certificate uploaded? Check Firebase Console
2. Notification permission granted? Start app after granting
3. Token generated? Check foreground logs
4. Simulator? Use real device for FCM
```

### Background Messages Not Working
```
Solution:
1. @pragma('vm:entry-point') on handler ✅ (Done)
2. App must be allowed by system (not force-stopped)
3. Battery optimization/Doze mode might block
4. Long-running handlers: Use Firebase Cloud Functions
```

---

**Last Updated**: February 17, 2026
**Status**: Phase 1-3 Complete, Phase 4-6 In Progress
**Next Steps**: Implement user token saving after auth, add Cloud Functions
