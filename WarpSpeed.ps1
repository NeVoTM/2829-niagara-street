# WarpSpeed-Enhanced.ps1 - Complete SOS Procedure
# Reads ALL compliance files and provides confirmation
#
# 🚨 CRITICAL FOR WARP AI: 🚨
# STEP 0: READ CUSTOMER PROFILE FIRST!
# Before doing ANYTHING, Warp AI must:
# 1. Read C:\Users\17274\ME\Scripts\New-Session-Instructions.md
# 2. Acknowledge all user preferences and rules from the profile
# 3. Confirm you will follow these profile rules
#
# STEP 1: READ FROM GITHUB FIRST
# When reading compliance files, you MUST:
# 1. Read from GitHub: https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/warp-compliance/[FILENAME]
# 2. NEVER read local files without confirming GitHub first
# 3. Confirm to user: "Reading from GitHub" before accessing any file
#
# RULE 1.1: GitHub-First Principle is MANDATORY

param(
    [switch]$Install = $false,
    [switch]$ShowPath = $false,
    [switch]$Update = $false,
    [switch]$QuickStart = $false
)

$gitRepo = "C:\Users\17274\ME\2829-Niagara-Street"
$complianceFolder = "$gitRepo\warp-compliance"

# SOS STEP 1: READ ALL COMPLIANCE FILES FROM GITHUB
function Read-ComplianceFiles {
    Write-Host "`n🤖 WARP AI SOS PROCEDURE - READING FROM GITHUB" -ForegroundColor Cyan
    Write-Host "📡 Source: https://github.com/NeVoTM/2829-niagara-street" -ForegroundColor Gray
    Write-Host "=" * 70 -ForegroundColor Blue
    
    $gitHubBase = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/warp-compliance"
    
    $filesToRead = @(
        @{Name="WARP-MASTER-RULES.md"; Description="📜 MASTER RULES - Single source of truth (24 numbered rules)"; URL="$gitHubBase/WARP-MASTER-RULES.md"},
        @{Name="WARP-COMMANDS-REFERENCE.md"; Description="🚀 Complete command reference (all available commands)"; URL="$gitHubBase/WARP-COMMANDS-REFERENCE.md"},
        @{Name="WARP-QUESTIONS-GUIDE.md"; Description="Question formats and user preferences"; URL="$gitHubBase/WARP-QUESTIONS-GUIDE.md"},
        @{Name="TODO-LIST.md"; Description="Open items and priorities"; URL="$gitHubBase/TODO-LIST.md"},
        @{Name="DEBUGGING-CHECKLIST.md"; Description="Universal solutions (10 categories)"; URL="$gitHubBase/DEBUGGING-CHECKLIST.md"},
        @{Name="WARP-START-SESSION.md"; Description="Session startup procedures"; URL="$gitHubBase/WARP-START-SESSION.md"},
        @{Name="WARP-COMPLIANCE-SYSTEM.md"; Description="Core rules (references MASTER RULES)"; URL="$gitHubBase/WARP-COMPLIANCE-SYSTEM.md"},
        @{Name="WARP-PROCEDURES-HIERARCHY.md"; Description="Numbered procedure system"; URL="$gitHubBase/WARP-PROCEDURES-HIERARCHY.md"}
    )
    
    # Also read directory structure from docs folder
    $docsFile = Join-Path (Split-Path $complianceFolder -Parent) "warp-toolbox\docs\SAIT-DIRECTORY-STRUCTURE.md"
    if (Test-Path $docsFile) {
        Write-Host "  ✅ SAIT-DIRECTORY-STRUCTURE.md" -ForegroundColor Green
        Write-Host "     Directory and file organization" -ForegroundColor Gray
        $filesToRead += @{Name="SAIT-DIRECTORY-STRUCTURE.md"; Description="Directory and file organization"}
    }
    
    $filesRead = @()
    $filesFailed = @()
    
    Write-Host "`n📥 DOWNLOADING FROM GITHUB..." -ForegroundColor Yellow
    
    foreach ($file in $filesToRead) {
        Write-Host ""
        Write-Host "  ▶️  EXECUTING: Invoke-WebRequest" -ForegroundColor Yellow
        Write-Host "     File: $($file.Name)" -ForegroundColor Gray
        Write-Host "     URL: $($file.URL)" -ForegroundColor Gray
        
        try {
            $response = Invoke-WebRequest -Uri $file.URL -UseBasicParsing -ErrorAction Stop
            Write-Host "  ✅ COMPLETED: Downloaded successfully ($($response.Content.Length) bytes)" -ForegroundColor Green
            Write-Host "     $($file.Description)" -ForegroundColor Cyan
            $filesRead += $file.Name
        } catch {
            Write-Host "  ❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
            $filesFailed += $file.Name
        }
    }
    
    Write-Host ""
    Write-Host "✅ Successfully read from GitHub: $($filesRead.Count)/$($filesToRead.Count)" -ForegroundColor Green
    
    if ($filesFailed.Count -gt 0) {
        Write-Host "❌ Failed to read: $($filesFailed -join ', ')" -ForegroundColor Red
    }
    
    return @{
        Read = $filesRead
        Failed = $filesFailed
    }
}

