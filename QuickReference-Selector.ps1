# QuickReference-Selector.ps1 - Numbered Reference Selector with Copy-to-Clipboard
# Global Hotkey: Ctrl+Alt+R (configurable)
# Screen Coverage: 30% of screen size  
# Purpose: Select numbered references and copy AI commands to clipboard

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$form = $null
$isVisible = $false

# Numbered references data (comprehensive list)
$numberedReferences = @(
    # Main Sections
    @{Type="SECTION"; Number="1.0"; Title="Data/Text Master Control"; AICommand="Apply SECTION 1.0 for data management"},
    @{Type="SECTION"; Number="2.0"; Title="Mobile-First Design"; AICommand="Apply SECTION 2.0 for mobile optimization"},
    @{Type="SECTION"; Number="3.0"; Title="Node.js Script Usage"; AICommand="Apply SECTION 3.0 for script commands"},
    @{Type="SECTION"; Number="4.0"; Title="Critical Mobile Issues"; AICommand="Apply SECTION 4.0 for mobile debugging"},
    @{Type="SECTION"; Number="5.0"; Title="README Template System"; AICommand="Apply SECTION 5.0 for documentation"},
    @{Type="SECTION"; Number="6.0"; Title="Quality Assurance Checklists"; AICommand="Apply SECTION 6.0 for QA testing"},
    @{Type="SECTION"; Number="7.0"; Title="Critical Failure Prevention"; AICommand="Apply SECTION 7.0 for quality control"},

    # Critical Issues (4.0 subsections)
    @{Type="ISSUE"; Number="4.1"; Title="Infinite Scrolling"; AICommand="Fix ISSUE 4.1 infinite scroll"},
    @{Type="ISSUE"; Number="4.2"; Title="Chart Sizing Disasters"; AICommand="Fix ISSUE 4.2 chart sizing"},
    @{Type="ISSUE"; Number="4.3"; Title="Alignment Nightmares"; AICommand="Fix ISSUE 4.3 alignment issues"},
    @{Type="ISSUE"; Number="4.4"; Title="Text Visibility Disasters"; AICommand="Fix ISSUE 4.4 text visibility"},
    @{Type="ISSUE"; Number="4.5"; Title="Navigation Positioning"; AICommand="Fix ISSUE 4.5 navigation"},
    @{Type="ISSUE"; Number="4.6"; Title="Data Integrity Problems"; AICommand="Fix ISSUE 4.6 data integrity"},
    @{Type="ISSUE"; Number="4.7"; Title="Mobile Usability Failures"; AICommand="Fix ISSUE 4.7 mobile usability"},
    @{Type="ISSUE"; Number="4.8"; Title="Video Container Overflow"; AICommand="Fix ISSUE 4.8 video containers"},
    @{Type="ISSUE"; Number="4.9"; Title="Version Management Chaos"; AICommand="Fix ISSUE 4.9 version display"},

    # Quality Assurance (6.0 subsections)  
    @{Type="QA"; Number="6.1"; Title="Charts & Visualizations"; AICommand="Check SECTION 6.1 charts"},
    @{Type="QA"; Number="6.2"; Title="Buttons & Navigation"; AICommand="Check SECTION 6.2 buttons"},
    @{Type="QA"; Number="6.3"; Title="iPhone Optimization"; AICommand="Check SECTION 6.3 iPhone"},
    @{Type="QA"; Number="6.4"; Title="Images & Slideshow"; AICommand="Check SECTION 6.4 images"},
    @{Type="QA"; Number="6.5"; Title="Links & Integration"; AICommand="Check SECTION 6.5 links"},
    @{Type="QA"; Number="6.6"; Title="Professional Appearance"; AICommand="Check SECTION 6.6 appearance"},
    @{Type="QA"; Number="6.7"; Title="Technical Testing"; AICommand="Check SECTION 6.7 technical"},

    # Warp AI Standards (7.0 subsections)
    @{Type="STANDARD"; Number="7.1"; Title="Numbered References"; AICommand="Follow SECTION 7.1 numbering"},
    @{Type="STANDARD"; Number="7.2"; Title="File Update Workflow"; AICommand="Follow SECTION 7.2 workflow"},
    @{Type="STANDARD"; Number="7.3"; Title="Adding New Items"; AICommand="Follow SECTION 7.3 for additions"},
    @{Type="STANDARD"; Number="7.4"; Title="Session Standards"; AICommand="Follow SECTION 7.4 sessions"},
    @{Type="STANDARD"; Number="7.5"; Title="AI Behavioral Rules"; AICommand="Reference SECTION 7.5 AI rules"},
    @{Type="STANDARD"; Number="7.6"; Title="WarpSpeed Commands"; AICommand="Use SECTION 7.6 commands"},

    # Common AI Redirections
    @{Type="REDIRECT"; Number=""; Title="Universal Access Principle"; AICommand="Follow Universal Access Principle: GitHub first, never local first"},
    @{Type="REDIRECT"; Number=""; Title="Use Numbered References"; AICommand="Use numbered references per SECTION 7.1 - SECTION X.X for categories, ISSUE X.X for problems"},
    @{Type="REDIRECT"; Number=""; Title="Apply Existing Solution"; AICommand="Check existing solution before debugging - we already solved this"},
    @{Type="REDIRECT"; Number=""; Title="Update All Related Files"; AICommand="Update ALL related files simultaneously per SECTION 7.2"},
    @{Type="REDIRECT"; Number=""; Title="GitHub Master First"; AICommand="Update GitHub master files first, then copy to local - never local first"},
    @{Type="REDIRECT"; Number=""; Title="Mobile-First Priority"; AICommand="Apply mobile-first design per SECTION 2.0 - iPhone viewport priority"},
    @{Type="REDIRECT"; Number=""; Title="Data Validation Required"; AICommand="Run data validation: .\\Update-ProjectData.ps1 -ValidateOnly"},
    @{Type="REDIRECT"; Number=""; Title="Marketing Rules"; AICommand="Apply marketing rules: Revenue UP, costs precise per ISSUE 4.6"}
)

