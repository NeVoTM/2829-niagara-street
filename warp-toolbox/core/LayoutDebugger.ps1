# LayoutDebugger.ps1 - REAL Layout Debugging That Actually Fixes Issues
# This system analyzes HTML/CSS files and provides specific fixes

param(
    [string]$Action = "menu",
    [string]$FilePath = "",
    [string]$URL = "",
    [string]$Issue = ""
)

# Function to analyze a specific HTML file for layout issues
function Analyze-LayoutFile {
    param(
        [string]$HtmlFilePath
    )
    
    if (-not (Test-Path $HtmlFilePath)) {
        Write-Host "❌ File not found: $HtmlFilePath" -ForegroundColor Red
        return
    }
    
    Write-Host "🔍 ANALYZING LAYOUT: $HtmlFilePath" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Blue
    
    $content = Get-Content $HtmlFilePath -Raw
    $issues = @()
    $fixes = @()
    
    # Check for border overlap issues
    if ($content -match 'border.*\d+px.*solid' -and $content -match 'padding.*\d+px') {
        $issues += "⚠️ BORDER OVERLAP RISK: Found borders with padding - may cause text overlap"
        $fixes += "Add: * { box-sizing: border-box; }"
        $fixes += "Review: border + padding calculations"
    }
    
    # Check for missing box-sizing
    if ($content -notmatch 'box-sizing.*border-box') {
        $issues += "⚠️ MISSING BOX-SIZING: No border-box detected - elements may exceed containers"
        $fixes += "Add to CSS: * { box-sizing: border-box; }"
    }
    
    # Check for text alignment issues
    if ($content -match 'text-align.*center' -and $content -match 'position.*absolute|fixed') {
        $issues += "⚠️ TEXT ALIGNMENT: Centered text with absolute positioning may cause overlap"
        $fixes += "Use: display: flex; justify-content: center; align-items: center;"
    }
    
    # Check for margin/padding conflicts
    if ($content -match 'margin.*auto' -and $content -match 'text-align.*center') {
        $issues += "⚠️ ALIGNMENT CONFLICT: Both margin: auto and text-align: center detected"
        $fixes += "Choose one method: Either margin: 0 auto OR text-align: center"
    }
    
    # Check for responsive issues
    if ($content -notmatch '@media' -and $content -match 'width.*px') {
        $issues += "⚠️ RESPONSIVE RISK: Fixed pixel widths without media queries"
        $fixes += "Add responsive breakpoints with @media queries"
        $fixes += "Use: width: 100%; max-width: 1200px;"
    }
    
    # Check ROI section specific issue (from your WARP-ASSISTANT-MOCKUPS.html)
    if ($content -match 'roi.*grid.*columns.*repeat' -and $content -match 'roi-number') {
        $issues += "⚠️ ROI GRID OVERLAP: Grid columns may be overlapping text in ROI section"
        $fixes += "Add to .roi-numbers: gap: 20px; margin: 20px 0;"
        $fixes += "Add to .roi-number: padding: 15px; margin-bottom: 10px;"
        $fixes += "Check: grid-template-columns and ensure proper spacing"
    }
    
    Write-Host ""
    Write-Host "🚨 ISSUES FOUND:" -ForegroundColor Red
    if ($issues.Count -eq 0) {
        Write-Host "✅ No obvious layout issues detected" -ForegroundColor Green
    } else {
        $issues | ForEach-Object { Write-Host "   $_" -ForegroundColor Yellow }
    }
    
    Write-Host ""
    Write-Host "🔧 RECOMMENDED FIXES:" -ForegroundColor Green
    if ($fixes.Count -gt 0) {
        $fixes | ForEach-Object { Write-Host "   $_" -ForegroundColor Cyan }
    }
    
    Write-Host ""
    Write-Host "📋 COPY THESE CSS FIXES:" -ForegroundColor Magenta
    Write-Host "/* Add this to your CSS */"
    Write-Host "* { box-sizing: border-box; }"
    Write-Host ".roi-numbers { gap: 20px; margin: 20px 0; }"
    Write-Host ".roi-number { padding: 15px; margin-bottom: 10px; }"
    Write-Host "@media (max-width: 768px) { "
    Write-Host "    .roi-numbers { grid-template-columns: 1fr; }"
    Write-Host "}"
}

