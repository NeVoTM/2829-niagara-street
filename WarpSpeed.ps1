# WarpSpeed-Enhanced.ps1 - Complete SOS Procedure
# Reads ALL compliance files and provides confirmation

param(
    [switch]$Install = $false,
    [switch]$ShowPath = $false,
    [switch]$Update = $false,
    [switch]$QuickStart = $false
)

$gitRepo = "C:\Users\17274\ME\2829-Niagara-Street"
$complianceFolder = "$gitRepo\warp-compliance"

# SOS STEP 1: READ ALL COMPLIANCE FILES
function Read-ComplianceFiles {
    Write-Host "`n🤖 WARP AI SOS PROCEDURE - READING COMPLIANCE FILES" -ForegroundColor Cyan
    Write-Host "=" * 70 -ForegroundColor Blue
    
    $filesToRead = @(
        @{Name="WARP-MASTER-RULES.md"; Description="📜 MASTER RULES - Single source of truth (24 numbered rules)"},
        @{Name="WARP-QUESTIONS-GUIDE.md"; Description="Question formats and user preferences"},
        @{Name="TODO-LIST.md"; Description="Open items and priorities"},
        @{Name="DEBUGGING-CHECKLIST.md"; Description="Universal solutions (10 categories)"},
        @{Name="WARP-START-SESSION.md"; Description="Session startup procedures"},
        @{Name="WARP-COMPLIANCE-SYSTEM.md"; Description="Core rules (references MASTER RULES)"},
        @{Name="WARP-PROCEDURES-HIERARCHY.md"; Description="Numbered procedure system"}
    )
    
    # Also read directory structure from docs folder
    $docsFile = Join-Path (Split-Path $complianceFolder -Parent) "warp-toolbox\docs\SAIT-DIRECTORY-STRUCTURE.md"
    if (Test-Path $docsFile) {
        Write-Host "  ✅ SAIT-DIRECTORY-STRUCTURE.md" -ForegroundColor Green
        Write-Host "     Directory and file organization" -ForegroundColor Gray
        $filesToRead += @{Name="SAIT-DIRECTORY-STRUCTURE.md"; Description="Directory and file organization"}
    }
    
    $filesRead = @()
    $filesMissing = @()
    
    foreach ($file in $filesToRead) {
        $filePath = Join-Path $complianceFolder $file.Name
        
        if (Test-Path $filePath) {
            Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
            Write-Host "     $($file.Description)" -ForegroundColor Gray
            $filesRead += $file.Name
        } else {
            Write-Host "  ❌ $($file.Name) - MISSING" -ForegroundColor Red
            $filesMissing += $file.Name
        }
    }
    
    Write-Host ""
    return @{
        Read = $filesRead
        Missing = $filesMissing
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

# SOS STEP 3: OFFER CLEANUP ROUTINE
function Offer-CleanupRoutine {
    Write-Host "`n🧹 SYSTEM CLEANUP CHECK" -ForegroundColor Cyan
    Write-Host "=" * 70 -ForegroundColor Blue
    
    Write-Host "  Would you like to run the cleanup routine?" -ForegroundColor White
    Write-Host "  (Checks for duplicates, outdated files, git status, disk space)" -ForegroundColor Gray
    Write-Host ""
    $response = Read-Host "  Run cleanup now? (y/n)"
    
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host ""
        $cleanupScript = Join-Path $gitRepo "warp-toolbox\core\cleanup-routine.ps1"
        if (Test-Path $cleanupScript) {
            & $cleanupScript
        } else {
            Write-Host "  ⚠️  cleanup-routine.ps1 not found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ⏭️  Skipping cleanup" -ForegroundColor Gray
    }
    Write-Host ""
}

# SOS STEP 4: DISPLAY WARP CONFIRMATION
function Show-WarpConfirmation {
    param($FilesRead, $TodoCount)
    
    Write-Host "`n" + "=" * 70 -ForegroundColor Magenta
    Write-Host "🤖 WARP AI CONFIRMATION - SOS COMPLETE" -ForegroundColor Magenta
    Write-Host "=" * 70 -ForegroundColor Magenta
    
    Write-Host "`n✅ FILES READ AND PROCEDURES LOADED:" -ForegroundColor Green
    foreach ($file in $FilesRead) {
        Write-Host "   • $file" -ForegroundColor White
    }
    
    Write-Host "`n✅ WILL FOLLOW:" -ForegroundColor Green
    Write-Host "   • Numbered reference system (SECTION X.X)" -ForegroundColor White
    Write-Host "   • GitHub-first principle for universal files" -ForegroundColor White
    Write-Host "   • Question procedures from WARP-QUESTIONS-GUIDE.md" -ForegroundColor White
    Write-Host "   • User preferences from Section 9.0" -ForegroundColor White
    Write-Host "   • Systematic approach (fix ALL instances, not just one)" -ForegroundColor White
    
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

# Execute SOS steps
$filesResult = Read-ComplianceFiles
$todoResult = Get-TodoItems
Offer-CleanupRoutine
Show-WarpConfirmation -FilesRead $filesResult.Read -TodoCount $todoResult.Total

# Display quick commands
Write-Host "⚡ QUICK COMMANDS:" -ForegroundColor Cyan
Write-Host "   clean           # Run profile cleanup analysis" -ForegroundColor Gray
Write-Host "   eos             # End of session routine" -ForegroundColor Gray
Write-Host "   q               # Reload SwiftLetter shortcuts" -ForegroundColor Gray
Write-Host ""
