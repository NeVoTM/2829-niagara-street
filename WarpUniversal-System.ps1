# WarpUniversal-System.ps1
# Universal AI Debugging System for ALL Warp sessions
# GitHub-first, works anywhere, no browser dependency

param(
    [string]$Action = "menu",  # menu, debug, commands, files, refs, setup
    [string]$Project = "",     # Optional: specific project context
    [switch]$GitHubFirst = $true  # Always try GitHub first
)

# Universal configuration - works across ALL projects
$Global:UniversalConfig = @{
    GitHubUsername = "your-username"  # Update with your GitHub username
    CommonRepos = @(
        "2829-Niagara-Street",
        "warp-ai-toolkit", 
        "development-standards"
    )
    LocalProjectsRoot = "C:\Users\17274\ME"
    WarpDataFile = "$env:USERPROFILE\.warp-ai-universal.json"
}

function Show-UniversalMenu {
    Write-Host "🚀 UNIVERSAL WARP AI DEBUGGING SYSTEM" -ForegroundColor Cyan
    Write-Host "=====================================`n" -ForegroundColor Blue
    
    Write-Host "📋 Quick Actions:" -ForegroundColor Yellow
    Write-Host "  1. Debug Issues    (WarpDebug)" -ForegroundColor White
    Write-Host "  2. Command Browser (WarpCommands)" -ForegroundColor White  
    Write-Host "  3. File References (WarpFiles)" -ForegroundColor White
    Write-Host "  4. Number References (WarpRefs)" -ForegroundColor White
    Write-Host "  5. GitHub Sync     (WarpSync)" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🎯 Current Context:" -ForegroundColor Green
    Write-Host "  Project: $(Split-Path (Get-Location) -Leaf)" -ForegroundColor Gray
    Write-Host "  Mode: $(if($GitHubFirst){'GitHub-First'}else{'Local-Only'})" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "⚡ Global Hotkeys Available:" -ForegroundColor Magenta
    Write-Host "  Win+D - Debug Issues" -ForegroundColor Gray
    Write-Host "  Win+C - Commands" -ForegroundColor Gray
    Write-Host "  Win+F - Files" -ForegroundColor Gray
    Write-Host "  Win+R - References" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Enter choice (1-5) or press Enter for auto-detect"
    
    switch ($choice) {
        "1" { & $PSScriptRoot\QuickDebug-Dropdown.ps1 }
        "2" { & $PSScriptRoot\QuickCommands-Dropdown.ps1 }
        "3" { & $PSScriptRoot\QuickFiles-Dropdown.ps1 }
        "4" { & $PSScriptRoot\QuickReference-Selector.ps1 }
        "5" { Sync-GitHubData }
        default { Auto-DetectContext }
    }
}

function Get-UniversalData {
    param([string]$DataType, [string]$ProjectContext = "")
    
    # GitHub-first approach
    if ($GitHubFirst) {
        $githubData = Get-GitHubData -DataType $DataType -Project $ProjectContext
        if ($githubData) {
            Write-Host "✅ Data retrieved from GitHub" -ForegroundColor Green
            return $githubData
        }
    }
    
    # Fallback to local
    $localData = Get-LocalData -DataType $DataType -Project $ProjectContext
    if ($localData) {
        Write-Host "📁 Data retrieved from local files" -ForegroundColor Yellow
        return $localData
    }
    
    Write-Host "❌ No data found for $DataType" -ForegroundColor Red
    return $null
}

function Get-GitHubData {
    param([string]$DataType, [string]$Project)
    
    # Detect current project if not specified
    if (-not $Project) {
        $Project = Split-Path (Get-Location) -Leaf
    }
    
    $apiUrl = "https://api.github.com/repos/$($Global:UniversalConfig.GitHubUsername)/$Project/contents"
    
    try {
        # Try to fetch from GitHub API
        $response = Invoke-RestMethod -Uri $apiUrl -Headers @{
            'Accept' = 'application/vnd.github.v3+json'
            'User-Agent' = 'WarpAI-Universal-System'
        }
        
        # Filter for relevant files based on DataType
        $relevantFiles = switch ($DataType) {
            "debug" { $response | Where-Object { $_.name -match "(debug|issue|problem|error)" } }
            "commands" { $response | Where-Object { $_.name -match "(command|script|tool)" } }
            "files" { $response | Where-Object { $_.type -eq "file" } }
            "refs" { $response | Where-Object { $_.name -match "(ref|doc|readme)" } }
            default { $response }
        }
        
        return $relevantFiles
    }
    catch {
        Write-Host "⚠️ GitHub API error: $($_.Exception.Message)" -ForegroundColor Yellow
        return $null
    }
}

