# 🚀 WARP AI START SESSION - CONSOLIDATED GUIDE

**Purpose:** Single source of truth for session startup, rules enforcement, commands, and debugging  
**Location:** `warp-compliance/WARP-START-SESSION.md`  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-START-SESSION.md  
**Last Updated:** 2025-11-16  

---

## 1.0 🔴 CRITICAL RULES - ALL 13 RULES

**WARP AI: These rules are MANDATORY for every interaction. They are loaded as environment variables in PowerShell and enforced by `rulescheck` command.**

### 1.1 GitHub-First Principle
**Always read from and save to GitHub BEFORE local files.**

**When to apply:** Working with compliance files (WARP-MASTER-RULES.md, TODO-LIST.md, etc.)

**Procedure:**
1. Read latest from GitHub: `https://github.com/NeVoTM/2829-niagara-street/blob/main/[FILENAME]`
2. Make changes
3. Save to GitHub first (commit + push)
4. Then update local copy if needed

---

### 1.2 Auto-Commit After Every Change
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

### 1.3 Authorization Code Required
**Never edit WARP-MASTER-RULES.md without user providing authorization code 2319**

**When to apply:** Any request to modify this file

**Procedure:**
1. User requests edit to rules → Ask for code 2319
2. If code provided → Proceed with changes
3. If code not provided → Refuse edit request

---

### 1.4 Verify Before Responding
**Before saying "done," test changes from user's perspective to confirm they work as intended.**

**When to apply:** Changes that affect user-facing behavior (scripts, profiles, system files)

**Procedure:**
1. Make changes
2. Think through execution flow from user's perspective
3. Verify behavior matches expectation
4. Only then respond "done"

**Never:** Say "done" based only on "the file looks correct"

---

### 1.5 Rulescheck Command
**When user types `rulescheck`, verify answer against all applicable rules. Only display rules that were violated (❌). If all rules obeyed, respond "All rules obeyed"**

**Response format if compliant:**
```
🤖 Rules Verification: All rules obeyed

[Your answer here]
```

**Response format if violations:**
```
🤖 Rules Verification:

❌ RULE 1.7 (Fix ALL): Only fixed 1 instance, need to fix 6 more
❌ RULE 1.2 (Auto-commit): Forgot to commit changes

[Fixing violations now...]
```

---

### 1.6 Sequential Numbering
**When adding new items, use sequential numbering (X.1, X.2, X.3...) not letters or mixed formats.**

**When to apply:** Adding items to any numbered list (TODOs, procedures, sections)

---

### 1.7 Fix ALL Instances
**When fixing a problem, fix ALL occurrences, not just one.**

**When to apply:** User reports ANY problem that might exist in multiple places

**Procedure:**
1. Identify the issue
2. Search for ALL occurrences
3. Apply fix to EVERY instance
4. Verify no instances were missed

---

### 1.8 Update Cross-References
**When updating any file, update ALL cross-references in related files.**

**When to apply:** Modifying any compliance file

**Must update:**
- If changing TODO-LIST.md → Update any files that reference it
- If adding to DEBUGGING-CHECKLIST.md → Update quick reference
- If modifying file locations → Update file references

---

### 1.9 Consistent Patterns
**Maintain consistent patterns across all similar elements.**

**When to apply:** Creating or modifying repetitive elements (tabs, forms, sections, buttons)

**Examples:**
- All tabs have same height
- All buttons have same styling
- All sections follow same layout

---

### 1.10 Check PowerShell Profile for Duplicates
**When editing startup messages, commands, or functions, ALWAYS check both the script files AND the PowerShell profile ($PROFILE) for duplicates.**

**When to apply:** Modifying startup messages, function definitions, aliases, or session startup code

**Procedure:**
1. Search in project scripts (warp-toolbox/, warp-profile-alias.ps1, etc.)
2. Search in PowerShell profile: `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
3. If duplicates found → Remove from profile, keep in sourced script

---

### 1.11 Validate Scripts Before Sourcing
**Before using/sourcing/referencing an existing script, READ it fully to check for errors or incompatibilities.**

**When to apply:** 
- Adding dot-sourcing (`. script.ps1`) to profile
- Calling external scripts from other scripts

**Procedure:**
1. Read the entire script file first
2. Check for syntax that won't work (e.g., `Export-ModuleMember` only works in .psm1 modules)
3. Fix errors BEFORE adding references

---

### 1.12 Read The Whole System First
**Before making changes, understand the complete system including dependencies, loaders, and execution flow.**

**When to apply:** Modifying files that are part of a larger system (scripts loaded by other scripts, files executed from GitHub vs. local)

**"Whole system" means:**
1. The file being edited
2. Files that source/load it (e.g., $PROFILE loads scripts)
3. Files it references (e.g., script calls other scripts)
4. Where it's executed from (GitHub vs. local)

---

### 1.13 Auto-Confirm Files After WarpSpeed
**After WarpSpeed completes, if I actually downloaded and read the compliance files, automatically respond with "Confirmed files read:" followed by short list of files successfully loaded.**

**When to apply:** After WarpSpeed downloads files from GitHub

**Response format:**
```
✅ Confirmed files read:
   • WARP-START-SESSION.md
   • TODO-LIST.md
