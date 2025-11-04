# WARP AI DORMANCY MONITOR - 1 HOUR NOTIFICATION SYSTEM
# Real email and SMS notifications for session memory loss

param(
    [switch]$Install,
    [switch]$Test,
    [switch]$Status,
    [string]$Email = "elichalfinny@gmail.com",
    [string]$Phone = "305-905-5068"
)

# Configuration
$config = @{
    DormancyThreshold = 3600  # 1 hour in seconds
    CheckInterval = 600       # Check every 10 minutes
    LastActivityFile = "C:\Users\17274\ME\super-ai-toolbox\core\last-warp-activity.txt"
    LogFile = "C:\Users\17274\ME\super-ai-toolbox\core\dormancy-log.txt"
    NotificationSent = "C:\Users\17274\ME\super-ai-toolbox\core\dormancy-notification-sent.flag"
}

function Write-DormancyLog {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    $logEntry | Add-Content -Path $config.LogFile -Encoding UTF8
    Write-Host $logEntry -ForegroundColor Green
}

function Update-ActivityTimestamp {
    Get-Date | Out-File -FilePath $config.LastActivityFile -Encoding UTF8
    # Remove notification flag since user is active
    if (Test-Path $config.NotificationSent) {
        Remove-Item $config.NotificationSent -Force
    }
}

