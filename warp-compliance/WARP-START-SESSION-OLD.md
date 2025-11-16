# 🚀 WARP AI START SESSION - CONSOLIDATED GUIDE

**Purpose:** Single source of truth for session startup, rules enforcement, commands, and debugging  
**Location:** `warp-compliance/WARP-START-SESSION.md`  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-START-SESSION.md  
**Last Updated:** 2025-11-16  

---

## 1.0 🔴 CRITICAL RULES - ALL 13 RULES

**WARP AI: These rules are MANDATORY for every interaction. They are loaded as environment variables in PowerShell and enforced by `rulescheck` command.**

### RULE 1.1: GitHub-First Principle
**Always read from and save to GitHub BEFORE local files.**

**When to apply:** Working with compliance files (WARP-MASTER-RULES.md, TODO-LIST.md, USER-PREFERENCES.md, etc.)

**Procedure:**
1. Read latest from GitHub: `https://github.com/NeVoTM/2829-niagara-street/blob/main/[FILENAME]`
2. Make changes
3. Save to GitHub first (commit + push)
4. Then update local copy if needed

---

### RULE 1.1a: Auto-Commit After Every Change
**After making ANY changes to files, IMMEDIATELY execute git commit and push without being reminded.**

**Mandatory sequence:**
```powershell
git add [files-modified]
git commit -m "[descriptive message]"
git push
```

**Do NOT:**
- Wait for user to remind you
- Ask "should I commit this?"
- Skip committing changes

---

### RULE 1.4: Authorization Code Required
**Never edit WARP-MASTER-RULES.md without user providing authorization code 2319**

**When to apply:** Any request to modify this file

**Procedure:**
1. User requests edit to rules → Ask for code 2319
2. If code provided → Proceed with changes
3. If code not provided → Refuse edit request

---

### RULE 1.5: Verify Before Responding
**Before saying "done," test changes from user's perspective to confirm they work as intended.**

**When to apply:** Changes that affect user-facing behavior (scripts, profiles, system files)

**Procedure:**
1. Make changes
2. Think through execution flow from user's perspective
3. Verify behavior matches expectation
4. Only then respond "done"

**Never:** Say "done" based only on "the file looks correct"

---

### RULE 1.6: Rulescheck Command
**When user types `rulescheck`, verify answer against all applicable rules. Only display rules that were violated (❌). If all rules obeyed, respond "All rules obeyed"**

**Response format if compliant:**
```
🤖 Rules Verification: All rules obeyed

[Your answer here]
```

**Response format if violations:**
```
🤖 Rules Verification:

❌ RULE 4.1 (Fix ALL): Only fixed 1 instance, need to fix 6 more
❌ RULE 1.1a (Auto-commit): Forgot to commit changes

[Fixing violations now...]
```

---

### RULE 2.2: Sequential Numbering
**When adding new items, use sequential numbering (X.1, X.2, X.3...) not letters or mixed formats.**

**When to apply:** Adding items to any numbered list (TODOs, procedures, sections)

---

### RULE 4.1: Fix ALL Instances
**When fixing a problem, fix ALL occurrences, not just one.**

**When to apply:** User reports ANY problem that might exist in multiple places

**Procedure:**
1. Identify the issue
2. Search for ALL occurrences
3. Apply fix to EVERY instance
4. Verify no instances were missed

---

### RULE 4.2: Update Cross-References
**When updating any file, update ALL cross-references in related files.**

**When to apply:** Modifying any compliance file

**Must update:**
- If changing TODO-LIST.md → Update any files that reference it
- If adding to DEBUGGING-CHECKLIST.md → Update quick reference
- If modifying file locations → Update SAIT-DIRECTORY-STRUCTURE.md

---

### RULE 4.3: Consistent Patterns
**Maintain consistent patterns across all similar elements.**

**When to apply:** Creating or modifying repetitive elements (tabs, forms, sections, buttons)

**Examples:**
- All tabs have same height
- All buttons have same styling
- All sections follow same layout

---

### RULE 4.5: Check PowerShell Profile for Duplicates
**When editing startup messages, commands, or functions, ALWAYS check both the script files AND the PowerShell profile ($PROFILE) for duplicates.**

**When to apply:** Modifying startup messages, function definitions, aliases, or session startup code

