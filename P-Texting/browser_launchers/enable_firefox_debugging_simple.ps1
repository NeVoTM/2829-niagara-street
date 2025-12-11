# Enable Firefox Remote Debugging - Simple Version

Write-Host "Firefox Remote Debugging Auto-Config" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if Firefox is running
$firefox = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefox) {
    Write-Host "ERROR: Please close Firefox first!" -ForegroundColor Red
    pause
    exit 1
}

# Find Firefox profile
$profilesPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (!(Test-Path $profilesPath)) {
    Write-Host "ERROR: Firefox profiles not found at: $profilesPath" -ForegroundColor Red
    pause
    exit 1
}

$profile = Get-ChildItem $profilesPath -Directory | Where-Object { $_.Name -like "*.default*" } | Select-Object -First 1
if (!$profile) {
    Write-Host "ERROR: No Firefox profile found!" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Found profile: $($profile.Name)" -ForegroundColor Green
Write-Host ""

# Create user.js with settings
$userJs = Join-Path $profile.FullName "user.js"
$content = 'user_pref("devtools.debugger.remote-enabled", true);' + "`n"
$content += 'user_pref("devtools.chrome.enabled", true);' + "`n"
$content += 'user_pref("devtools.debugger.prompt-connection", false);' + "`n"

Set-Content -Path $userJs -Value $content -Force

Write-Host "SUCCESS! Firefox configured for remote debugging" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run start_firefox_debug.bat"
Write-Host "2. Go to voice.google.com/messages"
Write-Host "3. Use P-Texting GUI with Firefox selected"
Write-Host ""
pause
