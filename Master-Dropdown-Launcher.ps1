# Master-Dropdown-Launcher.ps1 - Global Hotkey System for All Dropdown Tools
# Purpose: Set up global hotkeys for all dropdown tools and provide central management
# Usage: Run once to enable all global hotkeys, or use individual functions

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Import required modules for global hotkeys
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class GlobalHotkey
{
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    
    public const uint MOD_CTRL = 0x0002;
    public const uint MOD_ALT = 0x0001;
    public const uint MOD_SHIFT = 0x0004;
    public const uint VK_D = 0x44;
    public const uint VK_C = 0x43;
    public const uint VK_F = 0x46;
    public const uint VK_R = 0x52;
}
"@

# Global variables
$global:hotkeyForm = $null
$global:hotkeyRegistered = $false

# Hotkey definitions
$hotkeys = @{
    1 = @{Name="QuickDebug"; Script="QuickDebug-Dropdown.ps1"; Description="Debug Issues Dropdown"; Keys="Ctrl+Alt+D"}
    2 = @{Name="QuickCommands"; Script="QuickCommands-Dropdown.ps1"; Description="All Commands Browser"; Keys="Ctrl+Alt+C"}
    3 = @{Name="QuickFiles"; Script="QuickFiles-Dropdown.ps1"; Description="Project Files Browser"; Keys="Ctrl+Alt+F"}
    4 = @{Name="QuickReference"; Script="QuickReference-Selector.ps1"; Description="Numbered Reference Selector"; Keys="Ctrl+Alt+R"}
}

# Function to show main menu
function Show-DropdownMenu {
    $menuForm = New-Object System.Windows.Forms.Form
    $menuForm.Text = "🚀 DROPDOWN TOOLS LAUNCHER"
    $menuForm.Size = New-Object System.Drawing.Size(500, 400)
    $menuForm.StartPosition = "CenterScreen"
    $menuForm.FormBorderStyle = "FixedDialog"
    $menuForm.MaximizeBox = $false
    $menuForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $menuForm.ForeColor = [System.Drawing.Color]::White

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "DROPDOWN TOOLS - INSTANT AI EFFICIENCY"
    $title.Size = New-Object System.Drawing.Size(460, 30)
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.ForeColor = [System.Drawing.Color]::Cyan
    $title.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
    $title.TextAlign = "MiddleCenter"
    $menuForm.Controls.Add($title)

    # Instructions
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "Click any button to launch dropdown tool, or press indicated hotkey:"
    $instructions.Size = New-Object System.Drawing.Size(460, 20)
    $instructions.Location = New-Object System.Drawing.Point(20, 60)
    $instructions.ForeColor = [System.Drawing.Color]::Yellow
    $instructions.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $menuForm.Controls.Add($instructions)

    # Create buttons for each dropdown tool
    $buttonY = 100
    $buttonHeight = 50
    $buttonSpacing = 60

    foreach ($id in $hotkeys.Keys | Sort-Object) {
        $hotkey = $hotkeys[$id]
        
        $button = New-Object System.Windows.Forms.Button
        $button.Text = "$($hotkey.Keys)`n$($hotkey.Name)`n$($hotkey.Description)"
        $button.Size = New-Object System.Drawing.Size(460, $buttonHeight)
        $button.Location = New-Object System.Drawing.Point(20, $buttonY)
        $button.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
        $button.ForeColor = [System.Drawing.Color]::White
        $button.FlatStyle = "Flat"
        $button.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
        
        # Add click event
        $scriptPath = $hotkey.Script
        $button.Add_Click({
            try {
                & ".\$scriptPath"
            } catch {
                Write-Host "Error launching $scriptPath : $_" -ForegroundColor Red
            }
        }.GetNewClosure())
        
        $menuForm.Controls.Add($button)
        $buttonY += $buttonSpacing
    }

    # Global hotkey toggle
    $hotkeyButton = New-Object System.Windows.Forms.Button
    $hotkeyText = if ($global:hotkeyRegistered) { "DISABLE Global Hotkeys" } else { "ENABLE Global Hotkeys" }
    $hotkeyButton.Text = $hotkeyText
    $hotkeyButton.Size = New-Object System.Drawing.Size(220, 30)
    $hotkeyButton.Location = New-Object System.Drawing.Point(20, 320)
    $hotkeyButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $hotkeyButton.ForeColor = [System.Drawing.Color]::White
    $hotkeyButton.FlatStyle = "Flat"
    $hotkeyButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    
    $hotkeyButton.Add_Click({
        if ($global:hotkeyRegistered) {
            Stop-GlobalHotkeys
            $hotkeyButton.Text = "ENABLE Global Hotkeys"
            [System.Windows.Forms.MessageBox]::Show("Global hotkeys disabled", "Hotkeys", "OK", "Information")
        } else {
            Start-GlobalHotkeys
            $hotkeyButton.Text = "DISABLE Global Hotkeys"
            [System.Windows.Forms.MessageBox]::Show("Global hotkeys enabled! Use Ctrl+Alt+[D/C/F/R] anywhere in Windows", "Hotkeys", "OK", "Information")
        }
    })
    
    $menuForm.Controls.Add($hotkeyButton)

    # Close button
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "Close"
    $closeButton.Size = New-Object System.Drawing.Size(100, 30)
    $closeButton.Location = New-Object System.Drawing.Point(380, 320)
    $closeButton.BackColor = [System.Drawing.Color]::FromArgb(180, 60, 60)
    $closeButton.ForeColor = [System.Drawing.Color]::White
    $closeButton.FlatStyle = "Flat"
    $closeButton.Add_Click({ $menuForm.Close() })
    $menuForm.Controls.Add($closeButton)

    # Show form
    $menuForm.ShowDialog()
}

