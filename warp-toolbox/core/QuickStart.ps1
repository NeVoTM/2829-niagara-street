# QuickStart.ps1 - INSTANT DEBUG SHORTCUTS
# Copy these to your PowerShell profile for ultimate speed

# ULTRA-FAST ALIASES
Set-Alias -Name "d" -Value "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1"
Set-Alias -Name "debug" -Value "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1"

# ONE-LETTER SHORTCUTS
function c { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" check }
function p { param($port = "3000") & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" port $port }
function f { param($file) & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" file $file }
function e { param($error) & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" error $error }
function g { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" git }
function n { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" npm }
function l { param($issue = "border overlap") & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\LayoutDebugger.ps1" quick -Issue $issue }
function fixwarp { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\LayoutDebugger.ps1" fixwarp }

# VISUAL INTERFACE SHORTCUT
function visual { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\StartVisual.ps1" }
function v { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\StartVisual.ps1" }

# RELOAD SHORTCUTS SHORTCUT
function q { . "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\QuickStart.ps1" }

# SUPER COMMON DEBUGGING SHORTCUTS
function check { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" check }
function port3000 { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" port 3000 }
function port8080 { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" port 8080 }
function gitstatus { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" git }
function npmcheck { & "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\DebugToolbox.ps1" npm }

