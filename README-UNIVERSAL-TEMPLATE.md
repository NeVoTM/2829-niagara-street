# PROJECT NAME - Universal README Template

---

## 1.0 🎯 **PROJECT OVERVIEW**
**Copy this template for every new project and customize the sections below**

**Project Name:** [PROJECT NAME]  
**Location:** [FULL ADDRESS]  
**Development Model:** Western New York Makers Model (WNYMM) - "Partners Not Paychecks"  
**Total Investment:** $[XX]M Development Cost, $[XX]M Revenue Target  
**Status:** [Development Ready/In Progress/Complete]  

### **Project Status**
- [ ] **Development Ready** - Partner recruitment phase
- [ ] **Website Live** - [GITHUB PAGES URL]
- [ ] **Mobile Optimized** - Professional mobile interface complete
- [ ] **Partner Outreach** - Seeking partners

---

## 2.0 💻 **COMPLETE PROJECT ENVIRONMENT**

### 2.1 **Repository Information**
- **GitHub Repository:** https://github.com/NeVoTM/[PROJECT-NAME]
- **Live URL:** https://nevotm.github.io/[PROJECT-NAME]/mobile-design.html
- **Local Path:** `C:\Users\17274\ME\[PROJECT-FOLDER]\`

### 2.2 **Development Tools & Languages**
- **HTML5:** Mobile-responsive design with tab navigation
- **CSS3:** Advanced mobile optimization with gradient themes
- **JavaScript:** Chart.js integration, slideshow functionality
- **JSON:** Centralized data management system (project-data.json)
- **PowerShell:** Deployment and validation scripts

### 2.3 **File Structure Overview**
```
[PROJECT-NAME]/
├── 📱 INTERFACES
│   ├── mobile-design.html     # PRIMARY: Mobile-first interface
│   ├── 2829-dashboard.html    # Desktop dashboard (if exists)
│   └── index.html             # GitHub Pages entry point
│
├── 📊 DATA SYSTEM
│   ├── project-data.json      # 🎯 MASTER DATA SOURCE - Edit This!
│   └── Update-ProjectData.ps1 # PowerShell validation script
│
├── 📖 DOCUMENTATION
│   ├── README.md              # This file - project overview
│   ├── PROJECT-DOCUMENTATION.md # Complete project specifications
│   ├── DATA-SYSTEM-README.md  # Environment documentation
│   ├── DEBUGGING-CHECKLIST.md # Universal debugging guide
│   └── HOW-TO-DEPLOY.md       # GitHub Pages deployment
│
└── 📂 ASSETS (if local)
    ├── images/                # Property photos, renderings
    └── videos/                # Virtual tours, presentations
