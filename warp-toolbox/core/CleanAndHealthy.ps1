# SAIT CLEAN & HEALTHY SYSTEM
# 30-day retention cleanup system for profile management and non-duplication

param(
    [string]$Action = "analyze",  # analyze, cleanup, restore, purge
    [switch]$Force,
    [switch]$Verbose
)

# SAIT Clean & Healthy Configuration
$cleanConfig = @{
    RetentionDays = 30
    StorageFolder = "C:\Users\17274\ME\super-ai-toolbox\moved-deleted-copied-30day-storage"
    ProfilePath = "C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    BackupPrefix = "SAIT-BACKUP"
    LogFile = "C:\Users\17274\ME\super-ai-toolbox\core\cleanup-log.txt"
}

function Write-CleanLog {
    param($Message, $Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type] $Message"
    Write-Host $logEntry -ForegroundColor $(if($Type -eq "ERROR"){"Red"}elseif($Type -eq "WARN"){"Yellow"}else{"Green"})
    $logEntry | Add-Content -Path $cleanConfig.LogFile -Encoding UTF8
}

function Initialize-CleanStorage {
    if (-not (Test-Path $cleanConfig.StorageFolder)) {
        New-Item -ItemType Directory -Path $cleanConfig.StorageFolder -Force | Out-Null
        Write-CleanLog "Created storage folder: $($cleanConfig.StorageFolder)"
    }
    
    # Create subdirectories
    @("profiles", "scripts", "commands", "deprecated") | ForEach-Object {
        $subDir = Join-Path $cleanConfig.StorageFolder $_
        if (-not (Test-Path $subDir)) {
            New-Item -ItemType Directory -Path $subDir -Force | Out-Null
        }
    }
}

function Get-ProfileAnalysis {
    Write-CleanLog "Analyzing PowerShell profile for cleanup opportunities..."
    
    if (-not (Test-Path $cleanConfig.ProfilePath)) {
        Write-CleanLog "Profile not found: $($cleanConfig.ProfilePath)" "ERROR"
        return $null
    }
    
    $profileContent = Get-Content $cleanConfig.ProfilePath -Raw
    
    # Analysis categories
    $analysis = @{
        ActiveCommands = @()
        DeprecatedCommands = @()
        MissingScripts = @()
        Duplicates = @()
        Essential = @()
        Recommendations = @()
    }
    
    # Essential commands (never remove)
    $essential = @("q", "WarpSpeed", "swiftoff", "swifton")
    
    # Check for dropdown tools that might be deprecated
    $dropdownFunctions = @("dd", "cc", "ff", "rr", "ld", "popup", "menu")
    
    foreach ($func in $dropdownFunctions) {
        $scriptPath = ""
        switch ($func) {
            "dd" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\QuickDebug-Dropdown.ps1" }
            "cc" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\QuickCommands-Dropdown.ps1" }
            "ff" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\QuickFiles-Dropdown.ps1" }
            "rr" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\QuickReference-Selector.ps1" }
            "ld" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\LaunchDropdowns.ps1" }
            "popup" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\popup.ps1" }
            "menu" { $scriptPath = "C:\Users\17274\ME\2829-Niagara-Street\menu.ps1" }
        }
        
        if ($scriptPath) {
            if (Test-Path $scriptPath) {
                $analysis.ActiveCommands += @{
                    Name = $func
                    Type = "Function"
                    Path = $scriptPath
                    Status = "Active"
                    Purpose = "Dropdown/Menu system"
                }
            } else {
                $analysis.MissingScripts += @{
                    Name = $func
                    Type = "Function" 
                    Path = $scriptPath
                    Status = "Missing Script"
                    Recommendation = "Remove or fix path"
                }
            }
        }
    }
    
    # Check essential commands
    foreach ($cmd in $essential) {
        if ($profileContent -match "function $cmd") {
            $analysis.Essential += @{
                Name = $cmd
                Type = "Essential Function"
                Status = "Active"
                Purpose = "Core SAIT functionality"
            }
        }
    }
    
    # Check for duplicates
    if ($profileContent -match "function q" -and $profileContent -match "function swift") {
        $analysis.Duplicates += @{
            Issue = "Duplicate q functionality"
            Commands = @("q", "swift")
            Recommendation = "Keep 'q', consider removing 'swift' as duplicate"
        }
    }
    
    # Recommendations based on new SAIT system
    $analysis.Recommendations += @{
        Category = "Modernization"
        Suggestion = "Replace dropdown functions (dd, cc, ff, rr, ld) with unified 'v' visual interface"
        Benefit = "Simplifies profile, reduces maintenance, improves user experience"
    }
    
    $analysis.Recommendations += @{
        Category = "Cleanup"
        Suggestion = "Remove popup/menu functions if visual interface (v command) provides same functionality"
        Benefit = "Eliminates duplicate functionality, reduces profile complexity"
    }
    
    return $analysis
}

