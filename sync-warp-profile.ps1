# sync-warp-profile.ps1 - Backup and Sync PowerShell Profile Across Machines
# Purpose: Since Warp doesn't sync profiles across machines, this script manages it via GitHub

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("backup", "restore", "setup")]
    [string]$Action = "backup",
    
    [string]$GitHubRepo = "17274/warp-profile-backup",
    [string]$ProfileBackupPath = "C:\Users\17274\ME\profile-backup"
)

# Colors for output
$Colors = @{
    Success = "Green"
    Warning = "Yellow" 
    Error = "Red"
    Info = "Cyan"
    Highlight = "Magenta"
}

function Write-StatusMessage {
    param([string]$Message, [string]$Type = "Info")
    Write-Host "🔄 $Message" -ForegroundColor $Colors[$Type]
}

function Backup-ProfileToGitHub {
    Write-StatusMessage "Starting PowerShell Profile Backup..." "Info"
    
    # Create backup directory
    if (-not (Test-Path $ProfileBackupPath)) {
        New-Item -Path $ProfileBackupPath -ItemType Directory -Force | Out-Null
        Write-StatusMessage "Created backup directory: $ProfileBackupPath" "Success"
    }
    
    # Copy profile files
    $sourceProfile = $PROFILE
    $destProfile = Join-Path $ProfileBackupPath "Microsoft.PowerShell_profile.ps1"
    
    if (Test-Path $sourceProfile) {
        Copy-Item $sourceProfile $destProfile -Force
        Write-StatusMessage "Profile backed up to: $destProfile" "Success"
    } else {
        Write-StatusMessage "No profile found at: $sourceProfile" "Warning"
        return $false
    }
    
    # Copy SwiftLetter system files
    $swiftLetterPath = "C:\Users\17274\ME\super-ai-toolbox"
    $backupSwiftPath = Join-Path $ProfileBackupPath "super-ai-toolbox"
    
    if (Test-Path $swiftLetterPath) {
        if (Test-Path $backupSwiftPath) {
            Remove-Item $backupSwiftPath -Recurse -Force
        }
        Copy-Item $swiftLetterPath $backupSwiftPath -Recurse -Force
        Write-StatusMessage "SwiftLetter system backed up" "Success"
    }
    
    # Create machine-specific info file
    $machineInfo = @{
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
        ProfilePath = $PROFILE
        SwiftLetterPath = $swiftLetterPath
        BackupDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        WarpVersion = "Latest"
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
    } | ConvertTo-Json -Depth 3

    Set-Content -Path (Join-Path $ProfileBackupPath "machine-info.json") -Value $machineInfo
    Write-StatusMessage "Machine info saved" "Success"
    
    # Create setup instructions
    $setupInstructions = @"
# WARP PROFILE SETUP INSTRUCTIONS

## Automatic Setup (Recommended)
``````powershell
# Run this on the new machine:
.\sync-warp-profile.ps1 -Action restore
``````

## Manual Setup (If needed)
1. Copy Microsoft.PowerShell_profile.ps1 to: `$PROFILE
2. Copy super-ai-toolbox folder to: C:\Users\[YourUsername]\ME\
3. Run: . `$PROFILE
4. Test: Type 'q' to activate SwiftLetter

## Features Included
✅ SwiftLetter 1-letter commands (c, p, g, e, l, v)
✅ Warp custom dropdown functions (dd, cc, ff, rr)
✅ Popup and menu systems (popup, menu)
✅ Enable/disable controls (swiftoff, swifton)

## Testing Commands
- Type 'c' for system check
- Type 'v' for visual interface
- Type 'menu' for command list
- Type 'swiftoff' to disable (swifton to re-enable)

---
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Machine: $env:COMPUTERNAME
"@
    
    Set-Content -Path (Join-Path $ProfileBackupPath "SETUP-README.md") -Value $setupInstructions
    Write-StatusMessage "Setup instructions created" "Success"
    
    Write-StatusMessage "Backup complete! Upload $ProfileBackupPath to GitHub." "Highlight"
    Write-StatusMessage "GitHub repo suggestion: https://github.com/$GitHubRepo" "Info"
    
    return $true
}

