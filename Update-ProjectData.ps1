# Project Data Integrity Update Script (PowerShell Version)
# This script reads project-data.json and validates data consistency
# Usage: .\Update-ProjectData.ps1

param(
    [switch]$ValidateOnly = $false
)

Write-Host "🚀 Starting Project Data Integrity Check..." -ForegroundColor Green

try {
    # Read project data
    if (-not (Test-Path "project-data.json")) {
        Write-Host "❌ project-data.json not found!" -ForegroundColor Red
        exit 1
    }

    $projectData = Get-Content "project-data.json" | ConvertFrom-Json
    Write-Host "📊 Project data loaded successfully" -ForegroundColor Green

    # Validate data consistency
    $issues = @()
    
    # Check revenue components
    $residential = [float]($projectData.units.residential.revenue -replace '\$|M', '')
    $str = [float]($projectData.units.str_hotel_rooms.revenue -replace '\$|M', '')
    $retail = [float]($projectData.units.retail.revenue -replace '\$|M', '')
    $totalRevenue = [float]($projectData.financial.total_revenue -replace '\$|M', '')
    
    $calculatedTotal = $residential + $str + $retail
    if ([Math]::Abs($calculatedTotal - $totalRevenue) -gt 0.5) {
        $issues += "Revenue mismatch: Components sum to ${calculatedTotal}M but total shows ${totalRevenue}M"
    }
    
    # Check cost components
    $hardCost = [float]($projectData.costs.hard_construction.amount -replace '\$|M', '')
    $softCost = [float]($projectData.costs.soft_costs.amount -replace '\$|M', '')
    $totalCost = [float]($projectData.financial.development_costs -replace '\$|M', '')
    
    $calculatedCosts = $hardCost + $softCost
    if ([Math]::Abs($calculatedCosts - $totalCost) -gt 0.1) {
        $issues += "Cost mismatch: Components sum to ${calculatedCosts}M but total shows ${totalCost}M"
    }

    # Report results
    if ($issues.Count -gt 0) {
        Write-Host "⚠️ Data consistency issues found:" -ForegroundColor Yellow
        $issues | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    } else {
        Write-Host "✅ Data consistency validation passed" -ForegroundColor Green
    }

    if ($ValidateOnly) {
        Write-Host "📝 Validation complete (no changes made)" -ForegroundColor Cyan
    } else {
        Write-Host "📄 HTML validation would require Node.js" -ForegroundColor Yellow
        Write-Host "💡 To install Node.js: Download from https://nodejs.org/" -ForegroundColor Cyan
        Write-Host "📝 For now, manually verify HTML matches project-data.json values" -ForegroundColor Yellow
    }

    Write-Host "🎉 Data integrity check completed" -ForegroundColor Green

} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}