# SOS STEP 2: CHECK TODO LIST AND SHOW BREAKDOWN
function Get-TodoItems {
    Write-Host "`n📋 CHECKING TODO LIST FOR OPEN ITEMS..." -ForegroundColor Yellow
    Write-Host "=" * 70 -ForegroundColor Blue
    
    $todoPath = Join-Path $complianceFolder "TODO-LIST.md"
    
    if (-not (Test-Path $todoPath)) {
        Write-Host "  ⚠️  TODO-LIST.md not found" -ForegroundColor Red
        return @{ Total=0; Path=$null }
    }
    
    $content = Get-Content $todoPath -Raw
    
    # Count unchecked items total
    $totalUnchecked = ([regex]::Matches($content, '- \[ \]')).Count
    
    # Extract sections and count items in each
    $sections = @(
        @{Name="1.0 CRITICAL PRIORITY"; Pattern='(?s)## 1\.0.*?(?=## 2\.0|$)'; Color="Red"},
        @{Name="2.0 IMPORTANT"; Pattern='(?s)## 2\.0.*?(?=## 3\.0|$)'; Color="Yellow"},
        @{Name="3.0 PROJECT-SPECIFIC"; Pattern='(?s)## 3\.0.*?(?=## 4\.0|$)'; Color="White"},
        @{Name="4.0+ SYSTEM-WIDE"; Pattern='(?s)## [4-9]\.0.*$'; Color="Gray"}
    )
    
    Write-Host "  📊 Total Open Items: $totalUnchecked" -ForegroundColor White
    Write-Host ""
    Write-Host "  📌 BREAKDOWN BY PRIORITY:" -ForegroundColor Cyan
    
    foreach ($section in $sections) {
        $sectionMatch = [regex]::Match($content, $section.Pattern)
        if ($sectionMatch.Success) {
            $sectionContent = $sectionMatch.Value
            $sectionCount = ([regex]::Matches($sectionContent, '- \[ \]')).Count
            $icon = if ($section.Color -eq "Red") { "🔴" } 
                    elseif ($section.Color -eq "Yellow") { "🟡" } 
                    else { "⚪" }
            Write-Host "     $icon $($section.Name): $sectionCount items" -ForegroundColor $section.Color
        }
    }
    
    Write-Host ""
    Write-Host "  💡 Opening TODO-LIST.md for review..." -ForegroundColor Gray
    
    # Open TODO file
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process code $todoPath
    } else {
        Start-Process $todoPath
    }
    
    Write-Host ""
    return @{ Total=$totalUnchecked; Path=$todoPath }
}

# Cleanup moved to EOS command (RULE 1.1a requirement)

