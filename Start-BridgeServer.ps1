# Start-BridgeServer.ps1
# Launches the Node.js bridge server for Chrome extension hotkeys

param(
    [switch]$Background,  # Run in background
    [switch]$Kill,        # Kill existing server
    [switch]$Status       # Check if server is running
)

$ServerPath = Join-Path $PSScriptRoot "chrome-extension\bridge-server.js"
$ProcessName = "node"
$ServerPort = 8080

# Function to check if server is running
function Test-ServerRunning {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$ServerPort/status" -TimeoutSec 2 -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function to kill existing server process
function Stop-BridgeServer {
    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | 
                 Where-Object { $_.MainWindowTitle -match "bridge-server" -or $_.CommandLine -match "bridge-server" }
    
    if ($processes) {
        Write-Host "🛑 Stopping existing bridge server processes..." -ForegroundColor Yellow
        $processes | Stop-Process -Force
        Start-Sleep -Seconds 1
        Write-Host "✅ Bridge server stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ No bridge server processes found" -ForegroundColor Blue
    }
}

# Main execution
if ($Kill) {
    Stop-BridgeServer
    return
}

if ($Status) {
    if (Test-ServerRunning) {
        Write-Host "✅ Bridge server is running on port $ServerPort" -ForegroundColor Green
    } else {
        Write-Host "❌ Bridge server is not running" -ForegroundColor Red
    }
    return
}

# Check if Node.js is available
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not found. Please install Node.js first." -ForegroundColor Red
    Write-Host "   Download from: https://nodejs.org/" -ForegroundColor Yellow
    return
}

# Check if server file exists
if (-not (Test-Path $ServerPath)) {
    Write-Host "❌ Bridge server file not found: $ServerPath" -ForegroundColor Red
    return
}

# Stop any existing server
if (Test-ServerRunning) {
    Write-Host "🔄 Bridge server already running, restarting..." -ForegroundColor Yellow
    Stop-BridgeServer
}

# Start the server
Write-Host "🚀 Starting bridge server..." -ForegroundColor Cyan

if ($Background) {
    # Start in background (hidden window)
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "node"
    $startInfo.Arguments = "`"$ServerPath`""
    $startInfo.WorkingDirectory = Split-Path $ServerPath -Parent
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $startInfo.CreateNoWindow = $true
    
    $process = [System.Diagnostics.Process]::Start($startInfo)
    
    # Wait a moment and check if it started
    Start-Sleep -Seconds 2
    if (Test-ServerRunning) {
        Write-Host "✅ Bridge server started in background (PID: $($process.Id))" -ForegroundColor Green
        Write-Host "   Server accessible at: http://localhost:$ServerPort" -ForegroundColor Blue
    } else {
        Write-Host "❌ Failed to start bridge server" -ForegroundColor Red
    }
} else {
    # Start in foreground
    Write-Host "📡 Bridge server will run in this window. Press Ctrl+C to stop." -ForegroundColor Blue
    Write-Host ""
    
    Set-Location (Split-Path $ServerPath -Parent)
    node "bridge-server.js"
}

# Usage examples
if (-not $Background -and -not $Kill -and -not $Status) {
    Write-Host ""
    Write-Host "💡 Usage examples:" -ForegroundColor Yellow
    Write-Host "   .\Start-BridgeServer.ps1 -Background  # Run in background"
    Write-Host "   .\Start-BridgeServer.ps1 -Status      # Check if running"  
    Write-Host "   .\Start-BridgeServer.ps1 -Kill        # Stop server"
}