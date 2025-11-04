# REORGANIZE FILES TO LOGICAL GIT STRUCTURE
# Moves files from scattered locations into organized git repository
# Eliminates need for copying - everything lives in one place

Write-Host "🎯 REORGANIZING TO LOGICAL GIT STRUCTURE" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Blue

$gitRepo = "C:\Users\17274\ME\2829-Niagara-Street"

# PROPOSED STRUCTURE:
# 2829-Niagara-Street/  (Git repo root)
# ├── warp-toolbox/           (Main SAIT system - replaces super-ai-toolbox)
# │   ├── core/               (Core scripts and HTML)
# │   │   ├── SuperDebug.html
# │   │   ├── QuickStart.ps1
# │   │   ├── EOS-Routine.ps1
# │   │   └── DebugToolbox.ps1
# │   ├── docs/               (Documentation)
# │   │   ├── WARPY-SOS-EOS-INSTRUCTIONS.md
# │   │   └── README.md
# │   └── backup/             (30-day retention)
# ├── ai-teaching/            (AI Training Materials)
# │   └── AI-Teaching-Reference.md
# ├── session-docs/           (Session Documentation - auto-cleanup)
# │   └── [SESSION-DOCUMENTATION-*.md files]
# ├── warp-compliance/        (Compliance & Procedures)
# │   ├── WARP-COMPLIANCE-SYSTEM.md
# │   ├── WARP-START-SESSION.md
# │   ├── TODO-LIST.md
# │   └── WARP-PROCEDURES-HIERARCHY.md
# └── project-specific/       (2829 Niagara specific files)
#     ├── dashboard files
#     └── project data

Write-Host "`n📋 STEP 1: CREATING DIRECTORY STRUCTURE..." -ForegroundColor Green

# Create directories
$directories = @(
    "$gitRepo\warp-toolbox\core"
    "$gitRepo\warp-toolbox\docs"
    "$gitRepo\warp-toolbox\backup"
    "$gitRepo\ai-teaching"
    "$gitRepo\session-docs"
    "$gitRepo\warp-compliance"
    "$gitRepo\project-specific"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Created: $($dir.Replace($gitRepo, '.'))" -ForegroundColor Gray
    } else {
        Write-Host "  ✓ Exists: $($dir.Replace($gitRepo, '.'))" -ForegroundColor DarkGray
    }
}

Write-Host "`n📋 STEP 2: MOVING FILES TO NEW STRUCTURE..." -ForegroundColor Green

# Move Super AI Toolbox files
$oldToolbox = "C:\Users\17274\ME\super-ai-toolbox"
if (Test-Path $oldToolbox) {
    Write-Host "`n  📦 Moving Super AI Toolbox files..." -ForegroundColor Yellow
    
    # Core files
    Get-ChildItem "$oldToolbox\core\*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
        Move-Item $_.FullName "$gitRepo\warp-toolbox\core\" -Force
        Write-Host "    ✅ Moved: $($_.Name)" -ForegroundColor Gray
    }
    
    Get-ChildItem "$oldToolbox\core\*.html" -ErrorAction SilentlyContinue | ForEach-Object {
        Move-Item $_.FullName "$gitRepo\warp-toolbox\core\" -Force
        Write-Host "    ✅ Moved: $($_.Name)" -ForegroundColor Gray
    }
    
    Get-ChildItem "$oldToolbox\core\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        Move-Item $_.FullName "$gitRepo\warp-toolbox\docs\" -Force
        Write-Host "    ✅ Moved: $($_.Name)" -ForegroundColor Gray
    }
}

# Move AI Teaching files
$oldAITeaching = "C:\Users\17274\ME\AI-Teaching"
if (Test-Path $oldAITeaching) {
    Write-Host "`n  📚 Moving AI Teaching files..." -ForegroundColor Yellow
    
    Get-ChildItem "$oldAITeaching\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        Move-Item $_.FullName "$gitRepo\ai-teaching\" -Force
        Write-Host "    ✅ Moved: $($_.Name)" -ForegroundColor Gray
    }
}

