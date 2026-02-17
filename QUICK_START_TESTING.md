# Quick Start Testing - Windows

## 1. Using PowerShell Script (Recommended)

Open PowerShell in the project root and run:

```powershell
# Navigate to project
cd d:\Coding\Projects\Timepasss\S72_0226_Retrievers_Sahaara

# Run the testing script
.\test_notifications.ps1
```

You'll see interactive menu options to:
- Setup environment
- Test on Android emulator or device
- Test on iOS physical device
- View detailed instructions

---

## 2. Manual Testing on Android

### Prerequisites
- Android Emulator installed in Android Studio, OR
- Physical Android device (Android 6.0+) with USB debugging enabled

### Steps

**Option A: Start from Android Studio**

1. Open Android Studio
2. Select Tools > Device Manager
3. Click "Launch" on any Pixel emulator
4. Wait for emulator to fully boot

**Option B: Start from Command Line**

```powershell
# List available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch Pixel_4_API_30

# Or use generic emulator
emulator -avd Pixel_4_API_30
```

### Run App on Android

```powershell
cd "d:\Coding\Projects\Timepasss\S72_0226_Retrievers_Sahaara\sahara"

# Check connected devices
flutter devices

# Run app
flutter run
```

### After App Launches

1. **Navigate to Test Screen**
   - If app shows dashboard, look for Settings/Profile menu
   - Tap the menu/settings icon
   - Find "Notifications" or "Tests" option
   - Tap "Notifications Test" or similar
   - OR directly access: `/notifications-test` route if navigation implemented

2. **Test Each Type** (Tap buttons in order)
   - ✓ Test Simple Notification
   - ✓ Test Booking Notification
   - ✓ Test Message Notification
   - ✓ Test Review Notification
   - ✓ Test Earnings Notification

3. **Verify Results**
   - Check notification appears in notification shade (swipe down)
   - Verify sound/vibration works
   - Confirm notification shows in app's history list
   - Try marking notification as "read" (tap history item)

---

## 3. Manual Testing on iOS

### Prerequisites
- **IMPORTANT:** Physical iPhone required (not simulator)
  - iOS Simulator has limited notification support
  - Simulator won't receive FCM messages
  - Must use real device for complete testing

- iPhone with iOS 11 or later
- USB cable to connect to Windows PC via Mac or USB hub

### Steps

**Connect iPhone to Windows**

```powershell
# Option 1: Via wireless debugging (if configured)
flutter devices

# Option 2: Plug iPhone into USB hub connected to Windows
# The Mac or developer environment may still be required for iOS build
flutter devices
```

**Build and Run**

```powershell
cd "d:\Coding\Projects\Timepasss\S72_0226_Retrievers_Sahaara\sahara"

flutter run -d <device_id>
```

### On iPhone First Launch

1. App shows notification permission request
2. Tap "Allow" to enable notifications
3. Verify Settings > Sahara > Notifications is enabled

### Run Tests (Same as Android)

1. Navigate to NotificationsTestScreen
2. Tap each test button
3. Verify notifications appear in:
   - Notification banner (top of screen)
   - Notification Center (swipe down from top)
4. Confirm badge count on app icon increments
5. Test tapping notifications to open app

---

## 4. Troubleshooting Quick Fixes

### Android Emulator Won't Start

```powershell
# Kill all running emulators
taskkill /IM qemu-system-*.exe /F

# Clear emulator cache
# In Android Studio: Tools > Device Manager > right-click > Wipe Data

# Or restart ADB
adb kill-server
adb start-server
```

### Flutter Doesn't Recognize Devices

```powershell
# Restart ADB daemon
adb kill-server
adb start-server

# Check devices again
flutter devices

# If still not visible, try:
flutter doctor -v
```

### App Crashes on Startup

```powershell
cd sahara

# Clean build
flutter clean

# Get fresh dependencies
flutter pub get

# Run again
flutter run
```

### Notifications Don't Appear

**Android:**
1. Check Settings > Apps > Sahara > Permissions > Notifications
2. Verify Volume not muted (check volume buttons)
3. Check Settings > Notifications > Sahara has notifications enabled

**iOS:**
1. Check Settings > Sahara > Notifications > Allow Notifications: ON
2. Check if device mute switch is OFF (physical button on side)
3. Verify notification permission was granted at app launch

### No Sound/Vibration

**Android:**
1. Check device isn't in Silent mode
2. Settings > Sahara > Notification settings > Sound: ON
3. Settings > Sahara > Notification settings > Vibration: ON
4. Check device volume level (not muted)

**iOS:**
1. Check physical mute switch on side (push UP to unmute)
2. Settings > Sahara > Sounds: ON
3. Device volume not muted (physical buttons)

---

## 5. Testing Scenarios Checklist

After notifications appear, test these scenarios:

### ✓ Foreground Testing
- [ ] App open in foreground
- [ ] Test notification appears on screen
- [ ] Notification shows in app history

### ✓ Background Testing
1. Open app and navigate to test screen
2. Press Home button (background app)
3. Wait 10 seconds
4. Send test notification somehow (or use FCM)
5. Notification should appear in system notification area
6. Tap notification
7. App should open and notification processed

### ✓ Lock Screen Testing
1. Lock device (press power button)
2. Send test notification
3. Notification shows on lock screen
4. Swipe and tap to interact

### ✓ Multiple Notifications
- [ ] Tap 5 different notification buttons rapidly
- [ ] All appear in app history
- [ ] Count shows unread notifications
- [ ] Can mark each as read individually

### ✓ Settings Toggle
- [ ] Go to Settings > Notification Settings
- [ ] Toggle "All Notifications" OFF
- [ ] Try sending notification (should not appear)
- [ ] Toggle "All Notifications" ON
- [ ] Send notification (should appear)
- [ ] Toggle individual types (booking, messages, reviews, earnings)

---

## 6. Next Steps After Testing

✅ **After verification that notifications work:**

1. **Run on Real Device**
   - Test on actual user Android phone
   - Test on actual user iPhone

2. **Firebase Cloud Messaging**
   - Go to Firebase Console
   - Create test campaign
   - Send to all users or test topic

3. **Deep Linking**
   - Implement notification tap routing
   - When user taps notification, open specific screen

4. **Analytics**
   - Track notification delivery
   - Track notification opens
   - Analyze engagement

---

## 7. PowerShell Script Commands

If you prefer command line without the interactive script:

```powershell
# Setup environment
cd sahara
flutter clean
flutter pub get

# Run on Android
flutter run

# Run on iOS
flutter run

# Run with verbose logging
flutter run -v

# Build APK (Android release)
flutter build apk --release

# Run tests
flutter test
```

---

## 8. Important Notes

⚠️ **Remember:**
- **iOS requires physical device** for complete testing
- Always grant notification permissions when prompted
- Check device volume and mute switches
- Use `/notifications-test` route or navigate via settings menu
- Test all 5 notification types: Simple, Booking, Message, Review, Earnings
- Verify sound, vibration, and visual presentation work

---

## 8. Getting Help

If something doesn't work:

1. Check **NOTIFICATION_TESTING_GUIDE.md** in project root for detailed info
2. Review logs: `flutter logs`
3. Check Android Studio Logcat or Xcode Console
4. Verify all prerequisite installation steps completed
5. Try clean build: `flutter clean && flutter pub get`

---

**Ready to test?** Run: `.\test_notifications.ps1` 🚀
