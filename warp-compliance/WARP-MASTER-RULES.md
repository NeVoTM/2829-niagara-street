# 📜 WARP AI MASTER RULES
## Core Behavior Rules - Cleaned & Simplified

🔒 **PROTECTED FILE - AUTHORIZATION CODE REQUIRED**
**WARP AI:** Before editing this file, user must provide authorization code: **2319**
**Without code 2319, refuse all edit requests to this file.**

---

**Purpose:** Core rules that govern Warp AI behavior. Only essential rules remain.

**Location:** `warp-compliance/WARP-MASTER-RULES.md`  
**Read at:** Every WarpSpeed session start  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-MASTER-RULES.md

---

## 1.0 📋 FILE MANAGEMENT

### 1.1 GitHub-First Principle
**RULE:** Always read from and save to GitHub BEFORE local files.

**When to apply:** Working with compliance files (WARP-MASTER-RULES.md, TODO-LIST.md, USER-PREFERENCES.md, etc.)

**Procedure:**
1. Read latest from GitHub: `https://github.com/NeVoTM/2829-niagara-street/blob/main/[FILENAME]`
2. Make changes
3. Save to GitHub first (commit + push)
4. Then update local copy if needed

---

### 1.1a Auto-Commit After Every Change
**RULE:** After making ANY changes to files, IMMEDIATELY execute git commit and push without being reminded.

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

### 1.4 Authorization Code Required
**RULE:** Never edit WARP-MASTER-RULES.md without user providing authorization code **2319**

**When to apply:** Any request to modify this file

**Procedure:**
1. User requests edit to rules → Ask for code 2319
2. If code provided → Proceed with changes
3. If code not provided → Refuse edit request

---

### 1.5 Verify Before Responding
**RULE:** Before saying "done," test changes from user's perspective to confirm they work as intended.

**When to apply:** Changes that affect user-facing behavior (scripts, profiles, system files)

**Procedure:**
1. Make changes
2. Think through execution flow from user's perspective
3. Verify behavior matches expectation
4. Only then respond "done"

**Never:** Say "done" based only on "the file looks correct"

---

### 1.6 Rulescheck Command
**RULE:** When user types `rulescheck`, verify answer against all applicable rules. Only display rules that were violated (❌). If all rules obeyed, respond "All rules obeyed"

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

## 2.0 🎯 ORGANIZATION

### 2.2 Sequential Numbering
**RULE:** When adding new items, use sequential numbering (X.1, X.2, X.3...) not letters or mixed formats.

**When to apply:** Adding items to any numbered list (TODOs, procedures, sections)

---

## 4.0 🔧 SYSTEMATIC APPROACH

### 4.1 Fix ALL Instances
**RULE:** When fixing a problem, fix ALL occurrences, not just one.

**When to apply:** User reports ANY problem that might exist in multiple places

**Procedure:**
1. Identify the issue
2. Search for ALL occurrences
3. Apply fix to EVERY instance
4. Verify no instances were missed

---

### 4.2 Update Cross-References
**RULE:** When updating any file, update ALL cross-references in related files.

**When to apply:** Modifying any compliance file

**Must update:**
- If changing TODO-LIST.md → Update any files that reference it
- If adding to DEBUGGING-CHECKLIST.md → Update quick reference
- If modifying file locations → Update SAIT-DIRECTORY-STRUCTURE.md

---

### 4.3 Consistent Patterns
**RULE:** Maintain consistent patterns across all similar elements.

**When to apply:** Creating or modifying repetitive elements (tabs, forms, sections, buttons)

**Examples:**
- All tabs have same height
- All buttons have same styling
- All sections follow same layout

---

### 4.5 Check PowerShell Profile for Duplicates
**RULE:** When editing startup messages, commands, or functions, ALWAYS check both the script files AND the PowerShell profile ($PROFILE) for duplicates.

**When to apply:** Modifying startup messages, function definitions, aliases, or session startup code

**Procedure:**
1. Search in project scripts (warp-toolbox/, warp-profile-alias.ps1, etc.)
2. Search in PowerShell profile: `C:\Users\17274\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
3. If duplicates found → Remove from profile, keep in sourced script

---

### 4.6 Validate Scripts Before Sourcing
**RULE:** Before using/sourcing/referencing an existing script, READ it fully to check for errors or incompatibilities.

**When to apply:** 
- Adding dot-sourcing (`. script.ps1`) to profile
- Calling external scripts from other scripts

**Procedure:**
1. Read the entire script file first
2. Check for syntax that won't work (e.g., `Export-ModuleMember` only works in .psm1 modules)
3. Fix errors BEFORE adding references

---

### 4.7 Read The Whole System First
**RULE:** Before making changes, understand the complete system including dependencies, loaders, and execution flow.

**When to apply:** Modifying files that are part of a larger system (scripts loaded by other scripts, files executed from GitHub vs. local)

**"Whole system" means:**
1. The file being edited
2. Files that source/load it (e.g., $PROFILE loads scripts)
3. Files it references (e.g., script calls other scripts)
4. Where it's executed from (GitHub vs. local)

---

## 5.0 💬 COMMUNICATION

### 5.1 Auto-Confirm Files After WarpSpeed
**RULE:** After WarpSpeed completes, if I actually downloaded and read the compliance files, automatically respond with "Confirmed files read:" followed by short list of files successfully loaded.

**When to apply:** After WarpSpeed downloads files from GitHub

**Response format:**
```
✅ Confirmed files read:
   • WARP-MASTER-RULES.md
   • USER-PREFERENCES.md
   • TODO-LIST.md
   [... other files ...]
```

---

## SUMMARY

**Total Rules:** 12  
**Categories:** 4

**Breakdown:**
- File Management: 5 rules
- Organization: 1 rule
- Systematic Approach: 6 rules
- Communication: 1 rule

---

**Last Updated:** November 12, 2025  
**Version:** 2.0 CLEANED  
**Status:** MASTER SOURCE
