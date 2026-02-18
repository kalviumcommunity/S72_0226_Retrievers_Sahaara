# Week 2 Testing Guide - Booking & Service Management

## Overview
This guide provides comprehensive testing procedures for all Week 2 features including caregiver discovery, booking system, activity tracking, and reviews.

---

## Prerequisites

### Test Environment Setup
1. Flutter SDK installed
2. Firebase project configured
3. Test accounts created:
   - Pet Owner account
   - Caregiver account
4. Test data populated:
   - At least 3 caregiver profiles
   - At least 2 pet profiles
   - Sample bookings

### Test Devices
- Chrome (Web) - Primary
- Android Emulator (Optional)
- iOS Simulator (Optional)

---

## Test Suite 1: Caregiver Discovery

### TC1.1: View All Caregivers
**Steps:**
1. Login as pet owner
2. Navigate to "Find Caregivers"
3. Verify caregiver list loads

**Expected:**
- List of caregivers displayed
- Each card shows: name, photo, rating, experience, rate, services
- Verification badges visible for verified caregivers

### TC1.2: Filter by Service
**Steps:**
1. Open caregiver search
2. Tap filter button
3. Select "Walking" service
4. Tap "Apply Filters"

**Expected:**
- Only caregivers offering walking service shown
- Filter chip displayed
- Results update immediately

### TC1.3: Filter by Pet Type
**Steps:**
1. Open filters
2. Select "Dog" pet type
3. Apply filters

**Expected:**
- Only caregivers handling dogs shown
- Multiple filters can be combined

### TC1.4: Filter by Rating
**Steps:**
1. Open filters
2. Set minimum rating to 4.0
3. Apply filters

**Expected:**
- Only caregivers with 4.0+ rating shown
- Rating slider works smoothly

### TC1.5: View Caregiver Detail
**Steps:**
1. Tap on a caregiver card
2. View full profile

**Expected:**
- Profile photo, name, location displayed
- Stats shown (experience, rate, completed bookings)
- Services and pet types listed
- Reviews section visible
- "Book Now" button present

---

## Test Suite 2: Booking System

### TC2.1: Create Booking
**Steps:**
1. Open caregiver detail
2. Tap "Book Now"
3. Select pet
4. Choose service type
5. Select start date/time
6. Select end date/time
7. Add special instructions
8. Submit booking

**Expected:**
- All fields validated
- Total amount calculated correctly
- Success message shown
- Booking appears in "My Bookings"

### TC2.2: Price Calculation
**Steps:**
1. Create booking
2. Set start: Today 10:00 AM
3. Set end: Today 2:00 PM
4. Verify total

**Expected:**
- Duration: 4 hours
- Total = 4 × hourly rate
- Updates in real-time

### TC2.3: Conflict Detection
**Steps:**
1. Create booking for caregiver
2. Try to create overlapping booking
3. Submit

**Expected:**
- Error message: "Caregiver not available"
- Booking not created

### TC2.4: View Bookings List
**Steps:**
1. Navigate to "My Bookings"
2. View all tabs

**Expected:**
- Tabs: All, Pending, Confirmed, Completed
- Bookings sorted by date
- Status chips color-coded

### TC2.5: Cancel Booking
**Steps:**
1. Open pending booking
2. Tap cancel button
3. Enter reason
4. Confirm

**Expected:**
- Cancellation reason dialog shown
- Booking status updated to "cancelled"
- Reason stored

---

## Test Suite 3: Caregiver Booking Management

### TC3.1: View Booking Requests
**Steps:**
1. Login as caregiver
2. Navigate to "Bookings" tab
3. View "Pending" tab

**Expected:**
- Pending requests listed
- Accept/Reject buttons visible
- Pet and owner info shown

### TC3.2: Accept Booking
**Steps:**
1. Open pending booking
2. Tap "Accept" button
3. Confirm

**Expected:**
- Status changes to "confirmed"
- Success message shown
- Booking moves to "Confirmed" tab

### TC3.3: Reject Booking
**Steps:**
1. Open pending booking
2. Tap "Reject" button
3. Enter reason
4. Confirm

**Expected:**
- Reason dialog shown
- Status changes to "cancelled"
- Reason stored

### TC3.4: Start Service
**Steps:**
1. Open confirmed booking
2. Tap "Start Service"
3. Confirm

**Expected:**
- Confirmation dialog shown
- Status changes to "in-progress"
- Activity feed becomes available

### TC3.5: Complete Service
**Steps:**
1. Open in-progress booking
2. Tap "Complete Service"
3. Confirm

**Expected:**
- Confirmation dialog shown
- Status changes to "completed"
- Review option appears for owner

---

## Test Suite 4: Activity Tracking

### TC4.1: Add Text Update
**Steps:**
1. Open in-progress booking (caregiver)
2. Tap "Activity Feed"
3. Tap "Add Update"
4. Select "Text Update"
5. Enter description
6. Submit

**Expected:**
- Activity posted successfully
- Appears in feed immediately
- Owner can see update

### TC4.2: Add Photo Update
**Steps:**
1. Add update
2. Select "Photo"
3. Pick image
4. Add description
5. Submit

**Expected:**
- Photo uploaded
- Compressed before upload
- Displayed in feed
- Description shown