```

---

## 3.0 📊 **PROJECT SPECIFICATIONS**

### 3.1 **Development Details**
- **Type:** [X]-Floor Mixed-Use Building
- **Size:** [XXX,XXX] sq ft development
- **Total Units:** [XXX] mixed-use units
- **Unit Mix:** [XX] residential + [XX] STR + [XX] retail

### 3.2 **Financial Projections**
- **Total Revenue:** $[XX]M (Marketing rounded from $[XX.X]M)
- **Gross Profit:** $[XX]M (Marketing rounded from $[XX.X]M)
- **Development Costs:** $[XX.X]M
- **Profit Margin:** [XX]%

### 3.3 **Key Features**
- [Feature 1]
- [Feature 2] 
- [Feature 3]
- [Feature 4]

---

## 4.0 🔧 **DATA MANAGEMENT SYSTEM**

### 4.1 **Master Data Source: project-data.json**
This file contains ALL project text, financial data, and configuration:

```bash
# To edit project data:
1. Open project-data.json in any text editor
2. Edit values (keep JSON structure intact)  
3. Run validation: .\Update-ProjectData.ps1 -ValidateOnly
4. Deploy: git add . && git commit -m "Update data" && git push
```

### 4.2 **Data Categories Included:**
- **Project Info:** Name, address, specifications
- **Financial Data:** Revenue, costs, profits (with marketing rounding)
- **Contact Info:** All contact details and roles
- **Text Content:** All headlines, descriptions, button text
- **Labels:** All UI text and form labels

---

## 5.0 🚀 **DEPLOYMENT & LIVE ACCESS**

### 5.1 **Live Websites**
- **Mobile Interface:** https://nevotm.github.io/[PROJECT-NAME]/mobile-design.html
- **Desktop Interface:** https://nevotm.github.io/[PROJECT-NAME]/[DASHBOARD-NAME].html (if exists)
- **Main Entry:** https://nevotm.github.io/[PROJECT-NAME]/

### 5.2 **Quick Deploy**
```powershell
git add .
git commit -m "Update project"
git push origin main
# Live in 2-5 minutes
```

---

## 6.0 📞 **CONTACT INFORMATION**

**Primary Contact:** [NAME]  
**Role:** [TITLE]  
**Email:** [EMAIL]  
**Phone:** [PHONE]  
**Project Location:** [FULL ADDRESS]

---

## 7.0 🎡 **UNIVERSAL DEBUGGING SYSTEM**

This project implements the **Universal Project Debugging & Setup System**:

### 7.1 **Applied Universal Categories:**
- ✅ **Data/Text Master Control System** - Centralized in project-data.json
- ✅ **Mobile-First Design System** - mobile-design.html as primary
- ✅ **Data Integrity & Marketing Rules** - Revenue rounded UP
- ✅ **Professional Alignment System** - Table-based layouts
- ✅ **Complete Documentation System** - All docs included

### 7.2 **For Debugging Issues:**
Reference `DEBUGGING-CHECKLIST.md` and apply solutions by category number.

### 7.2.1 **WARP AI INSTRUCTIONS - MANDATORY PROCEDURES:**

**🤖 When Working with This Project, Warp AI MUST:**

1. **ALWAYS Use Numbered References:**
   - Refer to sections by number: "SECTION 4.1" not "Data Management"
   - Reference specific issues: "ISSUE 4.3 (ALIGNMENT NIGHTMARES)"
   - Use TODO items by number: "Complete TODO 3.1.2 (Data & Configuration)"

2. **MAINTAIN Numbering System:**
   - When adding new sections, follow sequential numbering
   - Add subsections as X.1, X.2, X.3 format
   - Never break the hierarchical structure

3. **UPDATE All Related Files:**
   - Changes to universal files must be reflected in ALL projects
   - GitHub files are MASTER - local copies are secondary
   - Always commit numbered updates to maintain consistency

4. **FOLLOW File Location Standards:**
   - GitHub URLs for universal files: `https://github.com/NeVoTM/2829-niagara-street/blob/main/[FILENAME]`
   - Local paths format: `C:\Users\17274\ME\[PROJECT-FOLDER]\[filename]`
   - Document ALL file locations when creating new references

### 7.2.2 **USER FEEDBACK INTEGRATION TRIGGERS:**

**🗣️ When you (the user) say these phrases, they trigger specific Warp AI responses:**

- **TRIGGER 7.2.1: "That's not what I meant"** → Triggers compliance check
  - *Warp should check if it ignored numbered reference system*
  - *Warp should re-read the specific SECTION you referenced*

- **TRIGGER 7.2.2: "We already solved this"** → Points to numbered existing solution  
  - *Warp should search DEBUGGING-CHECKLIST.md for existing numbered solution*
  - *Warp should reference the specific SECTION/ISSUE number*

- **TRIGGER 7.2.3: "This is inconsistent"** → Flags cross-reference update failure
  - *Warp should check if it updated ALL related files*
  - *Warp should verify cross-references in universal files*

- **TRIGGER 7.2.4: "I explained this before"** → Indicates procedure violation
  - *Warp should reference established numbered procedures*
  - *Warp should avoid re-asking for documented information*

**💡 Use these trigger phrases to quickly redirect Warp back to established procedures.**

### 7.2.3 **UNIVERSAL NUMBER SEQUENCING INSTRUCTIONS:**

**🔢 MANDATORY: All future lists, instructions, sections MUST follow this numbering system:**

