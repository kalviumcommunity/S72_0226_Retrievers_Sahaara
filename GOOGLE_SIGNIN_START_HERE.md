# 🚀 Google Sign-In - Quick Start Guide

**Get Google Sign-In working in 15 minutes!**

---

## ⚡ The Fastest Path to Implementation

### Step 1: Firebase (5 minutes)

Visit: https://console.firebase.google.com/

```
1. Create or select your project
2. Go to Authentication → Google Sign-In
3. Enable it
4. Add app:
   - Android app (download google-services.json)
   - iOS app (download GoogleService-Info.plist)
```

✅ **Done!**

---

### Step 2: Get SHA-1 Fingerprint (2 minutes)

Run this command:
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```

Copy the **SHA-1** value (looks like: `AA:BB:CC:DD:...`)

In Firebase Console:
- Click your Android app
- Scroll to "SHA certificate fingerprints"
- Add the SHA-1 above
- Wait a few seconds...

✅ **Done!**

---

### Step 3: Android Setup (3 minutes)

1. Open `android/app/src/main/res/values/strings.xml`
2. Add your Google Client ID:
   ```xml
   <string name="google_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
   ```
3. Save

✅ **Done!**

---

### Step 4: iOS Setup (3 minutes)

1. Download `GoogleService-Info.plist` from Firebase
2. Open Xcode: `ios/Runner.xcworkspace`
3. Drag `GoogleService-Info.plist` into Xcode
4. Select "Runner" target → "Finish"
5. Run: `flutter pub get && flutter clean`

✅ **Done!**

---

### Step 5: Test It! (2 minutes)

```bash
flutter run
```

When the app opens:
1. Tap "Continue with Google"
2. Select your Google account
3. ✅ You're logged in!

---

## 📝 That's It!

Your Google Sign-In is now working!

---

## 🔧 Code You Don't Need to Change

The following are already implemented:

✅ GoogleSignInService - `/lib/services/google_sign_in_service.dart`  
✅ GoogleSignInButton - `/lib/widgets/google_sign_in_button.dart`  
✅ Login Screen - `/lib/screens/auth/login_screen.dart`  
✅ Signup Screen - `/lib/screens/auth/signup_screen.dart`  
✅ AuthProvider - `/lib/providers/auth_provider.dart`  
✅ AuthRepository - `/lib/repositories/auth_repository.dart`  

Everything is ready to use!

---

## 💻 How to Use in Your Code

### Simple Usage:
```dart
GoogleSignInButton(
  onPressed: () async {
    final success = await authProvider.signInWithGoogle(role: 'owner');
    if (success) {
      Navigator.pushNamed(context, '/home');
    }
  },
  isLoading: authProvider.isLoading,
)
```

That's all you need!

---

## 🎨 Button Variants

```dart
// Default (outlined with border)
GoogleSignInButton(onPressed: _handleSignIn)

// Filled style
GoogleSignInButton(
  onPressed: _handleSignIn,
  variant: ButtonVariant.filled,
)

// Icon only (compact)
GoogleSignInIconButton(
  onPressed: _handleSignIn,
  size: 48,
)
```

---

## 📚 Need More Details?

| Document | For What |
|----------|----------|
| `GOOGLE_SIGNIN_QUICK_REFERENCE.md` | Quick code examples |
| `GOOGLE_SIGNIN_SETUP_CHECKLIST.md` | Step-by-step (detailed) |
| `GOOGLE_SIGNIN_INTEGRATION_GUIDE.md` | Complete reference |

---

## ⚠️ If Something Goes Wrong

### Button not working?
- Check Client ID in `strings.xml`
- Verify SHA-1 in Firebase Console
- Run `flutter clean && flutter pub get`

### Icon not showing?
- Add `google.png` to `assets/icons/`
- Or it will show fallback 'G' button

### iOS issues?
- Check `GoogleService-Info.plist` is in Xcode target
- Verify `Info.plist` has URL schemes
- Try on physical device (not simulator)

### Android issues?
- Use device/emulator with Google Play Services
- Verify SHA-1 matches Firebase
- Update `strings.xml` with correct Client ID

---

## 🔗 Links

- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Google Sign-In Docs](https://developers.google.com/identity/sign-in)

---

## 🎯 Common Tasks

### Check if User is Logged In
```dart
final authProvider = Provider.of<AuthProvider>(context);
if (authProvider.isAuthenticated) {
  // User is logged in
}
```

### Get Current User
```dart
final user = authProvider.user;
print('Logged in as: ${user?.displayName}');
```

### Sign Out
```dart
await authProvider.signOut();
Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
```

### Show Error
```dart
Consumer<AuthProvider>(
  builder: (_, authProvider, __) {
    if (authProvider.error != null) {
      return Text('Error: ${authProvider.error}');
    }
    return SizedBox.shrink();
  },
)
```

---

## ✅ Implementation Checklist

- [ ] Get SHA-1 fingerprint
- [ ] Add to Firebase Console
- [ ] Update `strings.xml`
- [ ] Add `GoogleService-Info.plist` to iOS
- [ ] Run `flutter pub get && flutter clean`
- [ ] Run `flutter run`
- [ ] Tap "Continue with Google"
- [ ] Test sign-in
- [ ] Check Firestore user document created
- [ ] ✅ Done!

---

## 🎉 You're Ready!

Your app now has Google Sign-In!

**Next steps:**
1. Customize navigation after sign-in
2. Build profile setup screen
3. Add more features
4. Deploy to production

---

**Questions?** Check the detailed guides:
- `GOOGLE_SIGNIN_QUICK_REFERENCE.md`
- `GOOGLE_SIGNIN_INTEGRATION_GUIDE.md`
- `GOOGLE_SIGNIN_SETUP_CHECKLIST.md`

**Status:** ✅ Ready to deploy!

---

*Last Updated: February 17, 2026*