### TC4.3: Add Location Update
**Steps:**
1. Add update
2. Enable "Include Location"
3. Wait for GPS
4. Add description
5. Submit

**Expected:**
- Location captured
- Address displayed
- Shown on activity card

### TC4.4: Real-time Updates
**Steps:**
1. Owner opens activity feed
2. Caregiver adds update
3. Observe owner's screen

**Expected:**
- New activity appears automatically
- No manual refresh needed
- Timestamp shows "Just now"

### TC4.5: Delete Activity
**Steps:**
1. Caregiver opens activity feed
2. Tap delete on activity
3. Confirm

**Expected:**
- Confirmation dialog shown
- Activity removed
- Feed updates

---

## Test Suite 5: Review System

### TC5.1: Write Review
**Steps:**
1. Open completed booking (owner)
2. Tap "Write a Review"
3. Set rating (e.g., 4.5 stars)
4. Select tags
5. Write comment (min 10 chars)
6. Submit

**Expected:**
- Star rating works
- Tags selectable
- Comment validated
- Success message shown

### TC5.2: Prevent Duplicate Review
**Steps:**
1. Submit review
2. Try to write another review for same booking

**Expected:**
- "Review Submitted" shown
- Cannot write duplicate
- Button disabled

### TC5.3: View Reviews
**Steps:**
1. Open caregiver profile
2. Tap "View All Reviews"

**Expected:**
- All reviews listed
- Owner info shown
- Ratings displayed
- Tags visible
- Comments readable

### TC5.4: Stats Update
**Steps:**
1. Note caregiver's average rating
2. Submit new review
3. Check caregiver profile

**Expected:**
- Average rating recalculated
- Review count incremented
- Stats accurate

### TC5.5: Review Validation
**Steps:**
1. Try to submit review with:
   - No rating
   - Comment < 10 chars
   - Empty comment

**Expected:**
- Validation errors shown
- Cannot submit invalid review
- Error messages clear

---

## Test Suite 6: Integration Tests

### TC6.1: Complete Booking Flow
**Steps:**
1. Owner searches caregivers
2. Filters by service
3. Views caregiver detail
4. Creates booking
5. Caregiver accepts
6. Caregiver starts service
7. Caregiver adds activities
8. Caregiver completes service
9. Owner writes review

**Expected:**
- All steps work seamlessly
- Data flows correctly
- No errors occur

### TC6.2: Multi-user Scenario
**Steps:**
1. Owner creates 3 bookings
2. Different caregivers accept
3. All start services
4. All add activities
5. All complete
6. Owner reviews all

**Expected:**
- All bookings independent
- No conflicts
- Stats update correctly

---

## Test Suite 7: Error Handling

### TC7.1: Network Error
**Steps:**
1. Disable internet
2. Try to load caregivers

**Expected:**
- Error message shown
- Retry button available
- No crash

### TC7.2: Invalid Data
**Steps:**
1. Create booking with:
   - End time before start time
   - Past date

**Expected:**
- Validation prevents submission
- Clear error messages

### TC7.3: Permission Denied
**Steps:**
1. Try to add photo without permission
2. Try to get location without permission

**Expected:**
- Permission request shown
- Graceful handling if denied

---

## Test Suite 8: Performance

### TC8.1: Load Time
**Steps:**
1. Measure time to load caregiver list
2. Measure time to load bookings
3. Measure time to load activities

**Expected:**
- < 2 seconds for lists
- < 1 second for details
- Real-time updates instant

### TC8.2: Image Upload
**Steps:**
1. Upload large image (5MB+)
2. Monitor upload time

**Expected:**
- Image compressed
- Upload < 5 seconds
- No UI freeze

---

## Test Suite 9: UI/UX

### TC9.1: Loading States
**Steps:**
1. Observe all loading operations

**Expected:**
- Loading skeletons shown
- Spinners for actions
- No blank screens

### TC9.2: Empty States
**Steps:**
1. View empty bookings list
2. View empty activities
3. View empty reviews

**Expected:**
- Friendly empty state messages
- Helpful descriptions
- Action buttons where appropriate

### TC9.3: Responsive Design
**Steps:**
1. Test on different screen sizes
2. Rotate device

**Expected:**
- UI adapts properly
- No overflow
- Readable text

---

## Bug Report Template

```
**Bug ID:** BUG-XXX
**Severity:** Critical/High/Medium/Low
**Test Case:** TCXX.X
**Environment:** Chrome/Android/iOS

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
What should happen

**Actual Result:**
What actually happened

**Screenshots:**
Attach if applicable

**Additional Notes:**
Any other relevant information
```

---

## Test Results Summary

### Test Execution
- Total Test Cases: 45
- Passed: ___
- Failed: ___
- Blocked: ___
- Not Executed: ___

### Coverage
- Caregiver Discovery: ____%
- Booking System: ____%
- Activity Tracking: ____%
- Review System: ____%
- Integration: ____%

### Critical Issues
List any critical issues found

### Recommendations
List recommendations for improvements

---

## Sign-off

**Tested By:** _______________
**Date:** _______________
**Status:** Pass/Fail/Conditional Pass
**Notes:** _______________
