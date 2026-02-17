# Notification Testing Guide - Sahara Pet Care App

Complete guide for testing local notifications and Firebase Cloud Messaging on Android and iOS.

---

## Table of Contents
1. [Setup Prerequisites](#setup-prerequisites)
2. [Android Testing](#android-testing)
3. [iOS Testing](#ios-testing)
4. [Test Scenarios](#test-scenarios)
5. [Troubleshooting](#troubleshooting)
6. [Firebase Cloud Messaging (FCM) Testing](#firebase-cloud-messaging-fcm-testing)

---

## Setup Prerequisites

### For All Platforms
```bash
# Navigate to project
cd sahara

# Get latest dependencies
flutter pub get

# Clean build
flutter clean
```

### Android Prerequisites
- Android SDK 21 or higher
- Android emulator or physical device (Android 6.0+)
- Google Play Services installed on device (for FCM)

### iOS Prerequisites
- iOS 11 or higher
- Physical iPhone device (simulators have notification limitations)
- Apple Developer Account for push notifications
- CocoaPods installed

---

## Android Testing

### Running on Android

#### Option 1: Android Emulator
```bash
# Start emulator (from project root)
cd sahara

# Run app
flutter run

# Or specify emulator
flutter emulators --launch Pixel_4_API_30
flutter run
```

#### Option 2: Physical Device
```bash
cd sahara

# Enable USB debugging on device
# Then run
flutter run
```

### Accessing Test Screens (Android)

After app launches, follow these steps:

1. **Navigate to Notifications Test Screen:**
   - Tap on profile/menu icon (if available in nav)
   - OR: Tap Settings → Notifications
   - Tap "Notifications Test" or similar debug option
   - OR: Access via direct route (if implemented): `/notifications-test`

2. **Alternative: Direct Navigation**
   - You can modify `main.dart` temporarily to start on NotificationsTestScreen:
   ```dart
   // In SaharaApp, change home to:
   home: const NotificationsTestScreen(),
   ```

### Testing Local Notifications (Android)

Once in NotificationsTestScreen, test each button:

#### 1. **Test Simple Notification**
```
Button: "Test Simple Notification"
Expected:
  ✓ Notification appears as banner
  ✓ Sound plays (if enabled)
  ✓ Device vibrates (if enabled)
  ✓ Notification appears in Settings > Notifications
  ✓ Click notification → dismisses
```

#### 2. **Test Booking Notification**
```
Button: "Test Booking Notification"
Expected:
  ✓ Shows pet name "Test Pet"
  ✓ Shows owner name "Test Owner"
  ✓ Service type displayed
  ✓ Notification style enhanced (big text format)
  ✓ Sound/vibration works
```

#### 3. **Test Message Notification**
```
Button: "Test Message Notification"
Expected:
  ✓ Shows message sender
  ✓ Shows preview of message
  ✓ Message notification icon appears
  ✓ Reply action available (if configured)
```

#### 4. **Test Review Notification**
```
Button: "Test Review Notification"
Expected:
  ✓ Stars rating displayed (5 stars)
  ✓ Reviewer info shown
  ✓ Review preview visible
  ✓ Gold/amber color theme applied
```

#### 5. **Test Earnings Notification**
```
Button: "Test Earnings Notification"
Expected:
  ✓ Shows earning amount (₹249)
  ✓ Transaction type shown
  ✓ Green color coding applied
  ✓ Financial notification styling
```

### Android Verification Checklist

- [ ] All 5 notification types display
- [ ] Notification sound works (check device volume)
- [ ] Device vibrates (check vibration settings)
- [ ] Notification color badges appear
- [ ] Multiple notifications stack properly
- [ ] Old notifications dismiss when new ones arrive (if configured)
- [ ] Notification history shows in NotificationsTestScreen
- [ ] Each notification shows correct timestamp
- [ ] Mark-as-read functionality works (toggle & visual change)

---

## iOS Testing

### Running on iOS

#### Requirement: Physical Device
iOS Simulator has limitations with push notifications. Always test on physical iPhone.

```bash
cd sahara

# List connected devices
flutter devices

# Run on physical device
flutter run -d <device_id>

# Or use default
flutter run
```

### Initial iOS Setup

Before testing, verify configuration:

1. **Check Info.plist**
   ```bash
   open ios/Runner/Info.plist
   ```
   Should contain:
   ```xml
   <key>UIApplicationSupportsIndirectInputEvents</key>
   <true/>
   ```

2. **Verify CocoaPods Dependencies**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### iOS Notification Permissions

When app first runs on iOS:

1. **Grant Notification Permission**
   - System popup: "Sahara" would like to send you notifications
   - Tap "Allow" to enable notifications
   - If denied, enable in: Settings → Sahara → Notifications

2. **Verify Settings**
   ```
   Settings > Sahara > Notifications
     ✓ Allow Notifications: ON
     ✓ Sounds: ON
     ✓ Badges: ON
   ```

### Testing Local Notifications (iOS)

Same buttons as Android:

1. **Test Simple Notification**
   ```
   Button: "Test Simple Notification"
   
   Expected (iOS specific):
     ✓ Alert banner slides down from top
     ✓ Alert sound plays (check device mute switch)
     ✓ Badge shows "1" on app icon
     ✓ Swipe down to view full notification
     ✓ Tap notification → opens app
   ```

2. **Test Booking Notification**
   ```
   Button: "Test Booking Notification"
   
   Expected:
     ✓ Rich notification with pet/owner details
     ✓ Expanded view shows full booking info
     ✓ Actions available (review, message, etc.)
   ```

3. **Test Other Notifications**
   ```
   Same behavior as Android with iOS visual styling
   ```

### iOS Verification Checklist

- [ ] Permission dialog appears on first app launch
- [ ] Notifications appear when app is in background
- [ ] Badge count increments on app icon
- [ ] All 5 notification types display
- [ ] Notification sound works (check mute switch on device)
- [ ] Notification history visible in app
- [ ] Tap notification opens app correctly
- [ ] Swipe to dismiss works
- [ ] Multiple notifications show in Notification Center

---

## Test Scenarios

### Scenario 1: Foreground Notifications
App is open and running:

```
1. Open NotificationsTestScreen
2. Tap "Test Simple Notification"
3. Expected: Banner appears at top (iOS) or as notification (Android)
4. Tap notification in app history
5. Verify appearance matches expectations
```

### Scenario 2: Background Notifications
App is backgrounded:

```
1. Open app to NotificationsTestScreen
2. Press home button (background app)
3. Tap test button (simulate via terminal)
4. Expected: 
   - iOS: Notification center shows alert
   - Android: Notification appears in status bar
5. Tap notification
6. Expected: App opens and notification shows processed
```

### Scenario 3: Lock Screen Notifications
Device is locked:

```
1. Lock device (physical button or auto-lock)
2. Send test notification (via app or FCM)
3. Expected:
   - iOS: Shows on lock screen
   - Android: Shows in status bar & lock screen
4. Swipe/tap to interact with notification
5. App opens and notification processed
```

### Scenario 4: Multiple Notifications
Test stacking behavior:

```
1. Rapidly tap 5 different notification buttons
2. Expected:
   - iOS: All appear in Notification Center
   - Android: Stack in status bar (count shows)
3. Verify history shows all 5 in app
4. Clear app notifications
5. Verify count resets in history
```

### Scenario 5: Notification Settings
Test toggle functionality:

```
1. Navigate to Settings > Notification Settings
2. Toggle "All Notifications" OFF
3. Try sending notification
4. Expected: No notification appears
5. Toggle "All Notifications" ON
6. Try sending notification
7. Expected: Notification appears
8. Test individual notification type toggles
```

---

## Firebase Cloud Messaging (FCM) Testing

### FCM Setup

1. **Get FCM Token**
   ```dart
   // In app, retrieve token:
   String token = await FirebaseMessaging.instance.getToken();
   print('FCM Token: $token');
   ```

2. **Enable Background Messages**
   - Already configured in `notification_service.dart`
   - Top-level handler registered for background messages

### Testing FCM via Firebase Console

1. **Go to Firebase Console**
   ```
   https://console.firebase.google.com
   → Select Sahara project
   → Engage > Messaging > Create your first campaign
   ```

2. **Create Test Campaign**
   ```
   Title: "Test Notification"
   Body: "This is a test from FCM"
   Target:
     - Use topic: "pet_owners" or "caregivers"
   Schedule: Send now
   ```

3. **Test Delivery**
   ```
   ✓ Notification appears on device
   ✓ Timestamp matches when sent
   ✓ Content matches Firebase message
   ✓ Tap notification processes correctly
   ```

### Testing FCM via Postman

**Alternative method using Firebase Admin SDK:**

1. **Get Service Account JSON**
   ```
   Firebase Console → Settings > Service Accounts
   → Download JSON file
   ```

2. **Use FCM API**
   ```bash
   curl -X POST \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     -H "Content-Type: application/json" \
     -d '{
       "message": {
         "topic": "pet_owners",
         "data": {
           "type": "booking",
           "petName": "Fluffy",
           "ownerName": "John"
         },
         "notification": {
           "title": "New Booking Request",
           "body": "Fluffy needs care"
         }
       }
     }' \
     https://fcm.googleapis.com/v1/projects/PROJECT_ID/messages:send
   ```

---

## Troubleshooting

### Issue: No notifications appear on Android

**Check:**
1. Notification permission granted in app
   ```
   Settings > Apps > Sahara > Permissions > Notifications
   ```

2. Device not in Do Not Disturb
   ```
   Check notification shade (swipe down)
   Disable DND if active
   ```

3. App channel has correct importance
   ```dart
   // Should be IMPORTANCE_MAX (4) for badges
   // Check in: NotificationService._createAndroidNotificationChannel()
   ```

**Fix:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: No notifications on iOS

**Check:**
1. Physical device required (not simulator)
2. Notification permission granted
   ```
   Settings > Sahara > Notifications
   Allow Notifications: ON
   ```

3. Pod dependencies updated
   ```bash
   cd ios && pod install && cd ..
   ```

**Fix:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

### Issue: Notifications not persistent

**Check:**
1. Notification service initialized in `main()`
   ```dart
   await NotificationService().initialize();
   ```

2. Firebase messaging background handler registered
   ```dart
   // Top-level function in notification_service.dart
   @pragma('vm:entry-point')
   void firebaseMessagingBackgroundHandler(RemoteMessage message) { ... }
   ```

**Fix:**
- Verify `notification_service.dart` has background handler
- Restart app: `flutter run`

### Issue: Vibration/Sound not working

**Android:**
```
Settings > Apps > Sahara > Permissions
  ✓ Vibration: Allowed
  ✓ Sound: Device volume not muted
```

**iOS:**
```
Settings > Sahara > Sounds: ON
Check device mute switch (physical side switch)
```

### Issue: Badge count not clearing

**Android:**
```dart
// Manually clear badges:
NotificationService().cancelAllNotifications();
```

**iOS:**
- Badges auto-clear when app in foreground
- Check: `UIApplicationDelegate.didFinishLaunchingWithOptions`

---

## Performance Testing

### Monitor CPU/Memory During Notifications

**Android:**
```bash
flutter run --profile
# Then check: AndroidStudio > Profiler
```

**iOS:**
```bash
flutter run --profile
# Then check: Xcode > Debug > Gauges
```

### Expected Performance
- Notification delivery: < 100ms
- Memory impact: < 5MB additional
- CPU spike: < 1 second

---

## Documentation Links

- [flutter_local_notifications docs](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Cloud Messaging docs](https://firebase.flutter.dev/docs/messaging/overview/)
- [Firebase Console](https://console.firebase.google.com)
- [Android Notification guidelines](https://developer.android.com/training/notify-user)
- [iOS Notification guidelines](https://developer.apple.com/documentation/usernotifications)

---

## Testing Checklist

### Before Release
- [ ] All notification types tested on Android
- [ ] All notification types tested on iOS physical device
- [ ] Foreground notifications work
- [ ] Background notifications work
- [ ] Lock screen notifications work
- [ ] FCM integration works
- [ ] Notification settings toggles work
- [ ] Sound/vibration preferences work
- [ ] Notification history persists
- [ ] No memory leaks in profiler
- [ ] App doesn't crash on heavy notification load

### Firebase Setup Verification
- [ ] Google Services JSON present in Android
- [ ] GoogleService-Info.plist present in iOS
- [ ] Firebase initialized before notification service
- [ ] FCM tokens logging correctly
- [ ] Topic subscriptions working
- [ ] Background message handler registered

---

## Next Steps

After testing:
1. **Implement Deep Linking** - Route notifications to correct screens
2. **Add Notification Preferences** - User controls for each type
3. **Set Up Analytics** - Track notification engagement
4. **Create Admin Panel** - UI for sending notifications
5. **A/B Testing** - Test different notification texts
6. **Localization** - Translate notifications for multiple languages

---

## Quick Commands Reference

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Run in debug mode
flutter run

# Run in profile mode (for performance testing)
flutter run --profile

# Run specific test
flutter test test/notification_test.dart

# View logs
flutter logs

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS - requires Team ID)
flutter build ios --release
```

---

**Last Updated:** February 17, 2026  
**Status:** Complete notification infrastructure ready for testing
