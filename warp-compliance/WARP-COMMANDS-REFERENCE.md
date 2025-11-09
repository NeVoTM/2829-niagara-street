# 🚀 WARP COMMANDS REFERENCE
## Complete List of Available Commands

**Location:** `warp-compliance/WARP-COMMANDS-REFERENCE.md`  
**Purpose:** Quick reference for all SAIT system commands  
**Last Updated:** 2025-11-07

---

## 📋 SESSION COMMANDS

### `WarpSpeed`
**Purpose:** Start of session procedure (SOS)  
**What it does:**
1. Downloads all compliance files from GitHub (enforces RULE 1.1)
2. Reads all compliance files and displays them
3. Checks TODO list and shows breakdown
4. Offers cleanup routine
5. Displays critical rules reminder
6. Shows confirmation of files read

**Usage:**
```powershell
WarpSpeed              # Standard startup
WarpSpeed -ShowPath    # Show file paths
WarpSpeed -Update      # Update mode
WarpSpeed -QuickStart  # Skip prompts
```

**When to use:** At the start of EVERY work session
### `r`
**Purpose:** Rules reminder with self-check enforcement  
**What it does:**
1. Displays critical compliance rules (RULE 1.1, 2.1, 4.1, 4.2)
2. Shows MANDATORY SELF-CHECK PROCESS
3. Instructs Warp AI to verify compliance after answering
4. Forces Warp AI to redo answer if rules violated

**Usage:**
```powershell
r    # Display rules reminder before asking question
```

**When to use:** Before EVERY task/question you give to Warp AI  
**Purpose:** Enforce rule compliance through self-checking mechanism  
**Expected flow:**
1. User types: `r`
2. User asks question
3. Warp AI runs `r` before answering
4. Warp AI provides answer
5. Warp AI runs `r` after answering to verify compliance
6. If rules violated, Warp AI redoes the answer


---

### `eos`
**Purpose:** End of Session routine  
**What it does:**
1. Commits changes to GitHub
2. Generates session documentation
3. Updates completion tracker
4. Creates TODO list for next session

**Usage:**
```powershell
eos
```

**When to use:** At the end of EVERY work session (RULE 7.2)

---

### `clean`
**Purpose:** Run profile cleanup and health check  
**What it does:**
1. Checks for duplicate files
2. Detects outdated files
3. Verifies git status
4. Checks disk space

**Usage:**
```powershell
clean
```

**When to use:** When WarpSpeed prompts, or before committing changes

---

### `rules`
**Purpose:** Display WARP MASTER RULES quick reference  
**What it does:**
- Shows the 7 most critical rules
- Displays location of full rules file

**Usage:**
```powershell
rules
```

**When to use:** Anytime you need a rule reminder

---

## 🔧 ONE-LETTER DEBUG COMMANDS

### `c` - Check System
**Purpose:** Run comprehensive system check  
**Usage:** `c`

### `p [port]` - Check Port
**Purpose:** Check if port is in use (default: 3000)  
**Usage:** 
```powershell
p          # Check port 3000
p 8080     # Check port 8080
```

### `f [file]` - Find File
**Purpose:** Locate file in system  
**Usage:** `f myfile.txt`

### `e [error]` - Check Error
**Purpose:** Analyze error message  
**Usage:** `e "Error message here"`

### `g` - Git Status
**Purpose:** Quick git status check  
**Usage:** `g`

### `n` - NPM Check
**Purpose:** Check npm status and packages  
**Usage:** `n`

### `l [issue]` - Layout Debugger
**Purpose:** Fix CSS/HTML layout issues  
**Usage:** 
```powershell
l                    # Default: border overlap
l "alignment issue"  # Specific issue
```

### `q` - Reload Shortcuts
**Purpose:** Reload QuickStart.ps1 shortcuts  
**Usage:** `q`

---

## 🎨 VISUAL INTERFACE COMMANDS

### `v` - Open Visual Interface
**Purpose:** Launch SuperDebug.html visual interface  
**What it does:**
- Opens 10-tab debugging interface in browser
- Provides visual navigation for all SAIT tools