# Function to create and show dropdown
function Show-ReferenceSelector {
    if ($global:isVisible) {
        Hide-ReferenceSelector
        return
    }

    # Get screen dimensions
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $screenWidth = $screen.Bounds.Width
    $screenHeight = $screen.Bounds.Height
    
    # Calculate 30% coverage
    $formWidth = [int]($screenWidth * 0.8)
    $formHeight = [int]($screenHeight * 0.3)
    $formX = [int](($screenWidth - $formWidth) / 2)
    $formY = [int]($screenHeight * 0.05)

    # Create form
    $global:form = New-Object System.Windows.Forms.Form
    $global:form.Text = "🔢 NUMBERED REFERENCE SELECTOR"
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
    $listView.Columns.Add("Type", 100) | Out-Null
    $listView.Columns.Add("Number", 80) | Out-Null
    $listView.Columns.Add("Title", 250) | Out-Null
    $listView.Columns.Add("AI Command", 400) | Out-Null

    # Add items grouped by type
    $typeGroups = $numberedReferences | Group-Object Type
    foreach ($group in $typeGroups) {
        foreach ($ref in $group.Group) {
            $item = New-Object System.Windows.Forms.ListViewItem($ref.Type)
            $item.SubItems.Add($ref.Number) | Out-Null
            $item.SubItems.Add($ref.Title) | Out-Null
            $item.SubItems.Add($ref.AICommand) | Out-Null
            
            # Color coding by type
            switch ($ref.Type) {
                "SECTION" { $item.BackColor = [System.Drawing.Color]::FromArgb(0, 50, 100) }
                "ISSUE" { $item.BackColor = [System.Drawing.Color]::FromArgb(100, 50, 0) }
                "QA" { $item.BackColor = [System.Drawing.Color]::FromArgb(0, 100, 50) }
                "STANDARD" { $item.BackColor = [System.Drawing.Color]::FromArgb(50, 0, 100) }
                "REDIRECT" { $item.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 0) }
            }
            
            $listView.Items.Add($item) | Out-Null
        }
    }

    # Add double-click event to copy command
    $listView.Add_DoubleClick({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedCommand = $listView.SelectedItems[0].SubItems[3].Text
            [System.Windows.Forms.Clipboard]::SetText($selectedCommand)
            
            # Show notification
            $notif = New-Object System.Windows.Forms.NotifyIcon
            $notif.Icon = [System.Drawing.SystemIcons]::Information
            $notif.BalloonTipText = "Copied to clipboard: $selectedCommand"
            $notif.BalloonTipTitle = "QuickReference"
            $notif.Visible = $true
            $notif.ShowBalloonTip(2000)
            
            # Clean up notification
            Start-Sleep -Milliseconds 2500
            $notif.Dispose()
            
            Hide-ReferenceSelector
        }
    })

    # Filter by type buttons
    $buttonY = $formHeight - 80
    $buttonWidth = 80
    $buttonSpacing = 85
    $startX = 20

    $filterButtons = @()
    $typeLabels = @("ALL", "SECTION", "ISSUE", "QA", "STANDARD", "REDIRECT")
    
    for ($i = 0; $i -lt $typeLabels.Length; $i++) {
        $button = New-Object System.Windows.Forms.Button
        $button.Text = $typeLabels[$i]
        $button.Size = New-Object System.Drawing.Size($buttonWidth, 25)
        $button.Location = New-Object System.Drawing.Point(($startX + ($i * $buttonSpacing)), $buttonY)
        $button.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
        $button.ForeColor = [System.Drawing.Color]::White
        $button.FlatStyle = "Flat"
        $button.Font = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)
        
        $filterType = $typeLabels[$i]
        $button.Add_Click({
            param($sender, $e)
            
            # Reset all button colors
            foreach ($btn in $filterButtons) {
                $btn.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
            }
            
            # Highlight selected button
            $sender.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
            
            # Filter items
            $listView.Items.Clear()
            $filteredRefs = if ($sender.Text -eq "ALL") { $numberedReferences } else { $numberedReferences | Where-Object { $_.Type -eq $sender.Text } }
            
            foreach ($ref in $filteredRefs) {
                $item = New-Object System.Windows.Forms.ListViewItem($ref.Type)
                $item.SubItems.Add($ref.Number) | Out-Null
                $item.SubItems.Add($ref.Title) | Out-Null
                $item.SubItems.Add($ref.AICommand) | Out-Null
                
                # Color coding
                switch ($ref.Type) {
                    "SECTION" { $item.BackColor = [System.Drawing.Color]::FromArgb(0, 50, 100) }
                    "ISSUE" { $item.BackColor = [System.Drawing.Color]::FromArgb(100, 50, 0) }
                    "QA" { $item.BackColor = [System.Drawing.Color]::FromArgb(0, 100, 50) }
                    "STANDARD" { $item.BackColor = [System.Drawing.Color]::FromArgb(50, 0, 100) }
                    "REDIRECT" { $item.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 0) }
                }
                
                $listView.Items.Add($item) | Out-Null
            }
        })
        
        $filterButtons += $button
        $global:form.Controls.Add($button)
    }

    # Set ALL button as selected initially
    $filterButtons[0].BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)

    # Instructions label  
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "💡 Double-click to copy AI command | Use filter buttons | Colors: Blue=Sections, Orange=Issues, Green=QA, Purple=Standards, Yellow=Redirects"
    $instructions.Size = New-Object System.Drawing.Size(($formWidth - 40), 40)
    $instructions.Location = New-Object System.Drawing.Point(20, ($formHeight - 50))
    $instructions.ForeColor = [System.Drawing.Color]::Yellow
    $instructions.Font = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)

    # Add controls to form
    $global:form.Controls.Add($listView)
    $global:form.Controls.Add($instructions)

    # Handle escape key
    $global:form.Add_KeyDown({
        param($sender, $e)
        if ($e.KeyCode -eq "Escape") {
            Hide-ReferenceSelector
        }
    })

    # Handle form closing
    $global:form.Add_FormClosed({
        $global:isVisible = $false
    })

    # Show form
    $global:form.Show()
    $global:isVisible = $true
}

# Function to hide dropdown
function Hide-ReferenceSelector {
    if ($global:form -and $global:isVisible) {
        $global:form.Close()
        $global:form.Dispose()
        $global:form = $null
        $global:isVisible = $false
    }
}

# Main execution when run directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Show-ReferenceSelector
    
    # Keep script running
    while ($global:isVisible) {
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Application]::DoEvents()
    }
}

# Functions available when script is dot-sourced
# Show-ReferenceSelector, Hide-ReferenceSelector
