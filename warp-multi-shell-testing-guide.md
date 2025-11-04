# 🔄 WARP MULTI-SHELL TESTING GUIDE

## Overview
This guide explains how to test Warp with different shells and simulate different machine environments for testing the SwiftLetter system and profile portability.

---

## 🖥️ METHOD 1: Different Shell Types in Warp

### PowerShell Core vs Windows PowerShell
```powershell
# Current (PowerShell Core 7.x)
pwsh

# Legacy Windows PowerShell 5.x  
powershell
```

### Command Prompt
```cmd
# Open CMD in Warp
cmd

# Test traditional batch commands
dir
echo %USERNAME%
```

### WSL (Windows Subsystem for Linux)
```bash
# Open bash/WSL in Warp
wsl

# Or specific distribution
wsl -d Ubuntu
```

---

## 🎭 METHOD 2: Simulate Clean Machine Environment

### Option A: Temporary Profile Disable
```powershell
# Disable SwiftLetter for this session
$env:WARP_DISABLE_SWIFTLETTER = "true"

# Start new Warp window - will be clean
# Test: Type 'c' - should show "command not found"
```

### Option B: Rename Profile Temporarily
```powershell
# Backup current profile
$profilePath = $PROFILE
$backupPath = "$PROFILE.testing-backup"
Move-Item $profilePath $backupPath

# Open new Warp window - completely clean PowerShell
# Restore when done:
Move-Item $backupPath $profilePath
```

### Option C: Different User Account
1. Create new Windows user account
2. Login as that user  
3. Open Warp - will have no profile/customizations
4. Test profile installation process

---

## 🌐 METHOD 3: Network-Based Testing

### Simulate Different Machine with SSH/RDP
```powershell
# SSH to different machine (if available)
ssh username@remote-machine

# Or use Windows Sandbox for isolated testing
# Enable Windows Sandbox feature, then:
# 1. Open Windows Sandbox
# 2. Install Warp in sandbox
# 3. Test profile restoration process
```

---

## 🧪 METHOD 4: Container-Based Testing

### Using Windows Containers (Advanced)
```dockerfile
# Create test container with PowerShell
FROM mcr.microsoft.com/powershell:7.3-windowsservercore-ltsc2022

# Copy test files
COPY sync-warp-profile.ps1 /app/
COPY profile-backup/ /app/profile-backup/

# Test restoration process
WORKDIR /app
CMD ["pwsh", "-Command", "./sync-warp-profile.ps1 -Action restore"]
```

---

## 📋 TESTING CHECKLIST

### ✅ Clean Environment Testing
- [ ] SwiftLetter commands don't work (c, p, g, etc.)
- [ ] No custom functions (WarpSpeed, popup, menu)
- [ ] Standard PowerShell behavior only
- [ ] Profile variable shows correct path: `$PROFILE`

### ✅ Restoration Testing
- [ ] Profile file copied to correct location
- [ ] SwiftLetter system files in ME/super-ai-toolbox/
- [ ] Commands work after running `. $PROFILE`
- [ ] 'q' activates shortcuts properly
- [ ] 'swiftoff'/'swifton' controls work

### ✅ Cross-Shell Testing
- [ ] PowerShell 7.x (current default)
- [ ] Windows PowerShell 5.x (legacy)
- [ ] Command Prompt (cmd)
- [ ] WSL/Bash (if needed)

---

## 🚨 COMMON TEST SCENARIOS

### Scenario 1: New Employee Setup
```powershell
# Simulate: New employee gets laptop with Warp
# 1. Clean profile (no customizations)
# 2. Download profile backup from company GitHub
# 3. Run restoration script
# 4. Verify all shortcuts work

# Test commands:
git clone https://github.com/company/warp-profile-backup.git profile-backup
.\sync-warp-profile.ps1 -Action restore
. $PROFILE
q  # Should show SwiftLetter activation
c  # Should run system check
```