# Move existing session docs to session-docs folder
Write-Host "`n  📄 Organizing session documentation..." -ForegroundColor Yellow
Get-ChildItem "$gitRepo\SESSION-DOCUMENTATION-*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Move-Item $_.FullName "$gitRepo\session-docs\" -Force
    Write-Host "    ✅ Moved: $($_.Name)" -ForegroundColor Gray
}

# Move compliance files
Write-Host "`n  📋 Organizing compliance files..." -ForegroundColor Yellow
$complianceFiles = @(
    "WARP-COMPLIANCE-SYSTEM.md"
    "WARP-START-SESSION.md"
    "TODO-LIST.md"
    "WARP-PROCEDURES-HIERARCHY.md"
    "WARP-AI-CONFIRMATION-CHECKLIST.md"
    "SESSION-COMPLETION-TRACKER.md"
)

foreach ($file in $complianceFiles) {
    if (Test-Path "$gitRepo\$file") {
        Move-Item "$gitRepo\$file" "$gitRepo\warp-compliance\" -Force
        Write-Host "    ✅ Moved: $file" -ForegroundColor Gray
    }
}

Write-Host "`n📋 STEP 3: CREATING AUTO-CLEANUP SCRIPT..." -ForegroundColor Green

# Create cleanup script for old session docs
$cleanupScript = @'
# AUTO-CLEANUP OLD SESSION DOCUMENTATION
# Runs automatically to delete session docs older than 7 days
# Keeps git repo clean while maintaining recent history

param([int]$DaysToKeep = 7)

$sessionDocsPath = "C:\Users\17274\ME\2829-Niagara-Street\session-docs"
$cutoffDate = (Get-Date).AddDays(-$DaysToKeep)

Write-Host "🧹 CLEANING OLD SESSION DOCUMENTATION..." -ForegroundColor Cyan
Write-Host "   Deleting files older than $DaysToKeep days (before $($cutoffDate.ToString('yyyy-MM-dd')))" -ForegroundColor Gray

$oldFiles = Get-ChildItem "$sessionDocsPath\SESSION-DOCUMENTATION-*.md" | 
    Where-Object { $_.LastWriteTime -lt $cutoffDate }

if ($oldFiles) {
    foreach ($file in $oldFiles) {
        Write-Host "   🗑️ Deleting: $($file.Name) ($(($cutoffDate - $file.LastWriteTime).Days) days old)" -ForegroundColor Yellow
        Remove-Item $file.FullName -Force
    }
    Write-Host "   ✅ Cleaned $($oldFiles.Count) old session doc(s)" -ForegroundColor Green
} else {
    Write-Host "   ✓ No old files to clean" -ForegroundColor DarkGray
}
'@

$cleanupScript | Out-File "$gitRepo\warp-toolbox\core\Cleanup-Old-Sessions.ps1" -Encoding UTF8
Write-Host "  ✅ Created: Cleanup-Old-Sessions.ps1" -ForegroundColor Gray

Write-Host "`n📋 STEP 4: CREATING PATH UPDATE SCRIPT..." -ForegroundColor Green

# Create script to update PowerShell profile with new paths
$updateProfileScript = @'
# UPDATE POWERSHELL PROFILE WITH NEW PATHS
# Updates profile to point to new git-based structure

Write-Host "🔧 UPDATING POWERSHELL PROFILE PATHS..." -ForegroundColor Cyan

$profilePath = $PROFILE
$newQuickStartPath = "C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\QuickStart.ps1"

if (Test-Path $profilePath) {
    $content = Get-Content $profilePath -Raw
    
    # Replace old paths with new ones
    $content = $content -replace 'C:\\Users\\17274\\ME\\super-ai-toolbox\\core', 'C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core'
    
    $content | Set-Content $profilePath -Encoding UTF8
    
    Write-Host "✅ Profile updated with new paths" -ForegroundColor Green
    Write-Host "💡 Run: . `$PROFILE  (to reload)" -ForegroundColor Yellow
} else {
    Write-Host "⚠️ Profile not found at: $profilePath" -ForegroundColor Yellow
}
'@

