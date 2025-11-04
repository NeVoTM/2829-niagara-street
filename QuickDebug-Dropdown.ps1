# QuickDebug-Dropdown.ps1 - Global Hotkey Dropdown for Debugging Issues
# Global Hotkey: Ctrl+Alt+D (configurable)
# Screen Coverage: 30% of screen size
# Purpose: Instant access to numbered debugging issues for AI instructions

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$form = $null
$isVisible = $false

# Debugging issues data
$debuggingIssues = @(
    @{Number="1.0"; Title="Data/Text Master Control"; Description="Centralized project-data.json system"; Command="Apply SECTION 1.0 for data management"},
    @{Number="2.0"; Title="Mobile-First Design"; Description="iPhone-priority development approach"; Command="Apply SECTION 2.0 for mobile optimization"},
    @{Number="3.0"; Title="Node.js Script Usage"; Description="Command syntax and installation"; Command="Apply SECTION 3.0 for script commands"},
    @{Number="4.0"; Title="Critical Mobile Issues"; Description="9 specific mobile problems + solutions"; Command="Apply SECTION 4.0 for mobile debugging"},
    @{Number="4.1"; Title="Infinite Scrolling"; Description="max-height: 100vh + overflow-y: auto"; Command="Fix ISSUE 4.1 infinite scroll"},
    @{Number="4.2"; Title="Chart Sizing Disasters"; Description="max-height: 280px + maintainAspectRatio: false"; Command="Fix ISSUE 4.2 chart sizing"},
    @{Number="4.3"; Title="Alignment Nightmares"; Description="Separate tables for different contexts"; Command="Fix ISSUE 4.3 alignment issues"},
    @{Number="4.4"; Title="Text Visibility Disasters"; Description="text-shadow + increased opacity"; Command="Fix ISSUE 4.4 text visibility"},
    @{Number="4.5"; Title="Navigation Positioning"; Description="scrollIntoView with block: 'start'"; Command="Fix ISSUE 4.5 navigation"},
    @{Number="4.6"; Title="Data Integrity Problems"; Description="Marketing rules + validation"; Command="Fix ISSUE 4.6 data integrity"},
    @{Number="4.7"; Title="Mobile Usability Failures"; Description="44px touch targets + large icons"; Command="Fix ISSUE 4.7 mobile usability"},
    @{Number="4.8"; Title="Video Container Overflow"; Description="max-height: 200px + overflow: hidden"; Command="Fix ISSUE 4.8 video containers"},
    @{Number="4.9"; Title="Version Management Chaos"; Description="Version info only in Contact tab"; Command="Fix ISSUE 4.9 version display"},
    @{Number="5.0"; Title="README Template System"; Description="Universal project documentation"; Command="Apply SECTION 5.0 for documentation"},
    @{Number="6.0"; Title="Quality Assurance Checklists"; Description="7 categories of testing"; Command="Apply SECTION 6.0 for QA testing"},
    @{Number="6.1"; Title="Charts & Visualizations"; Description="Revenue, cost, market charts working"; Command="Check SECTION 6.1 charts"},
    @{Number="6.2"; Title="Buttons & Navigation"; Description="All buttons visible and functional"; Command="Check SECTION 6.2 buttons"},
    @{Number="6.3"; Title="iPhone Optimization"; Description="Mobile viewport testing and optimization"; Command="Check SECTION 6.3 iPhone"},
    @{Number="6.4"; Title="Images & Slideshow"; Description="All 20 renderings, slideshow working"; Command="Check SECTION 6.4 images"},
    @{Number="6.5"; Title="Links & Integration"; Description="Email, phone, video links functional"; Command="Check SECTION 6.5 links"},
    @{Number="6.6"; Title="Professional Appearance"; Description="Typography, spacing, alignment consistent"; Command="Check SECTION 6.6 appearance"},
    @{Number="6.7"; Title="Technical Testing"; Description="No errors, cross-browser compatibility"; Command="Check SECTION 6.7 technical"},
    @{Number="7.0"; Title="Critical Failure Prevention"; Description="Testing protocols and standards"; Command="Apply SECTION 7.0 for quality control"}
)

