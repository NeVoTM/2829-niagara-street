# Setup-Warp-CustomCommands.ps1 - Automated Setup Guide for Warp Custom Commands
# Purpose: Provide copy-paste ready commands and step-by-step instructions
# Usage: Run this script to get all the setup information you need

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Custom commands data
$customCommands = @(
    @{
        Name = "DebugRef"
        Shortcut = "Ctrl+Shift+D"
        Description = "Show common debugging issues"
        Command = "echo 'DEBUGGING-CHECKLIST.md Quick Reference:'; echo 'ISSUE 4.1: Infinite scroll (max-height: 100vh)'; echo 'ISSUE 4.2: Chart sizing (max-height: 280px)'; echo 'ISSUE 4.3: Alignment (separate tables)'; echo 'ISSUE 4.4: Text visibility (text-shadow)'; echo 'ISSUE 4.7: Mobile usability (44px targets)'"
    },
    @{
        Name = "GitHubFirst"
        Shortcut = "Ctrl+Shift+G"
        Description = "Universal Access Principle reminder"
        Command = "echo '🚨 UNIVERSAL ACCESS PRINCIPLE: GitHub first, then copy to local (NEVER local first)'"
    },
    @{
        Name = "NumRef"
        Shortcut = "Ctrl+Shift+N"
        Description = "Numbered reference template"
        Command = "echo 'Use numbered references:'; echo 'SECTION X.X - for main categories'; echo 'ISSUE X.X - for specific problems'; echo 'TODO X.X.X - for task items'"
    },
    @{
        Name = "ComplianceCheck"
        Shortcut = "Ctrl+Shift+C"
        Description = "Session compliance checklist"
        Command = "echo 'Session Compliance Checklist:'; echo '✓ Started with WarpSpeed?'; echo '✓ Using numbered references?'; echo '✓ Following GitHub-first principle?'; echo '✓ Updating all related files?'"
    },
    @{
        Name = "QACheck"
        Shortcut = "Ctrl+Shift+Q"
        Description = "Quality assurance categories"
        Command = "echo 'Quality Checklist (SECTION 6.0):'; echo '6.1: Charts & Visualizations'; echo '6.2: Buttons & Navigation'; echo '6.3: iPhone Optimization'; echo '6.4: Images & Slideshow'; echo '6.5: Links & Integration'; echo '6.6: Professional Appearance'; echo '6.7: Technical Testing'"
    },
    @{
        Name = "MobileFirst"
        Shortcut = "Ctrl+Shift+M"
        Description = "Mobile-first design principles"
        Command = "echo '📱 Mobile-First Design (SECTION 2.0):'; echo '• iPhone viewport priority'; echo '• Max section height: 100vh'; echo '• Chart limit: 280px'; echo '• Touch targets: 44px min'; echo '• Text shadows for visibility'"
    },
    @{
        Name = "DataCheck"
        Shortcut = "Ctrl+Shift+V"
        Description = "Data validation and marketing rules"
        Command = ".\\Update-ProjectData.ps1 -ValidateOnly; echo 'Marketing Rules: Revenue UP, Costs precise'"
    },
    @{
        Name = "UpdateFlow"
        Shortcut = "Ctrl+Shift+U"
        Description = "File update workflow"
        Command = "echo 'File Update Workflow:'; echo '1. Update GitHub master files first'; echo '2. Copy changes to local'; echo '3. Update cross-references'; echo '4. Test and validate'"
    }
)

