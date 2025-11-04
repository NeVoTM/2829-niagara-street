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
