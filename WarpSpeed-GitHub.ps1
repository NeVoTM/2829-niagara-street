# WarpSpeed-GitHub.ps1 - Fully Dynamic GitHub-First Compliance System
# This script ONLY reads from GitHub, reports actual actions, no fake static text

$ErrorActionPreference = "Stop"
$GitHubBaseURL = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main"
$CompliancePath = "warp-compliance"

# STEP 1: READ USER PROFILE
Write-Host "`n🔍 STEP 1: READING USER PROFILE..." -ForegroundColor Cyan
$profileURL = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/ME/Scripts/New-Session-Instructions.md"

try {
    $profileContent = Invoke-WebRequest -Uri $profileURL -UseBasicParsing | Select-Object -ExpandProperty Content
    Write-Host "   ✅ Profile read from GitHub" -ForegroundColor Green
    Write-Host "   📄 $profileURL" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ FAILED to read profile from GitHub" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# STEP 2: FETCH COMPLIANCE FILE LIST FROM GITHUB
Write-Host "`n🔍 STEP 2: FETCHING COMPLIANCE FILES FROM GITHUB..." -ForegroundColor Cyan

$complianceFiles = @(
    "WARP-MASTER-RULES.md",
    "USER-PREFERENCES.md",
    "WARP-SYSTEM-OVERVIEW.md",
    "WARP-START-SESSION.md",
    "WARP-COMMANDS-REFERENCE.md",
    "TODO-LIST.md",
    "DEBUGGING-CHECKLIST.md"
)

$readSuccess = @()
$readFailed = @()

foreach ($file in $complianceFiles) {
    $url = "$GitHubBaseURL/$CompliancePath/$file"
    Write-Host "   📡 Fetching: $file..." -ForegroundColor Yellow -NoNewline
    
    try {
        $content = Invoke-WebRequest -Uri $url -UseBasicParsing | Select-Object -ExpandProperty Content
        Write-Host " ✅" -ForegroundColor Green
        $readSuccess += $file
    } catch {
        Write-Host " ❌ FAILED" -ForegroundColor Red
        Write-Host "      Error: $($_.Exception.Message)" -ForegroundColor DarkRed
        $readFailed += $file
    }
}

# STEP 3: REPORT ACTUAL STATUS
Write-Host "`n📊 COMPLIANCE STATUS REPORT:" -ForegroundColor Magenta
Write-Host "   ✅ Successfully read from GitHub: $($readSuccess.Count)" -ForegroundColor Green
foreach ($file in $readSuccess) {
    Write-Host "      • $file" -ForegroundColor White
}

if ($readFailed.Count -gt 0) {
    Write-Host "`n   ❌ Failed to read: $($readFailed.Count)" -ForegroundColor Red
    foreach ($file in $readFailed) {
        Write-Host "      • $file" -ForegroundColor White
    }
}

# STEP 4: FETCH AND DISPLAY TODO LIST
Write-Host "`n📋 CHECKING TODO LIST..." -ForegroundColor Cyan
$todoURL = "$GitHubBaseURL/$CompliancePath/TODO-LIST.md"

try {
    $todoContent = Invoke-WebRequest -Uri $todoURL -UseBasicParsing | Select-Object -ExpandProperty Content
    $uncheckedCount = ([regex]::Matches($todoContent, '- \[ \]')).Count
    $checkedCount = ([regex]::Matches($todoContent, '- \[x\]')).Count
    
    Write-Host "   ✅ TODO list read from GitHub" -ForegroundColor Green
    Write-Host "   📊 Open items: $uncheckedCount" -ForegroundColor Yellow
    Write-Host "   ✔️  Completed items: $checkedCount" -ForegroundColor Gray
    
    # Extract urgent items (lines with - [ ] that contain URGENT, CRITICAL, or !!!)
    $urgentPattern = '- \[ \].*(?:URGENT|CRITICAL|!!!)'
    $urgentItems = [regex]::Matches($todoContent, $urgentPattern)
    
    if ($urgentItems.Count -gt 0) {
        Write-Host "`n   🚨 URGENT ITEMS FOUND: $($urgentItems.Count)" -ForegroundColor Red
        foreach ($item in $urgentItems) {
            Write-Host "      • $($item.Value)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "   ❌ Failed to read TODO list" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

# STEP 5: GENERATE COMPLIANCE REPORT FOR GITHUB
Write-Host "`n📝 GENERATING COMPLIANCE REPORT..." -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
$reportContent = @"
# WARP COMPLIANCE REPORT
Generated: $timestamp

## FILES READ FROM GITHUB
$($readSuccess | ForEach-Object { "- ✅ $_" } | Out-String)

## FILES FAILED TO READ
$($readFailed | ForEach-Object { "- ❌ $_" } | Out-String)

## TODO STATUS
- Open items: $uncheckedCount
- Completed items: $checkedCount

## GITHUB SOURCE
- Base URL: $GitHubBaseURL
- Compliance path: $CompliancePath

## WARP AI ACKNOWLEDGMENT REQUIRED
Warp AI must confirm:
1. I have read all files listed above from GitHub
2. I acknowledge the user profile preferences
3. I will follow RULE 1.1 (GitHub-first)
4. I will report actual actions, not static claims
"@

$reportPath = "C:\Users\17274\ME\2829-Niagara-Street\session-docs\warp-compliance-$(Get-Date -Format 'yyyy-MM-dd-HHmm').md"
$reportContent | Out-File -FilePath $reportPath -Encoding UTF8

# STEP 6: DISPLAY RULES AND PREFERENCES
Write-Host "`n📖 DISPLAYING KEY FILES..." -ForegroundColor Cyan

# Fetch and display WARP-MASTER-RULES.md
$rulesURL = "$GitHubBaseURL/$CompliancePath/WARP-MASTER-RULES.md"
try {
    $rulesContent = Invoke-WebRequest -Uri $rulesURL -UseBasicParsing | Select-Object -ExpandProperty Content
    Write-Host "`nWARP-MASTER-RULES.md" -ForegroundColor Yellow
    Write-Host $rulesContent -ForegroundColor White
} catch {
    Write-Host "   ❌ Failed to display WARP-MASTER-RULES.md" -ForegroundColor Red
}

# Fetch and display USER-PREFERENCES.md
$preferencesURL = "$GitHubBaseURL/$CompliancePath/USER-PREFERENCES.md"
try {
    $preferencesContent = Invoke-WebRequest -Uri $preferencesURL -UseBasicParsing | Select-Object -ExpandProperty Content
    Write-Host "`nUSER-PREFERENCES.md" -ForegroundColor Yellow
    Write-Host $preferencesContent -ForegroundColor White
} catch {
    Write-Host "   ❌ Failed to display USER-PREFERENCES.md" -ForegroundColor Red
}

# Fetch and display WARP-COMMANDS-REFERENCE.md
$commandsURL = "$GitHubBaseURL/$CompliancePath/WARP-COMMANDS-REFERENCE.md"
try {
    $commandsContent = Invoke-WebRequest -Uri $commandsURL -UseBasicParsing | Select-Object -ExpandProperty Content
    Write-Host "`nWARP-COMMANDS-REFERENCE.md" -ForegroundColor Yellow
    Write-Host $commandsContent -ForegroundColor White
} catch {
    Write-Host "   ❌ Failed to display WARP-COMMANDS-REFERENCE.md" -ForegroundColor Red
}

# STEP 7: FINAL STATUS
Write-Host ""
if ($readFailed.Count -eq 0) {
    Write-Host "🚀 WARP SPEED COMPLETE - ALL FILES READ FROM GITHUB" -ForegroundColor Green
} else {
    Write-Host "⚠️  WARP SPEED INCOMPLETE - SOME FILES MISSING" -ForegroundColor Yellow
}
Write-Host ""
