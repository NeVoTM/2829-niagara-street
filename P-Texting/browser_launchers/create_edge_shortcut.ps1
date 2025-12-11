$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\P-Texting (Edge).lnk")
$Shortcut.TargetPath = "pythonw.exe"
$Shortcut.Arguments = '"C:\Users\17274\ME\2829-Niagara-Street\P-Texting\p_texting_edge.py"'
$Shortcut.WorkingDirectory = "C:\Users\17274\ME\2829-Niagara-Street\P-Texting"
$Shortcut.IconLocation = "shell32.dll,13"
$Shortcut.Save()
Write-Host "Edge shortcut created on desktop"
