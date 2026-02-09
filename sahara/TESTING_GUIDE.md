# 🧪 Sahara Testing Guide

Complete guide for testing the Sahara application.

---

## 📋 Table of Contents

1. [Setup](#setup)
2. [Manual Testing](#manual-testing)
3. [Automated Testing](#automated-testing)
4. [Test Scenarios](#test-scenarios)
5. [Known Issues](#known-issues)

---

## 🔧 Setup

### Prerequisites
- Flutter installed and configured
- Firebase project set up
- App running on device/emulator

### Test Accounts
Create test accounts for both roles:
- **Owner:** owner@test.com / password123
- **Caregiver:** caregiver@test.com / password123

---

## 🖱️ Manual Testing

### 1. Authentication Flow

#### Signup (Owner)
- [ ] Open app, see splash screen
- [ ] Navigate to Welcome screen
- [ ] Tap "Get Started"
- [ ] Select "Pet Owner" role
- [ ] Tap "Continue"
- [ ] Fill signup form with valid email/password
- [ ] Tap "Sign Up"
- [ ] Verify navigation to Profile Setup

#### Signup (Caregiver)
- [ ] Follow same steps as Owner
- [ ] Select "Caregiver" role
- [ ] Complete signup
- [ ] Verify navigation to Profile Setup

#### Login
- [ ] Tap "Already have an account? Login"
- [ ] Enter valid credentials
- [ ] Tap "Login"
- [ ] Verify navigation to home screen

#### Google Sign-In
- [ ] Tap "Continue with Google"
- [ ] Select Google account
- [ ] Verify authentication
- [ ] Complete profile if new user

#### Password Reset
- [ ] Tap "Forgot Password?"
- [ ] Enter email
- [ ] Tap "Send Reset Link"
- [ ] Check email for reset link
- [ ] Reset password
- [ ] Login with new password

---

### 2. Profile Management

#### Profile Setup
- [ ] Enter name (required)
- [ ] Enter phone number (required)
- [ ] Enter address (required)
- [ ] Tap "Use current location"
- [ ] Verify address auto-fills
- [ ] Tap profile photo area
- [ ] Select "Choose from Gallery"
- [ ] Pick an image
- [ ] Verify image displays
- [ ] Tap "Continue"
- [ ] Verify navigation to next screen

#### Profile Viewing
- [ ] Open navigation drawer
- [ ] Tap "My Profile"
- [ ] Verify all information displays
- [ ] Check profile photo
- [ ] Check verified badge (if verified)
- [ ] Check role badge
- [ ] Tap "Edit Profile"
- [ ] Make changes
- [ ] Save changes
- [ ] Verify updates

---

### 3. Pet Management (Owner)

#### Add Pet
- [ ] Tap FAB "Add Pet"
- [ ] Enter pet name (required)
- [ ] Select pet type (required)
- [ ] Enter breed (required)
- [ ] Enter age (required)
- [ ] Enter weight (required)
- [ ] Select gender (required)
- [ ] Tap photo area
- [ ] Select pet photo
- [ ] Enter special needs (optional)
- [ ] Enter medical info (optional)
- [ ] Tap "Save Pet"
- [ ] Verify success message
- [ ] Verify navigation to home

#### View Pets
- [ ] See pets in home screen carousel
- [ ] Tap "View All"
- [ ] See all pets in list
- [ ] Tap a pet card
- [ ] View full pet details
- [ ] Check all information displays

#### Edit Pet
- [ ] Open pet detail
- [ ] Tap "Edit" button
- [ ] Modify information
- [ ] Tap "Save Pet"
- [ ] Verify updates

#### Delete Pet
- [ ] Open pet detail
- [ ] Tap "Delete" button
- [ ] Confirm deletion
- [ ] Verify pet removed from list

---

### 4. Caregiver Profile

#### Setup Professional Profile
- [ ] Complete basic profile
- [ ] Enter bio (required)
- [ ] Enter experience years (required)
- [ ] Enter hourly rate (required)
- [ ] Select services offered
- [ ] Select pet types handled
- [ ] Tap "Complete Profile"
- [ ] Verify navigation to home

#### View Professional Profile
- [ ] Open drawer
- [ ] Tap "Professional Profile"
- [ ] Verify all information
- [ ] Edit if needed

---

### 5. Home Screens

#### Owner Home
- [ ] See welcome card with name
- [ ] See 4 quick action cards
- [ ] See pets carousel (if pets added)
- [ ] See upcoming bookings section
- [ ] Pull to refresh
- [ ] Verify data updates
- [ ] Tap quick actions
- [ ] Verify navigation (where implemented)

#### Caregiver Home
- [ ] See welcome card with name
- [ ] See 3 stats cards
- [ ] See 4 quick action cards
- [ ] See today's schedule
- [ ] See recent bookings
- [ ] Pull to refresh
- [ ] Verify data updates

---

### 6. Navigation

#### Drawer Menu (Owner)
- [ ] Open drawer
- [ ] Verify profile header
- [ ] Tap "Home" - goes to home
- [ ] Tap "My Pets" - goes to pet list
- [ ] Tap "Bookings" - placeholder
- [ ] Tap "Find Caregivers" - placeholder
- [ ] Tap "Messages" - placeholder
- [ ] Tap "My Profile" - goes to profile
- [ ] Tap "Settings" - goes to settings
- [ ] Tap "Help & Support" - placeholder

#### Drawer Menu (Caregiver)
- [ ] Open drawer
- [ ] Verify profile header
- [ ] Tap "Home" - goes to home
- [ ] Tap "My Bookings" - placeholder
- [ ] Tap "Schedule" - placeholder
- [ ] Tap "Messages" - placeholder
- [ ] Tap "Reviews" - placeholder
- [ ] Tap "My Profile" - goes to profile
- [ ] Tap "Professional Profile" - goes to caregiver profile
- [ ] Tap "Settings" - goes to settings
- [ ] Tap "Help & Support" - placeholder

---

### 7. Settings

#### Account Section
- [ ] See user info
- [ ] Profile photo displays
- [ ] Name and email correct

#### Notifications
- [ ] Toggle "Enable Notifications"
- [ ] Verify dependent toggles disable
- [ ] Toggle "Email Notifications"
- [ ] Toggle "Push Notifications"

#### Privacy & Security
- [ ] Toggle "Location Services"
- [ ] Tap "Change Password"
- [ ] Confirm email send
- [ ] Check email received
- [ ] Tap "Privacy Policy" - placeholder
- [ ] Tap "Terms of Service" - placeholder

#### App Section
- [ ] Tap "About"
- [ ] Verify app info displays
- [ ] Check version number
- [ ] Tap "Help & Support" - placeholder
- [ ] Tap "Rate App" - placeholder
- [ ] Tap "Share App" - placeholder

#### Account Actions
- [ ] Tap "Logout"
- [ ] Confirm logout
- [ ] Verify navigation to welcome
- [ ] Login again
- [ ] Tap "Delete Account"
- [ ] Enter password
- [ ] Cancel deletion
- [ ] Verify account still exists

---

### 8. UI/UX Elements

#### Loading States
- [ ] See loading indicators during operations
- [ ] See skeleton loaders where implemented
- [ ] Verify smooth transitions

#### Empty States
- [ ] See empty state when no pets
- [ ] See empty state when no bookings
- [ ] Verify friendly messages
- [ ] Check action buttons work

#### Error States
- [ ] Trigger network error (airplane mode)
- [ ] See error message
- [ ] Tap "Retry"
- [ ] Verify retry works

#### Animations
- [ ] Page transitions are smooth
- [ ] Shimmer animations work
- [ ] Pull-to-refresh animates
- [ ] Button loading states work

---

## 🤖 Automated Testing

### Unit Tests
```bash
# Run all unit tests
flutter test test/unit/

# Specific test
flutter test test/unit/validators_test.dart
```

### Widget Tests
```bash
# Run all widget tests
flutter test test/widget/

# Specific test
flutter test test/widget/login_screen_test.dart
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/

# Specific test
flutter drive --target=integration_test/app_test.dart
```

---

## 📝 Test Scenarios

### Scenario 1: New Owner Onboarding
1. Open app
2. Sign up as owner
3. Complete profile with photo
4. Add first pet with photo
5. View home screen
6. Explore navigation

**Expected:** Smooth flow, all data saved, home screen shows pet

### Scenario 2: New Caregiver Onboarding
1. Open app
2. Sign up as caregiver
3. Complete profile with photo
4. Complete professional profile
5. View home screen with stats
6. Explore navigation

**Expected:** Smooth flow, all data saved, stats display correctly

### Scenario 3: Pet Management
1. Login as owner
2. Add 3 different pets
3. View pet list
4. Edit one pet
5. Delete one pet
6. View remaining pets

**Expected:** All operations successful, data persists

### Scenario 4: Settings Management
1. Login as any user
2. Open settings
3. Toggle all switches
4. Change password
5. Logout
6. Login with new password

**Expected:** All settings work, password change successful

### Scenario 5: Error Handling
1. Login
2. Turn on airplane mode
3. Try to load data
4. See error state
5. Turn off airplane mode
6. Tap retry
7. Data loads

**Expected:** Graceful error handling, retry works

---

## 🐛 Known Issues

### Issue 1: Firebase Not Configured
**Symptom:** App crashes on startup  
**Solution:** Run `flutterfire configure`

### Issue 2: Location Permission Denied
**Symptom:** "Use current location" doesn't work  
**Solution:** Grant location permission in device settings

### Issue 3: Image Upload Fails
**Symptom:** Photo doesn't upload  
**Solution:** Check Firebase Storage rules and permissions

### Issue 4: Google Sign-In Fails
**Symptom:** Google sign-in returns error  
**Solution:** Configure OAuth consent screen in Firebase

---

## ✅ Test Checklist Summary

### Critical Paths (Must Pass)
- [ ] User can sign up
- [ ] User can login
- [ ] User can complete profile
- [ ] Owner can add pet
- [ ] Owner can view pets
- [ ] Caregiver can complete professional profile
- [ ] User can logout
- [ ] Navigation works

### Important Features (Should Pass)
- [ ] Photo upload works
- [ ] Location services work
- [ ] Profile editing works
- [ ] Pet editing works
- [ ] Pet deletion works
- [ ] Settings work
- [ ] Password reset works

### Nice to Have (Can Have Issues)
- [ ] Google Sign-In works
- [ ] All animations smooth
- [ ] All placeholders noted
- [ ] Error states display correctly

---

## 📊 Test Coverage Goals

- **Unit Tests:** 80%+
- **Widget Tests:** 70%+
- **Integration Tests:** 60%+
- **Manual Testing:** 100% of implemented features

---

## 🔄 Continuous Testing

### Before Each Commit
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`
- [ ] Fix all errors and warnings

### Before Each PR
- [ ] Run full test suite
- [ ] Manual test critical paths
- [ ] Check code coverage
- [ ] Update documentation

### Before Each Release
- [ ] Full regression testing
- [ ] Test on multiple devices
- [ ] Test both roles
- [ ] Verify all features

---

## 📞 Reporting Issues

When reporting issues, include:
1. **Steps to reproduce**
2. **Expected behavior**
3. **Actual behavior**
4. **Screenshots/videos**
5. **Device/platform info**
6. **App version**

---

**Happy Testing! 🎉**
