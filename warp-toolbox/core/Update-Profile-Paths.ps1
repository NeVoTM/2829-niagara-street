# UPDATE POWERSHELL PROFILE WITH NEW PATHS
# Updates profile to point to new git-based structure

Write-Host "🔧 UPDATING POWERSHELL PROFILE PATHS..." -ForegroundColor Cyan

$profilePath = $PROFILE
$newQuickStartPath = "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\QuickStart.ps1"

if (Test-Path $profilePath) {
    $content = Get-Content $profilePath -Raw
    
    # Replace old paths with new ones
    $content = $content -replace 'C:\\Users\\17274\\ME\\super-ai-toolbox\\core', 'C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core'
    
    $content | Set-Content $profilePath -Encoding UTF8
    
    Write-Host "✅ Profile updated with new paths" -ForegroundColor Green
    Write-Host "💡 Run: . `$PROFILE  (to reload)" -ForegroundColor Yellow
} else {
    Write-Host "⚠️ Profile not found at: $profilePath" -ForegroundColor Yellow
}