**Usage:** `v`

**Alias:** `visual`

---

## ⚙️ SWIFTLETTER CONTROL

### `swiftoff`
**Purpose:** Disable 1-letter command shortcuts in new windows  
**Usage:** `swiftoff`

### `swifton`
**Purpose:** Re-enable 1-letter command shortcuts  
**Usage:** `swifton`

---

## 📝 EXTENDED DEBUG COMMANDS

### `check`
**Purpose:** Full system check (same as `c`)  
**Usage:** `check`

### `port3000`
**Purpose:** Check if port 3000 is in use  
**Usage:** `port3000`

### `port8080`
**Purpose:** Check if port 8080 is in use  
**Usage:** `port8080`

### `gitstatus`
**Purpose:** Detailed git status (same as `g`)  
**Usage:** `gitstatus`

### `npmcheck`
**Purpose:** NPM system check (same as `n`)  
**Usage:** `npmcheck`

### `fixwarp`
**Purpose:** Fix Warp-specific layout issues  
**Usage:** `fixwarp`

---

## 🗂️ COMMAND FILES LOCATION

### Primary Files:
1. **Profile:** `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
   - Loads on every terminal start
   - Contains: WarpSpeed, eos, clean, rules, swiftoff, swifton
   - Sets environment variables for rule enforcement

2. **QuickStart.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\QuickStart.ps1`
   - Loaded automatically by profile
   - Contains: All 1-letter commands (c, p, f, e, g, n, l, v, q)
   - Contains: Extended commands (check, port3000, gitstatus, etc.)

### Supporting Scripts:
- **WarpSpeed.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed.ps1`
- **EOS-Routine.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\EOS-Routine.ps1`
- **CleanAndHealthy.ps1:** `C:\Users\17274\ME\2829-Niagara-Street\warp-toolbox\core\CleanAndHealthy.ps1`

---

## 🎯 QUICK WORKFLOW

### Start of Session:
```powershell
WarpSpeed              # Read GitHub files, check TODO, show rules
```

### During Work:
```powershell
v                      # Open visual interface
c                      # Quick system check
g                      # Check git status
rules                  # Remind yourself of rules
```

### End of Session:
```powershell
clean                  # Optional: cleanup check
eos                    # Commit, document, prepare for next session
```

---

## 🔍 HOW TO FIND COMMANDS

### View all loaded functions:
```powershell
Get-Command | Where-Object {$_.Source -eq "" -and $_.CommandType -eq "Function"} | Select-Object Name | Sort-Object Name
```

### Check if specific command exists:
```powershell
Get-Command v          # Shows command details
Get-Alias v            # Shows if it's an alias
```

### View command definition:
```powershell
(Get-Command v).Definition
```

---

## 📊 COMMAND CATEGORIES

| Category | Commands | Purpose |
|----------|----------|---------|
| **Session** | WarpSpeed, eos, clean, rules | Session management |
| **1-Letter** | c, p, f, e, g, n, l, v, q | Quick debugging |
| **Visual** | v, visual | Interface access |
| **Control** | swiftoff, swifton | Toggle shortcuts |
| **Extended** | check, port3000, gitstatus, npmcheck, fixwarp | Detailed checks |

---

## 🚨 ENVIRONMENT VARIABLES

These are set by the profile to signal rule enforcement to Warp AI:

- `$env:WARP_RULE_1_1` = "GitHub-first: Read/save GitHub BEFORE local"
- `$env:WARP_RULE_2_1` = "Use numbered references: SECTION X.X, RULE X.X"
- `$env:WARP_RULE_4_1` = "Fix ALL instances, not just one"
- `$env:WARP_RULE_4_2` = "Update cross-references in related files"
- `$env:WARP_RULES_LOADED` = "true"
- `$env:WARP_GITHUB_FIRST` = "true" (set after WarpSpeed runs)

---

## 📚 RELATED FILES

