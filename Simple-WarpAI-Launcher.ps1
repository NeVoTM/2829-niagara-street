# Simple-WarpAI-Launcher.ps1
# ONE HOTKEY: Win+W opens the Warp AI popup
# Simple, secure, works everywhere

param(
    [switch]$Install,
    [switch]$Remove,
    [switch]$Test
)

$PopupHtmlPath = Join-Path $PSScriptRoot "warp-ai-popup.html"

function Install-OneHotkey {
    Write-Host "🚀 Installing ONE simple hotkey: Win+W" -ForegroundColor Cyan
    
    # Create simple VBS script for the hotkey (avoids PowerShell security issues)
    $vbsScript = @"
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Wait for Win+W hotkey
Do
    ' Check if both Win key and W are pressed
    If GetAsyncKeyState(&H5B) < 0 And GetAsyncKeyState(&H57) < 0 Then
        ' Launch the popup
        WshShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command ""Start-Process '$PopupHtmlPath'""", 0, False
        
        ' Wait to avoid repeat triggers
        WScript.Sleep 1000
    End If
    
    WScript.Sleep 50
Loop

Function GetAsyncKeyState(vKey)
    GetAsyncKeyState = CreateObject("WScript.Shell").Exec("powershell.exe -Command ""Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class Win32{[DllImport(\""user32.dll\"")]public static extern short GetAsyncKeyState(int vKey);}';"[Win32]::GetAsyncKeyState(" & vKey & ")""").StdOut.ReadAll()
End Function
"@

    $vbsPath = "$env:TEMP\WarpAI-Hotkey.vbs"
    $vbsScript | Set-Content -Path $vbsPath
    
    # Create startup shortcut
    $startupPath = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupPath "WarpAI-OneHotkey.lnk"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "wscript.exe"
    $shortcut.Arguments = "`"$vbsPath`""
    $shortcut.WorkingDirectory = $PSScriptRoot
    $shortcut.Description = "WarpAI Win+W Hotkey"
    $shortcut.WindowStyle = 7  # Minimized
    $shortcut.Save()
    
    # Start the hotkey now
    Start-Process "wscript.exe" -ArgumentList "`"$vbsPath`"" -WindowStyle Hidden
    
    Write-Host "✅ Win+W hotkey installed!" -ForegroundColor Green
    Write-Host "🎯 Press Win+W anywhere to open Warp AI popup" -ForegroundColor Blue
}

function Remove-OneHotkey {
    Write-Host "🗑️ Removing WarpAI hotkey..." -ForegroundColor Yellow
    
    # Kill VBS process
    Get-Process -Name "wscript" -ErrorAction SilentlyContinue | 
        Where-Object { $_.CommandLine -like "*WarpAI-Hotkey*" } | 
        Stop-Process -Force
    
    # Remove files
    $vbsPath = "$env:TEMP\WarpAI-Hotkey.vbs"
    if (Test-Path $vbsPath) {
        Remove-Item $vbsPath -Force
    }
    
    $startupPath = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupPath "WarpAI-OneHotkey.lnk"
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
    }
    
    Write-Host "✅ Hotkey removed" -ForegroundColor Green
}

function Test-Popup {
    Write-Host "🧪 Testing popup..." -ForegroundColor Cyan
    
    if (-not (Test-Path $PopupHtmlPath)) {
        Write-Host "❌ Popup file not found: $PopupHtmlPath" -ForegroundColor Red
        return
    }
    
    Write-Host "🚀 Opening Warp AI popup..." -ForegroundColor Green
    Start-Process $PopupHtmlPath
    Write-Host "✅ If popup opened, Win+W hotkey will work the same way" -ForegroundColor Blue
}

# Main execution
if ($Install) {
    Install-OneHotkey
} elseif ($Remove) {
    Remove-OneHotkey  
} elseif ($Test) {
    Test-Popup
} else {
    Write-Host "🚀 Simple WarpAI Launcher" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "ONE HOTKEY: Win+W opens your AI popup" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Blue
    Write-Host "  -Install    Install Win+W hotkey" -ForegroundColor Gray
    Write-Host "  -Remove     Remove hotkey" -ForegroundColor Gray  
    Write-Host "  -Test       Test popup manually" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💡 After install, press Win+W anywhere to open popup" -ForegroundColor Green
}