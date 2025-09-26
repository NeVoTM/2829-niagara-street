# 🏢 2829 Niagara Street - Complete Project Environment Documentation

## 📝 **PROJECT OVERVIEW**

**Project Name:** 2829 Niagara Street Mixed-Use Development  
**Location:** 2829 Niagara Street, Tonawanda, NY 14207  
**Development Model:** Western New York Makers Model (WNYMM) - "Partners Not Paychecks"  
**Total Investment:** $25.7M Development Cost, $38M Revenue Target  
**Units:** 150 mixed-use units (65 residential, 72 STR hotel rooms, 13 retail)  

### **Project Status**
- ✅ **Development Ready** - Partner recruitment phase
- ✅ **Website Live** - https://nevotm.github.io/2829-niagara-street/
- ✅ **Mobile Optimized** - Professional mobile interface complete
- 🔄 **Partner Outreach** - Seeking Cash, Service, Technical, Material partners

---

## 💻 **COMPLETE DEVELOPMENT ENVIRONMENT**

### **Operating System & Shell**
- **Platform:** Windows 11
- **Shell:** PowerShell 7.5.3 (pwsh)
- **Working Directory:** `C:\Users\17274\ME\2829-Niagara-Street`
- **User Home:** `C:\Users\17274`

### **Version Control System**
- **Repository:** https://github.com/NeVoTM/2829-niagara-street
- **Branch:** main
- **Deployment:** GitHub Pages (automatic from main branch)
- **Live URL:** https://nevotm.github.io/2829-niagara-street/mobile-design.html

### **Development Tools & Languages**
- **HTML5:** Mobile-responsive design with 6-tab navigation
- **CSS3:** Advanced mobile optimization with gradient themes
- **JavaScript:** Chart.js integration, slideshow functionality
- **JSON:** Centralized data management system
- **PowerShell:** Deployment and validation scripts
- **Node.js:** Data synchronization (optional - PowerShell alternative provided)

### **Browser Compatibility**
- **Primary Target:** Mobile Safari (iPhone)
- **Secondary:** Chrome Mobile, Firefox Mobile
- **Desktop:** Chrome, Firefox, Edge (desktop experience available)

---

## 📁 **FILE STRUCTURE & PURPOSES**

```
2829-Niagara-Street/
├── 📱 MOBILE INTERFACE
│   ├── mobile-design.html     # PRIMARY: Mobile-optimized 6-tab interface
│   └── index.html             # GitHub Pages entry point
│
├── 🖥️ DESKTOP INTERFACE
│   ├── 2829-dashboard.html    # Desktop dashboard version
│   └── dashboard-design.html  # Alternative desktop layout
│
├── 📊 DATA MANAGEMENT SYSTEM
│   ├── project-data.json      # 🎯 MASTER DATA SOURCE - Edit This!
│   ├── Update-ProjectData.ps1 # PowerShell validation script
│   └── update-project-data.js # Node.js sync script (requires Node.js)
│
├── 📖 DOCUMENTATION
│   ├── DEBUGGING-CHECKLIST.md # 🎯 Comprehensive debugging guide
│   ├── DATA-SYSTEM-README.md  # This file - complete environment docs
│   ├── PROJECT-DOCUMENTATION.md # Complete project specs
│   ├── HOW-TO-DEPLOY.md       # GitHub Pages deployment guide
│   ├── GMAIL-SETUP-GUIDE.md   # Email integration guide
│   └── README.md              # Project overview
│
├── 📂 PROJECT DATA
│   ├── data/                  # Financial spreadsheets, contracts
│   ├── docs/                  # Legal documents, permits
│   ├── images/                # Property photos, renderings
│   └── videos/                # Virtual tours, presentations
│
└── ⚙️ DEPLOYMENT
    ├── _config.yml            # GitHub Pages configuration
    ├── .nojekyll              # Bypass Jekyll processing
    └── deploy-to-github.ps1   # Automated deployment script
```

---

## 📋 **CENTRALIZED DATA MANAGEMENT**

### **Master Data Source: project-data.json**

This is the **SINGLE SOURCE OF TRUTH** for all project values. Edit this file to change any data across the entire project.

**Key Data Categories:**

```json
{
  "project": {
    "name": "2829 Niagara Street",
    "address": "2829 Niagara Street, Tonawanda, NY",
    "type": "4-Floor Mixed-Use Building"
  },
  "financial": {
    "total_revenue": "$38M",      // Marketing rule: Rounded UP from $37.4M
    "gross_profit": "$12M",       // Marketing rule: Rounded UP from $11.7M
    "development_costs": "$25.7M" // Precise cost figure
  },
  "contact": {
    "name": "Tiffany Durilla",
    "email": "durillaprop@gmail.com",
    "phone": "716-421-1210"
  }
}
```

### **Data Validation Scripts**

**PowerShell Version (Recommended):**
```powershell
# Navigate to project
cd "C:\Users\17274\ME\2829-Niagara-Street"

# Validate data consistency
.\Update-ProjectData.ps1 -ValidateOnly
```