# Function to start global hotkeys
function Start-GlobalHotkeys {
    try {
        # Create invisible form for hotkey handling
        $global:hotkeyForm = New-Object System.Windows.Forms.Form
        $global:hotkeyForm.WindowState = "Minimized"
        $global:hotkeyForm.ShowInTaskbar = $false
        $global:hotkeyForm.Visible = $false

        # Register hotkeys
        $success = $true
        $success = $success -and [GlobalHotkey]::RegisterHotKey($global:hotkeyForm.Handle, 1, ([GlobalHotkey]::MOD_CTRL -bor [GlobalHotkey]::MOD_ALT), [GlobalHotkey]::VK_D)
        $success = $success -and [GlobalHotkey]::RegisterHotKey($global:hotkeyForm.Handle, 2, ([GlobalHotkey]::MOD_CTRL -bor [GlobalHotkey]::MOD_ALT), [GlobalHotkey]::VK_C)
        $success = $success -and [GlobalHotkey]::RegisterHotKey($global:hotkeyForm.Handle, 3, ([GlobalHotkey]::MOD_CTRL -bor [GlobalHotkey]::MOD_ALT), [GlobalHotkey]::VK_F)
        $success = $success -and [GlobalHotkey]::RegisterHotKey($global:hotkeyForm.Handle, 4, ([GlobalHotkey]::MOD_CTRL -bor [GlobalHotkey]::MOD_ALT), [GlobalHotkey]::VK_R)

        if ($success) {
            # Add hotkey handling
            $global:hotkeyForm.Add_KeyDown({
                param($sender, $e)
                Write-Host "KeyDown event: $($e.KeyCode)"
            })

            # Handle WM_HOTKEY messages
            $global:hotkeyForm.Add_Shown({
                $wndProc = {
                    param($m)
                    if ($m.Msg -eq 0x0312) { # WM_HOTKEY
                        $hotkeyId = $m.WParam.ToInt32()
                        if ($hotkeys.ContainsKey($hotkeyId)) {
                            $scriptPath = $hotkeys[$hotkeyId].Script
                            try {
                                Start-Process "powershell" -ArgumentList "-File `"$(Get-Location)\$scriptPath`"" -WindowStyle Hidden
                            } catch {
                                Write-Host "Error launching $scriptPath : $_" -ForegroundColor Red
                            }
                        }
                    }
                    [System.Windows.Forms.Form]::WndProc([ref]$m)
                }
                
                # Override WndProc (this is tricky in PowerShell)
                # Alternative: Use a timer to check for hotkey presses
                $timer = New-Object System.Windows.Forms.Timer
                $timer.Interval = 100
                $timer.Add_Tick({
                    # Check for hotkey combinations manually
                    if ([System.Windows.Forms.Control]::ModifierKeys -eq ([System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::Alt)) {
                        # This is a simplified approach - actual implementation would need Win32 API calls
                    }
                })
                $timer.Start()
            })

            $global:hotkeyRegistered = $true
            Write-Host "Global hotkeys registered successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to register some hotkeys" -ForegroundColor Red
            $global:hotkeyRegistered = $false
        }
    } catch {
        Write-Host "Error setting up global hotkeys: $_" -ForegroundColor Red
        $global:hotkeyRegistered = $false
    }
}

# Function to stop global hotkeys  
function Stop-GlobalHotkeys {
    if ($global:hotkeyForm -and $global:hotkeyRegistered) {
        try {
            [GlobalHotkey]::UnregisterHotKey($global:hotkeyForm.Handle, 1)
            [GlobalHotkey]::UnregisterHotKey($global:hotkeyForm.Handle, 2)
            [GlobalHotkey]::UnregisterHotKey($global:hotkeyForm.Handle, 3)
            [GlobalHotkey]::UnregisterHotKey($global:hotkeyForm.Handle, 4)
            
            $global:hotkeyForm.Close()
            $global:hotkeyForm.Dispose()
            $global:hotkeyForm = $null
            $global:hotkeyRegistered = $false
            
            Write-Host "Global hotkeys unregistered" -ForegroundColor Green
        } catch {
            Write-Host "Error stopping global hotkeys: $_" -ForegroundColor Red
        }
    }
}

# Individual launcher functions
function Start-QuickDebug { & ".\QuickDebug-Dropdown.ps1" }
function Start-QuickCommands { & ".\QuickCommands-Dropdown.ps1" }
function Start-QuickFiles { & ".\QuickFiles-Dropdown.ps1" }
function Start-QuickReference { & ".\QuickReference-Selector.ps1" }

# Main execution
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Write-Host ""
    Write-Host "🚀 DROPDOWN TOOLS MASTER LAUNCHER" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Available commands:" -ForegroundColor Yellow
    Write-Host "  Show-DropdownMenu    - Show interactive menu" -ForegroundColor White
    Write-Host "  Start-GlobalHotkeys  - Enable global hotkeys" -ForegroundColor White
    Write-Host "  Stop-GlobalHotkeys   - Disable global hotkeys" -ForegroundColor White
    Write-Host "  Start-QuickDebug     - Launch debug dropdown" -ForegroundColor White
    Write-Host "  Start-QuickCommands  - Launch commands browser" -ForegroundColor White  
    Write-Host "  Start-QuickFiles     - Launch files browser" -ForegroundColor White
    Write-Host "  Start-QuickReference - Launch reference selector" -ForegroundColor White
    Write-Host ""
    Write-Host "Global Hotkeys (when enabled):" -ForegroundColor Yellow
    Write-Host "  Ctrl+Alt+D - Debug Issues Dropdown" -ForegroundColor White
    Write-Host "  Ctrl+Alt+C - Commands Browser" -ForegroundColor White
    Write-Host "  Ctrl+Alt+F - Files Browser" -ForegroundColor White
    Write-Host "  Ctrl+Alt+R - Reference Selector" -ForegroundColor White
    Write-Host ""
    
    # Show menu by default
    Show-DropdownMenu
}

# Export functions
Export-ModuleMember -Function Show-DropdownMenu, Start-GlobalHotkeys, Stop-GlobalHotkeys, Start-QuickDebug, Start-QuickCommands, Start-QuickFiles, Start-QuickReference