# SOS STEP 4: REQUEST WARP AI RULE CONFIRMATION
function Request-WarpConfirmation {
    Write-Host "`n" + "=" * 70 -ForegroundColor Magenta
    Write-Host "👋 USER: ASK WARP AI TO CONFIRM RULES" -ForegroundColor Magenta
    Write-Host "=" * 70 -ForegroundColor Magenta
    
    Write-Host ""
    Write-Host "🗣️  USER MUST NOW ASK:" -ForegroundColor Yellow
    Write-Host "   'Warp, confirm you will follow RULE 1.1, 2.1, 4.1, and 4.2'" -ForegroundColor White
    Write-Host ""
    Write-Host "🤖 WARP AI MUST RESPOND:" -ForegroundColor Cyan
    Write-Host "   'I confirm and commit to following:" -ForegroundColor White
    Write-Host "    - RULE 1.1: GitHub-first (read/save GitHub BEFORE local)" -ForegroundColor White
    Write-Host "    - RULE 2.1: Use numbered references (SECTION X.X)" -ForegroundColor White
    Write-Host "    - RULE 4.1: Fix ALL instances (not just one)" -ForegroundColor White
    Write-Host "    - RULE 4.2: Update cross-references" -ForegroundColor White
    Write-Host "    I will do my absolute best to follow these rules.'" -ForegroundColor White
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor Magenta
    Write-Host ""
}

# SOS STEP 5: DISPLAY WARP CONFIRMATION (after user asks)
function Show-WarpConfirmation {
    param($FilesRead, $TodoCount)
    
    Write-Host "`n" + "=" * 70 -ForegroundColor Green
    Write-Host "🤖 WARP AI STATUS REPORT" -ForegroundColor Green
    Write-Host "=" * 70 -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📢 SOURCE CONFIRMED: Reading from GitHub" -ForegroundColor Cyan
    Write-Host "   https://github.com/NeVoTM/2829-niagara-street/tree/main/warp-compliance" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "✅ FILES READ FROM GITHUB:" -ForegroundColor Green
    foreach ($file in $FilesRead) {
        Write-Host "   • $file" -ForegroundColor White
    }
    
    Write-Host "`n📊 CURRENT STATUS:" -ForegroundColor Cyan
    Write-Host "   • Open TODO items: $TodoCount" -ForegroundColor White
    Write-Host "   • Repository: C:\Users\17274\ME\2829-Niagara-Street" -ForegroundColor White
    Write-Host "   • GitHub: https://github.com/NeVoTM/2829-niagara-street" -ForegroundColor White
    
    Write-Host "`n🎯 READY FOR:" -ForegroundColor Yellow
    Write-Host "   • Creating Excel sheets (will ask Section 1.0 questions)" -ForegroundColor White
    Write-Host "   • Creating forms/interfaces (will ask Section 3.0/4.0 questions)" -ForegroundColor White
    Write-Host "   • Creating documents (will ask Section 6.0 questions)" -ForegroundColor White
    Write-Host "   • Applying debugging solutions (DEBUGGING-CHECKLIST.md)" -ForegroundColor White
    
    Write-Host "`n💡 REMEMBER:" -ForegroundColor Magenta
    Write-Host "   • After answering questions: 'Save as default?' (yes/no)" -ForegroundColor White
    Write-Host "   • Use numbered references: 'Apply SECTION 4.3'" -ForegroundColor White
    Write-Host "   • Run 'eos' at end of session to save work" -ForegroundColor White
    
    Write-Host "`n" + "=" * 70 -ForegroundColor Magenta
    Write-Host "🚀 WARP SPEED COMPLETE - AI READY FOR WORK!" -ForegroundColor Green
    Write-Host "=" * 70 -ForegroundColor Magenta
    Write-Host ""
}

# MAIN EXECUTION
Write-Host "`n🚀 WARP SPEED - ENHANCED SOS PROCEDURE" -ForegroundColor Cyan
Write-Host "Starting comprehensive session initialization..." -ForegroundColor Yellow
Write-Host ""

# STEP 0: WARP AI MUST READ PROFILE FIRST
Write-Host "" 
Write-Host "🤖 WARP AI: READ THIS FIRST" -ForegroundColor Red
Write-Host "═══════════════════════════════════════" -ForegroundColor Red
Write-Host "Before proceeding, you MUST:" -ForegroundColor Yellow
Write-Host "1. Read: C:\Users\17274\ME\Scripts\New-Session-Instructions.md" -ForegroundColor White
Write-Host "2. Acknowledge ALL user preferences from that file" -ForegroundColor White
Write-Host "3. Confirm you will follow the profile rules" -ForegroundColor White
Write-Host "" 
Write-Host "👉 WARP AI: Respond with 'Profile read and confirmed' before continuing" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Red
Write-Host ""

