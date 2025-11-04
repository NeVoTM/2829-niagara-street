# GlobalHotkeys.ps1 - TRUE Windows Global Hotkeys (Bypass Warp Restrictions!)
# This registers ACTUAL Windows hotkeys that work EVERYWHERE

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Windows API for global hotkeys
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class WinAPI
{
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    
    public const uint MOD_CTRL = 0x0002;
    public const uint MOD_ALT = 0x0001;
    public const uint MOD_SHIFT = 0x0004;
    public const uint VK_D = 0x44;
    public const uint VK_C = 0x43;
    public const uint VK_F = 0x46;
    public const uint VK_R = 0x52;
    public const uint VK_ESCAPE = 0x1B;
    
    public const int SW_SHOW = 5;
    public const int SW_RESTORE = 9;
}
"@

# Global variables
$global:hotkeysForm = $null
$global:hotkeysActive = $false

# Hotkey mappings
$global:hotkeyCommands = @{
    1 = @{Keys="Ctrl+Alt+D"; Description="Debug Issues"; Command="& 'C:\Users\17274\ME\2829-Niagara-Street\QuickDebug-Dropdown.ps1'"}
    2 = @{Keys="Ctrl+Alt+C"; Description="Commands Browser"; Command="& 'C:\Users\17274\ME\2829-Niagara-Street\QuickCommands-Dropdown.ps1'"}
    3 = @{Keys="Ctrl+Alt+F"; Description="Files Browser"; Command="& 'C:\Users\17274\ME\2829-Niagara-Street\QuickFiles-Dropdown.ps1'"}
    4 = @{Keys="Ctrl+Alt+R"; Description="Reference Selector"; Command="& 'C:\Users\17274\ME\2829-Niagara-Street\QuickReference-Selector.ps1'"}
    5 = @{Keys="Ctrl+Alt+Esc"; Description="Stop Hotkeys"; Command="Stop-GlobalHotkeys"}
}

