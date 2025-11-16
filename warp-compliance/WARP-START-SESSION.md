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

**🔒 REMEMBER: GitHub-first always. Rules are enforced. Auto-commit required.**
