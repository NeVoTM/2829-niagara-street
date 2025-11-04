# PowerShell-Bridge-Server.ps1
# Pure PowerShell HTTP server for Chrome extension hotkeys
# No Node.js required!

param(
    [int]$Port = 8080,
    [switch]$Background,
    [switch]$Kill,
    [switch]$Status
)

$ServerUrl = "http://localhost:$Port/"

# Function to check if server is running
function Test-ServerRunning {
    try {
        $response = Invoke-WebRequest -Uri "$ServerUrl/status" -TimeoutSec 2 -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function to kill existing server
function Stop-PowerShellServer {
    $processes = Get-Process -Name "powershell", "pwsh" -ErrorAction SilentlyContinue | 
                 Where-Object { $_.CommandLine -match "PowerShell-Bridge-Server" }
    
    if ($processes) {
        Write-Host "🛑 Stopping existing PowerShell bridge server..." -ForegroundColor Yellow
        $processes | Stop-Process -Force
        Start-Sleep -Seconds 1
        Write-Host "✅ Bridge server stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ No PowerShell bridge server processes found" -ForegroundColor Blue
    }
}

# Handle parameters
if ($Kill) {
    Stop-PowerShellServer
    return
}

if ($Status) {
    if (Test-ServerRunning) {
        Write-Host "✅ PowerShell bridge server is running on port $Port" -ForegroundColor Green
    } else {
        Write-Host "❌ PowerShell bridge server is not running" -ForegroundColor Red
    }
    return
}

# Stop existing server if running
if (Test-ServerRunning) {
    Write-Host "🔄 Server already running, restarting..." -ForegroundColor Yellow
    Stop-PowerShellServer
    Start-Sleep -Seconds 2
}

Write-Host "🚀 Starting PowerShell HTTP Bridge Server on port $Port..." -ForegroundColor Cyan

# PowerShell dropdown commands mapping
$DropdownCommands = @{
    'debug-dropdown' = @{
        Name = 'Debug Issues'
        Script = 'C:\Users\17274\ME\2829-Niagara-Street\QuickDebug-Dropdown.ps1'
    }
    'commands-browser' = @{
        Name = 'Commands Browser'
        Script = 'C:\Users\17274\ME\2829-Niagara-Street\QuickCommands-Dropdown.ps1'
    }
    'files-browser' = @{
        Name = 'Files Browser'
        Script = 'C:\Users\17274\ME\2829-Niagara-Street\QuickFiles-Dropdown.ps1'
    }
    'reference-selector' = @{
        Name = 'Reference Selector'
        Script = 'C:\Users\17274\ME\2829-Niagara-Street\QuickReference-Selector.ps1'
    }
}

# Create HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($ServerUrl)

try {
    $listener.Start()
    Write-Host "✅ Server started successfully at $ServerUrl" -ForegroundColor Green
    Write-Host "📡 Ready to handle Chrome extension requests..." -ForegroundColor Blue
    Write-Host "   Available endpoints:" -ForegroundColor Gray
    Write-Host "   - POST /execute - Execute dropdown commands" -ForegroundColor Gray
    Write-Host "   - GET /status - Health check" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🔥 Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # CORS headers
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")
        
        $method = $request.HttpMethod
        $path = $request.Url.AbsolutePath
        
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - $method $path" -ForegroundColor Cyan
        
        if ($method -eq "OPTIONS") {
            # Handle CORS preflight
            $response.StatusCode = 200
            $response.Close()
            continue
        }
        
        if ($method -eq "GET" -and $path -eq "/status") {
            # Health check
            $responseData = @{
                status = "running"
                port = $Port
                message = "PowerShell Bridge Server"
                timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            } | ConvertTo-Json
            
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseData)
            $response.ContentLength64 = $buffer.Length
            $response.ContentType = "application/json"
            $response.StatusCode = 200
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        if ($method -eq "POST" -and $path -eq "/execute") {
            # Execute dropdown command
            try {
                $reader = New-Object System.IO.StreamReader($request.InputStream)
                $requestBody = $reader.ReadToEnd()
                $reader.Close()
                
                $data = $requestBody | ConvertFrom-Json
                $commandType = $data.command -replace '.*"([^"]+)".*', '$1'
                
                # Extract command type from the PowerShell command
                foreach ($key in $DropdownCommands.Keys) {
                    if ($data.command -match [regex]::Escape($DropdownCommands[$key].Script)) {
                        $commandInfo = $DropdownCommands[$key]
                        
                        Write-Host "🚀 Executing: $($commandInfo.Name)" -ForegroundColor Green
                        
                        # Execute PowerShell script in background
                        Start-Process -FilePath "powershell.exe" -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$($commandInfo.Script)`"" -WindowStyle Hidden
                        
                        $responseData = @{
                            success = $true
                            message = "$($commandInfo.Name) launched successfully"
                        } | ConvertTo-Json
                        
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseData)
                        $response.ContentLength64 = $buffer.Length
                        $response.ContentType = "application/json"
                        $response.StatusCode = 200
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)
                        $response.Close()
                        break
                    }
                }
            }
            catch {
                Write-Host "❌ Error processing request: $($_.Exception.Message)" -ForegroundColor Red
                
                $errorData = @{
                    success = $false
                    error = $_.Exception.Message
                } | ConvertTo-Json
                
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorData)
                $response.ContentLength64 = $buffer.Length
                $response.ContentType = "application/json"
                $response.StatusCode = 500
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
                $response.Close()
            }
            continue
        }
        
        # 404 for other paths
        $response.StatusCode = 404
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
}
catch {
    Write-Host "❌ Server error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    if ($listener.IsListening) {
        $listener.Stop()
        Write-Host "✅ Server stopped" -ForegroundColor Green
    }
}