# Function to display setup instructions
function Show-SetupInstructions {
    Write-Host ""
    Write-Host "🔧 WARP CUSTOM COMMANDS SETUP GUIDE" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Blue
    Write-Host ""
    Write-Host "STEP 1: Open Warp Terminal Settings" -ForegroundColor Yellow
    Write-Host "Method 1: Press Ctrl+, (Windows) or Cmd+, (Mac)" -ForegroundColor White
    Write-Host "Method 2: Click Warp menu > Settings" -ForegroundColor White
    Write-Host ""
    Write-Host "STEP 2: Navigate to Custom Commands" -ForegroundColor Yellow
    Write-Host "Click: Features > Custom Commands > Add Command" -ForegroundColor White
    Write-Host ""
    Write-Host "STEP 3: Add Each Command Below" -ForegroundColor Yellow
    Write-Host "Copy the Name, Description, and Command for each:" -ForegroundColor White
    Write-Host ""

    $commandNumber = 1
    foreach ($cmd in $customCommands) {
        Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
        Write-Host "COMMAND $commandNumber OF 8" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "Name: " -NoNewline -ForegroundColor Yellow
        Write-Host "$($cmd.Name)" -ForegroundColor White
        Write-Host ""
        Write-Host "Description: " -NoNewline -ForegroundColor Yellow  
        Write-Host "$($cmd.Description)" -ForegroundColor White
        Write-Host ""
        Write-Host "Command: " -NoNewline -ForegroundColor Yellow
        Write-Host "$($cmd.Command)" -ForegroundColor Green
        Write-Host ""
        Write-Host "Suggested Shortcut: $($cmd.Shortcut)" -ForegroundColor Cyan
        Write-Host ""
        $commandNumber++
    }

    Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    Write-Host "STEP 4: Set Up Keyboard Shortcuts (Optional)" -ForegroundColor Yellow
    Write-Host "Go to: Settings > Features > Keyboard Shortcuts" -ForegroundColor White
    Write-Host "Add shortcuts for each custom command:" -ForegroundColor White
    Write-Host ""
    
    foreach ($cmd in $customCommands) {
        Write-Host "  $($cmd.Shortcut) → $($cmd.Name)" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "STEP 5: Test Your Setup" -ForegroundColor Yellow
    Write-Host "Type any command name (e.g., 'DebugRef') to test" -ForegroundColor White
    Write-Host "Or use keyboard shortcuts if configured" -ForegroundColor White
    Write-Host ""
}

# Function to create interactive setup form
function Show-InteractiveSetup {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "🔧 Warp Custom Commands Setup"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $form.ForeColor = [System.Drawing.Color]::White

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "WARP CUSTOM COMMANDS - COPY & PASTE SETUP"
    $title.Size = New-Object System.Drawing.Size(760, 30)
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.ForeColor = [System.Drawing.Color]::Cyan
    $title.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
    $title.TextAlign = "MiddleCenter"
    $form.Controls.Add($title)

    # Instructions
    $instructions = New-Object System.Windows.Forms.Label
    $instructions.Text = "1. Open Warp Settings (Ctrl+,) > Features > Custom Commands > Add Command`n2. Click any command below to copy its details`n3. Paste into Warp settings fields"
    $instructions.Size = New-Object System.Drawing.Size(760, 50)
    $instructions.Location = New-Object System.Drawing.Point(20, 60)
    $instructions.ForeColor = [System.Drawing.Color]::Yellow
    $instructions.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.Controls.Add($instructions)

    # Create buttons for each command
    $buttonY = 120
    $buttonHeight = 50
    $buttonSpacing = 55

    foreach ($cmd in $customCommands) {
        $button = New-Object System.Windows.Forms.Button
        $button.Text = "$($cmd.Name) ($($cmd.Shortcut))`n$($cmd.Description)"
        $button.Size = New-Object System.Drawing.Size(760, $buttonHeight)
        $button.Location = New-Object System.Drawing.Point(20, $buttonY)
        $button.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
        $button.ForeColor = [System.Drawing.Color]::White
        $button.FlatStyle = "Flat"
        $button.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
        $button.TextAlign = "MiddleLeft"
        
        # Copy command details on click
        $cmdData = $cmd
        $button.Add_Click({
            $setupText = @"
Name: $($cmdData.Name)
Description: $($cmdData.Description)
Command: $($cmdData.Command)
Suggested Shortcut: $($cmdData.Shortcut)
"@
            [System.Windows.Forms.Clipboard]::SetText($setupText)
            
            # Show notification
            [System.Windows.Forms.MessageBox]::Show("Command details copied to clipboard!`n`nNow paste into Warp Settings:`n1. Name field: $($cmdData.Name)`n2. Description field: $($cmdData.Description)`n3. Command field: $($cmdData.Command)", "Copied", "OK", "Information")
        }.GetNewClosure())
        
        $form.Controls.Add($button)
        $buttonY += $buttonSpacing
    }

    # Copy all commands button
    $copyAllButton = New-Object System.Windows.Forms.Button
    $copyAllButton.Text = "📋 COPY ALL COMMANDS AS TEXT"
    $copyAllButton.Size = New-Object System.Drawing.Size(300, 30)
    $copyAllButton.Location = New-Object System.Drawing.Point(20, 520)
    $copyAllButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $copyAllButton.ForeColor = [System.Drawing.Color]::White
    $copyAllButton.FlatStyle = "Flat"
    $copyAllButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    
    $copyAllButton.Add_Click({
        $allCommands = ""
        $commandNum = 1
        foreach ($cmd in $customCommands) {
            $allCommands += "COMMAND $commandNum OF 8`n"
            $allCommands += "Name: $($cmd.Name)`n"
            $allCommands += "Description: $($cmd.Description)`n"
            $allCommands += "Command: $($cmd.Command)`n"
            $allCommands += "Shortcut: $($cmd.Shortcut)`n"
            $allCommands += "`n" + "─" * 50 + "`n`n"
            $commandNum++
        }
        [System.Windows.Forms.Clipboard]::SetText($allCommands)
        [System.Windows.Forms.MessageBox]::Show("All 8 commands copied to clipboard as text!", "All Commands Copied", "OK", "Information")
    })
    $form.Controls.Add($copyAllButton)

    # Open Warp Settings button
    $settingsButton = New-Object System.Windows.Forms.Button
    $settingsButton.Text = "⚙️ OPEN WARP SETTINGS"
    $settingsButton.Size = New-Object System.Drawing.Size(200, 30)
    $settingsButton.Location = New-Object System.Drawing.Point(340, 520)
    $settingsButton.BackColor = [System.Drawing.Color]::FromArgb(120, 180, 60)
    $settingsButton.ForeColor = [System.Drawing.Color]::White
    $settingsButton.FlatStyle = "Flat"
    $settingsButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    
    $settingsButton.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("In Warp Terminal:`n1. Press Ctrl+, (or Cmd+, on Mac)`n2. Navigate to Features > Custom Commands`n3. Click 'Add Command' for each of the 8 commands", "How to Open Settings", "OK", "Information")
    })
    $form.Controls.Add($settingsButton)

    # Close button
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "CLOSE"
    $closeButton.Size = New-Object System.Drawing.Size(100, 30)
    $closeButton.Location = New-Object System.Drawing.Point(660, 520)
    $closeButton.BackColor = [System.Drawing.Color]::FromArgb(180, 60, 60)
    $closeButton.ForeColor = [System.Drawing.Color]::White
    $closeButton.FlatStyle = "Flat"
    $closeButton.Add_Click({ $form.Close() })
    $form.Controls.Add($closeButton)

    $form.ShowDialog()
}

