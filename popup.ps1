# popup.ps1 - Simple command to open Warp AI popup
# Usage: .\popup.ps1 or just "popup" (if added to profile)

Write-Host "🚀 Opening Warp AI Popup..." -ForegroundColor Cyan

$popupHtml = Join-Path $PSScriptRoot "warp-ai-popup.html"

if (Test-Path $popupHtml) {
    Start-Process $popupHtml
    Write-Host "✅ Popup opened! Click any option to see commands." -ForegroundColor Green
} else {
    Write-Host "❌ Popup file not found: $popupHtml" -ForegroundColor Red
    Write-Host "💡 Make sure you're in the project directory." -ForegroundColor Yellow
}