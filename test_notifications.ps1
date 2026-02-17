# Sahara Notification Testing Script (Windows PowerShell)
# Simplifies testing notifications on Android and iOS

# Color formatting
function Write-Header {
    param([string]$Text)
    Write-Host "`n" -NoNewline
    Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Text)
    Write-Host "✓ $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "✗ $Text" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Text)
    Write-Host "⚠ $Text" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Text)
    Write-Host "ℹ $Text" -ForegroundColor Cyan
}

# Check prerequisites
function Check-Flutter {
    $flutter = Get-Command flutter -ErrorAction SilentlyContinue
    if (-not $flutter) {
        Write-Error "Flutter not found. Please install Flutter."
        exit 1
    }
    $version = flutter --version
    Write-Success "Flutter found: $($version.Split([Environment]::NewLine)[0])"
}

function Check-Git {
    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Write-Error "Git not found. Please install Git."
        exit 1
    }
    Write-Success "Git found"
}

# Setup environment
function Setup-Environment {
    Write-Header "Setting Up Environment"
    
    Push-Location sahara
    
    Write-Info "Running flutter clean..."
    & flutter clean
    
    Write-Info "Getting dependencies..."
    & flutter pub get
    
    Write-Success "Environment setup complete"
    
    Pop-Location
}

# Test on Android
function Test-Android {
    Write-Header "Testing on Android"
    
    Write-Info "Checking for connected Android devices..."
    $devices = & flutter devices | Select-String "Android" -ErrorAction SilentlyContinue
    
    if (-not $devices) {
        Write-Warning "No Android devices/emulators found"
        Write-Info "Options:"
        Write-Info "  1. Start Android Emulator: flutter emulators --launch <emulator_name>"
        Write-Info "  2. Connect physical Android device with USB debugging enabled"
        Write-Info "  3. Use 'flutter devices' to list available options"
        return $false
    }
    
    Write-Success "Found Android device(s):"
    Write-Host "$devices`n" -ForegroundColor White
    
    Write-Info "Building and running app on Android..."
    Push-Location sahara
    & flutter run
    Pop-Location
    
    Write-Success "Android testing complete"
    return $true
}

# Test on iOS
function Test-iOS {
    Write-Header "Testing on iOS"
    
    Write-Warning "iOS testing requires:"
    Write-Info "  • Physical iPhone device (simulators have notification limitations)"
    Write-Info "  • iOS 11 or higher"
    Write-Info "  • Notification permission granted in app settings"
    
    Write-Info "Checking for connected iOS devices..."
    $devices = & flutter devices | Select-String "iOS" -ErrorAction SilentlyContinue
    
    if (-not $devices) {
        Write-Error "No iOS devices found"
        Write-Info "Actions:"
        Write-Info "  1. Connect physical iPhone via USB"
        Write-Info "  2. Enable Developer Mode on iPhone (Settings > Privacy > Developer Mode)"
        Write-Info "  3. Trust the Mac on the device"
        Write-Info "  4. Run this script again"
        return $false
    }
    
    Write-Success "Found iOS device(s):"
    Write-Host "$devices`n" -ForegroundColor White
    
    Write-Info "Building and running app on iOS..."
    Push-Location sahara
    & flutter run
    Pop-Location
    
    Write-Success "iOS testing complete"
    return $true
}

# Display test instructions
function Show-TestInstructions {
    Write-Header "Notification Testing Instructions"
    
    Write-Host "Once the app launches:" -ForegroundColor White
    Write-Host ""
    Write-Host "Step 1:" -ForegroundColor Cyan
    Write-Host "  Navigate to the Notifications Test Screen"
    Write-Host "  • Option A: Tap Settings/Profile menu → Notifications → Test"
    Write-Host "  • Option B: Direct route access (if configured): /notifications-test"
    Write-Host ""
    Write-Host "Step 2:" -ForegroundColor Cyan
    Write-Host "  Test each notification type by tapping buttons:"
    Write-Host "  • Test Simple Notification"
    Write-Host "  • Test Booking Notification"
    Write-Host "  • Test Message Notification"
    Write-Host "  • Test Review Notification"
    Write-Host "  • Test Earnings Notification"
    Write-Host ""
    Write-Host "Step 3:" -ForegroundColor Cyan
    Write-Host "  Verify for each notification:"
    Write-Host "  ✓ Notification appears on screen"
    Write-Host "  ✓ Sound plays (if enabled)"
    Write-Host "  ✓ Device vibrates (if enabled)"
    Write-Host "  ✓ Notification shows in history"
    Write-Host "  ✓ Can mark as read"
    Write-Host ""
    Write-Host "Step 4:" -ForegroundColor Cyan
    Write-Host "  Test settings:"
    Write-Host "  • Navigate to Notification Settings"
    Write-Host "  • Toggle notification types on/off"
    Write-Host "  • Test sound and vibration preferences"
    Write-Host ""
    Write-Host "📖 For detailed instructions, see: NOTIFICATION_TESTING_GUIDE.md" -ForegroundColor Yellow
    Write-Host ""
}

# Show menu
function Show-Menu {
    Write-Header "Sahara Notification Testing"
    
    Write-Host "Select testing option:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1) Setup Environment (clean, pub get)" -ForegroundColor Cyan
    Write-Host "  2) Test on Android" -ForegroundColor Cyan
    Write-Host "  3) Test on iOS (physical device recommended)" -ForegroundColor Cyan
    Write-Host "  4) Setup + Test on Android" -ForegroundColor Cyan
    Write-Host "  5) Setup + Test on iOS" -ForegroundColor Cyan
    Write-Host "  6) Show Testing Instructions" -ForegroundColor Cyan
    Write-Host "  7) Exit" -ForegroundColor Cyan
    Write-Host ""
}

# Main script
function Main {
    Write-Header "Sahara Notification Testing Tool"
    
    Check-Flutter
    Check-Git
    
    while ($true) {
        Show-Menu
        $choice = Read-Host "Enter choice (1-7)"
        
        switch ($choice) {
            "1" {
                Setup-Environment
            }
            "2" {
                Test-Android
            }
            "3" {
                Test-iOS
            }
            "4" {
                Setup-Environment
                Test-Android
            }
            "5" {
                Setup-Environment
                Test-iOS
            }
            "6" {
                Show-TestInstructions
            }
            "7" {
                Write-Info "Exiting..."
                exit 0
            }
            default {
                Write-Error "Invalid choice. Please select 1-7."
            }
        }
        
        Write-Host ""
        Read-Host "Press Enter to continue"
    }
}

# Run main script
Main
