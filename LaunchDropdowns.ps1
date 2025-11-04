# LaunchDropdowns.ps1 - Simple launcher for all dropdown tools
# Just run this and pick what you want

Write-Host ""
Write-Host "=== DROPDOWN TOOLS LAUNCHER ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Choose a dropdown tool:" -ForegroundColor Yellow
Write-Host ""
Write-Host "[1] Debug Issues - Show all debugging problems & solutions" -ForegroundColor Green
Write-Host "[2] All Commands - Browse all available commands with search" -ForegroundColor Green  
Write-Host "[3] Project Files - Browse and open project files" -ForegroundColor Green
Write-Host "[4] Quick Reference - Copy numbered AI commands to clipboard" -ForegroundColor Green
Write-Host "[5] Exit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    "1" { 
        Write-Host "Opening Debug Issues dropdown..." -ForegroundColor Green
        & ".\QuickDebug-Dropdown.ps1"
    }
    "2" { 
        Write-Host "Opening Commands Browser..." -ForegroundColor Green
        & ".\QuickCommands-Dropdown.ps1"
    }
    "3" { 
        Write-Host "Opening Files Browser..." -ForegroundColor Green
        & ".\QuickFiles-Dropdown.ps1"
    }
    "4" { 
        Write-Host "Opening Reference Selector..." -ForegroundColor Green
        & ".\QuickReference-Selector.ps1"
    }
    "5" { 
        Write-Host "Goodbye!" -ForegroundColor Gray
        return 
    }
    default { 
        Write-Host "Invalid choice. Please select 1-5." -ForegroundColor Red
        & ".\LaunchDropdowns.ps1"
    }
}