- **WARP-MASTER-RULES.md** - All 19 numbered rules
- **DEBUGGING-CHECKLIST.md** - 10 categories of solutions
- **WARP-QUESTIONS-GUIDE.md** - Question templates and defaults
- **TODO-LIST.md** - Current work tracking
- **SAIT-DIRECTORY-STRUCTURE.md** - File organization

---

**END OF COMMANDS REFERENCE**




---

# 📐 NUMBERED PROCEDURES SYSTEM

# 🎯 WARP AI SESSION PROCEDURES - NUMBERED HIERARCHY

## 1.0 SESSION STARTUP PROCEDURES

### 1.1 IMMEDIATE VERIFICATION
1.1.1 Verify WARP-AI-CONFIRMATION-CHECKLIST.md completion
1.1.2 Confirm access to current SESSION-COMPLETION-TRACKER.md  
1.1.3 Check TODO-LIST.md for updated priorities

### 1.2 CONTEXT ESTABLISHMENT  
1.2.1 Review previous session documentation
1.2.2 Understand current completion status (8/12 - 67%)
1.2.3 Identify next priority items from todo list

### 1.3 SYSTEM VALIDATION
1.3.1 Test key commands: q, v, c functions
1.3.2 Verify SuperDebug.html interface accessibility
1.3.3 Confirm GitHub repository sync status

## 2.0 WORK EXECUTION PROCEDURES

### 2.1 SYSTEMATIC IMPLEMENTATION
2.1.1 Apply fixes to ALL instances, never just one
2.1.2 Maintain consistent patterns across all tabs
2.1.3 Use numbered references for all communications

### 2.2 QUALITY ASSURANCE  
2.2.1 Test changes across different screen resolutions
2.2.2 Verify Read More functionality on all commands
2.2.3 Confirm visual consistency in command groups

### 2.3 DOCUMENTATION UPDATES
2.3.1 Update SESSION-COMPLETION-TRACKER.md progress  
2.3.2 Document any new debugging lessons learned
2.3.3 Maintain cross-references between related files

## 3.0 END OF SESSION PROCEDURES

### 3.1 GITHUB INTEGRATION
3.1.1 Execute git add . for all changes
3.1.2 Create descriptive commit with numbered references  
3.1.3 Push to GitHub following GitHub-first principle

### 3.2 DOCUMENTATION COMPLETION
3.2.1 Generate comprehensive session report
3.2.2 Update completion tracker with final status
3.2.3 Create Warp AI checklist for next session

### 3.3 SYSTEM VALIDATION  
3.3.1 Test core functionality: q, v, c commands
3.3.2 Verify visual interface loads correctly
3.3.3 Confirm documentation files are accessible

## 4.0 QUALITY METRICS & SUCCESS CRITERIA

### 4.1 COMPLETION INDICATORS
4.1.1 All requirements marked as complete or in-progress
4.1.2 Session documentation generated with metrics
4.1.3 GitHub repository updated with detailed commit

### 4.2 CONTINUITY ASSURANCE
4.2.1 Next session checklist created for Warp AI
4.2.2 Clear priorities identified for continuation  
4.2.3 System fully operational for immediate use

---

**Reference System:** Use format "Execute SECTION 2.1.1" for precise communication
**Created:** 11/07/2025 00:04:26 by EOS-Routine.ps1 following WARP-COMPLIANCE-SYSTEM.md


---

# ❓ QUESTIONS GUIDE

# 📝 WARP AI QUESTIONS GUIDE
## Standard Question Formats for All Development Work

**Purpose:** Ensure Warp asks the right questions in the right format before creating any interface, form, Excel sheet, or text element.

**Why This Exists:** Prevents back-and-forth clarifications, ensures user preferences are captured upfront, saves time.

**Location:** `warp-compliance/WARP-QUESTIONS-GUIDE.md`  
**Read at:** Every WarpSpeed SOS session start  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-QUESTIONS-GUIDE.md

---

## 🤖 **INSTRUCTIONS FOR WARP AI**

### **MANDATORY SOS PROCEDURE:**

**At every session start (after running WarpSpeed):**

