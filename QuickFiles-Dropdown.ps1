# QuickFiles-Dropdown.ps1 - Global Hotkey Dropdown for Project Files
# Global Hotkey: Ctrl+Alt+F (configurable)  
# Screen Coverage: 30% of screen size
# Purpose: Instant access to all project files with quick opening

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$form = $null
$isVisible = $false

# Function to get all project files
function Get-ProjectFiles {
    $projectRoot = Get-Location
    $allFiles = @()
    
    # Essential files (prioritized)
    $essentialFiles = @(
        "DEBUGGING-CHECKLIST.md",
        "WARP-START-SESSION.md", 
        "NUMBERED-REFERENCE-GUIDE.md",
        "WARP-CUSTOM-COMMANDS.md",
        "WARP-GAPS-ANALYSIS.md",
        "WARP-TERMINAL-INTEGRATION.md",
        "README.md",
        "project-data.json",
        "Update-ProjectData.ps1",
        "WarpSpeed.ps1"
    )
    
    # Add essential files if they exist
    foreach ($file in $essentialFiles) {
        $fullPath = Join-Path $projectRoot $file
        if (Test-Path $fullPath) {
            $fileInfo = Get-Item $fullPath
            $allFiles += @{
                Category = "Essential Files"
                Name = $file
                Size = [math]::Round($fileInfo.Length / 1KB, 1)
                Modified = $fileInfo.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
                Path = $fullPath
                Extension = $fileInfo.Extension
            }
        }
    }
    
    # Add dropdown scripts
    $dropdownFiles = Get-ChildItem -Path $projectRoot -Filter "Quick*-Dropdown.ps1" -ErrorAction SilentlyContinue
    foreach ($file in $dropdownFiles) {
        $allFiles += @{
            Category = "Dropdown Scripts"
            Name = $file.Name
            Size = [math]::Round($file.Length / 1KB, 1)
            Modified = $file.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
            Path = $file.FullName
            Extension = $file.Extension
        }
    }
    
    # Add HTML interfaces
    $htmlFiles = Get-ChildItem -Path $projectRoot -Filter "*.html" -ErrorAction SilentlyContinue
    foreach ($file in $htmlFiles) {
        $allFiles += @{
            Category = "Web Interfaces"
            Name = $file.Name
            Size = [math]::Round($file.Length / 1KB, 1)
            Modified = $file.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
            Path = $file.FullName
            Extension = $file.Extension
        }
    }
    
    # Add other documentation
    $docFiles = Get-ChildItem -Path $projectRoot -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $essentialFiles }
    foreach ($file in $docFiles) {
        $allFiles += @{
            Category = "Documentation"
            Name = $file.Name
            Size = [math]::Round($file.Length / 1KB, 1)
            Modified = $file.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
            Path = $file.FullName
            Extension = $file.Extension
        }
    }
    
    # Add PowerShell scripts
    $psFiles = Get-ChildItem -Path $projectRoot -Filter "*.ps1" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin @($essentialFiles + $dropdownFiles.Name) }
    foreach ($file in $psFiles) {
        $allFiles += @{
            Category = "PowerShell Scripts"
            Name = $file.Name
            Size = [math]::Round($file.Length / 1KB, 1)
            Modified = $file.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
            Path = $file.FullName
            Extension = $file.Extension
        }
    }
    
    # Add data files
    $dataFiles = Get-ChildItem -Path $projectRoot -Filter "*.json", "*.csv", "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $dataFiles | Where-Object { $_.Name -notin $essentialFiles }) {
        $allFiles += @{
            Category = "Data Files"
            Name = $file.Name
            Size = [math]::Round($file.Length / 1KB, 1)
            Modified = $file.LastWriteTime.ToString("MM/dd/yyyy HH:mm")
            Path = $file.FullName
            Extension = $file.Extension
        }
    }
    
    return $allFiles
}

