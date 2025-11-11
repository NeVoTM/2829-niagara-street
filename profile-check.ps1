# profile-check.ps1 - Warp AI Profile Rules Loader
# Purpose: Load user profile rules and get Warp AI confirmation BEFORE running warpspeed

Write-Host ""
Write-Host "🧠 WARP AI PROFILE RULES LOADER" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════" -ForegroundColor Blue
Write-Host ""

$profilePath = "C:\Users\17274\ME\Scripts\New-Session-Instructions.md"

if (-not (Test-Path $profilePath)) {
    Write-Host "❌ Profile not found at: $profilePath" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host "📋 PROFILE LOCATION:" -ForegroundColor Cyan
Write-Host "   $profilePath" -ForegroundColor White
Write-Host ""

Write-Host "🤖 INSTRUCTION TO WARP AI:" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════" -ForegroundColor Blue
Write-Host ""
Write-Host "WARP AI: Please read the following file and confirm you will follow ALL rules:" -ForegroundColor White
Write-Host ""
Write-Host "   📄 $profilePath" -ForegroundColor Cyan
Write-Host ""
Write-Host "After reading, please respond with:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   'Confirmed: I've read your profile and will follow all preferences.'" -ForegroundColor Green
Write-Host ""
Write-Host "═══════════════════════════════════════" -ForegroundColor Blue
Write-Host ""
Write-Host "👉 USER ACTION REQUIRED:" -ForegroundColor Magenta
Write-Host "   1. Wait for Warp AI to read and confirm the profile" -ForegroundColor White
Write-Host "   2. Once confirmed, run: warpspeed" -ForegroundColor White
Write-Host ""