### Scenario 2: Developer Machine Migration  
```powershell
# Simulate: Moving from old laptop to new one
# 1. Backup current profile
# 2. Simulate clean machine
# 3. Restore and verify

.\sync-warp-profile.ps1 -Action backup
$env:WARP_DISABLE_SWIFTLETTER = "true"  # Simulate clean
# Open new window, test restoration
```

### Scenario 3: Shared Machine Usage
```powershell
# Simulate: Multiple developers on same machine
# 1. Each user has own profile backup
# 2. Users can switch between clean/customized
# 3. No conflicts between user setups

# User 1 setup:
swiftoff  # Disable for others
# User 2 can have clean session

# User 1 return:
swifton   # Re-enable personal shortcuts
```

---

## 🔧 DEBUGGING FAILED TESTS

### Issue: Commands not working after restore
```powershell
# Check profile location
$PROFILE  # Should show correct path

# Verify file exists
Test-Path $PROFILE

# Check content
Get-Content $PROFILE | Select-String "QuickStart"

# Manual activation
. "C:\Users\$env:USERNAME\ME\super-ai-toolbox\core\QuickStart.ps1"
```

### Issue: SwiftLetter files missing
```powershell
# Check if directory exists
Test-Path "C:\Users\$env:USERNAME\ME\super-ai-toolbox"

# List contents
Get-ChildItem "C:\Users\$env:USERNAME\ME\super-ai-toolbox\core"

# Look for key files
Test-Path "C:\Users\$env:USERNAME\ME\super-ai-toolbox\core\QuickStart.ps1"
```

---

## 📊 PERFORMANCE TESTING

### Test Profile Load Time
```powershell
# Measure profile loading speed
Measure-Command { . $PROFILE }

# Should be under 2 seconds for good UX
```

### Test Command Response Time  
```powershell
# Test SwiftLetter activation speed
Measure-Command { . "C:\Users\$env:USERNAME\ME\super-ai-toolbox\core\QuickStart.ps1" }

# Should be under 1 second
```

---

## 🎯 AUTOMATION SCRIPTS

### Quick Environment Switch
```powershell
function Switch-WarpEnvironment {
    param([switch]$Clean, [switch]$Custom)
    
    if ($Clean) {
        $env:WARP_DISABLE_SWIFTLETTER = "true"
        Write-Host "🧹 Clean environment enabled - open new Warp window" -ForegroundColor Yellow
    } elseif ($Custom) {
        Remove-Item env:WARP_DISABLE_SWIFTLETTER -ErrorAction SilentlyContinue
        Write-Host "⚡ Custom environment enabled - open new Warp window" -ForegroundColor Green
    }
}

# Usage:
# Switch-WarpEnvironment -Clean    # Test clean setup
# Switch-WarpEnvironment -Custom   # Test full setup
```

### Test All Scenarios
```powershell
function Test-AllWarpScenarios {
    Write-Host "🧪 Testing all Warp scenarios..." -ForegroundColor Cyan
    
    # Test 1: Clean environment
    $env:WARP_DISABLE_SWIFTLETTER = "true"
    Write-Host "1. Clean environment test - open new window and verify 'c' fails"
    
    # Test 2: Restored environment
    Remove-Item env:WARP_DISABLE_SWIFTLETTER -ErrorAction SilentlyContinue
    Write-Host "2. Custom environment test - open new window and verify 'c' works"
    
    # Test 3: Profile verification
    Write-Host "3. Profile verification:"
    Write-Host "   Profile path: $PROFILE"
    Write-Host "   Profile exists: $(Test-Path $PROFILE)"
    Write-Host "   SwiftLetter exists: $(Test-Path 'C:\Users\$env:USERNAME\ME\super-ai-toolbox')"
}
```

---

**Generated:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Machine:** $env:COMPUTERNAME  
**Purpose:** Multi-environment testing for Warp Super AI Toolbox