**Node.js Version (Optional):**

**Step 1: Check if Node.js is installed**
```powershell
node --version
# If not installed, download from: https://nodejs.org/
```

**Step 2: Navigate to project folder**
```powershell
cd "C:\Users\17274\ME\2829-Niagara-Street"
```

**Step 3: Run the script (CORRECT SYNTAX - no spaces)**
```powershell
node update-project-data.js
```

**IMPORTANT:** The filename has NO SPACES. Do not type `node update - project - data.js`

**What the Scripts Check:**
- ✅ Revenue components add up to total revenue
- ✅ Cost components add up to total development cost  
- ✅ Mathematical consistency across all sections
- ✅ Marketing rounding rules applied correctly

---

## 🔐 **CREDENTIALS & AUTHENTICATION**

### **GitHub Repository Access**
- **Username:** NeVoTM
- **Repository:** 2829-niagara-street
- **Access Method:** Personal Access Token (required for deployments)
- **Token Setup:** https://github.com/settings/tokens
- **Required Scopes:** `repo`, `workflow`

### **GitHub Pages Configuration**
- **Source:** Deploy from main branch
- **Folder:** / (root)
- **Custom Domain:** None (using github.io subdomain)
- **SSL:** Enforced automatically by GitHub

### **Google Drive Integration**
- **Video Storage:** Google Drive (public sharing enabled)
- **Image Assets:** Hosted directly on GitHub for faster loading
- **Access:** All assets are publicly accessible

---

## 🚀 **DEPLOYMENT & PUBLISHING**

### **GitHub Pages Deployment Process**

**Method 1: Automated Script (Recommended)**
```powershell
# Navigate to project folder
cd "C:\Users\17274\ME\2829-Niagara-Street"

# Deploy to GitHub Pages
.\deploy-to-github.ps1 -GitHubUsername "your-username" -PersonalAccessToken "your-token"
```

**Method 2: Manual Git Commands**
```powershell
git add .
git commit -m "Update project files"
git push origin main
```

### **Deployment Timeline**
- **Initial Deploy:** 5-10 minutes to go live
- **Updates:** 2-5 minutes to propagate
- **SSL Certificate:** May take additional time on first deployment

### **Live URLs**
- **Mobile Interface:** https://nevotm.github.io/2829-niagara-street/mobile-design.html
- **Desktop Interface:** https://nevotm.github.io/2829-niagara-street/2829-dashboard.html
- **Default Entry:** https://nevotm.github.io/2829-niagara-street/ (redirects to mobile)

---

## 🌐 **EXTERNAL INTEGRATIONS & PLATFORMS**

### **Chart.js (Data Visualization)**
- **CDN:** https://cdn.jsdelivr.net/npm/chart.js
- **Version:** Latest stable
- **Usage:** Revenue breakdown, cost analysis, market comparables
- **Mobile Optimized:** Custom configurations for mobile viewports

### **Email Integration**
- **Contact Email:** durillaprop@gmail.com
- **Method:** mailto: links (opens default email client)
- **Mobile Support:** Native mobile email app integration

### **Phone Integration**
- **Contact Phone:** 716-421-1210
- **Method:** tel: links (mobile click-to-call)
- **Desktop:** Shows phone number for manual dialing

---

## 🛠️ **TROUBLESHOOTING & MAINTENANCE**

### **Common Issues & Solutions**

**Issue: "Website not loading"**
- ✅ Check GitHub Pages is enabled in repository settings
- ✅ Verify main branch has latest commits
- ✅ Wait 5-10 minutes for deployment to complete
- ✅ Try hard refresh (Ctrl+F5 or Cmd+Shift+R)

**Issue: "Data inconsistencies"**
- ✅ Run `./Update-ProjectData.ps1 -ValidateOnly`
- ✅ Check project-data.json for mathematical errors
- ✅ Verify marketing rounding rules are applied
- ✅ Manually update HTML if needed

**Issue: "Mobile display problems"**
- ✅ Reference DEBUGGING-CHECKLIST.md for specific solutions
- ✅ Check mobile viewport meta tag is present
- ✅ Verify CSS media queries for mobile (max-width: 480px)
- ✅ Test on actual iPhone device, not just browser resize

**Issue: "Charts not displaying"**
- ✅ Verify Chart.js CDN is loading
- ✅ Check browser console for JavaScript errors
- ✅ Ensure chart container has proper height limits (280px max)
- ✅ Verify data arrays match expected format

### **Data Validation Failure Codes**

**Revenue Mismatch:**
```
Revenue mismatch: Components sum to 37.4M but total shows 38M
```
**Solution:** This is expected due to marketing rounding rules. Update components to match rounded total.

**Cost Mismatch:**
```
Cost mismatch: Components sum to 25.8M but total shows 25.7M
```
**Solution:** Verify hard construction and soft cost figures in project-data.json.

---

