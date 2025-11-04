# QuickCommands-Dropdown.ps1 - Global Hotkey Dropdown for All Available Commands
# Global Hotkey: Ctrl+Alt+C (configurable)
# Screen Coverage: 30% of screen size
# Purpose: Instant access to all custom commands and PowerShell commands

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$form = $null
$isVisible = $false

# Available commands data
$availableCommands = @(
    # Custom Commands
    @{Category="Custom Commands"; Name="DebugRef"; Hotkey="Ctrl+Shift+D"; Description="Show common debugging issues"; Command="DebugRef"},
    @{Category="Custom Commands"; Name="GitHubFirst"; Hotkey="Ctrl+Shift+G"; Description="Universal Access Principle reminder"; Command="GitHubFirst"},
    @{Category="Custom Commands"; Name="NumRef"; Hotkey="Ctrl+Shift+N"; Description="Numbered reference template"; Command="NumRef"},
    @{Category="Custom Commands"; Name="ComplianceCheck"; Hotkey="Ctrl+Shift+C"; Description="Session compliance checklist"; Command="ComplianceCheck"},
    @{Category="Custom Commands"; Name="QACheck"; Hotkey="Ctrl+Shift+Q"; Description="Quality assurance categories"; Command="QACheck"},
    @{Category="Custom Commands"; Name="MobileFirst"; Hotkey="Ctrl+Shift+M"; Description="Mobile-first design principles"; Command="MobileFirst"},
    @{Category="Custom Commands"; Name="DataCheck"; Hotkey="Ctrl+Shift+V"; Description="Data validation and marketing rules"; Command="DataCheck"},
    @{Category="Custom Commands"; Name="UpdateFlow"; Hotkey="Ctrl+Shift+U"; Description="File update workflow"; Command="UpdateFlow"},
    
    # Project Commands
    @{Category="Project Management"; Name="WarpSpeed"; Hotkey=""; Description="Start AI session with full context"; Command="WarpSpeed"},
    
    # AI Popup System (SIMPLE SOLUTION)
    @{Category="AI Popup (Simple)"; Name="🌟 AI Popup (Win+W)"; Hotkey="Win+W"; Description="ONE HOTKEY - Opens beautiful AI popup anywhere!"; Command="# Win+W opens AI popup - install first with command below"},
    @{Category="AI Popup (Simple)"; Name="Install AI Popup"; Hotkey=""; Description="Install Win+W global hotkey for AI popup"; Command=".\Simple-WarpAI-Launcher.ps1 -Install"},
    @{Category="AI Popup (Simple)"; Name="Test AI Popup"; Hotkey=""; Description="Test the AI popup manually"; Command=".\Simple-WarpAI-Launcher.ps1 -Test"},
    @{Category="AI Popup (Simple)"; Name="Remove AI Popup"; Hotkey=""; Description="Uninstall Win+W hotkey"; Command=".\Simple-WarpAI-Launcher.ps1 -Remove"},
    @{Category="Project Management"; Name="SimpleDebug"; Hotkey=""; Description="Quick debugging reference (console)"; Command=".\\SimpleDebug.ps1"},
    @{Category="Project Management"; Name="Data Validation"; Hotkey=""; Description="Validate project data consistency"; Command=".\\Update-ProjectData.ps1 -ValidateOnly"},
    @{Category="Project Management"; Name="Quick Deploy"; Hotkey=""; Description="Fast deployment to GitHub Pages"; Command="git add . && git commit -m 'Quick update' && git push"},
    @{Category="Project Management"; Name="Mobile Test"; Hotkey=""; Description="Open live mobile interface for testing"; Command="Start-Process 'https://nevotm.github.io/2829-niagara-street/mobile-design.html'"},
    
    # Dropdown Scripts
    @{Category="Dropdown Tools"; Name="Debug Dropdown"; Hotkey="Ctrl+Alt+D"; Description="Show debugging issues dropdown"; Command=".\QuickDebug-Dropdown.ps1"},
    @{Category="Dropdown Tools"; Name="Commands Dropdown"; Hotkey="Ctrl+Alt+C"; Description="Show this commands dropdown"; Command=".\QuickCommands-Dropdown.ps1"},
    @{Category="Dropdown Tools"; Name="Files Dropdown"; Hotkey="Ctrl+Alt+F"; Description="Show project files dropdown"; Command=".\QuickFiles-Dropdown.ps1"},
    @{Category="Dropdown Tools"; Name="Reference Selector"; Hotkey="Ctrl+Alt+R"; Description="Show numbered reference selector"; Command=".\QuickReference-Selector.ps1"},
    
    # Git Commands
    @{Category="Git Operations"; Name="Git Status"; Hotkey=""; Description="Check repository status"; Command="git status"},
    @{Category="Git Operations"; Name="Git Log"; Hotkey=""; Description="Show recent commits"; Command="git --no-pager log --oneline -10"},
    @{Category="Git Operations"; Name="Git Pull"; Hotkey=""; Description="Pull latest changes"; Command="git pull"},
    @{Category="Git Operations"; Name="Git Push"; Hotkey=""; Description="Push changes"; Command="git push"},
    
    # System Commands
    @{Category="System"; Name="Get Location"; Hotkey=""; Description="Show current directory"; Command="Get-Location"},
    @{Category="System"; Name="List Files"; Hotkey=""; Description="List all files in directory"; Command="Get-ChildItem -Name"},
    @{Category="System"; Name="PowerShell Version"; Hotkey=""; Description="Show PowerShell version"; Command="`$PSVersionTable"},
    @{Category="System"; Name="Environment Info"; Hotkey=""; Description="Show system information"; Command="Get-ComputerInfo | Select-Object WindowsProductName, TotalPhysicalMemory, CsProcessors"}
)

