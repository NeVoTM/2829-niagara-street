# StartVisual.ps1 - Simple Visual Interface Launcher
# Opens the SuperDebug.html file directly in browser

Write-Host "🚀 OPENING VISUAL DEBUG INTERFACE..." -ForegroundColor Cyan

$htmlPath = Join-Path $PSScriptRoot "SuperDebug.html" 
$fullPath = "file:///" + $htmlPath.Replace("\", "/")

Write-Host "📂 Opening: $fullPath" -ForegroundColor Green

Start-Process $fullPath

Write-Host "✅ Visual interface opened in browser!" -ForegroundColor Green
Write-Host "🎯 Use the file cabinet tabs to navigate" -ForegroundColor Yellow
Write-Host "⌨️  Keyboard shortcuts: Ctrl+1,2,3,4" -ForegroundColor Cyan