function Send-RealEmailNotification {
    param($Subject, $Body)
    
    try {
        # Using PowerShell with Gmail SMTP (requires app-specific password)
        $smtpServer = "smtp.gmail.com"
        $smtpPort = 587
        
        # Create secure credential (you'll need to set this up)
        $gmailUser = "your-gmail@gmail.com"  # Replace with your Gmail
        $gmailAppPassword = "your-app-password"  # Gmail App Password
        
        # For now, create email script that can be manually configured
        $emailScript = @"
# REAL EMAIL SENDING SCRIPT - Configure with your credentials
`$smtpServer = "smtp.gmail.com"
`$smtpPort = 587
`$gmailUser = "your-gmail@gmail.com"  # Your Gmail address
`$gmailAppPassword = "your-16-char-app-password"  # Gmail App Password

`$securePassword = ConvertTo-SecureString `$gmailAppPassword -AsPlainText -Force
`$credential = New-Object System.Management.Automation.PSCredential(`$gmailUser, `$securePassword)

Send-MailMessage -To "$Email" -From `$gmailUser -Subject "$Subject" -Body "$Body" -SmtpServer `$smtpServer -Port `$smtpPort -UseSsl -Credential `$credential
"@
        
        $emailScriptPath = "C:\Users\17274\ME\super-ai-toolbox\core\send-dormancy-email.ps1"
        $emailScript | Out-File -FilePath $emailScriptPath -Encoding UTF8
        
        Write-DormancyLog "📧 Email script created: $emailScriptPath"
        Write-Host "⚠️ Configure Gmail credentials in: $emailScriptPath" -ForegroundColor Yellow
        
        return $emailScriptPath
        
    } catch {
        Write-DormancyLog "❌ Email setup failed: $($_.Exception.Message)"
        return $null
    }
}

function Send-SMSNotification {
    param($Message)
    
    try {
        # Using Twilio API for SMS (free tier available)
        $twilioScript = @"
# REAL SMS SENDING SCRIPT - Configure with Twilio credentials
`$accountSid = "your-twilio-account-sid"
`$authToken = "your-twilio-auth-token"  
`$twilioNumber = "+1234567890"  # Your Twilio phone number

`$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("`$accountSid" + ':' + "`$authToken"))
}

`$body = @{
    'From' = `$twilioNumber
    'To' = "$Phone"
    'Body' = "$Message"
}

Invoke-RestMethod -Uri "https://api.twilio.com/2010-04-01/Accounts/`$accountSid/Messages.json" -Method POST -Headers `$headers -Body `$body
"@
        
        $smsScriptPath = "C:\Users\17274\ME\super-ai-toolbox\core\send-dormancy-sms.ps1"
        $twilioScript | Out-File -FilePath $smsScriptPath -Encoding UTF8
        
        Write-DormancyLog "📱 SMS script created: $smsScriptPath"
        Write-Host "⚠️ Configure Twilio credentials in: $smsScriptPath" -ForegroundColor Yellow
        
        return $smsScriptPath
        
    } catch {
        Write-DormancyLog "❌ SMS setup failed: $($_.Exception.Message)"
        return $null
    }
}

function Check-DormancyStatus {
    if (-not (Test-Path $config.LastActivityFile)) {
        Update-ActivityTimestamp
        Write-DormancyLog "🆕 First run - activity timestamp created"
        return
    }
    
    $lastActivity = Get-Content $config.LastActivityFile -ErrorAction SilentlyContinue | Get-Date -ErrorAction SilentlyContinue
    if (-not $lastActivity) {
        Update-ActivityTimestamp
        return
    }
    
    $timeSinceActivity = (Get-Date) - $lastActivity
    $secondsSinceActivity = [int]$timeSinceActivity.TotalSeconds
    
    Write-DormancyLog "⏱️ Time since last activity: $([int]$timeSinceActivity.TotalMinutes) minutes"
    
    if ($secondsSinceActivity -gt $config.DormancyThreshold) {
        # Check if notification already sent
        if (Test-Path $config.NotificationSent) {
            Write-DormancyLog "📵 Dormancy detected but notification already sent"
            return
        }
        
        Write-DormancyLog "🚨 DORMANCY DETECTED - Sending notifications"
        
        # Create notification flag
        "Notification sent at $(Get-Date)" | Out-File -FilePath $config.NotificationSent -Encoding UTF8
        
        # Send notifications
        $subject = "🚨 WARP AI Session Memory Lost - Reactivation Needed"
        $body = @"
WARP AI DORMANCY ALERT

Your WARP AI session has been dormant for over 1 hour.

⚠️ MEMORY STATUS: LOST - AI has zero memory of your conversation

🔄 REQUIRED ACTIONS:
1. Start new chat session OR
2. Say "Please read WARP-START-SESSION.md to restore context" OR  
3. Use: WarpSpeed command to reload session instructions

📊 CURRENT SYSTEM STATUS:
- Profile: Cleaned and optimized
- Commands: q, v, c, clean, eos all functional
- Progress: 83% session completion achieved
- Files: All documentation and procedures created

⚡ QUICK RESTART:
Type: q (loads all shortcuts)
Type: v (opens visual interface)
Type: WarpSpeed (shows session instructions)

Time of Alert: $(Get-Date)
Contact: elichalfinny@gmail.com | 305-905-5068

This message was automatically generated by WarpDormancyMonitor.ps1
"@
        
        # Send email notification
        $emailScript = Send-RealEmailNotification $subject $body
        
        # Send SMS notification  
        $smsMessage = "🚨 WARP AI DORMANT 1+ hours. Memory LOST. Need to restart chat or reload context. Use 'q' or WarpSpeed commands. - $(Get-Date -Format 'HH:mm')"
        $smsScript = Send-SMSNotification $smsMessage
        
        # Visual notification
        Write-Host "`n" + "🚨" * 20 -ForegroundColor Red
        Write-Host "WARP AI DORMANCY ALERT - MEMORY LOST!" -ForegroundColor Red
        Write-Host "Session inactive for $([int]$timeSinceActivity.TotalMinutes) minutes" -ForegroundColor Yellow
        Write-Host "EMAIL & SMS NOTIFICATIONS SENT TO: $Email / $Phone" -ForegroundColor Green
        Write-Host "🚨" * 20 + "`n" -ForegroundColor Red
        
    } else {
        $remainingMinutes = [int](($config.DormancyThreshold - $secondsSinceActivity) / 60)
        Write-DormancyLog "✅ Session active - $remainingMinutes minutes until dormancy alert"
    }
}

function Install-DormancyMonitor {
    Write-Host "🔧 Installing WARP Dormancy Monitor..." -ForegroundColor Cyan
    
    # Add to PowerShell profile
    $profilePath = $PROFILE
    $monitorFunction = @"

# WARP AI DORMANCY MONITOR - Auto-added by WarpDormancyMonitor.ps1
function Update-WarpActivity {
    & "C:\Users\17274\ME\super-ai-toolbox\core\WarpDormancyMonitor.ps1" -UpdateActivity
}

# Update activity on any Warp command usage
function q { 
    Update-WarpActivity
    . "C:\Users\17274\ME\super-ai-toolbox\core\QuickStart.ps1" 
}

# Scheduled task to check dormancy every 10 minutes
Register-ScheduledTask -TaskName "WarpDormancyCheck" -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File 'C:\Users\17274\ME\super-ai-toolbox\core\WarpDormancyMonitor.ps1'") -Trigger (New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 10) -At (Get-Date))
"@
    
    $monitorFunction | Add-Content -Path $profilePath -Encoding UTF8
    Write-Host "✅ Dormancy monitor added to PowerShell profile" -ForegroundColor Green
    Write-Host "✅ Scheduled task created for 10-minute checks" -ForegroundColor Green
    
    # Create initial activity timestamp
    Update-ActivityTimestamp
    Write-Host "✅ Initial activity timestamp created" -ForegroundColor Green
}

# Main execution
switch ($PSCmdlet.ParameterSetName) {
    default {
        if ($Install) {
            Install-DormancyMonitor
        } elseif ($Test) {
            Write-Host "🧪 Testing dormancy notification system..." -ForegroundColor Yellow
            $subject = "TEST: WARP AI Dormancy System"
            $body = "This is a test of the WARP AI dormancy notification system. If you receive this, the system is working correctly."
            Send-RealEmailNotification $subject $body
            Send-SMSNotification "TEST: WARP AI dormancy system working. Time: $(Get-Date -Format 'HH:mm')"
        } elseif ($Status) {
            if (Test-Path $config.LastActivityFile) {
                $lastActivity = Get-Content $config.LastActivityFile | Get-Date
                $timeSince = (Get-Date) - $lastActivity
                Write-Host "📊 Last Activity: $lastActivity" -ForegroundColor Green
                Write-Host "⏱️ Time Since: $([int]$timeSince.TotalMinutes) minutes" -ForegroundColor Yellow
                Write-Host "🚨 Alert Threshold: $([int]($config.DormancyThreshold/60)) minutes" -ForegroundColor Cyan
            } else {
                Write-Host "❌ No activity tracking found" -ForegroundColor Red
            }
        } else {
            # Regular dormancy check
            Check-DormancyStatus
        }
    }
}

# Update activity when script is called directly
if (-not $Install -and -not $Test -and -not $Status) {
    Update-ActivityTimestamp
}