**MAIN SECTIONS:**
- Use X.0 format: 1.0, 2.0, 3.0, 4.0, etc.
- Never skip numbers or use letters (A, B, C)
- Always include section titles with emojis for visual hierarchy

**SUBSECTIONS:**
- Use X.1, X.2, X.3 format under main sections
- Example: 4.1, 4.2, 4.3 under SECTION 4.0
- Maximum 3 levels: X.0 → X.1 → X.1.1

**LISTS & ITEMS:**
- Use ITEM X.X.X format for detailed items
- Use TRIGGER X.X.X format for user actions
- Use ISSUE X.X format for problems/solutions

**EXAMPLES OF PROPER NUMBERING:**
```
## 4.0 🔶 CRITICAL MOBILE ISSUES

### 4.1 INFINITE SCROLLING PROBLEM
#### 4.1.1 Root Cause Analysis
#### 4.1.2 Exact Solution
#### 4.1.3 Implementation Steps

### 4.2 CHART SIZING DISASTERS
#### 4.2.1 Root Cause Analysis
#### 4.2.2 Exact Solution

TRIGGER 7.2.1: "That's not what I meant"
ISSUE 4.3: Alignment nightmares
ITEM 3.1.2: Data configuration files
```

**CROSS-REFERENCE FORMAT:**
- Always reference by number: "Apply SECTION 4.3" not "fix alignment"
- Include brief description: "SECTION 4.3 (ALIGNMENT NIGHTMARES)"
- Link to specific subsection when needed: "Follow SECTION 4.3.2 for exact CSS"

**🔄 CONSISTENCY RULE: Every new addition must follow this numbering system to maintain universal organization.**

### 7.3 **Universal System Files (GitHub Master Source):**
- **DEBUGGING-CHECKLIST.md**: https://github.com/NeVoTM/2829-niagara-street/blob/main/DEBUGGING-CHECKLIST.md
- **README-UNIVERSAL-TEMPLATE.md**: https://github.com/NeVoTM/2829-niagara-street/blob/main/README-UNIVERSAL-TEMPLATE.md
- **TODO-LIST.md**: https://github.com/NeVoTM/2829-niagara-street/blob/main/TODO-LIST.md
- **WARP-START-SESSION.md**: https://github.com/NeVoTM/2829-niagara-street/blob/main/WARP-START-SESSION.md
- **WarpSpeed.ps1**: https://github.com/NeVoTM/2829-niagara-street/blob/main/WarpSpeed.ps1

### 7.4 **Local Project Files:**
- **project-data.json** - `C:\Users\17274\ME\[PROJECT-FOLDER]\project-data.json`
- **Update-ProjectData.ps1** - `C:\Users\17274\ME\[PROJECT-FOLDER]\Update-ProjectData.ps1`
- **mobile-design.html** - `C:\Users\17274\ME\[PROJECT-FOLDER]\mobile-design.html`
- **README.md** - `C:\Users\17274\ME\[PROJECT-FOLDER]\README.md`

---

## 8.0 📚 **RELATED PROJECTS**

### 8.1 **Template Source:**
- **Nevo Tower Portal:** https://nevotm.github.io/nevo-tower-portal/mmm-master-dashboard.html
- **Base System:** Miami Makers Model (MMM) framework

### 8.2 **Other Projects Using This System:**
- [Add other projects as they're created]

---

## 9.0 📝 **PROJECT-SPECIFIC NOTES**

### 9.1 **[Custom Section 1: Unique Features]**
[Add project-specific information that doesn't fit universal categories]

### 9.2 **[Custom Section 2: Special Requirements]**
[Add any special deployment, configuration, or operational notes]

### 9.3 **[Custom Section 3: Known Issues]**
[Document any project-specific bugs or limitations]

---

## 10.0 📅 **PROJECT HISTORY**

**Created:** [DATE]  
**Last Updated:** [DATE]  
**Version:** [VERSION]  
**Status:** [STATUS]  

**Development Timeline:**
- [Date]: [Milestone]
- [Date]: [Milestone]
- [Date]: [Milestone]

---

*This README follows the Universal Project Documentation System. For debugging issues, always reference DEBUGGING-CHECKLIST.md first.*