function Backup-ProfileSection {
    param($SectionName, $Content)
    
    Initialize-CleanStorage
    $timestamp = Get-Date -Format "yyyy-MM-dd-HHmm"
    $backupFile = Join-Path $cleanConfig.StorageFolder "profiles\$($cleanConfig.BackupPrefix)-$SectionName-$timestamp.ps1"
    
    $backupContent = @"
# SAIT CLEANUP BACKUP - $SectionName
# Created: $(Get-Date)
# Original Profile: $($cleanConfig.ProfilePath)
# Retention: $($cleanConfig.RetentionDays) days
# Auto-delete after: $($(Get-Date).AddDays($cleanConfig.RetentionDays))

$Content
"@
    
    $backupContent | Out-File -FilePath $backupFile -Encoding UTF8
    Write-CleanLog "Backed up $SectionName to: $(Split-Path $backupFile -Leaf)"
    return $backupFile
}

function Remove-OldBackups {
    if (-not (Test-Path $cleanConfig.StorageFolder)) { return }
    
    $cutoffDate = (Get-Date).AddDays(-$cleanConfig.RetentionDays)
    Get-ChildItem -Path $cleanConfig.StorageFolder -Recurse -File | Where-Object {
        $_.CreationTime -lt $cutoffDate
    } | ForEach-Object {
        Write-CleanLog "Auto-deleting expired backup: $($_.Name)" "WARN"
        Remove-Item $_.FullName -Force
    }
}

function New-CleanProfile {
    param($Analysis, [switch]$WhatIf)
    
    Write-CleanLog "Creating clean profile based on analysis..."
    
    # Essential profile content
    $cleanProfile = @"
# SAIT CLEAN PROFILE - Generated $(Get-Date)
# Optimized for Warp Super AI Toolbox efficiency

# AUTO-LOAD SUPER DEBUG SHORTCUTS (disable with: `$env:WARP_DISABLE_SWIFTLETTER = "true")
if (-not `$env:WARP_DISABLE_SWIFTLETTER) {
    . "C:\Users\17274\ME\super-ai-toolbox\core\QuickStart.ps1"
} else {
    Write-Host "⚪ SwiftLetter system disabled (clean PowerShell session)" -ForegroundColor Gray
}

# WarpSpeed function - Find and display Warp AI session instructions
function WarpSpeed {
    param([switch]`$ShowPath, [switch]`$Update)
    & "C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed.ps1" -ShowPath:`$ShowPath -Update:`$Update
}

# SwiftLetter System Activation - Ultra-fast 1-letter commands (ESSENTIAL)
function q {
    . "C:\Users\17274\ME\super-ai-toolbox\core\QuickStart.ps1"
}

# SwiftLetter Control Functions
function swiftoff {
    `$env:WARP_DISABLE_SWIFTLETTER = "true"
    Write-Host "🔴 SwiftLetter system will be disabled in NEW Warp windows" -ForegroundColor Red
    Write-Host "💡 Current session still has shortcuts active" -ForegroundColor Yellow
    Write-Host "🔄 To re-enable: swifton" -ForegroundColor Cyan
}

function swifton {
    Remove-Item env:WARP_DISABLE_SWIFTLETTER -ErrorAction SilentlyContinue
    Write-Host "✅ SwiftLetter system will be enabled in NEW Warp windows" -ForegroundColor Green
    Write-Host "🔄 Close and reopen Warp to activate shortcuts" -ForegroundColor Cyan
}

# SAIT Clean & Healthy System
function clean {
    & "C:\Users\17274\ME\super-ai-toolbox\core\CleanAndHealthy.ps1" @args
}

# EOS (End of Session) Routine
function eos {
    & "C:\Users\17274\ME\super-ai-toolbox\core\EOS-Routine.ps1" @args
}

Write-Host "🧹 SAIT Clean Profile Loaded - Essential functions only" -ForegroundColor Green
"@
    
    if ($WhatIf) {
        Write-CleanLog "WHAT-IF: Would create clean profile with content:"
        Write-Host $cleanProfile -ForegroundColor Yellow
        return $cleanProfile
    }
    
    # Backup current profile
    $currentProfile = Get-Content $cleanConfig.ProfilePath -Raw -ErrorAction SilentlyContinue
    if ($currentProfile) {
        Backup-ProfileSection "FULL-PROFILE" $currentProfile
    }
    
    # Write clean profile
    $cleanProfile | Out-File -FilePath $cleanConfig.ProfilePath -Encoding UTF8
    Write-CleanLog "Clean profile created successfully"
    
    return $cleanProfile
}

