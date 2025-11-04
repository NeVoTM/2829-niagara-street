# SimpleDebug.ps1 - Easy debugging helper for late nights
# Just shows the most common issues you need

Write-Host ""
Write-Host "=== QUICK DEBUG REFERENCE ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "MOST COMMON ISSUES:" -ForegroundColor Yellow
Write-Host "4.1 - Infinite scroll: max-height: 100vh + overflow-y: auto" -ForegroundColor Green
Write-Host "4.2 - Chart sizing: max-height: 280px + maintainAspectRatio: false" -ForegroundColor Green  
Write-Host "4.3 - Alignment: Use separate tables for different contexts" -ForegroundColor Green
Write-Host "4.4 - Text visibility: text-shadow + increased opacity" -ForegroundColor Green
Write-Host "4.7 - Mobile usability: 44px touch targets + large icons" -ForegroundColor Green
Write-Host ""

Write-Host "AI COMMANDS TO USE:" -ForegroundColor Yellow
Write-Host "- Fix ISSUE 4.1 infinite scroll" -ForegroundColor White
Write-Host "- Fix ISSUE 4.2 chart sizing" -ForegroundColor White
Write-Host "- Fix ISSUE 4.3 alignment issues" -ForegroundColor White
Write-Host "- Fix ISSUE 4.4 text visibility" -ForegroundColor White
Write-Host "- Fix ISSUE 4.7 mobile usability" -ForegroundColor White
Write-Host ""

Write-Host "QUICK REMINDERS:" -ForegroundColor Yellow
Write-Host "- Always GitHub first, then local (never local first)" -ForegroundColor Cyan
Write-Host "- Use numbered references: SECTION X.X, ISSUE X.X" -ForegroundColor Cyan  
Write-Host "- Mobile-first: iPhone viewport priority" -ForegroundColor Cyan
Write-Host "- Revenue UP, costs precise" -ForegroundColor Cyan
Write-Host ""

Write-Host "VALIDATION:" -ForegroundColor Yellow
Write-Host ".\Update-ProjectData.ps1 -ValidateOnly" -ForegroundColor Green
Write-Host ""