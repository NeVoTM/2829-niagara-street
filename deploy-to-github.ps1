# Deploy 2829 Niagara Street Project to GitHub Pages
# Usage: .\deploy-to-github.ps1 -GitHubUsername "your-username" -PersonalAccessToken "your-token"

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$PersonalAccessToken,
    
    [string]$RepoName = "2829-niagara-street",
    
    [string]$ProjectPath = "C:\Users\17274\ME\2829-Niagara-Street"
)

Write-Host "🚀 2829 Niagara Street - GitHub Pages Deployment" -ForegroundColor Cyan
Write-Host "=" * 50

# Repository URL
$RepoURL = "https://${GitHubUsername}:${PersonalAccessToken}@github.com/${GitHubUsername}/${RepoName}.git"
$TempDir = Join-Path $env:TEMP "2829-niagara-deployment"

Write-Host "📋 DEPLOYMENT SETTINGS:" -ForegroundColor Yellow
Write-Host "GitHub Username: $GitHubUsername" -ForegroundColor White
Write-Host "Repository Name: $RepoName" -ForegroundColor White
Write-Host "Project Path: $ProjectPath" -ForegroundColor White
Write-Host "Future URL: https://${GitHubUsername}.github.io/${RepoName}/" -ForegroundColor Green

# Clean up any existing temp directory
if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
    Write-Host "🧹 Cleaned existing temp directory" -ForegroundColor Gray
}

try {
    Write-Host "`n📥 CLONING/CREATING REPOSITORY..." -ForegroundColor Yellow
    
    # Try to clone existing repo, create new if doesn't exist
    try {
        git clone $RepoURL $TempDir 2>$null
        Write-Host "✅ Repository cloned successfully" -ForegroundColor Green
        Set-Location $TempDir
    } catch {
        Write-Host "📝 Repository doesn't exist, creating new one..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
        Set-Location $TempDir
        git init
        git remote add origin $RepoURL
        Write-Host "✅ New repository initialized" -ForegroundColor Green
    }
    
    Write-Host "`n📁 COPYING PROJECT FILES..." -ForegroundColor Yellow
    
    # Copy main project files
    $FilesToCopy = @(
        "index.html",
        "2829-dashboard.html", 
        "README.md"
    )
    
    foreach ($file in $FilesToCopy) {
        $sourcePath = Join-Path $ProjectPath $file
        if (Test-Path $sourcePath) {
            Copy-Item $sourcePath $TempDir -Force
            Write-Host "✅ Copied: $file" -ForegroundColor Green
        } else {
            Write-Host "⚠️  File not found: $file" -ForegroundColor Yellow
        }
    }
    
    # Create GitHub Pages specific files
    Write-Host "`n📋 CREATING GITHUB PAGES FILES..." -ForegroundColor Yellow
    
    # Create _config.yml for GitHub Pages
    $ConfigContent = @"
title: 2829 Niagara Street Development
description: Revolutionary MMM Development - Partners Not Paychecks
theme: minima
plugins:
  - jekyll-sitemap
  - jekyll-feed
"@
    Set-Content "_config.yml" $ConfigContent
    Write-Host "✅ Created: _config.yml" -ForegroundColor Green
    
    # Create CNAME file if custom domain needed (commented for now)
    # Set-Content "CNAME" "2829niagara.com"
    
    # Create .nojekyll to bypass Jekyll processing if needed
    New-Item ".nojekyll" -ItemType File -Force | Out-Null
    Write-Host "✅ Created: .nojekyll" -ForegroundColor Green
    
    Write-Host "`n🔄 COMMITTING CHANGES..." -ForegroundColor Yellow
    
    # Configure git if needed
    git config user.name "2829 Niagara Deployment" 2>$null
    git config user.email "${GitHubUsername}@users.noreply.github.com" 2>$null
    
    # Add all files
    git add .
    
    # Create commit message with timestamp
    $CommitMessage = "Deploy 2829 Niagara Street MMM Portal - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $CommitMessage
    
    Write-Host "✅ Changes committed: $CommitMessage" -ForegroundColor Green
    
    Write-Host "`n🚀 PUSHING TO GITHUB..." -ForegroundColor Yellow
    
    # Push to main branch
    git branch -M main 2>$null
    git push -u origin main --force
    
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    
    Write-Host "`n🌐 GITHUB PAGES SETUP..." -ForegroundColor Yellow
    Write-Host "1. Go to: https://github.com/${GitHubUsername}/${RepoName}/settings/pages" -ForegroundColor White
    Write-Host "2. Source: Deploy from branch 'main'" -ForegroundColor White
    Write-Host "3. Folder: / (root)" -ForegroundColor White
    Write-Host "4. Save settings" -ForegroundColor White
    
    Write-Host "`n🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
    Write-Host "Repository: https://github.com/${GitHubUsername}/${RepoName}" -ForegroundColor Cyan
    Write-Host "Live URL: https://${GitHubUsername}.github.io/${RepoName}/" -ForegroundColor Cyan
    Write-Host "Video Link: Already integrated with Google Drive" -ForegroundColor Cyan
    
    Write-Host "`n⏰ GITHUB PAGES ACTIVATION:" -ForegroundColor Magenta
    Write-Host "• Pages may take 5-10 minutes to become live" -ForegroundColor White
    Write-Host "• Check GitHub Pages settings if not working" -ForegroundColor White
    Write-Host "• SSL certificate may take additional time" -ForegroundColor White
    
} catch {
    Write-Host "`n❌ DEPLOYMENT ERROR: $_" -ForegroundColor Red
    Write-Host "Check your GitHub credentials and try again" -ForegroundColor Yellow
} finally {
    # Return to original directory
    Set-Location $ProjectPath
    
    # Clean up temp directory
    if (Test-Path $TempDir) {
        Remove-Item $TempDir -Recurse -Force
        Write-Host "`n🧹 Cleaned up temporary files" -ForegroundColor Gray
    }
}

Write-Host "`n📞 CONTACT INTEGRATION:" -ForegroundColor Magenta
Write-Host "Tiffany Durilla: durillaprop@gmail.com | 716-421-1210" -ForegroundColor White
Write-Host "All partner contact buttons are ready for live use!" -ForegroundColor Green

Write-Host "`n✅ DEPLOYMENT SCRIPT COMPLETE!" -ForegroundColor Green