function Test-QCommandGlobally {
    Write-CleanLog "Testing q command functionality across directories..."
    
    $testResults = @{
        HomeDir = $false
        SystemDir = $false
        ProjectDir = $false
        CurrentDir = $false
        Errors = @()
    }
    
    # Test current directory
    try {
        $result = Invoke-Expression "q" 2>&1
        if ($result -match "SUPER DEBUG SHORTCUTS LOADED") {
            $testResults.CurrentDir = $true
            Write-CleanLog "✅ q command working in current directory"
        }
    } catch {
        $testResults.Errors += "Current dir: $($_.Exception.Message)"
        Write-CleanLog "❌ q command failed in current directory: $($_.Exception.Message)" "ERROR"
    }
    
    # Test from different directories
    $testDirs = @(
        @{Name="Home"; Path="C:\Users\17274"},
        @{Name="System"; Path="C:\Windows"},
        @{Name="Project"; Path="C:\Users\17274\ME"}
    )
    
    foreach ($testDir in $testDirs) {
        try {
            $originalLocation = Get-Location
            Set-Location $testDir.Path
            $result = Invoke-Expression "q" 2>&1
            if ($result -match "SUPER DEBUG SHORTCUTS LOADED") {
                $testResults[$testDir.Name + "Dir"] = $true
                Write-CleanLog "✅ q command working in $($testDir.Name) directory"
            }
            Set-Location $originalLocation
        } catch {
            $testResults.Errors += "$($testDir.Name) dir: $($_.Exception.Message)"
            Write-CleanLog "❌ q command failed in $($testDir.Name) directory: $($_.Exception.Message)" "ERROR"
            Set-Location $originalLocation -ErrorAction SilentlyContinue
        }
    }
    
    return $testResults
}

# Main execution logic
Write-Host "🧹 SAIT CLEAN & HEALTHY SYSTEM" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Blue

Initialize-CleanStorage
Remove-OldBackups