1. ✅ **READ THIS FILE** - Load all question templates and user preferences
2. ✅ **CONFIRM READING** - Tell user: "Read WARP-QUESTIONS-GUIDE.md - Will follow question procedures"
3. ✅ **CHECK DEFAULTS** - Read Section 9.0 for saved user preferences
4. ✅ **APPLY DEFAULTS** - Use saved answers automatically, only ask if not saved
5. ✅ **OFFER TO SAVE** - After every answer: "Save this as default? (yes/no)"

### **QUESTION PROTOCOL:**

```
WHEN creating anything new:
1. Check Section 9.0 for existing defaults
2. If default exists → Use it automatically
3. If no default → Ask question from relevant section
4. After getting answer → "Save as default for future sessions? (yes/no)"
5. If yes → User updates Section 9.0, Warp commits to GitHub
```

### **NEVER ASSUME - ALWAYS ASK IF NO DEFAULT:**
- Color preferences
- Column widths  
- Validation rules
- Format preferences

---

## 1.0 📊 **EXCEL SHEET CREATION QUESTIONS**

### 1.1 **Before Creating Any Excel Workbook:**

**MANDATORY QUESTIONS - Ask ALL of these:**

```
📊 EXCEL WORKBOOK SPECIFICATIONS:

1. **Sheet Names & Count:**
   - What sheets do you need? (e.g., Summary, Assumptions, Hard Costs, Revenue, Cash Flow)
   - What order should they appear in?

2. **Editable vs Formula Cells:**
   - Which cells should users be able to edit? (Yellow highlighting standard)
   - Which cells should be formula-driven only? (Protected)

3. **Data Validation:**
   - Do you need dropdowns for any cells?
   - Do you need numeric validation (min/max values)?
   - Do you need date validation?

4. **Named Ranges:**
   - What values need to be referenced across multiple sheets?
   - What should they be named? (e.g., TotalHardCosts, GC_Rate)

5. **Formatting Preferences:**
   - Currency format: $ with commas? (e.g., $1,234,567)
   - Percentage format: whole or decimal? (e.g., 10% or 0.10)
   - Number format: decimals? (e.g., 1,234.56 or 1,235)

6. **Color Scheme:**
   - Header colors? (Default: Dark blue #366092)
   - Editable cell highlight? (Default: Yellow #FFFF99)
   - Totals/Important cells? (Default: Gold #FFD700)

7. **Column Widths:**
   - Auto-fit or fixed widths?
   - Any special width requirements?

8. **Sync Requirements:**
   - Does this need to sync with JSON/Python data?
   - Two-way sync or one-way (Excel → Python)?
```

### 1.2 **Excel Sheet-Specific Questions:**

**For Summary/Dashboard Sheets:**
```
- What key metrics should be displayed?
- What order (top to bottom)?
- Any visual separators needed?
- Any comparison/variance calculations?
```

**For Data Entry Sheets:**
```
- How many rows of data?
- Are rows fixed or expandable?
- Any calculation columns?
- Any conditional formatting rules?
```

**For Financial Sheets:**
```
- What's the calculation hierarchy? (subtotals → totals → grand total)
- What percentages need to be displayed?
- Any rate multipliers? ($/SF, $/unit, etc.)
- Any contingency or markup percentages?
```

---

## 2.0 📋 **TEXT BOX / INPUT FIELD QUESTIONS**

### 2.1 **Before Creating Any Text Input:**

```
📝 TEXT INPUT SPECIFICATIONS:

1. **Field Type:**
   - Single line or multi-line?
   - Plain text or formatted (markdown, HTML)?

2. **Validation:**
   - Required or optional?
   - Character limit?
   - Specific format (email, phone, URL)?

3. **Default Value:**
   - Pre-populated text?
   - Placeholder text?

4. **Styling:**
   - Width: Full, half, or custom?
   - Height: Auto or fixed?
   - Font size: Standard or custom?

5. **Labels:**
   - Label text?
   - Label position: above, left, inline?
   - Required indicator (*)?
```

---

## 3.0 🎨 **FORM CREATION QUESTIONS**

### 3.1 **Before Creating Any Form:**

