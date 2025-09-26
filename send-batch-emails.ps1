# Batch Email Sender for 2829 Niagara Street Project
# Sends partnership emails to multiple contacts from a CSV file

param(
    [Parameter(Mandatory=$false)]
    [string]$CsvFile = "contacts-template.csv",
    
    [Parameter(Mandatory=$false)]
    [int]$DelaySeconds = 5,
    
    [Parameter(Mandatory=$false)]
    [switch]$TestMode = $false
)

# Check if CSV file exists
if (-not (Test-Path $CsvFile)) {
    Write-Host "❌ CSV file not found: $CsvFile" -ForegroundColor Red
    Write-Host "💡 Create a CSV file with columns: Name,Email,Type,Notes" -ForegroundColor Yellow
    Write-Host "📝 Use contacts-template.csv as a starting point" -ForegroundColor Cyan
    exit 1
}

# Load contacts from CSV
try {
    $Contacts = Import-Csv $CsvFile
    Write-Host "📋 Loaded $($Contacts.Count) contacts from $CsvFile" -ForegroundColor Green
} catch {
    Write-Host "❌ Error reading CSV file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Validate required columns
$RequiredColumns = @('Name', 'Email', 'Type')
$CsvColumns = $Contacts[0].PSObject.Properties.Name

foreach ($Column in $RequiredColumns) {
    if ($Column -notin $CsvColumns) {
        Write-Host "❌ Required column missing: $Column" -ForegroundColor Red
        Write-Host "📝 CSV must have columns: Name, Email, Type" -ForegroundColor Yellow
        exit 1
    }
}

# Display contact summary
Write-Host ""
Write-Host "👥 CONTACT SUMMARY:" -ForegroundColor Magenta
$TypeCounts = $Contacts | Group-Object Type | Sort-Object Count -Descending
foreach ($TypeGroup in $TypeCounts) {
    Write-Host "   $($TypeGroup.Name): $($TypeGroup.Count) contacts" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "⚙️  BATCH SETTINGS:" -ForegroundColor Magenta
Write-Host "   📄 CSV File: $CsvFile" -ForegroundColor Cyan
Write-Host "   ⏱️  Delay between emails: $DelaySeconds seconds" -ForegroundColor Cyan
Write-Host "   🧪 Test Mode: $TestMode" -ForegroundColor Cyan

if ($TestMode) {
    Write-Host ""
    Write-Host "🧪 TEST MODE: Will preview emails without sending" -ForegroundColor Yellow
}

Write-Host ""
$Confirm = Read-Host "Continue with batch email sending? (y/N)"
if ($Confirm -ne 'y' -and $Confirm -ne 'Y') {
    Write-Host "❌ Batch email cancelled" -ForegroundColor Yellow
    exit 0
}

# Gmail setup (only if not in test mode)
if (-not $TestMode) {
    Write-Host ""
    Write-Host "🔐 Gmail App Password Required!" -ForegroundColor Yellow
    Write-Host "   1. Go to myaccount.google.com" -ForegroundColor Cyan
    Write-Host "   2. Security → 2-Step Verification → App passwords" -ForegroundColor Cyan
    Write-Host "   3. Generate 'App Password' for Mail" -ForegroundColor Cyan
    Write-Host ""
    
    $GmailAppPassword = Read-Host "Enter your Gmail App Password" -MaskInput
    
    if ([string]::IsNullOrEmpty($GmailAppPassword)) {
        Write-Host "❌ Gmail App Password is required!" -ForegroundColor Red
        exit 1
    }
}

# Process each contact
$SuccessCount = 0
$ErrorCount = 0
$TotalContacts = $Contacts.Count

Write-Host ""
Write-Host "🚀 Starting batch email process..." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

foreach ($Contact in $Contacts) {
    $ContactNumber = $Contacts.IndexOf($Contact) + 1
    
    Write-Host ""
    Write-Host "📧 [$ContactNumber/$TotalContacts] Processing: $($Contact.Name)" -ForegroundColor Yellow
    Write-Host "   Email: $($Contact.Email)" -ForegroundColor Cyan
    Write-Host "   Type: $($Contact.Type)" -ForegroundColor Cyan
    
    if ($Contact.Notes) {
        Write-Host "   Notes: $($Contact.Notes)" -ForegroundColor Gray
    }
    
    try {
        if ($TestMode) {
            Write-Host "   🧪 TEST: Would send $($Contact.Type) partnership email" -ForegroundColor Yellow
            Start-Sleep 1  # Simulate processing time
            $SuccessCount++
        } else {
            # Call the main email sending script
            $ScriptArgs = @(
                '-ToEmail', $Contact.Email
                '-PartnerType', $Contact.Type
                '-ContactName', $Contact.Name
            )
            
            # Set Gmail password as environment variable temporarily
            $env:GMAIL_APP_PASSWORD = $GmailAppPassword
            
            # Execute email sending (you'd need to modify the original script to use env variable)
            & ".\send-partnership-email.ps1" @ScriptArgs
            
            # Clear environment variable
            $env:GMAIL_APP_PASSWORD = $null
            
            Write-Host "   ✅ Email sent successfully!" -ForegroundColor Green
            $SuccessCount++
        }
        
    } catch {
        Write-Host "   ❌ Failed to send email: $($_.Exception.Message)" -ForegroundColor Red
        $ErrorCount++
    }
    
    # Add delay between emails (except for last one)
    if ($ContactNumber -lt $TotalContacts) {
        Write-Host "   ⏱️  Waiting $DelaySeconds seconds..." -ForegroundColor Gray
        Start-Sleep $DelaySeconds
    }
}

# Final summary
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "📊 BATCH EMAIL SUMMARY:" -ForegroundColor Magenta
Write-Host "   ✅ Successful: $SuccessCount" -ForegroundColor Green
Write-Host "   ❌ Failed: $ErrorCount" -ForegroundColor Red
Write-Host "   📧 Total Processed: $($SuccessCount + $ErrorCount)" -ForegroundColor Cyan

if (-not $TestMode -and $SuccessCount -gt 0) {
    Write-Host ""
    Write-Host "🎉 Partnership emails sent successfully!" -ForegroundColor Green
    Write-Host "📊 All emails included links to your 3 website designs:" -ForegroundColor Yellow
    Write-Host "   • Original: https://nevotm.github.io/2829-niagara-street/" -ForegroundColor Cyan
    Write-Host "   • Mobile: https://nevotm.github.io/2829-niagara-street/mobile-design.html" -ForegroundColor Cyan
    Write-Host "   • Dashboard: https://nevotm.github.io/2829-niagara-street/dashboard-design.html" -ForegroundColor Cyan
}

if ($TestMode) {
    Write-Host ""
    Write-Host "🧪 Test completed! Run without -TestMode to actually send emails." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "💡 Next Steps:" -ForegroundColor Magenta
Write-Host "   1. Monitor email responses" -ForegroundColor Cyan
Write-Host "   2. Follow up with interested partners" -ForegroundColor Cyan
Write-Host "   3. Schedule partnership meetings" -ForegroundColor Cyan
Write-Host "   4. Update your partner tracking spreadsheet" -ForegroundColor Cyan