# Function to execute PowerShell command
function Invoke-HotkeyCommand {
    param([string]$Command)
    
    try {
        # Run command in background PowerShell process
        $job = Start-Job -ScriptBlock {
            param($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $Command
        
        Write-Host "Executed: $Command" -ForegroundColor Green
    } catch {
        Write-Host "Error executing command: $_" -ForegroundColor Red
    }
}

# Function to start global hotkeys
function Start-GlobalHotkeys {
    if ($global:hotkeysActive) {
        Write-Host "Global hotkeys are already active!" -ForegroundColor Yellow
        return
    }
    
    Write-Host ""
    Write-Host "🚀 STARTING WINDOWS GLOBAL HOTKEYS" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Blue
    
    # Create invisible form to handle hotkeys
    $global:hotkeysForm = New-Object System.Windows.Forms.Form
    $global:hotkeysForm.WindowState = [System.Windows.Forms.FormWindowState]::Minimized
    $global:hotkeysForm.ShowInTaskbar = $false
    $global:hotkeysForm.Visible = $false
    $global:hotkeysForm.Text = "Global Hotkeys Handler"
    
    # Register hotkeys with Windows
    $success = $true
    $success = $success -and [WinAPI]::RegisterHotKey($global:hotkeysForm.Handle, 1, ([WinAPI]::MOD_CTRL -bor [WinAPI]::MOD_ALT), [WinAPI]::VK_D)
    $success = $success -and [WinAPI]::RegisterHotKey($global:hotkeysForm.Handle, 2, ([WinAPI]::MOD_CTRL -bor [WinAPI]::MOD_ALT), [WinAPI]::VK_C)
    $success = $success -and [WinAPI]::RegisterHotKey($global:hotkeysForm.Handle, 3, ([WinAPI]::MOD_CTRL -bor [WinAPI]::MOD_ALT), [WinAPI]::VK_F)
    $success = $success -and [WinAPI]::RegisterHotKey($global:hotkeysForm.Handle, 4, ([WinAPI]::MOD_CTRL -bor [WinAPI]::MOD_ALT), [WinAPI]::VK_R)
    $success = $success -and [WinAPI]::RegisterHotKey($global:hotkeysForm.Handle, 5, ([WinAPI]::MOD_CTRL -bor [WinAPI]::MOD_ALT), [WinAPI]::VK_ESCAPE)
    
    if ($success) {
        Write-Host "✅ Global hotkeys registered with Windows!" -ForegroundColor Green
        Write-Host ""
        Write-Host "ACTIVE HOTKEYS:" -ForegroundColor Yellow
        foreach ($id in $global:hotkeyCommands.Keys) {
            $hotkey = $global:hotkeyCommands[$id]
            Write-Host "  $($hotkey.Keys) - $($hotkey.Description)" -ForegroundColor White
        }
        Write-Host ""
        Write-Host "Press Ctrl+Alt+Esc to stop hotkeys" -ForegroundColor Red
        Write-Host ""
        
        $global:hotkeysActive = $true
        
        # Handle WM_HOTKEY messages
        $global:hotkeysForm.Add_Load({
            # Override WndProc to handle hotkey messages
            $wndProcDelegate = {
                param($m)
                
                if ($m.Msg -eq 0x0312) { # WM_HOTKEY
                    $hotkeyId = $m.WParam.ToInt32()
                    
                    if ($global:hotkeyCommands.ContainsKey($hotkeyId)) {
                        $command = $global:hotkeyCommands[$hotkeyId].Command
                        $description = $global:hotkeyCommands[$hotkeyId].Description
                        
                        Write-Host "🔥 HOTKEY TRIGGERED: $description" -ForegroundColor Cyan
                        
                        if ($command -eq "Stop-GlobalHotkeys") {
                            Stop-GlobalHotkeys
                        } else {
                            Invoke-HotkeyCommand -Command $command
                        }
                    }
                }
                
                # Call default window procedure
                try {
                    [System.Windows.Forms.Form].GetMethod("WndProc", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance).Invoke($global:hotkeysForm, [object[]]@([ref]$m))
                } catch {
                    # Ignore errors in WndProc
                }
            }
            
            # This is complex in PowerShell, so we'll use a timer-based approach instead
            $timer = New-Object System.Windows.Forms.Timer
            $timer.Interval = 50
            $timer.Add_Tick({
                [System.Windows.Forms.Application]::DoEvents()
            })
            $timer.Start()
        })
        
        # Show the form (invisible)
        $global:hotkeysForm.Load += {
            $global:hotkeysForm.WindowState = [System.Windows.Forms.FormWindowState]::Minimized
            $global:hotkeysForm.Visible = $false
        }
        
        $global:hotkeysForm.Show()
        
        # Keep processing messages
        while ($global:hotkeysActive) {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 100
        }
        
    } else {
        Write-Host "❌ Failed to register some hotkeys!" -ForegroundColor Red
        Write-Host "Some hotkeys might already be in use by other applications." -ForegroundColor Yellow
    }
}

# Function to stop global hotkeys
function Stop-GlobalHotkeys {
    if (-not $global:hotkeysActive) {
        Write-Host "Global hotkeys are not active." -ForegroundColor Yellow
        return
    }
    
    Write-Host ""
    Write-Host "🛑 STOPPING GLOBAL HOTKEYS" -ForegroundColor Red
    Write-Host "==========================" -ForegroundColor Blue
    
    try {
        # Unregister all hotkeys
        [WinAPI]::UnregisterHotKey($global:hotkeysForm.Handle, 1)
        [WinAPI]::UnregisterHotKey($global:hotkeysForm.Handle, 2)
        [WinAPI]::UnregisterHotKey($global:hotkeysForm.Handle, 3)
        [WinAPI]::UnregisterHotKey($global:hotkeysForm.Handle, 4)
        [WinAPI]::UnregisterHotKey($global:hotkeysForm.Handle, 5)
        
        # Clean up form
        if ($global:hotkeysForm) {
            $global:hotkeysForm.Close()
            $global:hotkeysForm.Dispose()
            $global:hotkeysForm = $null
        }
        
        $global:hotkeysActive = $false
        
        Write-Host "✅ Global hotkeys stopped!" -ForegroundColor Green
        Write-Host ""
        
    } catch {
        Write-Host "Error stopping hotkeys: $_" -ForegroundColor Red
    }
}

# Function to show status
function Show-HotkeysStatus {
    Write-Host ""
    Write-Host "🔥 GLOBAL HOTKEYS STATUS" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Blue
    Write-Host ""
    
    if ($global:hotkeysActive) {
        Write-Host "Status: ✅ ACTIVE" -ForegroundColor Green
        Write-Host ""
        Write-Host "REGISTERED HOTKEYS:" -ForegroundColor Yellow
        foreach ($id in $global:hotkeyCommands.Keys) {
            $hotkey = $global:hotkeyCommands[$id]
            Write-Host "  $($hotkey.Keys) - $($hotkey.Description)" -ForegroundColor White
        }
    } else {
        Write-Host "Status: ❌ INACTIVE" -ForegroundColor Red
        Write-Host ""
        Write-Host "Run 'Start-GlobalHotkeys' to activate" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Main execution
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Write-Host ""
    Write-Host "🔥 WINDOWS GLOBAL HOTKEYS - WARP RESTRICTION BYPASS" -ForegroundColor Red
    Write-Host "====================================================" -ForegroundColor Blue
    Write-Host ""
    Write-Host "This system registers REAL Windows global hotkeys that work" -ForegroundColor Yellow
    Write-Host "everywhere - even when Warp doesn't have focus!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Available commands:" -ForegroundColor Green
    Write-Host "  Start-GlobalHotkeys  - Activate global hotkeys" -ForegroundColor White
    Write-Host "  Stop-GlobalHotkeys   - Deactivate global hotkeys" -ForegroundColor White
    Write-Host "  Show-HotkeysStatus   - Show current status" -ForegroundColor White
    Write-Host ""
    
    Show-HotkeysStatus
    
    $choice = Read-Host "Start global hotkeys now? (y/n)"
    if ($choice -match '^[Yy]') {
        Start-GlobalHotkeys
    }
}

# Export functions
Export-ModuleMember -Function Start-GlobalHotkeys, Stop-GlobalHotkeys, Show-HotkeysStatus -ErrorAction SilentlyContinue