# Function to create and show dropdown
function Show-DebugDropdown {
    if ($global:isVisible) {
        Hide-DebugDropdown
        return
    }

    # Get screen dimensions
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $screenWidth = $screen.Bounds.Width
    $screenHeight = $screen.Bounds.Height
    
    # Calculate 30% coverage
    $formWidth = [int]($screenWidth * 0.6)
    $formHeight = [int]($screenHeight * 0.3)
    $formX = [int](($screenWidth - $formWidth) / 2)
    $formY = [int]($screenHeight * 0.05)

    # Create form
    $global:form = New-Object System.Windows.Forms.Form
    $global:form.Text = "DEBUGGING ISSUES QUICK REFERENCE"
    $global:form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
    $global:form.StartPosition = "Manual"
    $global:form.Location = New-Object System.Drawing.Point($formX, $formY)
    $global:form.TopMost = $true
    $global:form.FormBorderStyle = "FixedToolWindow"
    $global:form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $global:form.ForeColor = [System.Drawing.Color]::White

    # Create ListView
    $listView = New-Object System.Windows.Forms.ListView
    $listView.View = "Details"
    $listView.FullRowSelect = $true
    $listView.GridLines = $true
    $listView.Size = New-Object System.Drawing.Size(($formWidth - 40), ($formHeight - 100))
    $listView.Location = New-Object System.Drawing.Point(20, 20)
    $listView.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $listView.ForeColor = [System.Drawing.Color]::White

    # Add columns
    $listView.Columns.Add("Number", 80) | Out-Null
    $listView.Columns.Add("Title", 200) | Out-Null
    $listView.Columns.Add("Description", 300) | Out-Null
    $listView.Columns.Add("AI Command", 300) | Out-Null

    # Add items
    foreach ($issue in $debuggingIssues) {
        $item = New-Object System.Windows.Forms.ListViewItem($issue.Number)
        $item.SubItems.Add($issue.Title) | Out-Null
        $item.SubItems.Add($issue.Description) | Out-Null
        $item.SubItems.Add($issue.Command) | Out-Null
        $listView.Items.Add($item) | Out-Null
    }

    # Add double-click event
    $listView.Add_DoubleClick({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedCommand = $listView.SelectedItems[0].SubItems[3].Text
            [System.Windows.Forms.Clipboard]::SetText($selectedCommand)
            
            # Show notification
            $notif = New-Object System.Windows.Forms.NotifyIcon
            $notif.Icon = [System.Drawing.SystemIcons]::Information
            $notif.BalloonTipText = "Copied to clipboard: $selectedCommand"
            $notif.BalloonTipTitle = "QuickDebug"
            $notif.Visible = $true
            $notif.ShowBalloonTip(2000)
            
            # Clean up notification
            Start-Sleep -Milliseconds 2500
            $notif.Dispose()
            
            Hide-DebugDropdown
        }
    })

    # Instructions label
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "Double-click any item to copy AI command to clipboard | Press Esc or Ctrl+Alt+D to close"
    $instructions.Size = New-Object System.Drawing.Size(($formWidth - 40), 30)
    $instructions.Location = New-Object System.Drawing.Point(20, ($formHeight - 60))
    $instructions.ForeColor = [System.Drawing.Color]::Yellow
    $instructions.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)

    # Add controls to form
    $global:form.Controls.Add($listView)
    $global:form.Controls.Add($instructions)

    # Handle escape key
    $global:form.Add_KeyDown({
        param($sender, $e)
        if ($e.KeyCode -eq "Escape") {
            Hide-DebugDropdown
        }
    })

    # Handle form closing
    $global:form.Add_FormClosed({
        $global:isVisible = $false
    })

    # Show form and force to front
    $global:form.Show()
    $global:form.Activate()
    $global:form.BringToFront()
    $global:form.Focus()
    $global:isVisible = $true
}

# Function to hide dropdown
function Hide-DebugDropdown {
    if ($global:form -and $global:isVisible) {
        $global:form.Close()
        $global:form.Dispose()
        $global:form = $null
        $global:isVisible = $false
    }
}

# Register global hotkey (Ctrl+Alt+D)
# Note: PowerShell doesn't have built-in global hotkey support
# This function can be called directly or integrated with other hotkey solutions

# Main execution when run directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Show-DebugDropdown
    
    # Keep script running
    while ($global:isVisible) {
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Application]::DoEvents()
    }
}

# Functions available when script is dot-sourced
# Show-DebugDropdown, Hide-DebugDropdown