function Get-LocalData {
    param([string]$DataType, [string]$Project)
    
    $searchPaths = @(
        (Get-Location),
        "$($Global:UniversalConfig.LocalProjectsRoot)\$Project"
    )
    
    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            $files = Get-ChildItem -Path $path -Recurse -File | Where-Object {
                switch ($DataType) {
                    "debug" { $_.Name -match "(debug|issue|problem|error)" }
                    "commands" { $_.Name -match "(command|script|tool|\.ps1|\.bat)" }
                    "files" { $true }
                    "refs" { $_.Name -match "(ref|doc|readme|md)" }
                    default { $true }
                }
            }
            
            if ($files) { return $files }
        }
    }
    
    return $null
}

function Auto-DetectContext {
    Write-Host "🔍 Auto-detecting project context..." -ForegroundColor Cyan
    
    $currentDir = Get-Location
    $projectName = Split-Path $currentDir -Leaf
    
    # Check if we're in a known project
    if ($Global:UniversalConfig.CommonRepos -contains $projectName) {
        Write-Host "✅ Detected known project: $projectName" -ForegroundColor Green
        Sync-GitHubData -Project $projectName
    } else {
        Write-Host "📁 Unknown project, using local data only" -ForegroundColor Yellow
        Show-LocalFiles
    }
}

function Sync-GitHubData {
    param([string]$Project = "")
    
    Write-Host "🔄 Syncing with GitHub repositories..." -ForegroundColor Cyan
    
    foreach ($repo in $Global:UniversalConfig.CommonRepos) {
        $targetProject = if ($Project) { $Project } else { $repo }
        
        Write-Host "  📡 Syncing $targetProject..." -ForegroundColor Gray
        
        # Fetch latest data types
        $debugData = Get-GitHubData -DataType "debug" -Project $targetProject
        $commandData = Get-GitHubData -DataType "commands" -Project $targetProject
        $fileData = Get-GitHubData -DataType "files" -Project $targetProject
        
        # Cache locally for offline use
        $cacheData = @{
            Project = $targetProject
            LastSync = Get-Date
            DebugData = $debugData
            CommandData = $commandData
            FileData = $fileData
        }
        
        $cacheFile = "$env:TEMP\warp-cache-$targetProject.json"
        $cacheData | ConvertTo-Json -Depth 10 | Set-Content -Path $cacheFile
        
        Write-Host "  ✅ $targetProject cached locally" -ForegroundColor Green
    }
    
    Write-Host "🎉 GitHub sync complete!" -ForegroundColor Green
}

function Install-GlobalHotkeys {
    Write-Host "⚡ Installing global Windows hotkeys..." -ForegroundColor Cyan
    
    # Create global hotkey script
    $hotkeyScript = @"
# Global hotkeys for Warp AI Universal System
# Registers Win+D/C/F/R for universal access

Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class GlobalHotkey {
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
    
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    
    public static void RegisterWarpHotkeys() {
        // Win+D = Debug (91 = Win key, 0x44 = D)
        RegisterHotKey(IntPtr.Zero, 1, 0x0008, 0x44);
        // Win+C = Commands
        RegisterHotKey(IntPtr.Zero, 2, 0x0008, 0x43);
        // Win+F = Files  
        RegisterHotKey(IntPtr.Zero, 3, 0x0008, 0x46);
        // Win+R = References
        RegisterHotKey(IntPtr.Zero, 4, 0x0008, 0x52);
    }
}
'@

[GlobalHotkey]::RegisterWarpHotkeys()
Write-Host "Global hotkeys registered!"
"@
    
    $hotkeyScript | Set-Content -Path "$env:STARTUP\WarpAI-Hotkeys.ps1"
    Write-Host "✅ Global hotkeys will start with Windows" -ForegroundColor Green
}

# Main execution
switch ($Action.ToLower()) {
    "menu" { Show-UniversalMenu }
    "debug" { & $PSScriptRoot\QuickDebug-Dropdown.ps1 }
    "commands" { & $PSScriptRoot\QuickCommands-Dropdown.ps1 }
    "files" { & $PSScriptRoot\QuickFiles-Dropdown.ps1 }
    "refs" { & $PSScriptRoot\QuickReference-Selector.ps1 }
    "sync" { Sync-GitHubData -Project $Project }
    "setup" { Install-GlobalHotkeys }
    default { Show-UniversalMenu }
}

# Export functions for universal access
Export-ModuleMember -Function Show-UniversalMenu, Get-UniversalData, Sync-GitHubData