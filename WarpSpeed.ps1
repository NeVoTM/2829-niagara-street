# WarpSpeed.ps1 - Simplified Session Startup
# Downloads WARP-START-SESSION.md and TODO-LIST.md from GitHub
# Displays 13 critical rules

param(
    [switch]$ShowPath = $false
)

$gitHubBase = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main"
$complianceFolder = "warp-compliance"

Write-Host "`n🚀 WARP SPEED - SESSION STARTUP" -ForegroundColor Cyan
Write-Host "Downloading 2 files from GitHub...`n" -ForegroundColor Yellow

# Download WARP-START-SESSION.md
Write-Host "▶️  Downloading WARP-START-SESSION.md..." -ForegroundColor Yellow
try {
    $startSessionUrl = "$gitHubBase/$complianceFolder/WARP-START-SESSION.md"
    $startSessionContent = Invoke-RestMethod -Uri $startSessionUrl -TimeoutSec 10
    Write-Host "✅ WARP-START-SESSION.md downloaded" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download WARP-START-SESSION.md" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

# Download TODO-LIST.md
Write-Host "▶️  Downloading TODO-LIST.md..." -ForegroundColor Yellow
try {
    $todoUrl = "$gitHubBase/$complianceFolder/TODO-LIST.md"
    $todoContent = Invoke-RestMethod -Uri $todoUrl -TimeoutSec 10
    Write-Host "✅ TODO-LIST.md downloaded`n" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download TODO-LIST.md" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

# Display critical rules (Section 1.0)
Write-Host ("=" * 70) -ForegroundColor Magenta
Write-Host "🔴 SECTION 1.0: CRITICAL RULES (ALL 13 RULES)" -ForegroundColor Yellow
Write-Host ("=" * 70) -ForegroundColor Magenta
Write-Host ""
Write-Host "RULE 1.1   - GitHub-First Principle" -ForegroundColor Cyan
Write-Host "             Read/save GitHub BEFORE local files" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 1.1a  - Auto-Commit After Every Change" -ForegroundColor Cyan
Write-Host "             git add → commit → push (immediately)" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 1.4   - Authorization Code 2319 Required" -ForegroundColor Cyan
Write-Host "             Never edit rules without code 2319" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 1.5   - Verify Before Responding" -ForegroundColor Cyan
Write-Host "             Test changes before saying 'done'" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 1.6   - Rulescheck Command" -ForegroundColor Cyan
Write-Host "             Show violations only or 'All rules obeyed'" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 2.2   - Sequential Numbering" -ForegroundColor Cyan
Write-Host "             Use X.1, X.2, X.3... not letters" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.1   - Fix ALL Instances" -ForegroundColor Cyan
Write-Host "             Fix every occurrence, not just one" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.2   - Update Cross-References" -ForegroundColor Cyan
Write-Host "             Update ALL related files" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.3   - Consistent Patterns" -ForegroundColor Cyan
Write-Host "             Maintain consistency across elements" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.5   - Check PowerShell Profile for Duplicates" -ForegroundColor Cyan
Write-Host "             Check both scripts AND \$PROFILE" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.6   - Validate Scripts Before Sourcing" -ForegroundColor Cyan
Write-Host "             Read entire script first" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 4.7   - Read The Whole System First" -ForegroundColor Cyan
Write-Host "             Understand dependencies before changes" -ForegroundColor Gray
Write-Host ""
Write-Host "RULE 5.1   - Auto-Confirm Files After WarpSpeed" -ForegroundColor Cyan
Write-Host "             List files successfully loaded" -ForegroundColor Gray
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Magenta
Write-Host ""

# Save files locally for reference
$localCompliance = "C:\Users\17274\ME\2829-Niagara-Street\warp-compliance"
try {
    $startSessionContent | Out-File "$localCompliance\WARP-START-SESSION.md" -Encoding UTF8 -Force
    $todoContent | Out-File "$localCompliance\TODO-LIST.md" -Encoding UTF8 -Force
    Write-Host "✅ Files saved locally to $localCompliance" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not save files locally: $_" -ForegroundColor Yellow
}

# Open files in editor
Write-Host "`n📂 Opening reference files..." -ForegroundColor Cyan
if (Test-Path "$localCompliance\WARP-START-SESSION.md") {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process code "$localCompliance\WARP-START-SESSION.md"
        Start-Process code "$localCompliance\TODO-LIST.md"
        Write-Host "  ✅ Opened in VS Code" -ForegroundColor Green
    } else {
        Start-Process notepad "$localCompliance\WARP-START-SESSION.md"
        Start-Process notepad "$localCompliance\TODO-LIST.md"
        Write-Host "  ✅ Opened in Notepad" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Green
Write-Host "🚀 WARP SPEED COMPLETE - SESSION READY" -ForegroundColor Green
Write-Host ("=" * 70) -ForegroundColor Green
Write-Host ""
Write-Host "⚡ QUICK COMMANDS:" -ForegroundColor Cyan
Write-Host "   rulescheck  # Validate compliance" -ForegroundColor Gray
Write-Host "   clean       # Run health check" -ForegroundColor Gray
Write-Host "   eos         # End of session" -ForegroundColor Gray
Write-Host ""

# Set environment variable to signal completion
$env:WARP_GITHUB_FIRST = "true"
$env:WARP_SESSION_STARTED = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
