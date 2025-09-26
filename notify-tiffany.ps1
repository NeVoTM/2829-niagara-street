# Notify Tiffany - Send 2829 Niagara Street Project Link
# Usage: .\notify-tiffany.ps1

param(
    [string]$ProjectLink = "file:///C:/Users/17274/ME/2829-Niagara-Street/index.html"
)

Write-Host "🚀 2829 Niagara Street - Project Notification System" -ForegroundColor Cyan
Write-Host "=" * 50

# Contact Information
$TiffanyEmail = "durillaprop@gmail.com"
$TiffanyPhone = "716-421-1210"

# Project Details
$ProjectTitle = "2829 Niagara Street - Premier Mixed-Use Development"
$ProjectDescription = "Revolutionary 'Partners Not Paychecks' development opportunity in Tonawanda, NY. 3-story mixed-use with expansion potential."

Write-Host "📧 PREPARING EMAIL NOTIFICATION..." -ForegroundColor Yellow

# Email Subject and Body
$Subject = "🏗️ 2829 Niagara Street Development - Partnership Opportunity"
$EmailBody = @"
Hi Tiffany,

The 2829 Niagara Street development dashboard is ready for your review!

🏗️ PROJECT HIGHLIGHTS:
• Location: 2829 Niagara Street, Tonawanda, NY
• Type: 3-Story Mixed-Use with Major Expansion Potential
• Model: Revolutionary "Partners Not Paychecks" approach
• Status: Ready for development partners

🎬 FEATURES:
• Complete 6-tab portal (Overview, Financials, Project, Partners, Renderings, Contact)
• Video integration (2829 Niagara Development video)
• Partner category buttons with direct email integration
• Miami Makers Model (MMM) framework from Nevo Tower
• Mobile-responsive professional gradient theme
• Interactive stats and ROI projections

🔗 VIEW PROJECT:
Local Dashboard: $ProjectLink

📞 NEXT STEPS:
• Review the development proposal
• Watch the integrated development video
• Contact potential partners using the dashboard tools
• Discuss expansion strategies and timeline

The dashboard includes direct email and phone integration, making it easy for potential partners to reach out immediately.

Best regards,
Development Team

---
📧 Email: durillaprop@gmail.com
📱 Phone: 716-421-1210
📍 Location: 2829 Niagara Street, Tonawanda, NY
"@

# Create email URL for default email client
$EmailURL = "mailto:$TiffanyEmail" + 
    "?subject=" + [System.Web.HttpUtility]::UrlEncode($Subject) + 
    "&body=" + [System.Web.HttpUtility]::UrlEncode($EmailBody)

Write-Host "✅ Email prepared for: $TiffanyEmail" -ForegroundColor Green

# SMS Text (for copy-paste to SMS app)
$SMSText = @"
🏗️ 2829 Niagara Street Development Ready! 

Premier mixed-use project dashboard complete with video integration. 3-story base, major expansion potential. "Partners Not Paychecks" model.

Dashboard: $ProjectLink

Ready for partner outreach!

-Development Team
"@

Write-Host "📱 PREPARING SMS NOTIFICATION..." -ForegroundColor Yellow
Write-Host "✅ SMS prepared for: $TiffanyPhone" -ForegroundColor Green

# Action Menu
Write-Host "`n🎯 NOTIFICATION OPTIONS:" -ForegroundColor Magenta
Write-Host "1. Open Email Client (Default)" -ForegroundColor White
Write-Host "2. Copy SMS Text to Clipboard" -ForegroundColor White  
Write-Host "3. Open Project Dashboard" -ForegroundColor White
Write-Host "4. Display Contact Info" -ForegroundColor White
Write-Host "5. Exit" -ForegroundColor White

$Choice = Read-Host "`nSelect option (1-5)"

switch ($Choice) {
    "1" { 
        Write-Host "📧 Opening email client..." -ForegroundColor Green
        Start-Process $EmailURL
    }
    "2" { 
        Write-Host "📱 Copying SMS to clipboard..." -ForegroundColor Green
        Set-Clipboard -Value $SMSText
        Write-Host "✅ SMS text copied! Paste into your SMS app and send to: $TiffanyPhone" -ForegroundColor Cyan
    }
    "3" { 
        Write-Host "🌐 Opening project dashboard..." -ForegroundColor Green
        Start-Process $ProjectLink
    }
    "4" {
        Write-Host "`n📞 CONTACT INFORMATION:" -ForegroundColor Cyan
        Write-Host "Name: Tiffany Durilla" -ForegroundColor White
        Write-Host "Email: $TiffanyEmail" -ForegroundColor White
        Write-Host "Phone: $TiffanyPhone" -ForegroundColor White
        Write-Host "Project: 2829 Niagara Street, Tonawanda, NY" -ForegroundColor White
    }
    default { 
        Write-Host "👋 Exiting notification system..." -ForegroundColor Gray
    }
}

Write-Host "`n🎯 PROJECT SUMMARY:" -ForegroundColor Magenta
Write-Host "Dashboard Location: C:\Users\17274\ME\2829-Niagara-Street\2829-dashboard.html" -ForegroundColor White
Write-Host "Video Location: C:\Users\17274\ME\2829-Niagara-Street\videos\2829 Niagara Development" -ForegroundColor White
Write-Host "Status: Ready for morning presentation" -ForegroundColor Green

Write-Host "`n✅ NOTIFICATION SYSTEM COMPLETE!" -ForegroundColor Green