## 📄 **PROJECT WORKFLOW FOR WARP AI**

### **Standard Debugging Process**
1. **Identify Issue Category** - Reference DEBUGGING-CHECKLIST.md sections 1-9
2. **Apply Specific Solution** - Use exact code examples provided
3. **Validate Data** - Run Update-ProjectData.ps1 to check consistency
4. **Test on Mobile** - Verify fixes work on iPhone viewport
5. **Deploy Changes** - Use deploy-to-github.ps1 for live updates

### **New Feature Development**
1. **Update project-data.json** - Add any new data requirements
2. **Modify HTML/CSS** - Implement feature in mobile-design.html
3. **Test Mobile-First** - Ensure mobile compatibility from start
4. **Update Documentation** - Add any new debugging points
5. **Deploy and Verify** - Test live implementation

### **Emergency Fixes**
For critical issues affecting live site:

```powershell
# Quick fix deployment
git add .
git commit -m "EMERGENCY FIX: [description]"
git push origin main

# Verify deployment
Start-Process "https://nevotm.github.io/2829-niagara-street/mobile-design.html"
```

---

## 📚 **COMPLETE RESOURCE DIRECTORY**

### **Primary Documentation (This Repository)**
- **DEBUGGING-CHECKLIST.md** - 9 critical debugging solutions with examples
- **PROJECT-DOCUMENTATION.md** - Complete project specifications and financials
- **HOW-TO-DEPLOY.md** - Step-by-step GitHub Pages deployment
- **DATA-SYSTEM-README.md** - This file - complete environment guide

### **External Reference Files (ME Folder)**
- **AI-Teaching-Reference.md** - `C:\Users\17274\ME\AI-Teaching\` - Table alignment solutions from Nevo Tower project
- **SMLF-Senior-Memory-List.md** - `C:\Users\17274\ME\Scripts\` - PowerShell command reference
- **New-Session-Instructions.md** - `C:\Users\17274\ME\Scripts\` - Warp AI session setup

### **Related Projects**
- **Nevo Tower Portal** - Base template: https://nevotm.github.io/nevo-tower-portal/
- **Invoice Templates** - Table alignment examples: `C:\Users\17274\ME\Templates_Invoices\`

### **Quick Commands Reference**

**Data Validation:**
```powershell
.\Update-ProjectData.ps1 -ValidateOnly
```

**Deploy to GitHub:**
```powershell
.\deploy-to-github.ps1 -GitHubUsername "username" -PersonalAccessToken "token"
```

**Apply Specific Debug Fix:**
```
Please apply solution from DEBUGGING-CHECKLIST.md Section X to fix [specific issue].
```

---

## 📅 **DOCUMENT HISTORY**

**Created:** September 26, 2025  
**Last Updated:** September 26, 2025  
**Version:** 2.0-comprehensive  
**Author:** Development team with Warp AI assistance  
**Purpose:** Complete project environment documentation for seamless AI assistance  

**Changes in v2.0:**
- ✅ Complete environment documentation
- ✅ Comprehensive credential and platform information
- ✅ Detailed troubleshooting guides
- ✅ Integration with DEBUGGING-CHECKLIST.md
- ✅ Warp AI workflow optimization

---

*This document contains all information Warp AI needs to understand the complete project environment, resolve issues, and deploy changes effectively.*

## Data Structure

### Financial Data
```json
"financial": {
  "total_revenue": "$38M",
  "gross_profit": "$12M",
  "development_costs": "$25.7M",
  "profit_margin": "31%",
  "roi": "46%"
}
```

### Unit Distribution
```json
"units": {
  "total": 150,
  "residential": {"count": 65, "revenue": "$15.8M"},
  "str_hotel_rooms": {"count": 72, "revenue": "$15.1M"},
  "retail": {"count": 13, "revenue": "$6.5M"}
}
```

### Contact Information
```json
"contact": {
  "name": "Tiffany Durilla",
  "title": "Development Partner",
  "email": "durillaprop@gmail.com",
  "phone": "716-421-1210"
}
```

## Marketing Rules Applied
- **Revenue/Sales**: Always rounded UP for marketing appeal
- **Costs**: Kept precise for accuracy
- **Profits**: Rounded UP to nearest million

## Benefits
1. **Consistency**: Single source of truth for all data
2. **Validation**: Automatic checks prevent math errors
3. **Efficiency**: Update once, apply everywhere
4. **Maintenance**: Easy to track and modify project data
5. **Quality Control**: Built-in integrity checking

## Integration with QC Process
This data system is integrated into the Quality Control Checklist:
- Always check data integrity before deployment
- Run update script after any data changes
- Validate calculations match business rules
- Ensure marketing rounding is applied consistently

## Error Handling
The script will report:
- Data validation failures
- File access errors  
- Mathematical inconsistencies
- Missing required fields

## Future Enhancements
- Additional file format support (Excel, CSV)
- Automated deployment integration
- Historical data tracking
- Multi-project support