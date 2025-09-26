# WarpSpeed.ps1 - Warp AI Session Startup Script
# Automatically finds and displays WARP-START-SESSION.md from any location

param(
    [switch]$Install = $false,
    [switch]$ShowPath = $false,
    [switch]$Update = $false
)

# Function to display colorized header
function Show-WarpSpeedHeader {
    Write-Host ""
    Write-Host "🚀 WARP SPEED ACTIVATED" -ForegroundColor Cyan
    Write-Host "═══════════════════════" -ForegroundColor Blue
    Write-Host "Finding Warp AI session instructions..." -ForegroundColor Yellow
    Write-Host ""
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

# Function to display session file
function Show-SessionFile {
    param([string]$FilePath)
    
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
            elseif ($line -match '🔴|🟡|🔵|⚠️|✅|❌|📋|🚀|🎯') {
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

# Find and display session file
$sessionFile = Find-WarpSessionFile

if ($sessionFile) {
    Write-Host "✅ Found WARP-START-SESSION.md" -ForegroundColor Green
    if ($ShowPath) {
        Write-Host "📁 Location: $sessionFile" -ForegroundColor Magenta
    }
    Write-Host ""
    
    $success = Show-SessionFile -FilePath $sessionFile
    
    if ($success) {
        Write-Host ""
        Write-Host "🎯 WARP SPEED COMPLETE" -ForegroundColor Cyan
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
Write-Host "   WarpSpeed           # Display session instructions" -ForegroundColor Gray
Write-Host "   WarpSpeed -ShowPath # Show file location" -ForegroundColor Gray
Write-Host "   WarpSpeed -Update   # Update session timestamp" -ForegroundColor Gray
Write-Host "   WarpSpeed -Install  # Install globally in PowerShell profile" -ForegroundColor Gray