# Function to generate markdown documentation
function Export-SetupDocumentation {
    $docPath = "WARP-CUSTOM-COMMANDS-SETUP.md"
    $content = @"
# 🔧 Warp Custom Commands Setup Guide

## Quick Setup Steps

1. **Open Warp Settings**: Press `Ctrl+,` (Windows) or `Cmd+,` (Mac)
2. **Navigate**: Settings > Features > Custom Commands > Add Command
3. **Add Each Command**: Copy the details below for each of the 8 commands

## The 8 Essential Custom Commands

"@

    $commandNum = 1
    foreach ($cmd in $customCommands) {
        $content += "`n`n### Command ${commandNum}: $($cmd.Name)`n`n"
        $content += "**Name**: ``$($cmd.Name)```n"
        $content += "**Description**: $($cmd.Description)`n"
        $content += "**Command**: `n``````n$($cmd.Command)`n``````n"
        $content += "**Suggested Keyboard Shortcut**: $($cmd.Shortcut)`n`n---`n"
        $commandNum++
    }

    $content += @"

## Keyboard Shortcuts Setup (Optional)

After adding commands, set up keyboard shortcuts:

1. Go to Settings > Features > Keyboard Shortcuts
2. Add these shortcuts:

"@

    foreach ($cmd in $customCommands) {
        $content += "   - **$($cmd.Shortcut)** → $($cmd.Name)`n"
    }

    $content += @"

## Usage After Setup

Once configured, you can use these commands:
- Type the command name directly (e.g., `DebugRef`)
- Use keyboard shortcuts (if configured)
- Access via Warp command menu

## Time Savings

These 8 commands will save you **15-20 minutes per AI session** by providing instant access to:
- Common debugging solutions
- Compliance checklists  
- Universal Access Principle reminders
- Quality assurance categories
- Mobile-first design principles
- Data validation workflows

## Integration with Dropdown Tools

These custom commands work alongside the dropdown tools:
- **Ctrl+Alt+D**: Debug issues dropdown
- **Ctrl+Alt+C**: Commands browser  
- **Ctrl+Alt+F**: Files browser
- **Ctrl+Alt+R**: Reference selector

Together, they create the most efficient AI collaboration system available.
"@

    Set-Content -Path $docPath -Value $content -Encoding UTF8
    Write-Host "✅ Setup documentation exported to: $docPath" -ForegroundColor Green
    return $docPath
}

# Main menu
function Show-MainMenu {
    Write-Host ""
    Write-Host "🔧 WARP CUSTOM COMMANDS SETUP ASSISTANT" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Choose your preferred setup method:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[1] 📋 Interactive GUI Setup (Recommended)" -ForegroundColor Green
    Write-Host "[2] 📄 Console Text Instructions" -ForegroundColor White  
    Write-Host "[3] 📝 Export Setup Documentation" -ForegroundColor Cyan
    Write-Host "[4] ❌ Exit" -ForegroundColor Red
    Write-Host ""
    
    $choice = Read-Host "Enter your choice (1-4)"
    
    switch ($choice) {
        "1" { 
            Write-Host "Opening interactive setup..." -ForegroundColor Green
            Show-InteractiveSetup 
        }
        "2" { 
            Show-SetupInstructions 
        }
        "3" { 
            $docPath = Export-SetupDocumentation
            Write-Host "Setup guide exported! You can now reference $docPath anytime." -ForegroundColor Green
        }
        "4" { 
            Write-Host "Setup assistant closed." -ForegroundColor Gray
            return 
        }
        default { 
            Write-Host "Invalid choice. Please select 1-4." -ForegroundColor Red
            Show-MainMenu 
        }
    }
}

# Run main menu when script is executed directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Show-MainMenu
}