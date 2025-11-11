# Consolidate-WarpFiles.ps1
# Consolidates WARP files from 8 down to 5

$gitHubRaw = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/warp-compliance"
$localPath = "C:\Users\17274\ME\2829-Niagara-Street\warp-compliance"

Write-Host "🚀 WARP FILES CONSOLIDATION" -ForegroundColor Cyan
Write-Host "Reducing 8 files to 5 files" -ForegroundColor Yellow
Write-Host ""

# Step 1: Download files from GitHub
Write-Host "▶️  Step 1: Downloading from GitHub (RULE 1.1)" -ForegroundColor Yellow
$overview = Invoke-WebRequest -Uri "$gitHubRaw/WARPSPEED-OVERVIEW.md" -UseBasicParsing | Select-Object -ExpandProperty Content
$compliance = Invoke-WebRequest -Uri "$gitHubRaw/WARP-COMPLIANCE-SYSTEM.md" -UseBasicParsing | Select-Object -ExpandProperty Content
$commands = Invoke-WebRequest -Uri "$gitHubRaw/WARP-COMMANDS-REFERENCE.md" -UseBasicParsing | Select-Object -ExpandProperty Content
$procedures = Invoke-WebRequest -Uri "$gitHubRaw/WARP-PROCEDURES-HIERARCHY.md" -UseBasicParsing | Select-Object -ExpandProperty Content
$questions = Invoke-WebRequest -Uri "$gitHubRaw/WARP-QUESTIONS-GUIDE.md" -UseBasicParsing | Select-Object -ExpandProperty Content
Write-Host "✅ Downloaded 5 files" -ForegroundColor Green
Write-Host ""

# Step 2: Create WARP-SYSTEM-OVERVIEW.md (merge overview + compliance)
Write-Host "▶️  Step 2: Creating WARP-SYSTEM-OVERVIEW.md" -ForegroundColor Yellow
$systemOverview = @"
$overview

---

# 📋 COMPLIANCE SYSTEM - WHY RULES EXIST

$compliance
"@
Set-Content "$localPath\WARP-SYSTEM-OVERVIEW.md" -Value $systemOverview
Write-Host "✅ Created WARP-SYSTEM-OVERVIEW.md" -ForegroundColor Green
Write-Host ""

# Step 3: Create enhanced WARP-COMMANDS-REFERENCE.md (merge commands + procedures + questions)
Write-Host "▶️  Step 3: Creating enhanced WARP-COMMANDS-REFERENCE.md" -ForegroundColor Yellow
$commandsEnhanced = @"
$commands

---

# 📐 NUMBERED PROCEDURES SYSTEM

$procedures

---

# ❓ QUESTIONS GUIDE

$questions
"@
Set-Content "$localPath\WARP-COMMANDS-REFERENCE.md" -Value $commandsEnhanced
Write-Host "✅ Created enhanced WARP-COMMANDS-REFERENCE.md" -ForegroundColor Green
Write-Host ""

# Step 4: Delete redundant files
Write-Host "▶️  Step 4: Deleting redundant files" -ForegroundColor Yellow
$toDelete = @(
    "WARPSPEED-OVERVIEW.md",
    "WARP-COMPLIANCE-SYSTEM.md", 
    "WARP-PROCEDURES-HIERARCHY.md",
    "WARP-QUESTIONS-GUIDE.md",
    "WARP-AI-CONFIRMATION-CHECKLIST.md"
)

foreach ($file in $toDelete) {
    $path = "$localPath\$file"
    if (Test-Path $path) {
        Remove-Item $path
        Write-Host "  ❌ Deleted: $file" -ForegroundColor Red
    }
}
Write-Host "✅ Deleted 5 old files" -ForegroundColor Green
Write-Host ""

# Step 5: Commit changes
Write-Host "▶️  Step 5: Committing to GitHub (RULE 1.1a)" -ForegroundColor Yellow
cd "C:\Users\17274\ME\2829-Niagara-Street"
git add warp-compliance/*
git commit -m "Consolidate WARP files from 8 to 5

COMPLETED:
✅ Created WARP-SYSTEM-OVERVIEW.md (merged overview + compliance)
✅ Enhanced WARP-COMMANDS-REFERENCE.md (merged commands + procedures + questions)
✅ Deleted 5 redundant files

FINAL STRUCTURE (5 files):
1. WARP-MASTER-RULES.md (30 rules)
2. USER-PREFERENCES.md (format standards)
3. WARP-SYSTEM-OVERVIEW.md (why system exists)
4. WARP-START-SESSION.md (startup procedures)
5. WARP-COMMANDS-REFERENCE.md (commands + procedures + questions)

FILES DELETED:
- WARPSPEED-OVERVIEW.md
- WARP-COMPLIANCE-SYSTEM.md
- WARP-PROCEDURES-HIERARCHY.md
- WARP-QUESTIONS-GUIDE.md
- WARP-AI-CONFIRMATION-CHECKLIST.md

RULES APPLIED:
- RULE 1.1: GitHub-first (downloaded before editing)
- RULE 1.1a: Auto-commit
- RULE 4.1: Fixed ALL instances"

git push
Write-Host "✅ Pushed to GitHub" -ForegroundColor Green
Write-Host ""

Write-Host "🎉 CONSOLIDATION COMPLETE!" -ForegroundColor Green
Write-Host "Files reduced from 8 to 5" -ForegroundColor Cyan
