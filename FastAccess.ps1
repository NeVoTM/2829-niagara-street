# FastAccess.ps1 - 100x Efficiency System for Warp Terminal
# Quick file and command access with smart caching and procedural rules

param(
    [string]$Mode = "menu",
    [string]$Query = "",
    [switch]$Files,
    [switch]$Commands,
    [switch]$Recent,
    [switch]$Cache
)

# Configuration
$script:ConfigPath = Join-Path $PSScriptRoot "fastaccess-config.json"
$script:CachePath = Join-Path $PSScriptRoot "fastaccess-cache.json"
$script:MaxRecentFiles = 20
$script:MaxRecentCommands = 30

# Initialize cache structure
function Initialize-Cache {
    $defaultCache = @{
        recentFiles = @()
        recentCommands = @()
        frequentCommands = @()
        bookmarkedPaths = @()
        lastUpdate = (Get-Date).ToString()
    }
    
    if (-not (Test-Path $script:CachePath)) {
        $defaultCache | ConvertTo-Json -Depth 3 | Set-Content $script:CachePath
    }
}

# Load cache
function Get-Cache {
    if (Test-Path $script:CachePath) {
        return Get-Content $script:CachePath | ConvertFrom-Json
    }
    return $null
}

# Save cache
function Set-Cache {
    param($CacheData)
    $CacheData.lastUpdate = (Get-Date).ToString()
    $CacheData | ConvertTo-Json -Depth 3 | Set-Content $script:CachePath
}

# Add file to recent cache
function Add-RecentFile {
    param([string]$FilePath)
    $cache = Get-Cache
    if ($cache) {
        $cache.recentFiles = @($FilePath) + ($cache.recentFiles | Where-Object { $_ -ne $FilePath } | Select-Object -First ($script:MaxRecentFiles - 1))
        Set-Cache $cache
    }
}

# Add command to recent cache
function Add-RecentCommand {
    param([string]$Command)
    $cache = Get-Cache
    if ($cache) {
        $cache.recentCommands = @($Command) + ($cache.recentCommands | Where-Object { $_ -ne $Command } | Select-Object -First ($script:MaxRecentCommands - 1))
        Set-Cache $cache
    }
}

# Smart file finder - finds files quickly with fuzzy matching
function Find-FilesQuick {
    param([string]$Query)
    
    Write-Host "🔍 QUICK FILE SEARCH: '$Query'" -ForegroundColor Cyan
    Write-Host "=" * 40 -ForegroundColor Blue
    
    # Search current directory first (most relevant)
    $currentFiles = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue | 
                   Where-Object { $_.Name -like "*$Query*" -or $_.Extension -like "*$Query*" } |
                   Select-Object -First 10
    
    if ($currentFiles) {
        Write-Host "`n📂 CURRENT DIRECTORY MATCHES:" -ForegroundColor Green
        $currentFiles | ForEach-Object { 
            $relativePath = Resolve-Path $_.FullName -Relative
            Write-Host "  $relativePath" -ForegroundColor White
            Add-RecentFile $_.FullName
        }
    }
    
    # Show recent files if query matches
    $cache = Get-Cache
    if ($cache -and $cache.recentFiles) {
        $recentMatches = $cache.recentFiles | Where-Object { $_ -like "*$Query*" } | Select-Object -First 5
        if ($recentMatches) {
            Write-Host "`n⏰ RECENT FILES MATCHING:" -ForegroundColor Yellow
            $recentMatches | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        }
    }
}

# Smart command finder - analyzes history and suggests commands
function Find-CommandsQuick {
    param([string]$Query)
    
    Write-Host "⚡ QUICK COMMAND SEARCH: '$Query'" -ForegroundColor Cyan
    Write-Host "=" * 40 -ForegroundColor Blue
    
    # Built-in command shortcuts
    $shortcuts = @{
        "git" = @("git status", "git --no-pager log --oneline -10", "git pull", "git push", "git add .", "git commit -m")
        "npm" = @("npm install", "npm start", "npm run build", "npm test", "npm run dev")
        "yarn" = @("yarn", "yarn start", "yarn build", "yarn test", "yarn dev")
        "docker" = @("docker ps", "docker images", "docker build .", "docker-compose up", "docker-compose down")
        "code" = @("code .", "code README.md", "code package.json")
        "ls" = @("ls -la", "Get-ChildItem", "dir")
        "find" = @("Get-ChildItem -Recurse", "Select-String -Pattern")
    }
    
    # Find matching shortcuts
    $matches = @()
    foreach ($key in $shortcuts.Keys) {
        if ($key -like "*$Query*" -or $Query -eq "") {
            $matches += $shortcuts[$key]
        }
    }
    
    if ($matches) {
        Write-Host "`n🚀 SUGGESTED COMMANDS:" -ForegroundColor Green
        $matches | Select-Object -First 10 | ForEach-Object {
            Write-Host "  $_" -ForegroundColor White
            Add-RecentCommand $_
        }
    }
    
    # Show recent commands
    $cache = Get-Cache
    if ($cache -and $cache.recentCommands) {
        $recentMatches = $cache.recentCommands | Where-Object { $_ -like "*$Query*" } | Select-Object -First 5
        if ($recentMatches) {
            Write-Host "`n⏰ RECENT COMMANDS:" -ForegroundColor Yellow
            $recentMatches | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        }
    }
}

