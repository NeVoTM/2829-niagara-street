# WarpAI-Hotkey-Launcher.ps1
# Universal Windows hotkey system for HTML popup
# Works with ANY browser - Chrome, Firefox, Edge, Safari

param(
    [switch]$Install,   # Install global hotkeys
    [switch]$Remove,    # Remove global hotkeys  
    [string]$Action = "popup"  # popup, debug, commands, files, refs, github
)

$PopupHtmlPath = Join-Path $PSScriptRoot "warp-ai-popup.html"
$HotkeyServicePath = "$env:TEMP\WarpAI-HotkeyService.ps1"

function Install-GlobalHotkeys {
    Write-Host "⚡ Installing Universal Windows Hotkeys..." -ForegroundColor Cyan
    
    # Create hotkey service script
    $hotkeyServiceScript = @"
# WarpAI Global Hotkey Service
# Registers system-wide Windows hotkeys

Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class WarpHotkeys {
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
    
    [DllImport("user32.dll")] 
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    
    public const int MOD_WIN = 0x0008;    // Windows key
    public const int MOD_CTRL = 0x0002;   // Ctrl key
    public const int MOD_ALT = 0x0001;    // Alt key
    
    // Key codes
    public const int VK_D = 0x44; // D key
    public const int VK_1 = 0x31; // 1 key
    public const int VK_2 = 0x32; // 2 key  
    public const int VK_3 = 0x33; // 3 key
    public const int VK_4 = 0x34; // 4 key
    public const int VK_G = 0x47; // G key
    
    public static void RegisterWarpHotkeys() {
        IntPtr hwnd = GetConsoleWindow();
        
        // Register hotkeys
        RegisterHotKey(hwnd, 1, MOD_WIN, VK_D);  // Win+D = Main popup
        RegisterHotKey(hwnd, 2, MOD_WIN, VK_1);  // Win+1 = Debug
        RegisterHotKey(hwnd, 3, MOD_WIN, VK_2);  // Win+2 = Commands  
        RegisterHotKey(hwnd, 4, MOD_WIN, VK_3);  // Win+3 = Files
        RegisterHotKey(hwnd, 5, MOD_WIN, VK_4);  // Win+4 = References
        RegisterHotKey(hwnd, 6, MOD_WIN, VK_G);  // Win+G = GitHub
    }
    
    public static void UnregisterWarpHotkeys() {
        IntPtr hwnd = GetConsoleWindow();
        for(int i = 1; i <= 6; i++) {
            UnregisterHotKey(hwnd, i);
        }
    }
}
'@

# Register hotkeys
[WarpHotkeys]::RegisterWarpHotkeys()

Write-Host "🔥 Global hotkeys registered:" -ForegroundColor Green
Write-Host "  Win+D = Main Popup" -ForegroundColor Gray
Write-Host "  Win+1 = Debug Issues" -ForegroundColor Gray
Write-Host "  Win+2 = Commands Browser" -ForegroundColor Gray
Write-Host "  Win+3 = Files Browser" -ForegroundColor Gray
Write-Host "  Win+4 = References" -ForegroundColor Gray
Write-Host "  Win+G = GitHub Sync" -ForegroundColor Gray

# Message loop to handle hotkeys
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::AddMessageFilter({
    param(`$m)
    
    if (`$m.Msg -eq 0x0312) { # WM_HOTKEY
        `$hotkeyId = `$m.WParam.ToInt32()
        
        switch(`$hotkeyId) {
            1 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action popup" }
            2 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action debug" }
            3 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action commands" }
            4 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action files" }
            5 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action refs" }
            6 { Start-Process "powershell.exe" "-WindowStyle Hidden -File '$PSScriptRoot\WarpAI-Hotkey-Launcher.ps1' -Action github" }
        }
    }
    
    return `$false
})

# Keep the service running
Write-Host "🔄 Hotkey service running... Press Ctrl+C to stop" -ForegroundColor Blue

try {
    [System.Windows.Forms.Application]::Run()
} finally {
    [WarpHotkeys]::UnregisterWarpHotkeys()
    Write-Host "✅ Hotkeys unregistered" -ForegroundColor Green
}
"@

    # Save the hotkey service
    $hotkeyServiceScript | Set-Content -Path $HotkeyServicePath -Encoding UTF8
    
    # Create startup shortcut
    $startupPath = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupPath "WarpAI-Hotkeys.lnk"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$HotkeyServicePath`""
    $shortcut.WorkingDirectory = $PSScriptRoot
    $shortcut.Description = "WarpAI Global Hotkeys"
    $shortcut.Save()
    
    Write-Host "✅ Hotkey service installed to startup folder" -ForegroundColor Green
    Write-Host "📍 Service will start automatically on Windows boot" -ForegroundColor Blue
    
    # Start the service now
    Write-Host "🚀 Starting hotkey service..." -ForegroundColor Cyan
    Start-Process "powershell.exe" -ArgumentList "-WindowStyle Minimized -ExecutionPolicy Bypass -File `"$HotkeyServicePath`""
    
    Write-Host "🎉 Installation complete! Try Win+D to open the popup" -ForegroundColor Green
}

function Remove-GlobalHotkeys {
    Write-Host "🗑️ Removing WarpAI hotkeys..." -ForegroundColor Yellow
    
    # Remove startup shortcut
    $startupPath = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupPath "WarpAI-Hotkeys.lnk"
    
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "✅ Startup shortcut removed" -ForegroundColor Green
    }
    
    # Kill running hotkey service
    Get-Process -Name "powershell" -ErrorAction SilentlyContinue | 
        Where-Object { $_.CommandLine -like "*WarpAI-HotkeyService*" } | 
        Stop-Process -Force
    
    # Remove service file
    if (Test-Path $HotkeyServicePath) {
        Remove-Item $HotkeyServicePath -Force
        Write-Host "✅ Hotkey service removed" -ForegroundColor Green
    }
    
    Write-Host "🎯 WarpAI hotkeys completely removed" -ForegroundColor Green
}

function Open-WarpPopup {
    param([string]$DirectAction = "")
    
    if (-not (Test-Path $PopupHtmlPath)) {
        Write-Host "❌ Popup HTML file not found: $PopupHtmlPath" -ForegroundColor Red
        return
    }
    
    # Build URL with parameters
    $fileUrl = "file:///$($PopupHtmlPath.Replace('\', '/').Replace(' ', '%20'))"
    if ($DirectAction) {
        $fileUrl += "?action=$DirectAction"
    }
    
    Write-Host "🚀 Opening Warp AI Popup..." -ForegroundColor Cyan
    Write-Host "📂 URL: $fileUrl" -ForegroundColor Gray
    
    # Try multiple browsers in order of preference
    $browsers = @(
        @{Name="Chrome"; Path="chrome.exe"; Args="--new-window --app=`"$fileUrl`""},
        @{Name="Firefox"; Path="firefox.exe"; Args="-new-window `"$fileUrl`""},
        @{Name="Edge"; Path="msedge.exe"; Args="--new-window --app=`"$fileUrl`""},
        @{Name="Default"; Path="start"; Args="`"$fileUrl`""}
    )
    
    foreach ($browser in $browsers) {
        try {
            if ($browser.Name -eq "Default") {
                # Use default browser
                Start-Process $fileUrl
                Write-Host "✅ Opened in default browser" -ForegroundColor Green
                return
            } else {
                # Try specific browser
                $process = Get-Command $browser.Path -ErrorAction SilentlyContinue
                if ($process) {
                    Start-Process $browser.Path -ArgumentList $browser.Args
                    Write-Host "✅ Opened in $($browser.Name)" -ForegroundColor Green
                    return
                }
            }
        }
        catch {
            continue
        }
    }
    
    Write-Host "❌ Could not open popup in any browser" -ForegroundColor Red
}

function Launch-DirectAction {
    param([string]$ActionType)
    
    $actions = @{
        debug = "QuickDebug-Dropdown.ps1"
        commands = "QuickCommands-Dropdown.ps1" 
        files = "QuickFiles-Dropdown.ps1"
        refs = "QuickReference-Selector.ps1"
        github = "sync"
    }
    
    if ($actions.ContainsKey($ActionType)) {
        if ($ActionType -eq "github") {
            Write-Host "🌐 GitHub sync not implemented in direct mode" -ForegroundColor Yellow
            Write-Host "💡 Use Win+D to open popup for GitHub sync" -ForegroundColor Blue
        } else {
            $scriptPath = Join-Path $PSScriptRoot $actions[$ActionType]
            if (Test-Path $scriptPath) {
                Write-Host "⚡ Launching $ActionType directly..." -ForegroundColor Cyan
                & $scriptPath
            } else {
                Write-Host "❌ Script not found: $scriptPath" -ForegroundColor Red
            }
        }
    }
}

# Main execution
switch ($true) {
    $Install { Install-GlobalHotkeys }
    $Remove { Remove-GlobalHotkeys }
    ($Action -eq "popup") { Open-WarpPopup }
    ($Action -in @("debug", "commands", "files", "refs", "github")) { 
        # For direct actions, still open popup but with pre-selection
        Open-WarpPopup -DirectAction $Action 
    }
    default { 
        Write-Host "🚀 WarpAI Hotkey Launcher" -ForegroundColor Cyan
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  -Install    Install global hotkeys" -ForegroundColor Gray
        Write-Host "  -Remove     Remove global hotkeys" -ForegroundColor Gray
        Write-Host "  -Action     popup|debug|commands|files|refs|github" -ForegroundColor Gray
    }
}