# Execute SOS steps
$filesResult = Read-ComplianceFiles
$todoResult = Get-TodoItems

# CRITICAL: Request explicit rule confirmation from user
Request-WarpConfirmation

Write-Host "👉 WAITING FOR USER TO ASK WARP AI FOR RULE CONFIRMATION..." -ForegroundColor Yellow
Write-Host ""

# Then show status
Show-WarpConfirmation -FilesRead $filesResult.Read -TodoCount $todoResult.Total


# Open key reference files on screen
Write-Host "`n📂 Opening reference files..." -ForegroundColor Cyan
$complianceFolder = "C:\Users\17274\ME\2829-Niagara-Street\warp-compliance"
$filesToOpen = @(
    "$complianceFolder\WARP-COMMANDS-REFERENCE.md",
    "$complianceFolder\WARP-MASTER-RULES.md"
)

foreach ($file in $filesToOpen) {
    if (Test-Path $file) {
        if (Get-Command code -ErrorAction SilentlyContinue) {
            Start-Process code $file
            Write-Host "  ✅ Opened: $(Split-Path $file -Leaf)" -ForegroundColor Green
        } else {
            Start-Process notepad $file
            Write-Host "  ✅ Opened in Notepad: $(Split-Path $file -Leaf)" -ForegroundColor Green
        }
    }
}
Write-Host ""
# Display quick commands
Write-Host "⚡ QUICK COMMANDS:" -ForegroundColor Cyan
Write-Host "   clean           # Run profile cleanup analysis" -ForegroundColor Gray
Write-Host "   eos             # End of session routine" -ForegroundColor Gray
Write-Host "   q               # Reload SwiftLetter shortcuts" -ForegroundColor Gray
Write-Host ""

# WARP AI AUTO-TRIGGER
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Yellow
Write-Host "🤖 WARP AI: EXECUTE AUTO-SEQUENCE NOW" -ForegroundColor Yellow
Write-Host ("=" * 70) -ForegroundColor Yellow
Write-Host ""
Write-Host "Per WARP-START-SESSION.md Section 1.1, you must now automatically:" -ForegroundColor Cyan
Write-Host ""
Write-Host "COMMAND 1: Read TODO-LIST.md from GitHub" -ForegroundColor White
Write-Host "  → URL: https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/warp-compliance/TODO-LIST.md" -ForegroundColor Gray
Write-Host "  → Display: All items from SECTION 1.0 (CRITICAL PRIORITY)" -ForegroundColor Gray
Write-Host ""
Write-Host "COMMAND 2: Check git status" -ForegroundColor White
Write-Host "  → Run: git --no-pager status" -ForegroundColor Gray
Write-Host "  → Show: Any uncommitted changes or clean status" -ForegroundColor Gray
Write-Host ""
Write-Host "COMMAND 3: Display status message" -ForegroundColor White
Write-Host "  → Format: 'Ready to work. Current priorities: [list top 3 from TODO 1.0]'" -ForegroundColor Gray
Write-Host ""
Write-Host "COMMAND 4: Ask user which priority" -ForegroundColor White
Write-Host "  → Question: 'Which priority should we tackle first?'" -ForegroundColor Gray
Write-Host ""
Write-Host "🔴 MANDATORY: Show each command AS YOU RUN IT with format:" -ForegroundColor Red
Write-Host "   ▶️ EXECUTING: [command description]" -ForegroundColor Yellow
Write-Host "   ✅ COMPLETED: [what was found/done]" -ForegroundColor Green
Write-Host ""
Write-Host "👉 DO NOT just say 'I read the files' - EXECUTE and SHOW each command NOW." -ForegroundColor Red
Write-Host ("=" * 70) -ForegroundColor Yellow
Write-Host ""

# FINAL STEP: Prompt user to tell Warp AI to confirm files
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📋 FINAL STEP: FILE CONFIRMATION" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""
Write-Host "👉 Now tell Warp AI: 'Confirm files read'" -ForegroundColor Yellow
Write-Host ""
Write-Host "Warp AI will respond with list of files successfully loaded." -ForegroundColor Gray
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

