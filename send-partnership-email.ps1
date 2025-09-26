# 2829 Niagara Street Partnership Email Sender
# PowerShell script to send partnership emails via Gmail SMTP

param(
    [Parameter(Mandatory=$true)]
    [string]$ToEmail,
    
    [Parameter(Mandatory=$false)]
    [string]$PartnerType = "General",
    
    [Parameter(Mandatory=$false)]
    [string]$ContactName = ""
)

# Gmail SMTP Configuration
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$FromEmail = "durillaprop@gmail.com"

# You'll need to set up Gmail App Password
# Go to: Google Account → Security → 2-Step Verification → App passwords
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

# Create credential object
$SecurePassword = ConvertTo-SecureString $GmailAppPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($FromEmail, $SecurePassword)

# Email templates based on partner type
$Templates = @{
    "Cash" = @{
        Subject = "🏢 2829 Niagara Street - Cash Partnership Opportunity - $37.4M Project"
        Body = @"
Dear $ContactName,

I hope this email finds you well. I'm reaching out regarding an exceptional investment opportunity in Tonawanda, NY.

🏢 PROJECT OVERVIEW:
• Location: 2829 Niagara Street, Tonawanda, NY
• Type: 4-Floor Mixed-Use Development
• Total Revenue: $37.4M
• Gross Profit: $11.7M (31% margin)
• ROI: 46%

💰 CASH PARTNERSHIP OPPORTUNITY:
The WNY Makers Model (WNYMM) offers a revolutionary approach where cash partners receive:
• Direct equity participation
• Pro-rata share of substantial profits
• No traditional financing costs (save $3-5M)
• 6-12 months accelerated timeline
• Access to future WNYMM projects

🚀 WHY THIS IS DIFFERENT:
Unlike traditional real estate investments, our "Partners Not Paychecks" model eliminates:
❌ Interest payments to banks
❌ Lender pressures and forced sales
❌ Traditional financing delays

✅ Instead, you get direct ownership and faster returns!

📊 VIEW FULL DETAILS:
• Original Portal: https://nevotm.github.io/2829-niagara-street/
• Mobile Design: https://nevotm.github.io/2829-niagara-street/mobile-design.html
• Dashboard View: https://nevotm.github.io/2829-niagara-street/dashboard-design.html

I'd love to discuss how this aligns with your investment goals.

Best regards,
Tiffany Durilla
Development Partner
📧 durillaprop@gmail.com
📱 716-421-1210
"@
    }
    
    "Service" = @{
        Subject = "🔧 2829 Niagara Street - Service Partnership Opportunity - Your Expertise = Equity"
        Body = @"
Dear $ContactName,

I'm reaching out about an innovative partnership opportunity that transforms how contractors work with developers.

🏗️ PROJECT DETAILS:
• Location: 2829 Niagara Street, Tonawanda, NY
• 4-Floor Mixed-Use Development
• 143,997 sq ft - $37.4M projected revenue
• Your services = Direct equity ownership

🤝 SERVICE PARTNERSHIP MODEL:
Instead of traditional contracts, you become an equity partner:
• Your expertise valued at market rates as direct investment
• Pro-rata share of $11.7M gross profit
• 2x efficiency from ownership motivation
• Superior quality through partner accountability

💡 REVOLUTIONARY APPROACH:
✅ Your work = Ownership stake
✅ Profit sharing instead of just payment
✅ Long-term wealth building
✅ Future project access
✅ Active decision-making role

🎯 PARTNER CATEGORIES WE'RE SEEKING:
• General Contractors
• Architects & Engineers  
• Construction Managers
• Specialty Trades

📈 VIEW PROJECT DETAILS:
https://nevotm.github.io/2829-niagara-street/

This is your opportunity to build wealth, not just earn fees.

Looking forward to discussing partnership details!

Best regards,
Tiffany Durilla
Development Partner
📧 durillaprop@gmail.com
📱 716-421-1210
"@
    }
    
    "Technical" = @{
        Subject = "⚡ 2829 Niagara Street - Technical Partnership - MEP Expertise Needed"
        Body = @"
Dear $ContactName,

I'm reaching out about a unique opportunity for technical partners in our $37.4M mixed-use development project.

⚡ TECHNICAL PARTNERSHIP OPPORTUNITY:
We're seeking MEP (Mechanical, Electrical, Plumbing) partners for:
• 4-Floor Mixed-Use Building - Tonawanda, NY
• 150 total units (residential, STR hospitality, retail)
• Smart building integration potential
• Modern HVAC and electrical systems

🎯 YOUR EXPERTISE BECOMES EQUITY:
• Technical services = Direct ownership stake
• Pro-rata share of $11.7M gross profit
• Partner in decision-making process
• Access to future WNYMM projects

🔧 TECHNICAL CATEGORIES:
• Electrical Contractors
• Plumbing Specialists  
• HVAC Experts
• Smart Building Integrators
• Fire Safety Systems
• Security & Access Control

💰 FINANCIAL HIGHLIGHTS:
• Total Revenue: $37.4M
• Development Cost: $25.7M  
• ROI: 46%
• No traditional financing costs

🚀 WNYMM MODEL BENEFITS:
• Partner motivation = 2x efficiency
• Quality premium from ownership
• Faster 12-18 month timeline
• Scalable to future projects

📊 EXPLORE THE PROJECT:
https://nevotm.github.io/2829-niagara-street/dashboard-design.html

Let's discuss how your technical expertise fits into our partnership model.

Best regards,
Tiffany Durilla
Development Partner
📧 durillaprop@gmail.com
📱 716-421-1210
"@
    }
    
    "Material" = @{
        Subject = "🧱 2829 Niagara Street - Material Partnership Opportunity - Supply = Equity"
        Body = @"
Dear $ContactName,

I'm reaching out about an innovative material partnership opportunity that could transform your supplier relationship into ownership.

🧱 MATERIAL PARTNERSHIP MODEL:
Instead of traditional purchase orders, become an equity partner:
• Your materials = Direct ownership stake  
• Market value of supplies becomes investment
• Share in $11.7M gross profit
• Long-term partnership relationship

🏗️ PROJECT REQUIREMENTS:
• 4-Floor Mixed-Use Development
• 143,997 sq ft construction
• $21.4M in material and labor needs
• Premium quality standards

📦 MATERIAL CATEGORIES NEEDED:
• Steel Suppliers
• Concrete Providers
• Fixture Suppliers (plumbing, electrical)
• Building Materials (lumber, drywall, etc.)
• Flooring and Finishes
• Windows and Doors
• Roofing Materials

💰 PARTNERSHIP ADVANTAGES:
✅ Materials = Equity ownership
✅ Guaranteed project commitment
✅ Profit sharing beyond markup
✅ Future project partnerships
✅ No payment delays or disputes

🎯 PROJECT FINANCIALS:
• Total Revenue: $37.4M
• Material Investment Opportunity: Significant
• ROI: 46%
• Timeline: 12-18 months

🚀 WHY PARTNER WITH US:
• WNY Makers Model - proven approach
• No traditional financing delays
• Partner-driven quality standards
• Expansion into multiple projects

📈 VIEW PROJECT DETAILS:
https://nevotm.github.io/2829-niagara-street/

Let's discuss how your materials can become your investment!

Best regards,  
Tiffany Durilla
Development Partner
📧 durillaprop@gmail.com
📱 716-421-1210
"@
    }
    
    "Land" = @{
        Subject = "🏘️ 2829 Niagara Street - Land Partnership & Expansion Opportunity"
        Body = @"
Dear $ContactName,

I'm reaching out about land partnership opportunities related to our 2829 Niagara Street development project.

🏘️ LAND PARTNERSHIP OPPORTUNITIES:
We're interested in partnering with property owners for:
• Adjacent properties to 2829 Niagara Street
• Expansion and development rights
• Land contribution = Equity participation
• Future development partnerships

🎯 CURRENT PROJECT SUCCESS:
• 4-Floor Mixed-Use Development
• $37.4M total revenue projected
• $11.7M gross profit (31% margin)
• Proven WNY Makers Model

🗺️ EXPANSION POTENTIAL:
Our successful model can scale to:
• Adjacent properties
• Similar mixed-use developments
• Multi-phase projects
• Community-wide transformations

💡 LAND PARTNERSHIP BENEFITS:
✅ Property value = Equity stake
✅ Development without upfront costs
✅ Shared profits from development
✅ Retained partial ownership
✅ Community improvement impact

🏢 PARTNER CATEGORIES:
• Adjacent Property Owners
• Land Developers
• Real Estate Holders
• Community Development Partners

📊 CURRENT PROJECT DETAILS:
View our successful model:
https://nevotm.github.io/2829-niagara-street/

🚀 FUTURE VISION:
Your land + Our model = Mutual success
• No traditional financing needed
• Partner-driven development
• Community-focused growth
• Scalable wealth building

Let's discuss how your property can become part of this success story.

Best regards,
Tiffany Durilla  
Development Partner
📧 durillaprop@gmail.com
📱 716-421-1210
"@
    }
    
    "General" = @{
        Subject = "🚀 2829 Niagara Street Development - Partnership Opportunity Available"
        Body = @"
Dear $ContactName,

I hope this email finds you well. I wanted to reach out about an exciting partnership opportunity in Tonawanda, NY.

🏢 PROJECT OVERVIEW:
• 2829 Niagara Street - 4-Floor Mixed-Use Development  
• Total Revenue: $37.4M
• Gross Profit: $11.7M (31% margin)
• 150 total units (residential, STR hospitality, retail)

🤝 WNY MAKERS MODEL (WNYMM):
Our revolutionary "Partners Not Paychecks" approach offers:
• Your expertise = Direct equity ownership
• Pro-rata share of substantial profits  
• No traditional bank financing costs
• 6-12 months accelerated timeline
• Access to future WNYMM projects

💰 PARTNERSHIP OPPORTUNITIES:
• 💵 Cash Partners - Direct investment
• 🔧 Service Partners - Contractors, architects
• ⚡ Technical Partners - MEP specialists  
• 🧱 Material Partners - Suppliers
• 🏘️ Land Partners - Property owners

🎯 WHY THIS WORKS:
✅ Partner motivation = 2x efficiency
✅ Quality premium from ownership
✅ No forced sales pressure
✅ Scalable investment model
✅ Community-focused development

📊 EXPLORE THE PROJECT:
• Full Details: https://nevotm.github.io/2829-niagara-street/
• Mobile View: https://nevotm.github.io/2829-niagara-street/mobile-design.html  
• Dashboard: https://nevotm.github.io/2829-niagara-street/dashboard-design.html

I'd love to discuss how this partnership model aligns with your goals and expertise.

Best regards,
Tiffany Durilla
Development Partner
📧 durillaprop@gmail.com  
📱 716-421-1210

P.S. This is about building wealth together, not just completing transactions.
"@
    }
}

