# SAIT Duplication Detection System
# Identifies and prevents duplicate commands, functions, and procedures across the ecosystem

function Find-SAITDuplicates {
    param(
        [string]$ScanPath = "C:\Users\17274\ME\super-ai-toolbox",
        [switch]$ShowDetails,
        [switch]$RemoveDuplicates
    )
    
    Write-Host "🔍 SAIT Duplication Detection System" -ForegroundColor Cyan
    Write-Host "=" * 50
    
    # Define file patterns to scan
    $FilePatterns = @("*.ps1", "*.html", "*.md", "*.bat", "*.json")
    $Duplicates = @{}
    $FunctionNames = @{}
    $CommandAliases = @{}
    
    # Scan all relevant files
    foreach ($Pattern in $FilePatterns) {
        $Files = Get-ChildItem -Path $ScanPath -Filter $Pattern -Recurse -ErrorAction SilentlyContinue
        
        foreach ($File in $Files) {
            try {
                $Content = Get-Content $File.FullName -Raw
                
                # Extract PowerShell functions
                if ($File.Extension -eq ".ps1") {
                    $Functions = [regex]::Matches($Content, 'function\s+([a-zA-Z0-9_-]+)')
                    foreach ($Match in $Functions) {
                        $FuncName = $Match.Groups[1].Value
                        if ($FunctionNames[$FuncName]) {
                            $FunctionNames[$FuncName] += @($File.FullName)
                        } else {
                            $FunctionNames[$FuncName] = @($File.FullName)
                        }
                    }
                    
                    # Extract Set-Alias commands
                    $Aliases = [regex]::Matches($Content, 'Set-Alias\s+([a-zA-Z0-9_-]+)')
                    foreach ($Match in $Aliases) {
                        $AliasName = $Match.Groups[1].Value
                        if ($CommandAliases[$AliasName]) {
                            $CommandAliases[$AliasName] += @($File.FullName)
                        } else {
                            $CommandAliases[$AliasName] = @($File.FullName)
                        }
                    }
                }
                
                # Extract HTML/JS functions and IDs
                if ($File.Extension -eq ".html") {
                    $JSFunctions = [regex]::Matches($Content, 'function\s+([a-zA-Z0-9_-]+)\s*\(')
                    foreach ($Match in $JSFunctions) {
                        $FuncName = "JS_" + $Match.Groups[1].Value
                        if ($FunctionNames[$FuncName]) {
                            $FunctionNames[$FuncName] += @($File.FullName)
                        } else {
                            $FunctionNames[$FuncName] = @($File.FullName)
                        }
                    }
                    
                    $IDs = [regex]::Matches($Content, 'id=["'']([a-zA-Z0-9_-]+)["'']')
                    foreach ($Match in $IDs) {
                        $IDName = "ID_" + $Match.Groups[1].Value
                        if ($FunctionNames[$IDName]) {
                            $FunctionNames[$IDName] += @($File.FullName)
                        } else {
                            $FunctionNames[$IDName] = @($File.FullName)
                        }
                    }
                }
                
            } catch {
                Write-Warning "Could not scan $($File.FullName): $($_.Exception.Message)"
            }
        }
    }
    
    # Find duplicates
    $DuplicateCount = 0
    $DuplicateFunctions = $FunctionNames.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }
    $DuplicateAliases = $CommandAliases.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }
    
    if ($DuplicateFunctions.Count -gt 0) {
        Write-Host "`n⚠️  DUPLICATE FUNCTIONS DETECTED:" -ForegroundColor Yellow
        Write-Host "-" * 40
        foreach ($Dup in $DuplicateFunctions) {
            $DuplicateCount++
            Write-Host "🔄 Function: $($Dup.Key)" -ForegroundColor Red
            if ($ShowDetails) {
                foreach ($File in $Dup.Value) {
                    Write-Host "   📄 $File" -ForegroundColor Gray
                }
            } else {
                Write-Host "   Found in $($Dup.Value.Count) files" -ForegroundColor Gray
            }
        }
    }
    
    if ($DuplicateAliases.Count -gt 0) {
        Write-Host "`n⚠️  DUPLICATE ALIASES DETECTED:" -ForegroundColor Yellow
        Write-Host "-" * 40
        foreach ($Dup in $DuplicateAliases) {
            $DuplicateCount++
            Write-Host "🔄 Alias: $($Dup.Key)" -ForegroundColor Red
            if ($ShowDetails) {
                foreach ($File in $Dup.Value) {
                    Write-Host "   📄 $File" -ForegroundColor Gray
                }
            } else {
                Write-Host "   Found in $($Dup.Value.Count) files" -ForegroundColor Gray
            }
        }
    }
    
    if ($DuplicateCount -eq 0) {
        Write-Host "✅ No duplicates detected! System is clean." -ForegroundColor Green
    } else {
        Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
        Write-Host "   Total duplicates found: $DuplicateCount" -ForegroundColor White
        Write-Host "   Run with -ShowDetails for file locations" -ForegroundColor Gray
        Write-Host "   Run with -RemoveDuplicates to clean automatically" -ForegroundColor Gray
    }
    
    # Auto-removal logic (if requested)
    if ($RemoveDuplicates -and $DuplicateCount -gt 0) {
        Write-Host "`n🧹 AUTOMATIC CLEANUP MODE" -ForegroundColor Magenta
        # Implementation would go here - for safety, just logging for now
        Write-Host "⚠️  Auto-removal not yet implemented for safety" -ForegroundColor Yellow
        Write-Host "   Manual review recommended before deletion" -ForegroundColor Gray
    }
    
    Write-Host "`n" + "=" * 50
    Write-Host "🔍 Duplication scan complete." -ForegroundColor Cyan
}

# Create alias for easy access
Set-Alias -Name "dupcheck" -Value Find-SAITDuplicates

# Add to profile detection
function Test-SAITDuplicationDetector {
    return (Get-Command Find-SAITDuplicates -ErrorAction SilentlyContinue) -ne $null
}

Write-Host "✅ SAIT Duplication Detector loaded. Use 'dupcheck' or Find-SAITDuplicates" -ForegroundColor Green