# Function to create and show dropdown
function Show-CommandsDropdown {
    if ($global:isVisible) {
        Hide-CommandsDropdown
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
    $global:form.Text = "ALL AVAILABLE COMMANDS"
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
    $listView.Columns.Add("Category", 150) | Out-Null
    $listView.Columns.Add("Name", 150) | Out-Null
    $listView.Columns.Add("Hotkey", 120) | Out-Null
    $listView.Columns.Add("Description", 250) | Out-Null
    $listView.Columns.Add("Command", 300) | Out-Null

    # Add items grouped by category
    $categories = $availableCommands | Group-Object Category
    foreach ($category in $categories) {
        foreach ($command in $category.Group) {
            $item = New-Object System.Windows.Forms.ListViewItem($command.Category)
            $item.SubItems.Add($command.Name) | Out-Null
            $item.SubItems.Add($command.Hotkey) | Out-Null
            $item.SubItems.Add($command.Description) | Out-Null
            $item.SubItems.Add($command.Command) | Out-Null
            $listView.Items.Add($item) | Out-Null
        }
    }

    # Add double-click event
    $listView.Add_DoubleClick({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedCommand = $listView.SelectedItems[0].SubItems[4].Text
            [System.Windows.Forms.Clipboard]::SetText($selectedCommand)
            
            # Show notification
            $notif = New-Object System.Windows.Forms.NotifyIcon
            $notif.Icon = [System.Drawing.SystemIcons]::Information
            $notif.BalloonTipText = "Copied to clipboard: $selectedCommand"
            $notif.BalloonTipTitle = "QuickCommands"
            $notif.Visible = $true
            $notif.ShowBalloonTip(2000)
            
            # Clean up notification
            Start-Sleep -Milliseconds 2500
            $notif.Dispose()
            
            Hide-CommandsDropdown
        }
    })

    # Search box
    $searchBox = New-Object System.Windows.Forms.TextBox
    $searchBox.Size = New-Object System.Drawing.Size(200, 25)
    $searchBox.Location = New-Object System.Drawing.Point(20, ($formHeight - 80))
    $searchBox.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $searchBox.ForeColor = [System.Drawing.Color]::White
    $searchBox.Text = "Search commands..."

    # Search functionality
    $searchBox.Add_TextChanged({
        $searchText = $searchBox.Text.ToLower()
        if ($searchText -eq "search commands..." -or $searchText -eq "") {
            # Show all items
            foreach ($item in $listView.Items) {
                $item.Remove()
            }
            foreach ($category in $categories) {
                foreach ($command in $category.Group) {
                    $item = New-Object System.Windows.Forms.ListViewItem($command.Category)
                    $item.SubItems.Add($command.Name) | Out-Null
                    $item.SubItems.Add($command.Hotkey) | Out-Null
                    $item.SubItems.Add($command.Description) | Out-Null
                    $item.SubItems.Add($command.Command) | Out-Null
                    $listView.Items.Add($item) | Out-Null
                }
            }
        } else {
            # Filter items
            $listView.Items.Clear()
            foreach ($category in $categories) {
                foreach ($command in $category.Group) {
                    if ($command.Name.ToLower().Contains($searchText) -or 
                        $command.Description.ToLower().Contains($searchText) -or
                        $command.Category.ToLower().Contains($searchText)) {
                        $item = New-Object System.Windows.Forms.ListViewItem($command.Category)
                        $item.SubItems.Add($command.Name) | Out-Null
                        $item.SubItems.Add($command.Hotkey) | Out-Null
                        $item.SubItems.Add($command.Description) | Out-Null
                        $item.SubItems.Add($command.Command) | Out-Null
                        $listView.Items.Add($item) | Out-Null
                    }
                }
            }
        }
    })

    # Clear search on focus
    $searchBox.Add_GotFocus({
        if ($searchBox.Text -eq "Search commands...") {
            $searchBox.Text = ""
        }
    })

    # Instructions label
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "Double-click any command to copy to clipboard | Use search box to filter | Press Esc to close"
    $instructions.Size = New-Object System.Drawing.Size(($formWidth - 250), 30)
    $instructions.Location = New-Object System.Drawing.Point(240, ($formHeight - 80))
    $instructions.ForeColor = [System.Drawing.Color]::Yellow
    $instructions.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)

    # Add controls to form
    $global:form.Controls.Add($listView)
    $global:form.Controls.Add($searchBox)
    $global:form.Controls.Add($instructions)

    # Handle escape key
    $global:form.Add_KeyDown({
        param($sender, $e)
        if ($e.KeyCode -eq "Escape") {
            Hide-CommandsDropdown
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
function Hide-CommandsDropdown {
    if ($global:form -and $global:isVisible) {
        $global:form.Close()
        $global:form.Dispose()
        $global:form = $null
        $global:isVisible = $false
    }
}

# Main execution when run directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Show-CommandsDropdown
    
    # Keep script running
    while ($global:isVisible) {
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Application]::DoEvents()
    }
}

# Functions available when script is dot-sourced
# Show-CommandsDropdown, Hide-CommandsDropdown
