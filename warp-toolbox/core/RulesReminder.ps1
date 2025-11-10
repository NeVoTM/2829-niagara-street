# Rules Reminder Command with Self-Check Enforcement
function Invoke-RulesReminder {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Yellow
    Write-Host "🤖 WARP AI: RULES ACTIVE - COMPREHENSIVE SELF-CHECK" -ForegroundColor Yellow
    Write-Host "======================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 COMPLIANCE CHECKLIST - Verify EACH rule:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "FILE MANAGEMENT:" -ForegroundColor White
    Write-Host "  ☐ RULE 1.1: GitHub-first (read/save GitHub BEFORE local)" -ForegroundColor Gray
    Write-Host "  ☐ RULE 1.1a: Auto-commit after EVERY change" -ForegroundColor Gray
    Write-Host "  ☐ RULE 1.4: Never modify rules without permission" -ForegroundColor Gray
    Write-Host ""
    Write-Host "NUMBERED REFERENCES:" -ForegroundColor White
    Write-Host "  ☐ RULE 2.1: Use numbered references (SECTION X.X, RULE X.X)" -ForegroundColor Gray
    Write-Host "  ☐ RULE 2.2: Maintain hierarchical numbering (X.1, X.2...)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "SYSTEMATIC APPROACH:" -ForegroundColor White
    Write-Host "  ☐ RULE 4.1: Fix ALL instances (not just one)" -ForegroundColor Gray
    Write-Host "  ☐ RULE 4.2: Update cross-references in related files" -ForegroundColor Gray
    Write-Host "  ☐ RULE 4.4: Check PowerShell profile for duplicates" -ForegroundColor Gray
    Write-Host "  ☐ RULE 4.5: Validate scripts before referencing" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🔴 USE >r COMMAND FOR RULES ENFORCEMENT:" -ForegroundColor Red
    Write-Host "  📝 Type: >r [your message to Warp]" -ForegroundColor Yellow
    Write-Host "  ✅ Warp will check ALL applicable rules before responding" -ForegroundColor Yellow
    Write-Host "  🎯 No more forgotten rules or missed compliance checks" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Example: >r update the todo list" -ForegroundColor Cyan
    Write-Host "  Result: Warp checks RULE 1.1, 1.1a, 9.3, etc. before proceeding" -ForegroundColor Gray
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Yellow
    Write-Host ""
}

# Alias is set in profile after dot-sourcing this script