switch ($Action.ToLower()) {
    "analyze" {
        Write-Host "📊 ANALYZING POWERSHELL PROFILE..." -ForegroundColor Green
        $analysis = Get-ProfileAnalysis
        
        if ($analysis) {
            Write-Host "`n📋 PROFILE ANALYSIS RESULTS:" -ForegroundColor Cyan
            
            Write-Host "`n✅ ESSENTIAL COMMANDS:" -ForegroundColor Green
            $analysis.Essential | ForEach-Object {
                Write-Host "  • $($_.Name) - $($_.Purpose)" -ForegroundColor White
            }
            
            Write-Host "`n🔍 ACTIVE COMMANDS:" -ForegroundColor Yellow
            $analysis.ActiveCommands | ForEach-Object {
                Write-Host "  • $($_.Name) - $($_.Purpose)" -ForegroundColor White
            }
            
            Write-Host "`n⚠️ MISSING SCRIPTS:" -ForegroundColor Red
            $analysis.MissingScripts | ForEach-Object {
                Write-Host "  • $($_.Name) - $($_.Recommendation)" -ForegroundColor White
            }
            
            Write-Host "`n🔄 DUPLICATES FOUND:" -ForegroundColor Yellow
            $analysis.Duplicates | ForEach-Object {
                Write-Host "  • $($_.Issue) - $($_.Recommendation)" -ForegroundColor White
            }
            
            Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
            $analysis.Recommendations | ForEach-Object {
                Write-Host "  • [$($_.Category)] $($_.Suggestion)" -ForegroundColor White
                Write-Host "    Benefit: $($_.Benefit)" -ForegroundColor Gray
            }
            
            Write-Host "`n🎯 NEXT STEPS:" -ForegroundColor Green
            Write-Host "  1. Run: clean cleanup -WhatIf (preview changes)" -ForegroundColor White
            Write-Host "  2. Run: clean cleanup (apply changes)" -ForegroundColor White
            Write-Host "  3. Run: clean test (verify q command works)" -ForegroundColor White
        }
    }
    
    "cleanup" {
        Write-Host "🧹 CLEANING POWERSHELL PROFILE..." -ForegroundColor Green
        $analysis = Get-ProfileAnalysis
        if ($analysis) {
            $cleanProfile = New-CleanProfile $analysis -WhatIf:(!$Force)
            if (!$Force) {
                Write-Host "`n⚠️ This was a preview. Use -Force to apply changes." -ForegroundColor Yellow
            }
        }
    }
    
    "test" {
        Write-Host "🔬 TESTING Q COMMAND FUNCTIONALITY..." -ForegroundColor Green
        $testResults = Test-QCommandGlobally
        
        Write-Host "`n📊 TEST RESULTS:" -ForegroundColor Cyan
        Write-Host "  Current Directory: $(if($testResults.CurrentDir){'✅ PASS'}else{'❌ FAIL'})" -ForegroundColor $(if($testResults.CurrentDir){'Green'}else{'Red'})
        Write-Host "  Home Directory:    $(if($testResults.HomeDir){'✅ PASS'}else{'❌ FAIL'})" -ForegroundColor $(if($testResults.HomeDir){'Green'}else{'Red'})
        Write-Host "  System Directory:  $(if($testResults.SystemDir){'✅ PASS'}else{'❌ FAIL'})" -ForegroundColor $(if($testResults.SystemDir){'Green'}else{'Red'})
        Write-Host "  Project Directory: $(if($testResults.ProjectDir){'✅ PASS'}else{'❌ FAIL'})" -ForegroundColor $(if($testResults.ProjectDir){'Green'}else{'Red'})
        
        if ($testResults.Errors.Count -gt 0) {
            Write-Host "`n❌ ERRORS ENCOUNTERED:" -ForegroundColor Red
            $testResults.Errors | ForEach-Object {
                Write-Host "  • $_" -ForegroundColor White
            }
        }
        
        $passCount = ($testResults.CurrentDir, $testResults.HomeDir, $testResults.SystemDir, $testResults.ProjectDir | Where-Object {$_}).Count
        Write-Host "`n🎯 OVERALL RESULT: $passCount/4 tests passed" -ForegroundColor $(if($passCount -eq 4){'Green'}elseif($passCount -ge 2){'Yellow'}else{'Red'})
    }
    
    "purge" {
        Write-Host "🗑️ PURGING OLD BACKUPS..." -ForegroundColor Yellow
        Remove-OldBackups
        Write-Host "✅ Cleanup complete" -ForegroundColor Green
    }
    
    default {
        Write-Host "❌ Invalid action: $Action" -ForegroundColor Red
        Write-Host "Valid actions: analyze, cleanup, test, purge" -ForegroundColor Yellow
    }
}

Write-Host "`n📄 Log file: $($cleanConfig.LogFile)" -ForegroundColor Gray