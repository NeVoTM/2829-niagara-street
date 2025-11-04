# TestDropdown.ps1 - Simple test to see if Windows Forms works

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "Creating test window..." -ForegroundColor Green

$form = New-Object System.Windows.Forms.Form
$form.Text = "TEST DROPDOWN"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "If you see this window, dropdowns are working!"
$label.Size = New-Object System.Drawing.Size(350, 50)
$label.Location = New-Object System.Drawing.Point(25, 50)
$label.Font = New-Object System.Drawing.Font("Arial", 12)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Close"
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Location = New-Object System.Drawing.Point(150, 150)
$button.Add_Click({ $form.Close() })

$form.Controls.Add($label)
$form.Controls.Add($button)

Write-Host "Showing window..." -ForegroundColor Green
$form.ShowDialog()
Write-Host "Window closed." -ForegroundColor Green