function Restore-ProfileFromBackup {
    Write-StatusMessage "Starting PowerShell Profile Restore..." "Info"
    
    if (-not (Test-Path $ProfileBackupPath)) {
        Write-StatusMessage "Backup directory not found: $ProfileBackupPath" "Error"
        Write-StatusMessage "Please download from GitHub first!" "Warning"
        return $false
    }
    
    # Restore profile
    $backupProfile = Join-Path $ProfileBackupPath "Microsoft.PowerShell_profile.ps1"
    if (Test-Path $backupProfile) {
        # Create profile directory if it doesn't exist
        $profileDir = Split-Path $PROFILE -Parent
        if (-not (Test-Path $profileDir)) {
            New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
        }
        
        Copy-Item $backupProfile $PROFILE -Force
        Write-StatusMessage "Profile restored to: $PROFILE" "Success"
    } else {
        Write-StatusMessage "Profile backup not found!" "Error"
        return $false
    }
    
    # Restore SwiftLetter system
    $backupSwiftPath = Join-Path $ProfileBackupPath "super-ai-toolbox"
    $targetSwiftPath = "C:\Users\$env:USERNAME\ME\super-ai-toolbox"
    
    if (Test-Path $backupSwiftPath) {
        $targetDir = Split-Path $targetSwiftPath -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
        }
        
        if (Test-Path $targetSwiftPath) {
            Remove-Item $targetSwiftPath -Recurse -Force
        }
        Copy-Item $backupSwiftPath $targetSwiftPath -Recurse -Force
        Write-StatusMessage "SwiftLetter system restored" "Success"
    }
    
    Write-StatusMessage "Restore complete!" "Highlight"
    Write-StatusMessage "Run: . `$PROFILE" "Info"
    Write-StatusMessage "Test: Type 'q' to activate SwiftLetter" "Info"
    
    return $true
}

function Setup-GitHubRepo {
    Write-StatusMessage "Setting up GitHub repository for profile sync..." "Info"
    
    # Check if git is available
    try {
        git --version | Out-Null
    } catch {
        Write-StatusMessage "Git not found! Please install Git first." "Error"
        return $false
    }
    
    # Initialize or clone repository
    if (-not (Test-Path $ProfileBackupPath)) {
        Write-StatusMessage "Cloning repository from GitHub..." "Info"
        try {
            git clone "https://github.com/$GitHubRepo.git" $ProfileBackupPath
            Write-StatusMessage "Repository cloned successfully" "Success"
        } catch {
            Write-StatusMessage "Failed to clone. Creating new backup..." "Warning"
            Backup-ProfileToGitHub
        }
    } else {
        Write-StatusMessage "Backup directory exists. Pulling latest changes..." "Info"
        Push-Location $ProfileBackupPath
        try {
            git pull origin main
            Write-StatusMessage "Latest changes pulled" "Success"
        } catch {
            Write-StatusMessage "Failed to pull. Continuing with local backup..." "Warning"
        }
        Pop-Location
    }
    
    return $true
}

# Main execution
Write-Host ""
Write-Host "🚀 WARP PROFILE BACKUP SYSTEM" -ForegroundColor Cyan
Write-Host "═══════════════════════════════" -ForegroundColor Blue
Write-Host ""

switch ($Action.ToLower()) {
    "backup" {
        Write-StatusMessage "Action: Backup profile to GitHub" "Highlight"
        $result = Backup-ProfileToGitHub
        if ($result) {
            Write-Host ""
            Write-Host "📋 NEXT STEPS:" -ForegroundColor Yellow
            Write-Host "1. Upload '$ProfileBackupPath' to GitHub" -ForegroundColor White
            Write-Host "2. On new machine: git clone [your-repo] '$ProfileBackupPath'" -ForegroundColor White
            Write-Host "3. Run: .\sync-warp-profile.ps1 -Action restore" -ForegroundColor White
        }
    }
    "restore" {
        Write-StatusMessage "Action: Restore profile from backup" "Highlight"
        $result = Restore-ProfileFromBackup
        if ($result) {
            Write-Host ""
            Write-Host "🎉 PROFILE RESTORED!" -ForegroundColor Green
            Write-Host "Now run: . `$PROFILE" -ForegroundColor Cyan
            Write-Host "Test with: q" -ForegroundColor Yellow
        }
    }
    "setup" {
        Write-StatusMessage "Action: Setup GitHub repository" "Highlight"
        Setup-GitHubRepo
    }
    default {
        Write-StatusMessage "Invalid action. Use: backup, restore, or setup" "Error"
    }
}

Write-Host ""
Write-Host "💡 USAGE:" -ForegroundColor Yellow
Write-Host "  .\sync-warp-profile.ps1 -Action backup   # Backup current profile" -ForegroundColor White
Write-Host "  .\sync-warp-profile.ps1 -Action restore  # Restore from backup" -ForegroundColor White
Write-Host "  .\sync-warp-profile.ps1 -Action setup    # Setup GitHub sync" -ForegroundColor White
Write-Host ""