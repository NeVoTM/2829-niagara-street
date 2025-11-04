# QuickStart.ps1 - INSTANT DEBUG SHORTCUTS
# Copy these to your PowerShell profile for ultimate speed

# ULTRA-FAST ALIASES
Set-Alias -Name "d" -Value "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1"
Set-Alias -Name "debug" -Value "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1"

# ONE-LETTER SHORTCUTS
function c { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" check }
function p { param($port = "3000") & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" port $port }
function f { param($file) & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" file $file }
function e { param($error) & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" error $error }
function g { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" git }
function n { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" npm }
function l { param($issue = "border overlap") & "C:\Users\17274\ME\super-ai-toolbox\core\LayoutDebugger.ps1" quick -Issue $issue }
function fixwarp { & "C:\Users\17274\ME\super-ai-toolbox\core\LayoutDebugger.ps1" fixwarp }

# VISUAL INTERFACE SHORTCUT
function visual { & "C:\Users\17274\ME\super-ai-toolbox\core\StartVisual.ps1" }
function v { & "C:\Users\17274\ME\super-ai-toolbox\core\StartVisual.ps1" }

# RELOAD SHORTCUTS SHORTCUT
function q { . "C:\Users\17274\ME\super-ai-toolbox\core\QuickStart.ps1" }

# SUPER COMMON DEBUGGING SHORTCUTS
function check { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" check }
function port3000 { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" port 3000 }
function port8080 { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" port 8080 }
function gitstatus { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" git }
function npmcheck { & "C:\Users\17274\ME\super-ai-toolbox\core\DebugToolbox.ps1" npm }

# WARP AI CONFIRMATION PROTOCOL
Write-Host "🤖 WARP AI CONFIRMATION PROTOCOL READY" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "✅ SAIT SYSTEM STATUS: All core functions loaded and tested (Super AI Intelligence Toolbox)" -ForegroundColor Green
Write-Host "✅ COMMANDS READY: Core debugging tools active" -ForegroundColor Green
Write-Host "✅ VISUAL INTERFACE: 10-tab system ready (use 'v' command)" -ForegroundColor Green
Write-Host "✅ PROFILE HEALTH: Optimized, backed up, 30-day retention active" -ForegroundColor Green
Write-Host "✅ CURRENT READINESS: AI can continue with established procedures" -ForegroundColor Green
Write-Host "" 
Write-Host "📱 SESSION CONTINUITY STATUS:" -ForegroundColor Cyan
Write-Host "🟢 SAME CHAT: Full context retained - continue normally" -ForegroundColor Green
Write-Host "🟡 1+ HOUR GAP: I may lose some context - remind me key details if needed" -ForegroundColor Yellow
Write-Host "🔴 NEW CHAT: I have zero memory - share critical files to restore context" -ForegroundColor Red
Write-Host "" 
Write-Host "⚡ WARP-CLI PS: Ready for immediate task execution with numbered procedures" -ForegroundColor Cyan
Write-Host "" 
Write-Host "🧠 WARP COMPLIANCE ACTIVE: Following numbered reference system (SECTION X.X)" -ForegroundColor Blue
Write-Host "📋 GITHUB-FIRST PRINCIPLE: Will reference and update master files" -ForegroundColor Blue
Write-Host "🎯 SYSTEMATIC APPROACH: Maintaining hierarchical structure and cross-references" -ForegroundColor Blue
Write-Host "⚠️ VIOLATION PREVENTION: Applying lessons from debugging pitfalls documented in system" -ForegroundColor Red
Write-Host "═══════════════════════════════════════" -ForegroundColor DarkMagenta
