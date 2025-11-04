# debug-aliases.ps1 - Simple Debug Shortcuts
# Add to PowerShell profile for instant debugging access

# Main debug command - short and sweet
Set-Alias -Name "d" -Value ".\DebugToolbox.ps1"
Set-Alias -Name "debug" -Value ".\DebugToolbox.ps1"

# Specific shortcuts for common tasks
function dcheck { .\DebugToolbox.ps1 check }
function dport { param($port = "3000") .\DebugToolbox.ps1 port $port }
function dfile { param($path) .\DebugToolbox.ps1 file $path }
function derror { param($text) .\DebugToolbox.ps1 error $text }
function dgit { .\DebugToolbox.ps1 git }
function dnpm { .\DebugToolbox.ps1 npm }

# Export functions so they work in terminal
Export-ModuleMember -Function dcheck, dport, dfile, derror, dgit, dnpm

Write-Host "🔧 Debug shortcuts loaded!" -ForegroundColor Green
Write-Host "Use: d, debug, dcheck, dport, dfile, derror, dgit, dnpm" -ForegroundColor Cyan