# Get the appropriate template
$EmailTemplate = $Templates[$PartnerType]
if (-not $EmailTemplate) {
    $EmailTemplate = $Templates["General"]
}

# Replace contact name placeholder
$Subject = $EmailTemplate.Subject
$Body = $EmailTemplate.Body.Replace('$ContactName', $ContactName)

try {
    Write-Host "📧 Sending partnership email..." -ForegroundColor Green
    Write-Host "   To: $ToEmail" -ForegroundColor Cyan
    Write-Host "   Type: $PartnerType Partnership" -ForegroundColor Cyan
    
    Send-MailMessage -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $Credential -From $FromEmail -To $ToEmail -Subject $Subject -Body $Body -Encoding UTF8
    
    Write-Host "✅ Email sent successfully!" -ForegroundColor Green
    Write-Host "📊 Project links included in email:" -ForegroundColor Yellow
    Write-Host "   • Main site: https://nevotm.github.io/2829-niagara-street/" -ForegroundColor Cyan
    Write-Host "   • Mobile: https://nevotm.github.io/2829-niagara-street/mobile-design.html" -ForegroundColor Cyan
    Write-Host "   • Dashboard: https://nevotm.github.io/2829-niagara-street/dashboard-design.html" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Failed to send email: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "" 
    Write-Host "🔧 Troubleshooting Tips:" -ForegroundColor Yellow
    Write-Host "   1. Verify Gmail App Password is correct" -ForegroundColor Cyan
    Write-Host "   2. Ensure 2-Step Verification is enabled" -ForegroundColor Cyan
    Write-Host "   3. Check internet connection" -ForegroundColor Cyan
    Write-Host "   4. Try again in a few minutes" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎯 Usage Examples:" -ForegroundColor Magenta
Write-Host '   .\send-partnership-email.ps1 -ToEmail "investor@company.com" -PartnerType "Cash" -ContactName "John Smith"' -ForegroundColor Gray
Write-Host '   .\send-partnership-email.ps1 -ToEmail "contractor@builder.com" -PartnerType "Service" -ContactName "ABC Construction"' -ForegroundColor Gray
Write-Host '   .\send-partnership-email.ps1 -ToEmail "supplier@materials.com" -PartnerType "Material"' -ForegroundColor Gray