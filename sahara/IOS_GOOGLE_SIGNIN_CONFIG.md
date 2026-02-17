// iOS CONFIGURATION FOR GOOGLE SIGN-IN
// =====================================

/*
STEP 1: Update Info.plist
==========================
File: ios/Runner/Info.plist

Add the following configuration:

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace PROJECT_ID with your actual Firebase project ID -->
            <string>com.googleusercontent.apps.PROJECT_ID-YOUR_AWS_REGION.apps.googleusercontent.com</string>
        </array>
    </dict>
</array>

<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
*/

/*
STEP 2: Enable Sign In with Apple (Recommended)
===============================================
File: ios/Runner.xcodeproj

1. In Xcode:
   - Select Runner project in Project Navigator
   - Select Runner target
   - Go to Signing & Capabilities tab
   - Click "+ Capability"
   - Add "Sign in with Apple"
   - Add "Push Notifications" (if needed)

2. Ensure Team ID is set
   - In Signing section, select your Team
*/

/*
STEP 3: GoogleService-Info.plist
================================
File: ios/Runner/GoogleService-Info.plist

This file is generated from Firebase Console:
1. Go to Firebase Console
2. Select your project
3. Go to Settings (gear icon)
4. Download GoogleService-Info.plist
5. Drag and drop into Xcode under Runner folder
6. Ensure it's added to Runner target
7. Run: flutter clean && flutter pub get
*/

/*
STEP 4: Update Podfile (if needed)
==================================
File: ios/Podfile

Ensure you have:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
      ]
    end
  end
end
*/

/*
STEP 5: Swift Bridging Header
============================
File: ios/Runner/Runner-Bridging-Header.h

Ensure it includes Firebase:

//
//  Runner-Bridging-Header.h
//  Runner
//

#ifndef Runner_Bridging_Header_h
#define Runner_Bridging_Header_h

#import "GeneratedPluginRegistrant.h"

#endif /* Runner_Bridging_Header_h */
*/

/*
TESTING:
========
1. Use iOS Simulator with Google Play Services
2. Or test on physical device with Google account
3. Ensure internet connection for authentication
4. Test on both iPhone and iPad

Common Issues:
- "Error: INVALID_CLIENT" → Check CLIENT_ID in URL scheme
- "Error: DRIVE_NOT_AVAILABLE" → Wrong URL scheme format
- "Nil URL scheme" → Missing CFBundleURLTypes in Info.plist
*/

// CONFIGURATION CHECKLIST:
// ========================
// [ ] Added CFBundleURLTypes to Info.plist
// [ ] Added GIDClientID to Info.plist
// [ ] Downloaded GoogleService-Info.plist from Firebase
// [ ] Added GoogleService-Info.plist to Xcode project
// [ ] Added GoogleService-Info.plist to Runner target
// [ ] Installed pods (flutter pub get)
// [ ] Set Team ID in Xcode Signing & Capabilities
// [ ] iOS Deployment Target >= 11.0
// [ ] Swift Language Version is set
