# Add to PowerShell Profile
# This creates the 'warpspeed' command that runs directly from GitHub

function warpspeed {
    Write-Host "`n🚀 Launching WarpSpeed from GitHub..." -ForegroundColor Cyan
    
    $scriptURL = "https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/WarpSpeed-GitHub.ps1"
    
    try {
        Write-Host "   📡 Fetching: $scriptURL" -ForegroundColor Yellow
        $scriptContent = Invoke-WebRequest -Uri $scriptURL -UseBasicParsing | Select-Object -ExpandProperty Content
        Write-Host "   ✅ Script downloaded from GitHub" -ForegroundColor Green
        Write-Host "`n" + "="*70 -ForegroundColor Blue
        
        # Execute the downloaded script
        Invoke-Expression $scriptContent
        
    } catch {
        Write-Host "   ❌ FAILED to fetch WarpSpeed from GitHub" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n   💡 Fallback: Running local version..." -ForegroundColor Yellow
        
        # Fallback to local if GitHub fails
        $localScript = "C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed-GitHub.ps1"
        if (Test-Path $localScript) {
            & $localScript
        } else {
            Write-Host "   ❌ Local script not found either" -ForegroundColor Red
        }
    }
}

Write-Host "✅ 'warpspeed' command loaded - runs from GitHub" -ForegroundColor Green