# Display efficiency menu
function Show-EfficiencyMenu {
    Clear-Host
    Write-Host ""
    Write-Host "⚡ 100X EFFICIENCY SYSTEM" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Blue
    Write-Host ""
    Write-Host "🔥 INSTANT ACCESS COMMANDS:" -ForegroundColor Yellow
    Write-Host ""
    
    # File operations
    Write-Host "📂 FILES:" -ForegroundColor Green
    Write-Host "  f <name>     - Find files quickly" -ForegroundColor White
    Write-Host "  rf           - Recent files" -ForegroundColor White
    Write-Host "  code .       - Open current dir in VS Code" -ForegroundColor White
    Write-Host "  explorer .   - Open current dir in Explorer" -ForegroundColor White
    Write-Host ""
    
    # Command operations
    Write-Host "⚡ COMMANDS:" -ForegroundColor Green
    Write-Host "  c <term>     - Find commands quickly" -ForegroundColor White
    Write-Host "  rc           - Recent commands" -ForegroundColor White
    Write-Host "  h            - Command history search" -ForegroundColor White
    Write-Host ""
    
    # Project shortcuts
    Write-Host "🚀 PROJECT SHORTCUTS:" -ForegroundColor Green
    Write-Host "  gs           - git status" -ForegroundColor White
    Write-Host "  gl           - git log (last 10)" -ForegroundColor White
    Write-Host "  gp           - git pull" -ForegroundColor White
    Write-Host "  gpu          - git push" -ForegroundColor White
    Write-Host "  ni           - npm install" -ForegroundColor White
    Write-Host "  ns           - npm start" -ForegroundColor White
    Write-Host ""
    
    # Debug shortcuts
    Write-Host "🔧 DEBUG:" -ForegroundColor Green  
    Write-Host "  d check      - System health check" -ForegroundColor White
    Write-Host "  d port 3000  - Find port usage" -ForegroundColor White
    Write-Host "  d git        - Git status check" -ForegroundColor White
    Write-Host "  debug        - Full debug menu" -ForegroundColor White
    Write-Host ""
    
    # System shortcuts  
    Write-Host "🔧 SYSTEM:" -ForegroundColor Green
    Write-Host "  menu         - Show main menu" -ForegroundColor White
    Write-Host "  popup        - Open HTML popup" -ForegroundColor White
    Write-Host "  fast         - This efficiency menu" -ForegroundColor White
    Write-Host "  cls          - Clear screen" -ForegroundColor White
    Write-Host ""
    
    Write-Host "💡 USAGE: FastAccess f README  |  FastAccess c git" -ForegroundColor Cyan
    Write-Host "⚡ TIP: Create aliases for instant access!" -ForegroundColor Yellow
}

# Main execution logic
Initialize-Cache

switch ($Mode.ToLower()) {
    "f" { 
        if ($Query) { Find-FilesQuick $Query }
        else { Write-Host "Usage: FastAccess f <filename>" -ForegroundColor Yellow }
    }
    "c" { 
        if ($Query) { Find-CommandsQuick $Query }
        else { Find-CommandsQuick "" }
    }
    "rf" { 
        $cache = Get-Cache
        if ($cache -and $cache.recentFiles) {
            Write-Host "⏰ RECENT FILES:" -ForegroundColor Cyan
            $cache.recentFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        }
    }
    "rc" { 
        $cache = Get-Cache
        if ($cache -and $cache.recentCommands) {
            Write-Host "⏰ RECENT COMMANDS:" -ForegroundColor Cyan
            $cache.recentCommands | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        }
    }
    default { Show-EfficiencyMenu }
}