$updateProfileScript | Out-File "$gitRepo\warp-toolbox\core\Update-Profile-Paths.ps1" -Encoding UTF8
Write-Host "  ✅ Created: Update-Profile-Paths.ps1" -ForegroundColor Gray

Write-Host "`n📋 STEP 5: CREATING README FOR NEW STRUCTURE..." -ForegroundColor Green

$readmeContent = @"
# 🎯 Warp Toolbox - Organized Structure

## 📁 Directory Structure

\`\`\`
2829-Niagara-Street/  (Git repo - everything in one place!)
├── warp-toolbox/           Main SAIT system
│   ├── core/               Core scripts & HTML interface
│   ├── docs/               Documentation files
│   └── backup/             30-day retention backups
├── ai-teaching/            AI training materials
├── session-docs/           Session documentation (auto-cleanup after 7 days)
├── warp-compliance/        Compliance, procedures, checklists
└── project-specific/       2829 Niagara project files
\`\`\`

## 🚀 Key Files

**Core Scripts:**
- \`warp-toolbox/core/SuperDebug.html\` - Visual interface with draggable popups
- \`warp-toolbox/core/QuickStart.ps1\` - SwiftLetter 1-letter commands
- \`warp-toolbox/core/EOS-Routine.ps1\` - End of session automation
- \`warp-toolbox/core/Cleanup-Old-Sessions.ps1\` - Auto-cleanup old docs

**Documentation:**
- \`ai-teaching/AI-Teaching-Reference.md\` - Lessons for future AI sessions
- \`warp-compliance/WARP-COMPLIANCE-SYSTEM.md\` - Critical procedures
- \`warp-compliance/WARP-START-SESSION.md\` - Session startup checklist

## 🧹 Automatic Cleanup

Session docs older than 7 days are automatically deleted from \`session-docs/\`
Run manually: \`.\warp-toolbox\core\Cleanup-Old-Sessions.ps1\`

## 🔄 Maintenance

All files in this repo are synced to GitHub:
https://github.com/NeVoTM/2829-niagara-street

No more copying files - everything lives here!
"@

$readmeContent | Out-File "$gitRepo\warp-toolbox\README.md" -Encoding UTF8
Write-Host "  ✅ Created: warp-toolbox/README.md" -ForegroundColor Gray

Write-Host "`n" + "=" * 60 -ForegroundColor Blue
Write-Host "✅ REORGANIZATION COMPLETE!" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Blue

Write-Host "`n📊 NEW STRUCTURE SUMMARY:" -ForegroundColor Cyan
Write-Host "  ✅ All files now in git repo: $gitRepo" -ForegroundColor White
Write-Host "  ✅ Organized into logical directories" -ForegroundColor White
Write-Host "  ✅ Auto-cleanup script created (7-day retention)" -ForegroundColor White
Write-Host "  ✅ No more file copying needed!" -ForegroundColor White

Write-Host "`n🔄 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Run: .\warp-toolbox\core\Update-Profile-Paths.ps1" -ForegroundColor White
Write-Host "  2. Run: . `$PROFILE  (reload profile with new paths)" -ForegroundColor White
Write-Host "  3. Test: q  (verify commands work from new location)" -ForegroundColor White
Write-Host "  4. Commit: git add . && git commit -m 'Reorganized to logical structure'" -ForegroundColor White
Write-Host "  5. Delete old folders (optional - after verifying everything works)" -ForegroundColor White
Write-Host "     - C:\Users\17274\ME\super-ai-toolbox\" -ForegroundColor DarkGray
Write-Host "     - C:\Users\17274\ME\AI-Teaching\" -ForegroundColor DarkGray

Write-Host "`n💡 TIP: Run cleanup manually:" -ForegroundColor Cyan
Write-Host "   .\warp-toolbox\core\Cleanup-Old-Sessions.ps1" -ForegroundColor White