**Procedure:**
1. Search in project scripts (warp-toolbox/, warp-profile-alias.ps1, etc.)
2. Search in PowerShell profile: `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
3. If duplicates found → Remove from profile, keep in sourced script

---

### RULE 4.6: Validate Scripts Before Sourcing
**Before using/sourcing/referencing an existing script, READ it fully to check for errors or incompatibilities.**

**When to apply:** 
- Adding dot-sourcing (`. script.ps1`) to profile
- Calling external scripts from other scripts

**Procedure:**
1. Read the entire script file first
2. Check for syntax that won't work (e.g., `Export-ModuleMember` only works in .psm1 modules)
3. Fix errors BEFORE adding references

---

### RULE 4.7: Read The Whole System First
**Before making changes, understand the complete system including dependencies, loaders, and execution flow.**

**When to apply:** Modifying files that are part of a larger system (scripts loaded by other scripts, files executed from GitHub vs. local)

**"Whole system" means:**
1. The file being edited
2. Files that source/load it (e.g., $PROFILE loads scripts)
3. Files it references (e.g., script calls other scripts)
4. Where it's executed from (GitHub vs. local)

---

### RULE 5.1: Auto-Confirm Files After WarpSpeed
**After WarpSpeed completes, if I actually downloaded and read the compliance files, automatically respond with "Confirmed files read:" followed by short list of files successfully loaded.**

**When to apply:** After WarpSpeed downloads files from GitHub

**Response format:**
```
✅ Confirmed files read:
   • WARP-START-SESSION.md
   • TODO-LIST.md
```

---

## 2.0 📋 ESSENTIAL COMMANDS

### `WarpSpeed`
**Purpose:** Start of session procedure - downloads rules and TODO list from GitHub

**Where to run:** Any terminal in PowerShell 7+

**What it does:**
1. Downloads WARP-START-SESSION.md from GitHub
2. Downloads TODO-LIST.md from GitHub
3. Displays Section 1.0 (13 critical rules) as reminder
4. Shows TODO breakdown by priority (1.0 CRITICAL, 2.0 IMPORTANT, etc.)
5. Opens both files in editor for reference

**Usage:**
```powershell
WarpSpeed
```

**Output:**
- "GitHub-first confirmed" message
- 13 rules displayed
- TODO count by priority
- Files opened in Notepad or VS Code

---

### `rulescheck`
**Purpose:** Display and validate all 13 critical rules before Warp AI responds

**Where to run:** Any terminal in PowerShell 7+

**What it does:**
1. Prints all 13 rules from environment variables
2. Validates GitHub-first policy
3. Confirms rule count matches (should be 13)
4. Signals to Warp AI to verify compliance before responding

**Usage:**
```powershell
rulescheck
```

**Output:**
- List of all 13 rules
- "GitHub-first confirmed" status
- Rule count verification

**For Warp AI:** When user types `rulescheck`, follow RULE 1.6 format

---

### `eos`
**Purpose:** End of session routine

**Where to run:** Project root `C:\Users\17274\ME\2829-Niagara-Street`

**What it does:**
1. Commits all changes to GitHub
2. Generates session documentation
3. Updates completion tracker
4. Creates TODO list for next session

**Usage:**
```powershell
eos
```

**Note:** Run this at the end of EVERY work session

---

### `clean`
**Purpose:** Run profile cleanup and health check

**Where to run:** Any terminal in PowerShell 7+

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

## 3.0 🔧 QUICK DEBUGGING PLAYBOOK

### 3.1 Git & GitHub First Verification
**Problem:** Changes not syncing to GitHub  
**Fix:** Verify remote and push
```powershell
git remote -v  # Should show github.com/NeVoTM/2829-niagara-street
git status
git add .
git commit -m "Description"
git push
```

---

### 3.2 PowerShell Execution Policy
**Problem:** Scripts won't run, "execution policy" error  
**Fix:** Set execution policy for current user
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### 3.3 Module Not Found or Import Errors
**Problem:** Module commands not available  
**Fix:** Reimport module or install if missing
```powershell
Import-Module ModuleName -Force
# or
Install-Module ModuleName -Scope CurrentUser
```

---

### 3.4 Path Issues - Script Not Found
**Problem:** "command not found" or script path errors  
**Fix:** Use absolute paths or navigate to directory first
```powershell
cd C:\Users\17274\ME\2829-Niagara-Street
.\WarpSpeed.ps1
```

---

### 3.5 File Encoding Issues
**Problem:** Special characters appear wrong or script fails to parse  
**Fix:** Save files as UTF-8 with BOM in VS Code
```
File > Save with Encoding > UTF-8 with BOM
```

---

### 3.6 Git Credential Issues
**Problem:** Git asks for password repeatedly  
**Fix:** Configure credential manager
```powershell
git config --global credential.helper manager-core
```

---

### 3.7 Environment Variables Not Loading
**Problem:** `$env:WARP_RULE_*` variables are empty  
**Fix:** Reload profile
```powershell
. $PROFILE
# or restart terminal
```

---

### 3.8 Network/TLS Issues When Downloading from GitHub
**Problem:** "SSL/TLS secure channel" errors  
**Fix:** Force TLS 1.2
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

---

## 4.0 📂 PROJECT CONTEXT & FILE LOCATIONS

### Local Paths:
- **Repository Root:** `C:\Users\17274\ME\2829-Niagara-Street`
- **Compliance Folder:** `C:\Users\17274\ME\2829-Niagara-Street\warp-compliance`
- **WarpSpeed Script:** `C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed.ps1`
- **PowerShell Profile:** `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