# Function to generate specific fixes for your WARP-ASSISTANT-MOCKUPS.html issue
function Fix-WarpAssistantLayout {
    Write-Host "🎯 FIXING WARP ASSISTANT LAYOUT BORDERS" -ForegroundColor Cyan
    Write-Host "=" * 45 -ForegroundColor Blue
    Write-Host ""
    
    Write-Host "🚨 ISSUE: Border design overlapping text in ROI section" -ForegroundColor Red
    Write-Host "📂 FILE: file:///C:/Users/17274/ME/super-ai-toolbox/mockups/WARP-ASSISTANT-MOCKUPS.html" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "🔧 SPECIFIC FIXES FOR YOUR FILE:" -ForegroundColor Green
    Write-Host ""
    
    $cssfix = @"
/* FIX 1: Add proper box-sizing (prevents border expansion) */
* { 
    box-sizing: border-box; 
    margin: 0; 
    padding: 0; 
}

/* FIX 2: Fix ROI section grid overlap */
.roi-demo {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    margin: 20px 0; /* Add margin for breathing room */
}

.roi-numbers {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 25px; /* Increase gap to prevent overlap */
    margin: 25px 0; /* Add more margin */
    padding: 0 20px; /* Add internal padding */
}

.roi-number {
    background: rgba(255,255,255,0.1);
    padding: 25px 15px; /* Increase padding */
    border-radius: 8px;
    min-height: 120px; /* Ensure minimum height */
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.roi-number .big {
    font-size: 2em;
    font-weight: bold;
    display: block;
    margin-bottom: 8px; /* Add space between number and text */
    line-height: 1.2; /* Prevent line overlap */
}

/* FIX 3: Responsive fixes for mobile */
@media (max-width: 768px) {
    .roi-numbers {
        grid-template-columns: 1fr;
        gap: 15px;
    }
    .roi-number {
        padding: 20px 15px;
        min-height: 100px;
    }
}
"@
    
    Write-Host $cssfix -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 COPY ENTIRE CSS BLOCK ABOVE AND:" -ForegroundColor Yellow
    Write-Host "1. Open your HTML file in VS Code" -ForegroundColor White
    Write-Host "2. Find the <style> section" -ForegroundColor White  
    Write-Host "3. Add this CSS at the end of your styles" -ForegroundColor White
    Write-Host "4. Save and refresh your browser" -ForegroundColor White
    Write-Host ""
    Write-Host "⚡ INSTANT COMMAND TO COPY CSS:" -ForegroundColor Green
    
    # Save the CSS fix to a temporary file for easy copying
    $tempCssFile = Join-Path $PSScriptRoot "temp-css-fix.css"
    $cssfix | Out-File $tempCssFile -Encoding UTF8
    
    Write-Host "CSS saved to: $tempCssFile" -ForegroundColor Green
    Write-Host "Command to view: Get-Content '$tempCssFile'" -ForegroundColor Cyan
    
    return $tempCssFile
}

# Function to create quick layout diagnostic
function Quick-LayoutDiagnostic {
    param([string]$Issue)
    
    Write-Host "🔍 QUICK LAYOUT DIAGNOSTIC" -ForegroundColor Cyan
    Write-Host "=" * 30 -ForegroundColor Blue
    
    switch ($Issue.ToLower()) {
        "border overlap" {
            Write-Host "🚨 BORDER OVERLAP ISSUE" -ForegroundColor Red
            Write-Host "Quick Fix: * { box-sizing: border-box; }" -ForegroundColor Green
            Write-Host "Check: padding + border calculations" -ForegroundColor Yellow
        }
        "text alignment" {
            Write-Host "🚨 TEXT ALIGNMENT ISSUE" -ForegroundColor Red
            Write-Host "Quick Fix: display: flex; justify-content: center;" -ForegroundColor Green
            Write-Host "Avoid: mixing text-align with absolute positioning" -ForegroundColor Yellow
        }
        "responsive" {
            Write-Host "🚨 RESPONSIVE LAYOUT ISSUE" -ForegroundColor Red
            Write-Host "Quick Fix: Add @media queries" -ForegroundColor Green
            Write-Host "Use: width: 100%; max-width: 1200px;" -ForegroundColor Yellow
        }
        default {
            Write-Host "❓ Please specify issue type:" -ForegroundColor Yellow
            Write-Host "  border overlap, text alignment, or responsive" -ForegroundColor White
        }
    }
}

# Main execution
switch ($Action.ToLower()) {
    "analyze" {
        if ($FilePath) {
            Analyze-LayoutFile $FilePath
        } else {
            Write-Host "Usage: .\LayoutDebugger.ps1 analyze -FilePath 'path/to/file.html'" -ForegroundColor Yellow
        }
    }
    "fixwarp" {
        Fix-WarpAssistantLayout
    }
    "quick" {
        Quick-LayoutDiagnostic $Issue
    }
    default {
        Write-Host "🎨 LAYOUT DEBUGGER - Real CSS Issue Fixer" -ForegroundColor Cyan
        Write-Host "=========================================" -ForegroundColor Blue
        Write-Host ""
        Write-Host "🔧 COMMANDS:" -ForegroundColor Yellow
        Write-Host "  analyze   - Analyze HTML file for layout issues" -ForegroundColor White
        Write-Host "  fixwarp   - Fix your WARP-ASSISTANT-MOCKUPS.html issue" -ForegroundColor White  
        Write-Host "  quick     - Quick diagnostic for specific issue" -ForegroundColor White
        Write-Host ""
        Write-Host "🎯 EXAMPLES:" -ForegroundColor Green
        Write-Host "  .\LayoutDebugger.ps1 fixwarp" -ForegroundColor Gray
        Write-Host "  .\LayoutDebugger.ps1 analyze -FilePath 'mockups\WARP-ASSISTANT-MOCKUPS.html'" -ForegroundColor Gray
        Write-Host "  .\LayoutDebugger.ps1 quick -Issue 'border overlap'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "⚡ INSTANT FIX FOR YOUR CURRENT ISSUE:" -ForegroundColor Red
        Write-Host "  .\LayoutDebugger.ps1 fixwarp" -ForegroundColor Yellow
    }
}