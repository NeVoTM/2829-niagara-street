# CLEANUP ROUTINE - WARP SUPER AI TOOLBOX
# Checks for duplicates, outdated files, and system health

param(
    [switch]$Auto,
    [switch]$ShowOnly
)

Write-Host "🧹 WARP SYSTEM CLEANUP ROUTINE" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Blue

$gitRepo = "C:\Users\17274\ME\2829-Niagara-Street"

# 1. CHECK FOR DUPLICATE FILES
Write-Host "`n📋 CHECKING FOR DUPLICATE FILES..." -ForegroundColor Yellow

$duplicates = @()

# Common duplicate patterns
$duplicatePatterns = @(
    "*_copy*",
    "*_backup*",
    "*(1)*",
    "*(2)*",
    "*_old*",
    "*_temp*"
)

foreach ($pattern in $duplicatePatterns) {
    $found = Get-ChildItem -Path $gitRepo -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
    if ($found) {
        $duplicates += $found
    }
}

if ($duplicates.Count -gt 0) {
    Write-Host "  ⚠️  Found $($duplicates.Count) potential duplicate files:" -ForegroundColor Red
    $duplicates | ForEach-Object {
        Write-Host "     - $($_.FullName)" -ForegroundColor Gray
    }
} else {
    Write-Host "  ✅ No duplicate files found" -ForegroundColor Green
}

# 2. CHECK FOR OUTDATED FILES
Write-Host "`n📅 CHECKING FOR OUTDATED FILES (90+ days)..." -ForegroundColor Yellow

$cutoffDate = (Get-Date).AddDays(-90)
$outdated = Get-ChildItem -Path $gitRepo -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.LastWriteTime -lt $cutoffDate -and $_.Extension -in @('.md', '.ps1', '.html', '.json') }

if ($outdated.Count -gt 0) {
    Write-Host "  ⚠️  Found $($outdated.Count) files not modified in 90+ days:" -ForegroundColor Yellow
    $outdated | Select-Object -First 10 | ForEach-Object {
        $daysSince = ((Get-Date) - $_.LastWriteTime).Days
        Write-Host "     - $($_.Name) ($daysSince days old)" -ForegroundColor Gray
    }
    if ($outdated.Count -gt 10) {
        Write-Host "     ... and $($outdated.Count - 10) more" -ForegroundColor Gray
    }
} else {
    Write-Host "  ✅ No significantly outdated files" -ForegroundColor Green
}

# 3. CHECK FOR UNCOMMITTED CHANGES
Write-Host "`n📦 CHECKING GIT STATUS..." -ForegroundColor Yellow

Push-Location $gitRepo
$gitStatus = git status --short 2>&1

if ($gitStatus) {
    Write-Host "  ⚠️  Uncommitted changes found:" -ForegroundColor Yellow
    $gitStatus | ForEach-Object {
        Write-Host "     $_" -ForegroundColor Gray
    }
} else {
    Write-Host "  ✅ No uncommitted changes" -ForegroundColor Green
}
Pop-Location

# 4. CHECK FOR MISSING CRITICAL FILES
Write-Host "`n📝 CHECKING CRITICAL FILES..." -ForegroundColor Yellow

$criticalFiles = @(
    "WARP-COMPLIANCE-SYSTEM.md",
    "TODO-LIST.md",
    "WARP-START-SESSION.md",
    "DEBUGGING-CHECKLIST.md",
    "WARP-QUESTIONS-GUIDE.md"
)

$missing = @()
foreach ($file in $criticalFiles) {
    $found = Get-ChildItem -Path $gitRepo -Recurse -Filter $file -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $found) {
        $missing += $file
    }
}

if ($missing.Count -gt 0) {
    Write-Host "  ⚠️  Missing critical files:" -ForegroundColor Red
    $missing | ForEach-Object {
        Write-Host "     - $_" -ForegroundColor Gray
    }
} else {
    Write-Host "  ✅ All critical files present" -ForegroundColor Green
}

# 5. CHECK DISK SPACE
Write-Host "`n💾 CHECKING DISK SPACE..." -ForegroundColor Yellow

$drive = (Get-Item $gitRepo).PSDrive
$freeSpace = [math]::Round($drive.Free / 1GB, 2)
$totalSpace = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
$percentFree = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)

if ($percentFree -lt 10) {
    Write-Host "  ⚠️  Low disk space: $freeSpace GB free ($percentFree%)" -ForegroundColor Red
} elseif ($percentFree -lt 20) {
    Write-Host "  ⚠️  Disk space getting low: $freeSpace GB free ($percentFree%)" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ Disk space OK: $freeSpace GB free ($percentFree%)" -ForegroundColor Green
}

# 6. CHECK FOR LARGE FILES
Write-Host "`n📏 CHECKING FOR LARGE FILES (10MB+)..." -ForegroundColor Yellow

$largeFiles = Get-ChildItem -Path $gitRepo -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.Length -gt 10MB }

if ($largeFiles.Count -gt 0) {
    Write-Host "  ⚠️  Found $($largeFiles.Count) files larger than 10MB:" -ForegroundColor Yellow
    $largeFiles | Sort-Object Length -Descending | Select-Object -First 5 | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 2)
        Write-Host "     - $($_.Name) ($sizeMB MB)" -ForegroundColor Gray
    }
} else {
    Write-Host "  ✅ No unusually large files" -ForegroundColor Green
}

# SUMMARY
Write-Host "`n" + "=" * 60 -ForegroundColor Blue
Write-Host "🎯 CLEANUP SUMMARY" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Blue

$issues = 0
if ($duplicates.Count -gt 0) { $issues++ }
if ($outdated.Count -gt 10) { $issues++ }
if ($gitStatus) { $issues++ }
if ($missing.Count -gt 0) { $issues++ }
if ($percentFree -lt 20) { $issues++ }
if ($largeFiles.Count -gt 5) { $issues++ }

if ($issues -eq 0) {
    Write-Host "`n✅ SYSTEM CLEAN - No issues found!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Found $issues potential issues" -ForegroundColor Yellow
    Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
    
    if ($duplicates.Count -gt 0) {
        Write-Host "  • Review and remove duplicate files" -ForegroundColor White
    }
    if ($outdated.Count -gt 10) {
        Write-Host "  • Archive or delete outdated files" -ForegroundColor White
    }
    if ($gitStatus) {
        Write-Host "  • Commit or discard uncommitted changes" -ForegroundColor White
    }
    if ($missing.Count -gt 0) {
        Write-Host "  • Restore missing critical files from GitHub" -ForegroundColor White
    }
    if ($percentFree -lt 20) {
        Write-Host "  • Free up disk space" -ForegroundColor White
    }
    if ($largeFiles.Count -gt 5) {
        Write-Host "  • Review and compress/remove large files" -ForegroundColor White
    }
}

if (-not $ShowOnly) {
    Write-Host "`n💡 Run with -ShowOnly to preview without making changes" -ForegroundColor Gray
}

Write-Host ""
