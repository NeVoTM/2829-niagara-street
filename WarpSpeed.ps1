# WarpSpeed.ps1 - Warp AI Session Startup Script
# Automatically finds and displays WARP-START-SESSION.md from any location

param(
    [switch]$Install = $false,
    [switch]$ShowPath = $false,
    [switch]$Update = $false,
    [switch]$QuickStart = $false
)

# Function to display colorized header
function Show-WarpSpeedHeader {
    Write-Host ""
    Write-Host "🚀 WARP SPEED ACTIVATED" -ForegroundColor Cyan
    Write-Host "═══════════════════════" -ForegroundColor Blue
    Write-Host "Finding Warp AI session instructions..." -ForegroundColor Yellow
    Write-Host ""
}

# Function to ask about project type
function Get-ProjectChoice {
    Write-Host "🎨 PROJECT SELECTION" -ForegroundColor Magenta
    Write-Host "──────────────────" -ForegroundColor Blue
    Write-Host "Are you:" -ForegroundColor White
    Write-Host ""
    Write-Host "[1] 🆕 Starting a NEW project" -ForegroundColor Green
    Write-Host "[2] 🔄 Continuing an EXISTING project" -ForegroundColor Yellow
    Write-Host "[3] 🛠️  Opening a project with KNOWN ISSUES" -ForegroundColor Red
    Write-Host "[4] ⏭️  SKIP - Just show session file" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Enter your choice (1-4)"
    
    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "🆕 NEW PROJECT MODE ACTIVATED" -ForegroundColor Green
            Write-Host "Priority: README template setup, universal file copying, initial structure" -ForegroundColor Green
            Write-Host ""
            return "new"
        }
        "2" {
            Write-Host ""
            Write-Host "🔄 EXISTING PROJECT MODE ACTIVATED" -ForegroundColor Yellow
            Write-Host "Priority: TODO list review, data validation, progress continuation" -ForegroundColor Yellow
            Write-Host ""
            return "existing"
        }
        "3" {
            Write-Host ""
            Write-Host "🛠️  ISSUE RESOLUTION MODE ACTIVATED" -ForegroundColor Red
            Write-Host "Priority: DEBUGGING-CHECKLIST.md review, specific issue fixes, quality assurance" -ForegroundColor Red
            Write-Host "📝 Use numbered references like 'Fix ISSUE #4.1' or 'Apply SECTION #2'" -ForegroundColor Red
            Write-Host ""
            return "issues"
        }
        "4" {
            Write-Host ""
            Write-Host "⏭️  QUICK MODE - Skipping project selection" -ForegroundColor Gray
            Write-Host ""
            return "skip"
        }
        default {
            Write-Host ""
            Write-Host "⚠️  Invalid choice. Defaulting to EXISTING project mode." -ForegroundColor Yellow
            Write-Host ""
            return "existing"
        }
    }
}

# Function to search for WARP-START-SESSION.md
function Find-WarpSessionFile {
    $searchPaths = @(
        # Current directory first
        ".\WARP-START-SESSION.md",
        
        # Known project locations
        "C:\Users\17274\ME\2829-Niagara-Street\WARP-START-SESSION.md",
        
        # Search ME folder and subdirectories
        "C:\Users\17274\ME\*\WARP-START-SESSION.md",
        
        # Search user profile
        "$env:USERPROFILE\*\WARP-START-SESSION.md",
        
        # Search common development directories
        "C:\Development\*\WARP-START-SESSION.md",
        "C:\Projects\*\WARP-START-SESSION.md"
    )
    
    foreach ($path in $searchPaths) {
        $files = Get-ChildItem $path -ErrorAction SilentlyContinue
        if ($files) {
            return $files[0].FullName
        }
    }
    
    # Last resort: system-wide search (limited to avoid performance issues)
    Write-Host "⏳ Searching system-wide (this may take a moment)..." -ForegroundColor Yellow
    $systemSearch = Get-ChildItem -Path "C:\" -Recurse -Name "WARP-START-SESSION.md" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($systemSearch) {
        return "C:\$systemSearch"
    }
    
    return $null
}