### GitHub Repository:
- **Main Repo:** https://github.com/NeVoTM/2829-niagara-street
- **Compliance Files:** https://github.com/NeVoTM/2829-niagara-street/tree/main/warp-compliance
- **Raw URL Base:** https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main

### Key Files:
1. **WARP-START-SESSION.md** - This file (single source of truth)
2. **TODO-LIST.md** - Current work items and priorities
3. **DEBUGGING-CHECKLIST.md** - Complete debugging reference (kept for deep reference)
4. **project-data.json** - Master data source for project content

### Environment:
- **OS:** Windows 11
- **Shell:** PowerShell 7.5.4 (pwsh)
- **Git:** Required for GitHub-first workflow
- **Editor:** VS Code or Notepad

### Project Details:
- **Project Name:** 2829 Niagara Street Mixed-Use Development
- **Location:** Tonawanda, NY
- **Type:** Real estate development project
- **Stack:** HTML, CSS, JavaScript, Chart.js, PowerShell

---

## 5.0 🎯 WORKFLOW SUMMARY

### Start of Session:
1. Open PowerShell 7
2. Run `WarpSpeed`
3. Review 13 rules displayed
4. Check TODO priorities
5. Begin work

### During Work:
- Use `rulescheck` when asking Warp AI for help
- Follow RULE 1.1a (auto-commit after changes)
- Reference SECTION numbers (SECTION 1.0, RULE 4.1, etc.)

### End of Session:
1. Run `eos` to commit and document
2. Verify changes pushed to GitHub

---

## 6.0 🔧 COMPLETE DEBUGGING REFERENCE

**All debugging solutions from DEBUGGING-CHECKLIST.md organized by priority**

### CRITICAL MOBILE ISSUES (Section 4.0 - Apply First)

#### 4.1 🔴 Infinite Scrolling Problem
**Symptoms:** Page won't stop scrolling, sections repeat endlessly
**Fix:**
```css
.section {
    max-height: 100vh;  /* CRITICAL */
    overflow-y: auto;   /* CRITICAL */
    padding-bottom: 100px;
}
```

#### 4.2 🔴 Chart Sizing Disasters
**Symptoms:** Charts huge, break layout, cause scrolling
**Fix:**
```css
canvas {
    max-height: 280px !important;  /* CRITICAL */
}
```
```javascript
options: { maintainAspectRatio: false }  /* CRITICAL */
```

#### 4.3 🔴 Alignment Nightmares
**Symptoms:** Text misaligned, addresses unprofessional, checkmarks inconsistent
**Fix:** Use separate tables for different alignment needs
```html
<table style="width: 100%; border-collapse: collapse;">
    <tr>
        <td style="width: 30px;">✓</td>
        <td><strong>Location:</strong><br>&nbsp;&nbsp;2829 Niagara Street</td>
    </tr>
</table>
```

#### 4.4 🔴 Text Visibility Disasters
**Symptoms:** Can't read text on mobile, washed out
**Fix:**
```css
@media (max-width: 480px) {
    .card h2, .card h3 {
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);  /* CRITICAL */
    }
}
```

#### 4.5 🔴 Navigation Positioning Failures
**Symptoms:** Clicking tab jumps to middle, not top
**Fix:**
```javascript
targetSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
```

#### 4.6 🔴 Data Integrity Problems
**Symptoms:** Number inconsistencies (35M vs 38M), math errors
**Fix:** Use project-data.json as single source
**Marketing Rules:**
- Revenue: ALWAYS round UP ($37.4M → $38M)
- Costs: Keep precise or round DOWN

#### 4.7 🔴 Mobile Usability Failures
**Symptoms:** Icons too small, hard to click on phone
**Fix:**
```css
.contact-icon {
    font-size: 1.8rem;  /* 44px minimum touch target */
}
```

#### 4.8 🔴 Video Container Overflow
**Symptoms:** Video box cuts off, shows on other tabs
**Fix:**
```css
.video-placeholder {
    max-height: 200px;   /* CRITICAL */
    overflow: hidden;    /* CRITICAL */
}
```

#### 4.9 🔴 Version Management Chaos
**Symptoms:** Version info appears in wrong places
**Fix:** Version info ONLY on Contact tab

---

### UNIVERSAL SYSTEMS (Sections 1.0-3.0 - Foundation)

