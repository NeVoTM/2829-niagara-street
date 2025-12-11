# Create Desktop Shortcuts for P-Texting Chrome and Firefox versions

$desktopPath = [Environment]::GetFolderPath("Desktop")
$ptextingFolder = $PSScriptRoot
$pythonPath = (Get-Command pythonw.exe).Source

# Chrome Version Shortcut
$chromeShortcutPath = Join-Path $desktopPath "P-Texting (Chrome).lnk"
$chromeScriptPath = Join-Path $ptextingFolder "p_texting_chrome.py"

$WshShell = New-Object -ComObject WScript.Shell
$chromeShortcut = $WshShell.CreateShortcut($chromeShortcutPath)
$chromeShortcut.TargetPath = $pythonPath
$chromeShortcut.Arguments = "`"$chromeScriptPath`""
$chromeShortcut.WorkingDirectory = $ptextingFolder
$chromeShortcut.Description = "P-Texting Chrome Version - Primary tool"
$chromeShortcut.IconLocation = "$pythonPath,0"
$chromeShortcut.Save()

Write-Output "✓ Created: $chromeShortcutPath"

# Firefox Version Shortcut
$firefoxShortcutPath = Join-Path $desktopPath "P-Texting (Firefox).lnk"
$firefoxScriptPath = Join-Path $ptextingFolder "p_texting_firefox.py"

$firefoxShortcut = $WshShell.CreateShortcut($firefoxShortcutPath)
$firefoxShortcut.TargetPath = $pythonPath
$firefoxShortcut.Arguments = "`"$firefoxScriptPath`""
$firefoxShortcut.WorkingDirectory = $ptextingFolder
$firefoxShortcut.Description = "P-Texting Firefox Version - Backup tool"
$firefoxShortcut.IconLocation = "$pythonPath,0"
$firefoxShortcut.Save()

Write-Output "✓ Created: $firefoxShortcutPath"

Write-Output ""
Write-Output "========================================" 
Write-Output "Desktop Shortcuts Created Successfully!"
Write-Output "========================================" 
Write-Output ""
Write-Output "Chrome Version (PRIMARY):"
Write-Output "  - Use this as your main texting tool"
Write-Output "  - Stays logged in"
Write-Output "  - Best experience"
Write-Output ""
Write-Output "Firefox Version (BACKUP):"
Write-Output "  - Use when Chrome hits daily limit"
Write-Output "  - Must log in each session"
Write-Output "  - New Firefox instance each time"
Write-Output ""
Write-Output "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
