# DebugToolbox.ps1 - Simple Debugging Where Rubber Meets Steel
# Rule: Simple is always better | Start small and grow
# Quick, practical debugging tools that solve real problems NOW

param(
    [string]$Action = "menu",
    [string]$Target = "",
    [switch]$Quick,
    [switch]$Deep
)

# Simple error patterns - most common issues
$script:ErrorPatterns = @{
    "Cannot find path" = @{
        Solution = "Check if file/folder exists. Use Test-Path or ls to verify."
        Command = "Test-Path `"`$Target`""
    }
    "Access denied" = @{
        Solution = "Run as administrator or check file permissions."
        Command = "Get-Acl `"`$Target`" | Format-List"
    }
    "Port already in use" = @{
        Solution = "Find and kill process using the port."
        Command = "netstat -ano | findstr :3000"
    }
    "Module not found" = @{
        Solution = "Install missing module or check import path."
        Command = "npm list | yarn list | pip list"
    }
    "Git error" = @{
        Solution = "Check git status and recent changes."
        Command = "git status && git --no-pager log --oneline -3"
    }
    "Layout border overlap" = @{
        Solution = "CSS borders or margins are overlapping text content. Check border-box sizing, margins, and padding."
        Command = "Inspect element in browser dev tools -> Check CSS: margin, padding, border-box"
    }
    "Text alignment error" = @{
        Solution = "Text alignment issues due to CSS conflicts or missing container constraints."
        Command = "Check CSS: text-align, display, flex properties -> Validate container width/height"
    }
    "Hover tooltip issues" = @{
        Solution = "Tooltip positioning, z-index conflicts, or hover state problems. Check CSS positioning and mouse event handling."
        Command = "Check CSS: position, z-index, pointer-events -> Validate hover pseudo-class"
    }
}

# Quick system check - the basics that matter
function Quick-SystemCheck {
    Write-Host "🔍 QUICK SYSTEM CHECK" -ForegroundColor Cyan
    Write-Host "=" * 25 -ForegroundColor Blue
    
    # Disk space
    $disk = Get-PSDrive C
    $freeGB = [math]::Round($disk.Free / 1GB, 1)
    Write-Host "💾 Disk Space: $freeGB GB free" -ForegroundColor $(if($freeGB -lt 5){"Red"}else{"Green"})
    
    # Memory
    $mem = Get-WmiObject Win32_OperatingSystem
    $freeMemGB = [math]::Round($mem.FreePhysicalMemory / 1MB, 1)
    Write-Host "🧠 Memory: $freeMemGB GB free" -ForegroundColor $(if($freeMemGB -lt 2){"Red"}else{"Green"})
    
    # Network
    $ping = Test-Connection google.com -Count 1 -Quiet
    Write-Host "🌐 Network: $(if($ping){'Connected'}else{'Offline'})" -ForegroundColor $(if($ping){"Green"}else{"Red"})
    
    # Current processes (top 3 CPU)
    $topProcs = Get-Process | Sort-Object CPU -Descending | Select-Object -First 3 Name, CPU
    Write-Host "`n🔥 Top CPU Processes:" -ForegroundColor Yellow
    $topProcs | ForEach-Object { Write-Host "   $($_.Name): $([math]::Round($_.CPU, 1))" -ForegroundColor White }
}

# Smart error lookup - match error to solution
function Find-ErrorSolution {
    param([string]$ErrorText)
    
    Write-Host "🚨 ERROR SOLUTION FINDER" -ForegroundColor Red
    Write-Host "=" * 30 -ForegroundColor Blue
    Write-Host "Searching for: '$ErrorText'" -ForegroundColor Yellow
    
    $found = $false
    foreach ($pattern in $script:ErrorPatterns.Keys) {
        if ($ErrorText -like "*$pattern*") {
            $found = $true
            Write-Host "`n✅ MATCH FOUND:" -ForegroundColor Green
            Write-Host "Problem: $pattern" -ForegroundColor White
            Write-Host "Solution: $($script:ErrorPatterns[$pattern].Solution)" -ForegroundColor Cyan
            Write-Host "Try: $($script:ErrorPatterns[$pattern].Command)" -ForegroundColor Yellow
            break
        }
    }
    
    if (-not $found) {
        Write-Host "`n❓ No exact match found." -ForegroundColor Yellow
        Write-Host "💡 Try these common fixes:" -ForegroundColor Cyan
        Write-Host "   • Restart the application" -ForegroundColor White
        Write-Host "   • Check file paths and permissions" -ForegroundColor White
        Write-Host "   • Update dependencies (npm/pip/etc)" -ForegroundColor White
        Write-Host "   • Check system resources" -ForegroundColor White
    }
}