# Function to open file with appropriate application
function Open-ProjectFile {
    param([string]$FilePath)
    
    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    
    switch ($extension) {
        ".md" { 
            # Try VS Code first, fall back to notepad
            try {
                Start-Process "code" -ArgumentList "`"$FilePath`"" -ErrorAction Stop
            } catch {
                Start-Process "notepad" -ArgumentList "`"$FilePath`""
            }
        }
        ".json" {
            try {
                Start-Process "code" -ArgumentList "`"$FilePath`"" -ErrorAction Stop
            } catch {
                Start-Process "notepad" -ArgumentList "`"$FilePath`""
            }
        }
        ".ps1" {
            try {
                Start-Process "powershell_ise" -ArgumentList "`"$FilePath`"" -ErrorAction Stop
            } catch {
                try {
                    Start-Process "code" -ArgumentList "`"$FilePath`"" -ErrorAction Stop
                } catch {
                    Start-Process "notepad" -ArgumentList "`"$FilePath`""
                }
            }
        }
        ".html" {
            Start-Process $FilePath  # Opens in default browser
        }
        default {
            Start-Process "notepad" -ArgumentList "`"$FilePath`""
        }
    }
}

# Function to create and show dropdown
function Show-FilesDropdown {
    if ($global:isVisible) {
        Hide-FilesDropdown
        return
    }

    # Get screen dimensions
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $screenWidth = $screen.Bounds.Width
    $screenHeight = $screen.Bounds.Height
    
    # Calculate 30% coverage
    $formWidth = [int]($screenWidth * 0.7)
    $formHeight = [int]($screenHeight * 0.3)
    $formX = [int](($screenWidth - $formWidth) / 2)
    $formY = [int]($screenHeight * 0.05)

    # Create form
    $global:form = New-Object System.Windows.Forms.Form
    $global:form.Text = "📁 PROJECT FILES BROWSER"
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
    $listView.Columns.Add("File Name", 250) | Out-Null
    $listView.Columns.Add("Size (KB)", 80) | Out-Null
    $listView.Columns.Add("Modified", 130) | Out-Null
    $listView.Columns.Add("Type", 60) | Out-Null

    # Get and add project files
    $projectFiles = Get-ProjectFiles
    foreach ($file in $projectFiles) {
        $item = New-Object System.Windows.Forms.ListViewItem($file.Category)
        $item.SubItems.Add($file.Name) | Out-Null
        $item.SubItems.Add($file.Size.ToString()) | Out-Null
        $item.SubItems.Add($file.Modified) | Out-Null
        $item.SubItems.Add($file.Extension) | Out-Null
        $item.Tag = $file.Path  # Store full path in Tag
        $listView.Items.Add($item) | Out-Null
    }

    # Add double-click event to open file
    $listView.Add_DoubleClick({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedPath = $listView.SelectedItems[0].Tag
            Open-ProjectFile -FilePath $selectedPath
            Hide-FilesDropdown
        }
    })

    # Add right-click menu
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    
    $openMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Open File")
    $openMenuItem.Add_Click({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedPath = $listView.SelectedItems[0].Tag
            Open-ProjectFile -FilePath $selectedPath
        }
    })
    
    $copyPathMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Copy Path")
    $copyPathMenuItem.Add_Click({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedPath = $listView.SelectedItems[0].Tag
            [System.Windows.Forms.Clipboard]::SetText($selectedPath)
            
            # Show notification
            $notif = New-Object System.Windows.Forms.NotifyIcon
            $notif.Icon = [System.Drawing.SystemIcons]::Information
            $notif.BalloonTipText = "File path copied to clipboard"
            $notif.BalloonTipTitle = "QuickFiles"
            $notif.Visible = $true
            $notif.ShowBalloonTip(1500)
            Start-Sleep -Milliseconds 2000
            $notif.Dispose()
        }
    })
    
    $explorerMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Show in Explorer")
    $explorerMenuItem.Add_Click({
        if ($listView.SelectedItems.Count -gt 0) {
            $selectedPath = $listView.SelectedItems[0].Tag
            Start-Process "explorer" -ArgumentList "/select,`"$selectedPath`""
        }
    })
    
    $contextMenu.Items.Add($openMenuItem)
    $contextMenu.Items.Add($copyPathMenuItem)
    $contextMenu.Items.Add($explorerMenuItem)
    $listView.ContextMenuStrip = $contextMenu

    # Search box
    $searchBox = New-Object System.Windows.Forms.TextBox
    $searchBox.Size = New-Object System.Drawing.Size(200, 25)
    $searchBox.Location = New-Object System.Drawing.Point(20, ($formHeight - 60))
    $searchBox.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $searchBox.ForeColor = [System.Drawing.Color]::White
    $searchBox.Text = "🔍 Search files..."

    # Search functionality
    $searchBox.Add_TextChanged({
        $searchText = $searchBox.Text.ToLower()
        if ($searchText -eq "🔍 search files..." -or $searchText -eq "") {
            # Show all files
            $listView.Items.Clear()
            foreach ($file in $projectFiles) {
                $item = New-Object System.Windows.Forms.ListViewItem($file.Category)
                $item.SubItems.Add($file.Name) | Out-Null
                $item.SubItems.Add($file.Size.ToString()) | Out-Null
                $item.SubItems.Add($file.Modified) | Out-Null
                $item.SubItems.Add($file.Extension) | Out-Null
                $item.Tag = $file.Path
                $listView.Items.Add($item) | Out-Null
            }
        } else {
            # Filter files
            $listView.Items.Clear()
            foreach ($file in $projectFiles) {
                if ($file.Name.ToLower().Contains($searchText) -or 
                    $file.Category.ToLower().Contains($searchText)) {
                    $item = New-Object System.Windows.Forms.ListViewItem($file.Category)
                    $item.SubItems.Add($file.Name) | Out-Null
                    $item.SubItems.Add($file.Size.ToString()) | Out-Null
                    $item.SubItems.Add($file.Modified) | Out-Null
                    $item.SubItems.Add($file.Extension) | Out-Null
                    $item.Tag = $file.Path
                    $listView.Items.Add($item) | Out-Null
                }
            }
        }
    })

    # Instructions label
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "💡 Double-click to open | Right-click for options | Search to filter | Press Esc to close"
    $instructions.Size = New-Object System.Drawing.Size(($formWidth - 250), 30)
    $instructions.Location = New-Object System.Drawing.Point(240, ($formHeight - 60))
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
            Hide-FilesDropdown
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
function Hide-FilesDropdown {
    if ($global:form -and $global:isVisible) {
        $global:form.Close()
        $global:form.Dispose()
        $global:form = $null
        $global:isVisible = $false
    }
}

# Main execution when run directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Show-FilesDropdown
    
    # Keep script running
    while ($global:isVisible) {
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Application]::DoEvents()
    }
}

# Functions available when script is dot-sourced
# Show-FilesDropdown, Hide-FilesDropdown
