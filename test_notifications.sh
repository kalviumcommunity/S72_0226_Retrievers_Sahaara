#!/bin/bash
# Sahara Notification Testing Script
# Simplifies testing notifications on Android and iOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check prerequisites
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter."
        exit 1
    fi
    print_success "Flutter found: $(flutter --version)"
}

check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git not found. Please install Git."
        exit 1
    fi
    print_success "Git found"
}

# Setup environment
setup_environment() {
    print_header "Setting Up Environment"
    
    cd sahara
    
    print_info "Running flutter clean..."
    flutter clean
    
    print_info "Getting dependencies..."
    flutter pub get
    
    print_success "Environment setup complete"
}

# Test on Android
test_android() {
    print_header "Testing on Android"
    
    print_info "Checking for connected Android devices..."
    devices=$(flutter devices | grep -i android || true)
    
    if [ -z "$devices" ]; then
        print_warning "No Android devices/emulators found"
        print_info "Options:"
        echo "  1. Start Android Emulator: flutter emulators --launch <emulator_name>"
        echo "  2. Connect physical Android device with USB debugging enabled"
        echo "  3. Use 'flutter devices' to list available options"
        return 1
    fi
    
    print_success "Found Android device(s):"
    echo "$devices"
    
    print_info "Building and running app on Android..."
    flutter run
    
    print_success "Android testing complete"
}

# Test on iOS
test_ios() {
    print_header "Testing on iOS"
    
    print_warning "iOS testing requires:"
    print_info "  • Physical iPhone device (simulators have notification limitations)"
    print_info "  • iOS 11 or higher"
    print_info "  • Notification permission granted in app settings"
    
    print_info "Checking for connected iOS devices..."
    devices=$(flutter devices | grep -i ios || true)
    
    if [ -z "$devices" ]; then
        print_error "No iOS devices found"
        print_info "Actions:"
        echo "  1. Connect physical iPhone via USB"
        echo "  2. Enable Developer Mode on iPhone (Settings > Privacy > Developer Mode)"
        echo "  3. Trust the Mac on the device"
        echo "  4. Run this script again"
        return 1
    fi
    
    print_success "Found iOS device(s):"
    echo "$devices"
    
    # Update CocoaPods
    print_info "Updating iOS CocoaPods dependencies..."
    cd ios
    pod install --repo-update
    cd ..
    
    print_info "Building and running app on iOS..."
    flutter run
    
    print_success "iOS testing complete"
}

# Display test instructions
show_test_instructions() {
    print_header "Notification Testing Instructions"
    
    echo "Once the app launches:"
    echo ""
    echo "${BLUE}Step 1:${NC} Navigate to the Notifications Test Screen"
    echo "  • Option A: Tap Settings/Profile menu → Notifications → Test"
    echo "  • Option B: Direct route access (if configured): /notifications-test"
    echo ""
    echo "${BLUE}Step 2:${NC} Test each notification type by tapping buttons:"
    echo "  • Test Simple Notification"
    echo "  • Test Booking Notification"
    echo "  • Test Message Notification"
    echo "  • Test Review Notification"
    echo "  • Test Earnings Notification"
    echo ""
    echo "${BLUE}Step 3:${NC} Verify for each notification:"
    echo "  ✓ Notification appears on screen"
    echo "  ✓ Sound plays (if enabled)"
    echo "  ✓ Device vibrates (if enabled)"
    echo "  ✓ Notification shows in history"
    echo "  ✓ Can mark as read"
    echo ""
    echo "${BLUE}Step 4:${NC} Test settings:"
    echo "  • Navigate to Notification Settings"
    echo "  • Toggle notification types on/off"
    echo "  • Test sound and vibration preferences"
    echo ""
    echo "📖 For detailed instructions, see: NOTIFICATION_TESTING_GUIDE.md"
    echo ""
}

# Main menu
show_menu() {
    print_header "Sahara Notification Testing"
    
    echo "Select testing option:"
    echo ""
    echo "  1) Setup Environment (clean, pub get)"
    echo "  2) Test on Android"
    echo "  3) Test on iOS (physical device recommended)"
    echo "  4) Setup + Test on Android"
    echo "  5) Setup + Test on iOS"
    echo "  6) Show Testing Instructions"
    echo "  7) Exit"
    echo ""
}

# Main script
main() {
    print_header "Sahara Notification Testing Tool"
    
    check_flutter
    check_git
    
    while true; do
        show_menu
        read -p "Enter choice (1-7): " choice
        
        case $choice in
            1)
                setup_environment
                ;;
            2)
                test_android
                ;;
            3)
                test_ios
                ;;
            4)
                setup_environment
                test_android
                ;;
            5)
                setup_environment
                test_ios
                ;;
            6)
                show_test_instructions
                ;;
            7)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select 1-7."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main script
main