```
📋 FORM SPECIFICATIONS:

1. **Form Purpose:**
   - What data are you collecting?
   - What happens when submitted? (save, email, calculate)

2. **Fields Required:**
   - List all field names
   - List all field types (text, number, date, dropdown, checkbox)
   - Mark which are required vs optional

3. **Layout:**
   - Single column or multi-column?
   - Grouped sections?
   - Section headers?

4. **Validation:**
   - Real-time or on-submit?
   - Custom error messages?
   - Field dependencies? (if X then show Y)

5. **Submit Behavior:**
   - Button text?
   - Success message?
   - Redirect after submit?
   - Clear form or keep values?
```

---

## 4.0 🏗️ **INTERFACE LAYOUT QUESTIONS**

### 4.1 **Before Creating Any Interface:**

```
🎨 INTERFACE SPECIFICATIONS:

1. **Device Targets:**
   - Mobile-first or desktop-first?
   - Specific device sizes to optimize for?
   - Responsive breakpoints?

2. **Navigation:**
   - Tab-based, sidebar, or top menu?
   - How many sections?
   - Fixed or scrolling navigation?

3. **Sections:**
   - Section names and order?
   - Which sections are collapsible?
   - Any anchor links between sections?

4. **Color Scheme:**
   - Primary color?
   - Secondary color?
   - Background colors?
   - Text colors (light/dark)?

5. **Typography:**
   - Font family preference?
   - Header sizes (H1, H2, H3)?
   - Body text size?

6. **Spacing:**
   - Tight, normal, or spacious?
   - Card-based or full-width?
   - Padding preferences?
```

---

## 5.0 📊 **CHART/VISUALIZATION QUESTIONS**

### 5.1 **Before Creating Any Chart:**

```
📈 CHART SPECIFICATIONS:

1. **Chart Type:**
   - Bar, line, pie, doughnut, scatter, etc.?
   - Horizontal or vertical?

2. **Data Source:**
   - What data to display?
   - Static or dynamic?
   - Labels and values?

3. **Sizing:**
   - Height constraint? (e.g., 280px for mobile)
   - Width: full container or fixed?
   - Responsive behavior?

4. **Styling:**
   - Color scheme?
   - Legend position?
   - Axis labels?
   - Grid lines?

5. **Interactivity:**
   - Tooltips?
   - Click behavior?
   - Hover effects?
```

---

## 6.0 📄 **DOCUMENT CREATION QUESTIONS**

### 6.1 **Before Creating Any Document:**

```
📄 DOCUMENT SPECIFICATIONS:

1. **Document Type:**
   - README, guide, checklist, spec, RFQ?
   - Format: Markdown, Word, PDF?

2. **Structure:**
   - Numbered sections?
   - Hierarchical depth? (1.0, 1.1, 1.1.1)
   - Table of contents?

3. **Content Sections:**
   - What sections are needed?
   - Any standard templates to follow?

4. **Tone:**
   - Technical, business, casual?
   - Audience: developers, clients, internal?

5. **References:**
   - Links to other documents?
   - Code examples?
   - External resources?
```

---

## 7.0 🎯 **PROJECT SETUP QUESTIONS**

### 7.1 **Before Creating Any New Project:**

```
🚀 PROJECT SETUP SPECIFICATIONS:

1. **Project Type:**
   - Real estate, software, marketing, other?
   - Web app, desktop app, mobile app, document?

2. **File Structure:**
   - Standard structure or custom?
   - Key directories needed?

3. **Data Management:**
   - Centralized data file (JSON)?
   - Database needed?
   - API integration?

4. **Deployment:**
   - GitHub Pages, server, local only?
   - Build process needed?
   - CI/CD pipeline?

5. **Documentation:**
   - README template?
   - Changelog?
   - Contributing guide?
```

---

## 8.0 🔧 **SCRIPT/AUTOMATION QUESTIONS**

### 8.1 **Before Creating Any Script:**

