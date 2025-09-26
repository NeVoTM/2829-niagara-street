# 📧 Gmail Email Setup Guide for 2829 Niagara Street Project

## 🚀 **Quick Setup Process**

### Step 1: Enable Gmail App Passwords
1. Go to **https://myaccount.google.com**
2. Click **Security** (left sidebar)
3. Under "How you sign in to Google", click **2-Step Verification**
4. Scroll down and click **App passwords**
5. Select app: **Mail**
6. Select device: **Windows Computer**
7. Click **Generate** and **SAVE THE PASSWORD** (you'll need this)

### Step 2: Use the PowerShell Script
```powershell
# Navigate to project folder
cd "C:\Users\17274\ME\2829-Niagara-Street"

# Send a cash partnership email
.\send-partnership-email.ps1 -ToEmail "investor@example.com" -PartnerType "Cash" -ContactName "John Smith"

# Send a service partnership email  
.\send-partnership-email.ps1 -ToEmail "contractor@builder.com" -PartnerType "Service" -ContactName "ABC Construction"

# Send a general partnership email
.\send-partnership-email.ps1 -ToEmail "partner@company.com" -PartnerType "General" -ContactName "Jane Doe"
```

## 🎯 **Available Partner Types**

| Partner Type | Use For | Email Content |
|--------------|---------|---------------|
| `Cash` | Investors, private capital | $37.4M project overview, ROI details |
| `Service` | Contractors, architects | Expertise = Equity model |
| `Technical` | MEP specialists | Technical partnership opportunities |
| `Material` | Suppliers | Materials = Ownership stakes |
| `Land` | Property owners | Land partnership & expansion |
| `General` | Any potential partner | Overview of all opportunities |

## 📋 **What Each Email Includes**

✅ **All 3 website links** (original, mobile, dashboard designs)  
✅ **Professional formatting** with emojis and clear sections  
✅ **Specific financial data** ($37.4M revenue, $11.7M profit, 46% ROI)  
✅ **Contact information** (durillaprop@gmail.com, 716-421-1210)  
✅ **WNY Makers Model** explanation  
✅ **Call-to-action** for partnership discussions  

## 🔐 **Security Notes**

- **App Password is NOT your regular Gmail password**
- **Keep the App Password secure** - treat it like a password
- **You can revoke App Passwords** anytime from Google settings
- **Script will prompt for password each time** (for security)

## 💡 **Pro Tips**

### Batch Email Sending
```powershell
# Create a CSV file with contacts
# Then loop through them:
Import-Csv "contacts.csv" | ForEach-Object {
    .\send-partnership-email.ps1 -ToEmail $_.Email -PartnerType $_.Type -ContactName $_.Name
    Start-Sleep 5  # Wait 5 seconds between emails
}
```

### CSV Format Example (`contacts.csv`):
```csv
Name,Email,Type
John Smith,investor@company.com,Cash
ABC Construction,info@abcbuilders.com,Service
XYZ Electrical,contact@xyzelec.com,Technical
Steel Supply Co,sales@steelsupply.com,Material
```

## 🌟 **Alternative Email Options**

### Option 1: Manual Gmail (Easiest)
1. **Copy email content** from PowerShell script output
2. **Paste into Gmail** compose window
3. **Manually send** to each contact

### Option 2: Gmail API (Advanced)
- More complex but allows advanced features
- Requires Google Cloud Platform setup
- Better for high-volume sending

### Option 3: Email Marketing Services
- **Mailchimp, Constant Contact, etc.**
- Professional templates and analytics
- Good for newsletter-style campaigns

## 🎯 **Usage Examples**

### Send to a potential cash investor:
```powershell
.\send-partnership-email.ps1 -ToEmail "wealthy.investor@richfund.com" -PartnerType "Cash" -ContactName "Robert Johnson"
```

### Send to a construction company:
```powershell  
.\send-partnership-email.ps1 -ToEmail "estimates@builderpro.com" -PartnerType "Service" -ContactName "BuilderPro Inc"
```

### Send to an electrical contractor:
```powershell
.\send-partnership-email.ps1 -ToEmail "jobs@sparkelectric.com" -PartnerType "Technical" -ContactName "Spark Electric"
```

## 📊 **Email Content Preview**

Each email includes:
- 🏢 **Project Overview** (4-floor, $37.4M revenue)
- 💰 **Financial Highlights** (31% margin, 46% ROI) 
- 🤝 **Partnership Benefits** (equity, profit sharing)
- 📈 **All 3 Website Links** for different viewing preferences
- 📞 **Direct Contact Info** (durillaprop@gmail.com, 716-421-1210)
- 🚀 **Professional call-to-action**

## 🔧 **Troubleshooting**

**"Authentication failed"**
- Verify 2-Step Verification is enabled
- Double-check App Password (not regular Gmail password)
- Try generating a new App Password

**"SMTP timeout"**
- Check internet connection
- Try again in a few minutes
- Verify firewall isn't blocking port 587

**"Too many recipients"** 
- Gmail has sending limits (500/day for personal accounts)
- Add delays between emails (`Start-Sleep 5`)
- Consider upgrading to Google Workspace

## 🎉 **Ready to Start?**

1. **Enable Gmail App Passwords** (Step 1 above)
2. **Run the PowerShell script** with your first contact
3. **Watch the magic happen!** ✨

Your professional partnership emails will showcase all 3 beautiful website designs and help you build your WNY Makers Model network! 🚀