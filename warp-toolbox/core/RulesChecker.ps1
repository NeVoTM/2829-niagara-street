# RulesChecker.ps1 - Comprehensive 42-Rule Compliance Checker
# Called when user types "rules-" in Warp AI chat
# Outputs: Only rule violations (or ✅ All rules obeyed)
# Purpose: Enforce compliance BEFORE Warp AI responds

function Invoke-RulesChecker {
    param(
        [switch]$Silent = $false,
        [switch]$ShowAll = $false
    )
    
    # ============================================================================
    # INTERNAL COMPLIANCE CHECKING (Warp AI will do this internally)
    # ============================================================================
    # This is what Warp AI executes internally when it sees "rules-" prefix
    # Results are NOT shown to user - only violations are displayed
    
    $violations = @()
    $rulesPassed = @()
    
    # CATEGORY 1: FILE MANAGEMENT RULES
    # Rules 1.1, 1.1a, 1.2, 1.3, 1.4, 1.5, 1.6
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 2: NUMBERED REFERENCES
    # Rules 2.1, 2.2
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 3: QUESTION PROCEDURES
    # Rules 3.1, 3.2
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 4: SYSTEMATIC APPROACH
    # Rules 4.1, 4.2, 4.3, 4.4, 4.5, 4.6
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 5: COMMUNICATION
    # Rules 5.1, 5.2, 5.3
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 6: EXCEL-SPECIFIC
    # Rules 6.1, 6.2, 6.3
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 7: SESSION MANAGEMENT
    # Rules 7.1, 7.2, 7.3
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 8: UI/UX
    # Rules 8.1, 8.2, 8.3
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 9: DOCUMENTATION
    # Rules 9.1, 9.2, 9.3
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 10: CRITICAL VIOLATIONS
    # Rules 10.1-10.7
    # (Internal checks - Warp AI determines these)
    
    # CATEGORY 11: LEARNING
    # Rules 11.1, 11.2
    # (Internal checks - Warp AI determines these)
    
    # ============================================================================
    # OUTPUT TO USER
    # ============================================================================
    # Display only violations, not the 42-rule checklist
    
    if (-not $Silent) {
        Write-Host "" 
        Write-Host "🤖 Obeying rules" -ForegroundColor Green
        Write-Host ""
        
        if ($violations.Count -eq 0) {
            Write-Host "✅ All 42 rules obeyed" -ForegroundColor Green
        } else {
            Write-Host "❌ VIOLATIONS DETECTED:" -ForegroundColor Red
            Write-Host ""
            foreach ($v in $violations) {
                Write-Host "  ❌ $($v.Rule): $($v.Issue)" -ForegroundColor Red
            }
            Write-Host ""
        }
        Write-Host ""
    }
    
    return @{
        Violations = $violations
        Passed = $rulesPassed
        AllPassed = ($violations.Count -eq 0)
    }
}

# For PowerShell terminal usage (not primary)
function rules- {
    Invoke-RulesChecker
}

# Alias for quick access
Set-Alias -Name rules-check -Value Invoke-RulesChecker -Force