```
⚙️ SCRIPT SPECIFICATIONS:

1. **Purpose:**
   - What task does this automate?
   - How often will it run?

2. **Inputs:**
   - Command-line arguments?
   - Configuration file?
   - User prompts?

3. **Outputs:**
   - Files created/modified?
   - Console output?
   - Logs?

4. **Error Handling:**
   - Validation checks?
   - Error messages?
   - Rollback capability?

5. **Parameters:**
   - Required vs optional?
   - Default values?
   - Switch flags?
```

---

## 9.0 💡 **USER PREFERENCES (TO BE FILLED IN)**

### 9.1 **General Preferences:**

**Your preferences - add/edit as needed:**

```
📌 GENERAL PREFERENCES:

1. **Excel Formatting:**
   - Currency: $ with commas, no decimals unless cents matter
   - Percentages: Display as whole numbers (10%) not decimals (0.10)
   - Numbers: Commas for thousands
   - Editable cells: ALWAYS yellow background
   - Headers: Dark blue with white text

2. **Color Scheme:**
   - Professional blues and golds
   - Yellow for editable
   - Gold for totals
   - Red for critical/errors
   - Green for success/complete

3. **Documentation Style:**
   - Numbered sections (SECTION X.X)
   - Clear hierarchies
   - Concise explanations
   - Real-world examples

4. **Code Style:**
   - Clear variable names
   - Comments for complex logic
   - Error handling always included
   - DRY principle (Don't Repeat Yourself)

5. **Communication Style:**
   - Ask questions upfront
   - Summarize changes clearly
   - Use numbered references
   - Professional but efficient tone
```

### 9.2 **Project-Specific Preferences:**

**Add preferences for specific project types:**

```
📌 REAL ESTATE PROJECTS:
- Always include financial summary
- Always include unit breakdown
- Revenue rounded UP for marketing
- Costs kept precise
- Include contact information

📌 EXCEL BUDGETS:
- Summary sheet first
- Assumptions sheet second
- Formulas use named ranges
- Two-way sync capability
- Professional presentation ready

📌 WEB INTERFACES:
- Mobile-first always
- Centralized data (project-data.json)
- No infinite scrolling issues
- Touch-friendly (44px minimum)
- Professional shadows for readability
```

---

## 10.0 ✅ **QUESTION TEMPLATES - QUICK REFERENCE**

### 10.1 **Copy-Paste Templates:**

**Excel Sheet:**
```
Before I create this Excel sheet, I need to confirm:
1. Sheet names and order?
2. Which cells should be editable (yellow)?
3. Any dropdown validations needed?
4. Named ranges for cross-sheet references?
5. Currency/percentage format preferences?
```

**Text Input:**
```
For this text input:
1. Single or multi-line?
2. Required or optional?
3. Any character limits?
4. Default/placeholder text?
```

**Form:**
```
For this form:
1. What fields do you need? (name, type, required)
2. Single or multi-column layout?
3. Validation: real-time or on-submit?
4. What happens when submitted?
```

**Chart:**
```
For this chart:
1. Chart type (bar/line/pie)?
2. What data to display?
3. Height constraint (e.g., 280px)?
4. Color scheme preference?
```

---

## 11.0 🚀 **USING THIS GUIDE**

### 11.1 **When Warp Should Ask Questions:**

**ALWAYS ask questions BEFORE:**
- Creating new Excel workbooks
- Building forms or interfaces
- Writing scripts with user input
- Setting up new projects

**NEVER assume:**
- Color preferences
- Column widths
- Validation rules
- Default values

### 11.2 **How to Reference:**

```powershell
# Warp should check this guide at session start
# Use numbered references:
"Applying SECTION 1.1 (Excel questions) before creating workbook"
"Following SECTION 9.1 (user preferences) for color scheme"
```

---

## 12.0 📝 **CUSTOMIZATION NOTES**

**To User:** Fill in SECTION 9.0 with your specific preferences.

**To Warp AI:** Read SECTION 9.0 at every session start. These are user-specific preferences that override defaults.

---

**Last Updated:** [Date]  
**Version:** 1.0  
**Location:** `warp-compliance/WARP-QUESTIONS-GUIDE.md`  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-QUESTIONS-GUIDE.md

---

**END OF QUESTIONS GUIDE**

