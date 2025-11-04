# SuperDebugBridge.ps1 - Real PowerShell Bridge for HTML Interface
# This connects the HTML interface to actual PowerShell commands

param(
    [string]$Command = "",
    [string]$Target = "",
    [int]$Port = 8888
)

# Start HTTP server to handle HTML requests
function Start-DebugServer {
    param([int]$ServerPort = 8888)
    
    Write-Host "🚀 Starting Super Debug Bridge Server on port $ServerPort" -ForegroundColor Cyan
    Write-Host "📂 Open: http://localhost:$ServerPort/debug" -ForegroundColor Green
    
    # Create HTTP listener
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$ServerPort/")
    $listener.Start()
    
    Write-Host "✅ Server started! Press Ctrl+C to stop." -ForegroundColor Green
    
    try {
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            # Handle different endpoints
            $url = $request.Url.LocalPath.ToLower()
            
            switch ($url) {
                "/debug" {
                    # Serve the main HTML interface
                    $htmlContent = Get-Content "SuperDebug.html" -Raw
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($htmlContent)
                    $response.ContentLength64 = $buffer.Length
                    $response.ContentType = "text/html"
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/command" {
                    # Handle command execution
                    $body = ""
                    if ($request.HasEntityBody) {
                        $reader = New-Object System.IO.StreamReader($request.InputStream)
                        $body = $reader.ReadToEnd()
                        $reader.Close()
                    }
                    
                    # Parse JSON request
                    $requestData = $body | ConvertFrom-Json
                    $cmd = $requestData.command
                    $args = $requestData.arguments
                    
                    # Execute the actual command
                    $result = Execute-DebugCommand -Command $cmd -Arguments $args
                    
                    # Return JSON response
                    $jsonResponse = @{
                        success = $true
                        result = $result
                        timestamp = (Get-Date).ToString()
                    } | ConvertTo-Json
                    
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($jsonResponse)
                    $response.ContentType = "application/json"
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                default {
                    # 404 Not Found
                    $response.StatusCode = 404
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
            }
            
            $response.Close()
        }
    }
    catch {
        Write-Host "❌ Server error: $_" -ForegroundColor Red
    }
    finally {
        $listener.Stop()
        Write-Host "🛑 Server stopped." -ForegroundColor Yellow
    }
}

# Execute actual debug commands
function Execute-DebugCommand {
    param(
        [string]$Command,
        [string]$Arguments = ""
    )
    
    try {
        switch ($Command.ToLower()) {
            "check" {
                return (& ".\DebugToolbox.ps1" check)
            }
            "port" {
                return (& ".\DebugToolbox.ps1" port $Arguments)
            }
            "file" {
                return (& ".\DebugToolbox.ps1" file $Arguments)
            }
            "error" {
                return (& ".\DebugToolbox.ps1" error $Arguments)
            }
            "git" {
                return (& ".\DebugToolbox.ps1" git)
            }
            "npm" {
                return (& ".\DebugToolbox.ps1" npm)
            }
            "explorer" {
                Start-Process explorer .
                return "✅ File Explorer opened"
            }
            "vscode" {
                if (Get-Command code -ErrorAction SilentlyContinue) {
                    Start-Process code .
                    return "✅ VS Code opened"
                } else {
                    return "❌ VS Code not found in PATH"
                }
            }
            "gitpull" {
                $output = git pull 2>&1
                return $output
            }
            "gitpush" {
                $output = git push 2>&1
                return $output
            }
            "gitlog" {
                $output = git --no-pager log --oneline -10 2>&1
                return $output
            }
            default {
                return "❌ Unknown command: $Command"
            }
        }
    }
    catch {
        return "❌ Error executing command: $_"
    }
}

# Quick launch function
function Launch-SuperDebug {
    Write-Host "🚀 LAUNCHING SUPER AI DEBUG TOOLBOX" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Blue
    Write-Host ""
    Write-Host "🌐 Starting web interface..." -ForegroundColor Yellow
    
    # Start the server in background
    Start-Job -ScriptBlock {
        Set-Location $using:PWD
        & ".\SuperDebugBridge.ps1" server -Port 8888
    } | Out-Null
    
    # Wait a moment for server to start
    Start-Sleep 2
    
    # Open browser
    Write-Host "🔥 Opening in browser..." -ForegroundColor Green
    Start-Process "http://localhost:8888/debug"
    
    Write-Host ""
    Write-Host "✅ SUPER DEBUG TOOLBOX IS LIVE!" -ForegroundColor Green
    Write-Host "📱 Use the web interface for visual debugging" -ForegroundColor Cyan
    Write-Host "⌨️  Or continue using PowerShell commands directly" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 Quick PowerShell commands:" -ForegroundColor Yellow
    Write-Host "   .\DebugToolbox.ps1 check" -ForegroundColor White
    Write-Host "   .\DebugToolbox.ps1 error 'your error'" -ForegroundColor White
    Write-Host "   .\DebugToolbox.ps1 port 3000" -ForegroundColor White
}

# Main execution
if ($Command -eq "") {
    if ($args[0] -eq "server") {
        Start-DebugServer -ServerPort $Port
    } elseif ($args[0] -eq "launch") {
        Launch-SuperDebug
    } else {
        Write-Host "🔧 SUPER DEBUG BRIDGE" -ForegroundColor Cyan
        Write-Host "=====================" -ForegroundColor Blue
        Write-Host ""
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  .\SuperDebugBridge.ps1 launch    - Start web interface" -ForegroundColor White
        Write-Host "  .\SuperDebugBridge.ps1 server    - Start server only" -ForegroundColor White
        Write-Host ""
        Write-Host "Quick launch: .\SuperDebugBridge.ps1 launch" -ForegroundColor Green
    }
} else {
    # Direct command execution
    $result = Execute-DebugCommand -Command $Command -Arguments $Target
    Write-Output $result
}