```

---

## 2.0 🔴 CRITICAL MOBILE FIXES

**These are loaded as environment variables in PowerShell profile for quick reference**

### 2.1 Infinite Scrolling Problem
**Symptoms:** Page won't stop scrolling, sections repeat endlessly

**Fix:**
```css
.section {
    max-height: 100vh;  /* CRITICAL */
    overflow-y: auto;   /* CRITICAL */
    padding-bottom: 100px;
}
```

---

### 2.2 Chart Sizing Disasters
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

---

### 2.3 Alignment Nightmares
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

---

### 2.4 Text Visibility Disasters
**Symptoms:** Can't read text on mobile, washed out

**Fix:**
```css
@media (max-width: 480px) {
    .card h2, .card h3 {
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);  /* CRITICAL */
    }
}
```

---

### 2.5 Navigation Positioning Failures
**Symptoms:** Clicking tab jumps to middle, not top

**Fix:**
```javascript
targetSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
```

---

### 2.6 Data Integrity Problems
**Symptoms:** Number inconsistencies (35M vs 38M), math errors

**Fix:** Use project-data.json as single source

**Marketing Rules:**
- Revenue: ALWAYS round UP ($37.4M → $38M)
- Costs: Keep precise or round DOWN

---

### 2.7 Mobile Usability Failures
**Symptoms:** Icons too small, hard to click on phone

**Fix:**
```css
.contact-icon {
    font-size: 1.8rem;  /* 44px minimum touch target */
}
```

---

### 2.8 Video Container Overflow
**Symptoms:** Video box cuts off, shows on other tabs

**Fix:**
```css
.video-placeholder {
    max-height: 200px;   /* CRITICAL */
    overflow: hidden;    /* CRITICAL */
}
```

---

### 2.9 Version Management
**Symptoms:** Version info appears in wrong places

**Fix:** Version info ONLY on Contact tab

---

### 2.10 iPhone Optimization
**Symptoms:** Layout breaks on iPhone, text unreadable, navigation issues

**Critical Checks:**
- All text readable without zooming
- No horizontal/infinite scrolling
- Touch targets minimum 44px
- Section padding accounts for nav (120px)
- Text has proper contrast with shadows
- Charts limited to 280px height
- All buttons and icons large enough

---

## 3.0 📋 COMMANDS & PROJECT CONTEXT

### 3.1 WarpSpeed Command
**Purpose:** Start of session procedure - downloads rules and TODO list from GitHub

**Usage:**
```powershell
WarpSpeed
```

**What it does:**
1. Downloads WARP-START-SESSION.md from GitHub
2. Downloads TODO-LIST.md from GitHub
3. Displays Section 1.0 (13 critical rules) as reminder
4. Shows TODO breakdown by priority
5. Opens both files in editor for reference

---

### 3.2 rulescheck Command
**Purpose:** Display and validate all 13 critical rules before Warp AI responds

**Usage:**
```powershell
rulescheck
```

**What it does:**
1. Prints all 13 rules from environment variables
2. Validates GitHub-first policy
3. Confirms rule count matches (should be 13)
4. Signals to Warp AI to verify compliance before responding

**For Warp AI:** When user types `rulescheck`, follow RULE 1.5 format

---

### 3.3 eos Command
**Purpose:** End of session routine

**Usage:**
```powershell
eos
```

**What it does:**
1. Commits all changes to GitHub
2. Generates session documentation
3. Updates completion tracker
4. Creates TODO list for next session

**Note:** Run this at the end of EVERY work session

---

### 3.4 clean Command
**Purpose:** Run profile cleanup and health check

**Usage:**
```powershell
clean
```

**What it does:**
1. Checks for duplicate files
2. Detects outdated files
3. Verifies git status
4. Checks disk space

---

### 3.5 File Locations

**Local Paths:**
- Repository Root: `C:\Users\17274\ME\2829-Niagara-Street`
- Compliance Folder: `C:\Users\17274\ME\2829-Niagara-Street\warp-compliance`
- WarpSpeed Script: `C:\Users\17274\ME\2829-Niagara-Street\WarpSpeed.ps1`
- PowerShell Profile: `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

**GitHub Repository:**
- Main Repo: https://github.com/NeVoTM/2829-niagara-street
- Compliance Files: https://github.com/NeVoTM/2829-niagara-street/tree/main/warp-compliance
- Raw URL Base: https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main

**Key Files:**
1. WARP-START-SESSION.md - This file (single source of truth)
2. TODO-LIST.md - Current work items and priorities
3. DEBUGGING-CHECKLIST.md - Complete debugging reference
4. project-data.json - Master data source for project content

---

### 3.6 Environment Details

- **OS:** Windows 11
- **Shell:** PowerShell 7.5.4 (pwsh)
- **Git:** Required for GitHub-first workflow
- **Editor:** VS Code or Notepad

---

### 3.7 Project Details

