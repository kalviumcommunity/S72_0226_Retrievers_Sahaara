# 🚀 How to Run the Sahara App

## Current Status

The app is ready to run, but needs one of these options:

---

## ✅ Option 1: Enable Windows Developer Mode (Recommended)

### Steps:
1. Press `Windows + I` to open Settings
2. Go to **Privacy & Security** → **For developers**
3. Turn on **Developer Mode**
4. Restart your computer (if prompted)

### Then run:
```bash
cd sahara
flutter run -d windows
```

**Result**: A Windows desktop app will open showing the Sahara splash screen!

---

## ✅ Option 2: Use Android Emulator

### Steps:
1. Open Android Studio
2. Go to **Tools** → **Device Manager**
3. Create or start an Android emulator
4. Wait for emulator to fully boot

### Then run:
```bash
cd sahara
flutter run
```

**Result**: The app will install and run on the Android emulator!

---

## ✅ Option 3: Use Physical Android Device

### Steps:
1. Enable **Developer Options** on your Android phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable **USB Debugging** in Developer Options
3. Connect phone to computer via USB
4. Allow USB debugging when prompted on phone

### Then run:
```bash
cd sahara
flutter devices  # Verify device is detected
flutter run
```

**Result**: The app will install and run on your phone!

---

## ✅ Option 4: Run on Web (Chrome) - After Fixing Dependencies

The web version has Firebase dependency issues. To fix:

### Option A: Remove Firebase dependencies temporarily
Edit `sahara/pubspec.yaml` and comment out these lines:
```yaml
# firebase_core: ^2.24.2
# firebase_auth: ^4.16.0
# cloud_firestore: ^4.14.0
# firebase_storage: ^11.6.0
# firebase_messaging: ^14.7.10
```

Then run:
```bash
cd sahara
flutter pub get
flutter run -d chrome
```

### Option B: Set up Firebase first
Follow the Firebase setup guide in `sahara/QUICKSTART.md`

---

## 🎯 What You'll See

When the app runs successfully, you'll see:

### Splash Screen
- **Purple gradient background**
- **White paw icon** in a rounded square
- **"Sahara"** text in large white letters
- **"Trusted Pet Discovery & Monitoring"** tagline
- **Loading indicator** at the bottom

### Screenshot Preview
```
┌─────────────────────────────┐
│                             │
│         [Purple             │
│          Gradient]          │
│                             │
│      ┌─────────┐            │
│      │  🐾     │            │
│      └─────────┘            │
│                             │
│       Sahara                │
│                             │
│  Trusted Pet Discovery      │
│    & Monitoring             │
│                             │
│         ⏳                  │
│      Loading...             │
│                             │
└─────────────────────────────┘
```

---

## 🐛 Troubleshooting

### Issue: "Building with plugins requires symlink support"
**Solution**: Enable Windows Developer Mode (Option 1 above)

### Issue: "No devices found"
**Solution**: 
- For Android: Start an emulator or connect a phone
- For Windows: Enable Developer Mode
- For Web: Use Chrome (should always be available)

### Issue: Firebase compilation errors on web
**Solution**: Either remove Firebase dependencies temporarily or complete Firebase setup

### Issue: "flutter: command not found"
**Solution**: 
```bash
# Add Flutter to PATH or use full path
D:\Flutter\flutter\bin\flutter run
```

---

## 📱 Recommended: Use Android Emulator

The easiest way to see the app right now:

1. **Open Android Studio**
2. **Click Device Manager** (phone icon in toolbar)
3. **Create a new device** if you don't have one:
   - Click "Create Device"
   - Select "Pixel 5" or any phone
   - Select system image (Android 13 recommended)
   - Click "Finish"
4. **Start the emulator** (click play button)
5. **Wait for it to fully boot** (shows home screen)
6. **Run the app**:
   ```bash
   cd sahara
   flutter run
   ```

---

## ✅ Quick Check

To see what devices are available:
```bash
cd sahara
flutter devices
```

You should see:
- ✅ Windows (if Developer Mode enabled)
- ✅ Chrome (always available)
- ✅ Edge (always available)
- ✅ Android emulator (if running)
- ✅ Physical device (if connected)

---

## 🎉 Success!

Once the app runs, you'll see the beautiful Sahara splash screen with:
- Purple gradient background
- Paw icon
- "Sahara" branding
- Loading animation

**The app is ready - just need to choose how to run it!** 🐾

---

## 📞 Need Help?

Check these files:
- `sahara/QUICKSTART.md` - Complete setup guide
- `sahara/docs/SETUP_GUIDE.md` - Detailed instructions
- `sahara/SETUP_VERIFICATION.md` - Troubleshooting

---

**Choose your preferred option above and see Sahara in action!** 🚀