# Function to update session timestamp
function Update-SessionTimestamp {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        # Update session start date
        $content = $content -replace '\[Auto-updated by script\]', $timestamp
        
        # Update last updated timestamp
        $content = $content -replace '\*\*Last Updated:\*\* \[Auto-updated by WarpSpeed script\]', "**Last Updated:** $timestamp"
        
        Set-Content -Path $FilePath -Value $content -NoNewline
        Write-Host "✅ Session timestamp updated: $timestamp" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  Could not update timestamp: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Function to show project-specific guidance
function Show-ProjectGuidance {
    param([string]$ProjectType)
    
    switch ($ProjectType) {
        "new" {
            Write-Host "🆕 NEW PROJECT QUICK START:" -ForegroundColor Green
            Write-Host "1. Copy README-UNIVERSAL-TEMPLATE.md to README.md" -ForegroundColor Gray
            Write-Host "2. Create project-data.json for centralized data" -ForegroundColor Gray
            Write-Host "3. Copy DEBUGGING-CHECKLIST.md for quality assurance" -ForegroundColor Gray
            Write-Host "4. Implement SECTION #1 (centralized data) and SECTION #2 (mobile-first)" -ForegroundColor Gray
            Write-Host ""
        }
        "existing" {
            Write-Host "🔄 EXISTING PROJECT CONTINUATION:" -ForegroundColor Yellow
            Write-Host "1. Review TODO-LIST.md for current priorities" -ForegroundColor Gray
            Write-Host "2. Run data validation: .\Update-ProjectData.ps1 -ValidateOnly" -ForegroundColor Gray
            Write-Host "3. Check git status for uncommitted changes" -ForegroundColor Gray
            Write-Host "4. Continue with highest priority items" -ForegroundColor Gray
            Write-Host ""
        }
        "issues" {
            Write-Host "🛠️  ISSUE RESOLUTION FOCUS:" -ForegroundColor Red
            Write-Host "0. 🤖 READ WARP-COMPLIANCE-SYSTEM.md FIRST (prevents wasting hours)" -ForegroundColor Red
            Write-Host "1. Read DEBUGGING-CHECKLIST.md for specific solutions" -ForegroundColor Gray
            Write-Host "2. Use numbered references: 'Fix ISSUE 4.1 (infinite scroll)'" -ForegroundColor Gray
            Write-Host "3. Apply SECTION 2.0 for mobile optimization" -ForegroundColor Gray
            Write-Host "4. Validate fixes with mobile viewport testing" -ForegroundColor Gray
            Write-Host ""
            Write-Host "📝 QUICK REFERENCE - Most Common Issues:" -ForegroundColor Magenta
            Write-Host "   ISSUE 4.1: Infinite scrolling (max-height: 100vh)" -ForegroundColor White
            Write-Host "   ISSUE 4.2: Chart sizing (max-height: 280px)" -ForegroundColor White
            Write-Host "   ISSUE 4.3: Alignment problems (separate tables)" -ForegroundColor White
            Write-Host "   ISSUE 4.4: Text visibility (text-shadow)" -ForegroundColor White
            Write-Host "   ISSUE 4.7: Mobile usability (44px touch targets)" -ForegroundColor White
            Write-Host ""
        }
    }
}

# Function to display session file
function Show-SessionFile {
    param([string]$FilePath, [string]$ProjectType = "skip")
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "❌ WARP-START-SESSION.md not found at: $FilePath" -ForegroundColor Red
        return $false
    }
    
    # Update timestamp if requested
    if ($Update) {
        Update-SessionTimestamp -FilePath $FilePath
    }
    
    # Display file path if requested
    if ($ShowPath) {
        Write-Host "📁 File Location: $FilePath" -ForegroundColor Magenta
        Write-Host ""
    }
    
    # Show project-specific guidance first if not skipped
    if ($ProjectType -ne "skip") {
        Show-ProjectGuidance -ProjectType $ProjectType
    }
    
    # Read and display the file
    try {
        $content = Get-Content $FilePath
        foreach ($line in $content) {
            # Colorize headers and important sections
            if ($line -match '^#+ .*') {
                Write-Host $line -ForegroundColor Cyan
            }
            elseif ($line -match '^\*\*.*\*\*:') {
                Write-Host $line -ForegroundColor Yellow
            }
            elseif ($line -match '^- \*\*') {
                Write-Host $line -ForegroundColor Green
            }
            elseif ($line -match '🔴|🟡|🔵|⚠️|✅|❌|📋|🚀|🎧') {
                Write-Host $line -ForegroundColor White
            }
            else {
                Write-Host $line
            }
        }
        return $true
    }
    catch {
        Write-Host "❌ Error reading file: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to install WarpSpeed globally
function Install-WarpSpeedGlobal {
    try {
        $profilePath = $PROFILE
        $scriptPath = $PSScriptRoot + "\WarpSpeed.ps1"
        
        # Create profile if it doesn't exist
        if (-not (Test-Path $profilePath)) {
            New-Item -Path $profilePath -ItemType File -Force | Out-Null
            Write-Host "✅ Created PowerShell profile: $profilePath" -ForegroundColor Green
        }
        
        # Check if WarpSpeed function already exists
        $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($profileContent -and $profileContent.Contains("function WarpSpeed")) {
            Write-Host "⚠️  WarpSpeed function already exists in profile" -ForegroundColor Yellow
            return
        }
        
        # Add WarpSpeed function to profile
        $functionCode = @"

# WarpSpeed function - Find and display Warp AI session instructions
function WarpSpeed {
    param([switch]`$ShowPath, [switch]`$Update)
    & "$scriptPath" -ShowPath:`$ShowPath -Update:`$Update
}
"@
        
        Add-Content -Path $profilePath -Value $functionCode
        Write-Host "✅ WarpSpeed function added to PowerShell profile" -ForegroundColor Green
        Write-Host "📝 Restart PowerShell or run: . `$PROFILE" -ForegroundColor Yellow
        Write-Host "🎯 Then you can use: WarpSpeed" -ForegroundColor Cyan
    }
    catch {
        Write-Host "❌ Failed to install globally: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main execution
Show-WarpSpeedHeader

# Handle install parameter
if ($Install) {
    Install-WarpSpeedGlobal
    return
}

# Get project choice unless quick start is enabled
$projectType = "skip"
if (-not $QuickStart) {
    $projectType = Get-ProjectChoice
}

# Find and display session file
$sessionFile = Find-WarpSessionFile

if ($sessionFile) {
    Write-Host "✅ Found WARP-START-SESSION.md" -ForegroundColor Green
    if ($ShowPath) {
        Write-Host "📁 Location: $sessionFile" -ForegroundColor Magenta
    }
    Write-Host ""
    
    $success = Show-SessionFile -FilePath $sessionFile -ProjectType $projectType
    
    if ($success) {
        Write-Host ""
        Write-Host "🎩 WARP SPEED COMPLETE" -ForegroundColor Cyan
        Write-Host "Ready for AI assistance!" -ForegroundColor Green
        Write-Host ""
    }
}
else {
    Write-Host "❌ WARP-START-SESSION.md not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔍 Searched locations:" -ForegroundColor Yellow
    Write-Host "  • Current directory" -ForegroundColor Gray
    Write-Host "  • C:\Users\17274\ME\2829-Niagara-Street\" -ForegroundColor Gray
    Write-Host "  • All ME project subdirectories" -ForegroundColor Gray
    Write-Host "  • User profile directories" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💡 To create WARP-START-SESSION.md:" -ForegroundColor Cyan
    Write-Host "   Copy from existing project or create new from template" -ForegroundColor Gray
    Write-Host ""
}

# Display usage help
Write-Host "🛠️  Usage Options:" -ForegroundColor Magenta
Write-Host "   WarpSpeed              # Interactive project selection + session instructions" -ForegroundColor Gray
Write-Host "   WarpSpeed -QuickStart  # Skip project selection, show session file only" -ForegroundColor Gray
Write-Host "   WarpSpeed -ShowPath    # Show file location" -ForegroundColor Gray
Write-Host "   WarpSpeed -Update      # Update session timestamp" -ForegroundColor Gray
Write-Host "   WarpSpeed -Install     # Install globally in PowerShell profile" -ForegroundColor Gray
Write-Host ""
Write-Host "📋 Project Types:" -ForegroundColor Cyan
Write-Host "   NEW: First-time setup, README templates, universal files" -ForegroundColor Gray
Write-Host "   EXISTING: Continue work, TODO review, data validation" -ForegroundColor Gray
Write-Host "   ISSUES: Bug fixes, debugging checklist, numbered solutions" -ForegroundColor Gray
