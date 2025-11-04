# Multi-Browser SMS Setup Script
# Run this script in PowerShell as Administrator

Write-Host "🚀 Multi-Browser SMS System Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -like "*not found*" -or $pythonVersion -like "*not recognized*") {
        throw "Python not found"
    }
    Write-Host "✅ Python is already installed: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please download and install Python 3.12" -ForegroundColor Red
    Write-Host "   Download from: https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe" -ForegroundColor Yellow
    Write-Host "   IMPORTANT: Check 'Add Python to PATH' during installation" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installing Python, run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🔧 Setting up virtual environment..." -ForegroundColor Yellow

# Create virtual environment
if (-not (Test-Path "smsenv")) {
    python -m venv smsenv
    Write-Host "✅ Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "✅ Virtual environment already exists" -ForegroundColor Green
}

# Activate virtual environment
Write-Host "🔧 Activating virtual environment..." -ForegroundColor Yellow
& ".\smsenv\Scripts\Activate.ps1"

# Upgrade pip
Write-Host "🔧 Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install requirements
Write-Host "🔧 Installing Python packages..." -ForegroundColor Yellow
pip install -r requirements.txt

Write-Host ""
Write-Host "🎯 Testing browser detection..." -ForegroundColor Yellow
python browser_config.py

Write-Host ""
Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit sample_recipients.csv with your phone numbers and messages" -ForegroundColor White
Write-Host "2. Run: python multi_browser_sms.py" -ForegroundColor White
Write-Host "3. Scan QR codes in each browser with your Google Messages app" -ForegroundColor White
Write-Host "4. Watch the magic happen! 🚀" -ForegroundColor White
Write-Host ""
Write-Host "To activate the environment later:" -ForegroundColor Yellow
Write-Host "   .\smsenv\Scripts\Activate.ps1" -ForegroundColor White