- **Project Name:** 2829 Niagara Street Mixed-Use Development
- **Location:** Tonawanda, NY
- **Type:** Real estate development project
- **Stack:** HTML, CSS, JavaScript, Chart.js, PowerShell

---

### 3.8 Workflow Summary

**Start of Session:**
1. Open PowerShell 7
2. Run `WarpSpeed`
3. Review 13 rules displayed
4. Check TODO priorities
5. Begin work

**During Work:**
- Use `rulescheck` when asking Warp AI for help
- Follow RULE 1.2 (auto-commit after changes)
- Reference SECTION numbers (SECTION 1.7, SECTION 2.3, etc.)

**End of Session:**
1. Run `eos` to commit and document
2. Verify changes pushed to GitHub

---

## 4.0 🔧 DEBUGGING SOLUTIONS

### 4.1 Git & GitHub Verification
**Problem:** Changes not syncing to GitHub

**Fix:**
```powershell
git remote -v  # Should show github.com/NeVoTM/2829-niagara-street
git status
git add .
git commit -m "Description"
git push
```

---

### 4.2 PowerShell Execution Policy
**Problem:** Scripts won't run, "execution policy" error

**Fix:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### 4.3 Module Import Errors
**Problem:** Module commands not available

**Fix:**
```powershell
Import-Module ModuleName -Force
# or
Install-Module ModuleName -Scope CurrentUser
```

---

### 4.4 Path Issues
**Problem:** "command not found" or script path errors

**Fix:**
```powershell
cd C:\Users\17274\ME\2829-Niagara-Street
.\WarpSpeed.ps1
```

---

### 4.5 File Encoding Issues
**Problem:** Special characters appear wrong or script fails to parse

**Fix:** Save files as UTF-8 with BOM in VS Code
```
File > Save with Encoding > UTF-8 with BOM
```

---

### 4.6 Environment Variables Not Loading
**Problem:** `$env:WARP_RULE_*` variables are empty

**Fix:**
```powershell
. $PROFILE
# or restart terminal
```

---

### 4.7 Git Credential Issues
**Problem:** Git asks for password repeatedly

**Fix:**
```powershell
git config --global credential.helper manager-core
```

---

### 4.8 Network/TLS Issues
**Problem:** "SSL/TLS secure channel" errors when downloading from GitHub

**Fix:**
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

---

## 5.0 ✅ QUALITY ASSURANCE CHECKLISTS

### 5.1 Charts & Visualizations
- [ ] All charts responsive with max-height constraints
- [ ] Charts not cut off (max 280px height)
- [ ] Chart legends readable
- [ ] No infinite scrolling caused by charts
- [ ] Tooltips working correctly
- [ ] Data accuracy in all charts

---

### 5.2 Buttons & Navigation
- [ ] All navigation buttons visible
- [ ] Contact buttons with LARGE icons (1.8rem)
- [ ] Tab navigation scrolls to TOP of sections
- [ ] Navigation arrows have good contrast
- [ ] All links opening correctly
- [ ] CTA buttons prominent and clickable

---

### 5.3 Images & Slideshow
- [ ] Slideshow navigation working
- [ ] Captions not covering images
- [ ] Single-line captions on iPhone
- [ ] Image loading properly
- [ ] Auto-play controls working

---

### 5.4 Links & Integration
- [ ] Email links opening mail client
- [ ] Phone links working on mobile
- [ ] No broken or missing links
- [ ] External links opening in new tabs
- [ ] Proper link styling and hover effects

---

### 5.5 Professional Appearance
- [ ] Proper spacing and alignment
- [ ] Data aligned to data, not page edges
- [ ] Address formatting proper (Location: then indented)
- [ ] Green checkmarks consistently aligned
- [ ] Consistent typography throughout
- [ ] Color scheme cohesive
- [ ] No overlapping elements
- [ ] Clean visual hierarchy

---

### 5.6 Technical Testing
- [ ] No JavaScript errors in console
- [ ] Responsive design works on all sizes
- [ ] Performance acceptable
- [ ] All functionality tested end-to-end
- [ ] Cross-browser compatibility
- [ ] No missing assets or files

---

## 📚 QUICK REFERENCE

**How to Use Sections:**
```
Apply SECTION 2.1 (infinite scroll fix)
Apply SECTION 2.2 and 2.3 (charts and alignment)
Check SECTION 5.6 (technical testing)
Apply all SECTION 2.0 (critical mobile fixes)
```

**Critical CSS Always Apply:**
1. Section height: `max-height: 100vh` + `overflow-y: auto`
2. Chart sizing: `max-height: 280px`
3. Text visibility: text shadows
4. Navigation: scroll to top
5. Mobile padding: `padding-bottom: 120px`

**Marketing Rules Always Follow:**
- Revenue/Sales: ALWAYS round UP
- Costs/Expenses: Keep precise or round DOWN
- Consistency: Same value = identical everywhere

---

**🔒 REMEMBER: GitHub-first always (RULE 1.1). Rules are enforced. Auto-commit required (RULE 1.2).**