#### 1.0 🟡 Data/Text Master Control System
**Problem:** Scattered text, inconsistent data
**Solution:** Create project-data.json as single source of truth
**Steps:**
1. Create project-data.json with all text/data
2. Create Update-ProjectData.ps1 validation script
3. Edit JSON, validate, deploy

#### 2.0 🟡 Mobile-First Design System
**Problem:** Mobile issues discovered late
**Solution:** Separate mobile and desktop interfaces
- mobile-design.html (primary)
- desktop-design.html (enhancement)
- index.html (device detection)

#### 3.0 🟡 Node.js Script Usage
**Problem:** Command syntax errors, script not found
**Fix:**
```powershell
cd C:\Users\17274\ME\2829-Niagara-Street
node update-project-data.js  # Correct syntax
```

---

### QUALITY ASSURANCE (Section 6.0 - Testing)

#### 6.1 📊 Charts & Visualizations Checklist
- [ ] All charts responsive with max-height constraints
- [ ] Charts not cut off (max 280px height)
- [ ] Chart legends readable
- [ ] No infinite scrolling caused by charts

#### 6.2 🔘 Buttons & Navigation Checklist
- [ ] All navigation buttons visible
- [ ] Contact buttons with LARGE icons
- [ ] Tab navigation scrolls to TOP of sections
- [ ] Navigation arrows have good contrast

#### 6.3 📱 iPhone Optimization Checklist
- [ ] All text readable without zooming
- [ ] No horizontal/infinite scrolling
- [ ] Touch targets appropriate size (44px min)
- [ ] Section padding accounts for nav (120px)
- [ ] Text has proper contrast with shadows

#### 6.4 🖼️ Images & Slideshow Checklist
- [ ] Slideshow navigation working
- [ ] Captions not covering images
- [ ] Single-line captions on iPhone

#### 6.5 🔗 Links & Integration Checklist
- [ ] Email links opening mail client
- [ ] Phone links working on mobile
- [ ] No broken or missing links

#### 6.6 🎨 Professional Appearance Checklist
- [ ] Proper spacing and alignment
- [ ] Data aligned to data, not page edges
- [ ] Address formatting proper
- [ ] Green checkmarks consistently aligned

#### 6.7 🔧 Technical Testing Checklist
- [ ] No JavaScript errors in console
- [ ] Responsive design works on all sizes
- [ ] Performance acceptable
- [ ] All functionality tested end-to-end

---

### CRITICAL FAILURE POINTS (Section 7.0 - Avoid These)

#### 7.1 Major Issues to Avoid
- Charts cut off or not visible (ALWAYS set max-height)
- Missing financial data or wrong numbers
- Broken navigation or buttons
- Infinite scrolling or layout breaks
- Navigation not scrolling to section tops

#### 7.2 Common Oversights
- Forgetting to test on iPhone specifically
- Not checking all tabs/sections
- Text overflow in stat boxes
- Small contact icons on mobile
- Revenue not rounded for marketing appeal

#### 7.3 Professional Standards
- Every element must serve a purpose
- No placeholder or dummy content
- Consistent styling throughout
- Fast loading and responsive
- Error-free operation

---

### QUICK COMMAND FORMATS FOR WARP AI

**For Specific Issues:**
```
Apply SECTION 4.1 (infinite scroll fix)
Apply SECTION 4.2 and 4.3 (charts and alignment)
Check SECTION 6.3 (iPhone optimization)
```

**For Complete Reviews:**
```
Apply full QC checklist - comprehensive testing required
Apply SECTION 6.0 (all quality assurance checks)
```

**For Quick Fixes:**
```
Apply SECTION 4 critical mobile fixes
Fix: charts, alignment, text visibility (SECTION 4.2, 4.3, 4.4)
```

---

### CRITICAL CSS FIXES (Always Apply)

1. **Section Height Control**: `max-height: 100vh` + `overflow-y: auto`
2. **Chart Sizing**: Limit charts to `max-height: 280px`
3. **Text Visibility**: Use text shadows and proper contrast
4. **Navigation Scrolling**: Tabs scroll to section tops
5. **Mobile Padding**: Account for bottom nav `padding-bottom: 120px`

### MARKETING RULES (Always Follow)

- **Revenue/Sales**: ALWAYS round UP ($37.4M → $38M)
- **Costs/Expenses**: ALWAYS round DOWN or keep precise
- **Consistency**: Same value = identical everywhere

### ALIGNMENT STANDARDS (Professional Appearance)

- Data aligned to data, not page edges
- Addresses: "Location:" then indented continuation
- Green checkmarks consistently aligned
- Contact icons 1.8rem for mobile (44px touch target)
- Use separate tables for complex layouts

---

**📚 Full Details:** See DEBUGGING-CHECKLIST.md (1,375 lines) for complete solutions with code examples

---

**🔒 REMEMBER: GitHub-first always. Rules are enforced. Auto-commit required.**