# Port detective - find what's using a port
function Find-PortUsage {
    param([string]$Port = "3000")
    
    Write-Host "🔍 PORT DETECTIVE: $Port" -ForegroundColor Cyan
    Write-Host "=" * 25 -ForegroundColor Blue
    
    $result = netstat -ano | Select-String ":$Port "
    if ($result) {
        Write-Host "🎯 Port $Port is in use:" -ForegroundColor Red
        $result | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
        
        # Extract PID and show process
        $pid = ($result[0] -split '\s+')[-1]
        if ($pid -match '^\d+$') {
            $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "`n📱 Process: $($process.Name) (PID: $pid)" -ForegroundColor Yellow
                Write-Host "💡 To kill: Stop-Process -Id $pid" -ForegroundColor Cyan
            }
        }
    } else {
        Write-Host "✅ Port $Port is available" -ForegroundColor Green
    }
}

# Quick file detective
function Check-File {
    param([string]$FilePath)
    
    if (-not $FilePath) {
        Write-Host "Usage: DebugToolbox file <filepath>" -ForegroundColor Yellow
        return
    }
    
    Write-Host "📁 FILE DETECTIVE: $FilePath" -ForegroundColor Cyan
    Write-Host "=" * 30 -ForegroundColor Blue
    
    if (Test-Path $FilePath) {
        $file = Get-Item $FilePath
        Write-Host "✅ File exists" -ForegroundColor Green
        Write-Host "📏 Size: $([math]::Round($file.Length/1KB, 1)) KB" -ForegroundColor White
        Write-Host "📅 Modified: $($file.LastWriteTime)" -ForegroundColor White
        Write-Host "🔒 Attributes: $($file.Attributes)" -ForegroundColor White
        
        # Check if it's a text file and show first few lines
        if ($file.Extension -in @('.txt', '.md', '.json', '.js', '.ts', '.py', '.ps1', '.html', '.css')) {
            Write-Host "`n👀 First 3 lines:" -ForegroundColor Yellow
            Get-Content $FilePath -TotalCount 3 | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
        }
    } else {
        Write-Host "❌ File not found" -ForegroundColor Red
        Write-Host "💡 Checking similar files..." -ForegroundColor Yellow
        
        $dir = Split-Path $FilePath -Parent
        $name = Split-Path $FilePath -LeafBase
        if ($dir -and (Test-Path $dir)) {
            $similar = Get-ChildItem $dir -File | Where-Object { $_.BaseName -like "*$name*" } | Select-Object -First 3
            if ($similar) {
                Write-Host "🔍 Similar files found:" -ForegroundColor Cyan
                $similar | ForEach-Object { Write-Host "   $($_.Name)" -ForegroundColor White }
            }
        }
    }
}

# Show simple debugging menu
function Show-DebugMenu {
    Clear-Host
    Write-Host ""
    Write-Host "🔧 DEBUG TOOLBOX - Rubber Meets Steel" -ForegroundColor Red
    Write-Host "====================================" -ForegroundColor Blue
    Write-Host ""
    Write-Host "🚀 QUICK ACTIONS:" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "📊 SYSTEM:" -ForegroundColor Green
    Write-Host "  check        - Quick system health check" -ForegroundColor White
    Write-Host "  port 3000    - Find what's using port 3000" -ForegroundColor White
    Write-Host "  file <path>  - Check file status and info" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🚨 ERRORS:" -ForegroundColor Green  
    Write-Host "  error <text> - Find solution for error message" -ForegroundColor White
    Write-Host "  git          - Quick git status and recent changes" -ForegroundColor White
    Write-Host "  npm          - Check npm/node issues" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🔍 EXAMPLES:" -ForegroundColor Cyan
    Write-Host "  .\\DebugToolbox check" -ForegroundColor Gray
    Write-Host "  .\\DebugToolbox error \"Cannot find module\"" -ForegroundColor Gray  
    Write-Host "  .\\DebugToolbox port 8080" -ForegroundColor Gray
    Write-Host "  .\\DebugToolbox file README.md" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "💡 TIP: Start with 'check' for system overview!" -ForegroundColor Yellow
}

# Main execution
switch ($Action.ToLower()) {
    "check" { Quick-SystemCheck }
    "error" { Find-ErrorSolution $Target }
    "port" { Find-PortUsage $Target }
    "file" { Check-File $Target }
    "git" { 
        Write-Host "🔍 GIT STATUS CHECK" -ForegroundColor Cyan
        git status
        Write-Host "`n📝 Last 3 commits:" -ForegroundColor Yellow
        git --no-pager log --oneline -3
    }
    "npm" {
        Write-Host "📦 NPM/NODE CHECK" -ForegroundColor Cyan
        if (Get-Command node -ErrorAction SilentlyContinue) {
            Write-Host "Node: $(node --version)" -ForegroundColor Green
            Write-Host "NPM: $(npm --version)" -ForegroundColor Green
        } else {
            Write-Host "❌ Node.js not found" -ForegroundColor Red
        }
        
        if (Test-Path "package.json") {
            Write-Host "`n📋 Package.json exists" -ForegroundColor Green
            Write-Host "💡 Try: npm install" -ForegroundColor Yellow
        }
    }
    default { Show-DebugMenu }
}