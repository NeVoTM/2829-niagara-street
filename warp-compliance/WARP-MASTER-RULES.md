# 📜 WARP AI MASTER RULES
## Single Source of Truth - All Rules Numbered by Category

**Purpose:** Eliminate rule duplication. ONE rule, ONE number, ONE location.

**Location:** `warp-compliance/WARP-MASTER-RULES.md`  
**Read at:** Every WarpSpeed SOS session start  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/WARP-MASTER-RULES.md

**CRITICAL:** These rules are MANDATORY. Not following them wastes hours of user time.

---

## 1.0 📋 **FILE MANAGEMENT RULES**

### 1.1 GitHub-First Principle
**RULE:** Always read from and save to GitHub BEFORE local files.

**APPLY WHEN:** Working with universal files (WARP-COMPLIANCE-SYSTEM.md, DEBUGGING-CHECKLIST.md, TODO-LIST.md, etc.)

**PROCEDURE:**
1. Read latest from GitHub: `https://github.com/NeVoTM/2829-niagara-street/blob/main/[FILENAME]`
2. Make changes
3. Save to GitHub first (commit + push)
4. Then update local copy if needed

**NEVER:** Work with local files without checking GitHub first

**VIOLATION EXAMPLE:** "I read the local file" → WRONG. Should read GitHub first.

---

### 1.1a Auto-Commit After Every Change
**RULE:** After making ANY changes to files, IMMEDIATELY execute git commit and push without being reminded.

**APPLY WHEN:** ANY file modification in the project

**MANDATORY SEQUENCE:**
```powershell
# After making changes, AUTOMATICALLY execute:
git add [files-modified]
git commit -m "[descriptive message with SECTION references]"
git push
```

**DO NOT:**
- Wait for user to remind you
- Ask "should I commit this?"
- Skip committing changes

**ALWAYS:**
- Commit immediately after edits
- Use descriptive commit messages with numbered references
- Push to GitHub automatically

**CRITICAL:** User has requested this behavior for WEEKS. Execute it EVERY time.

---

### 1.2 Named Ranges in Excel
**RULE:** All Excel cross-sheet references MUST use named ranges, not cell addresses.

**APPLY WHEN:** Creating Excel workbooks with multiple sheets

**PROCEDURE:**
1. Define named ranges for all shared values (e.g., TotalHardCosts, GC_Rate)
2. Use `=TotalHardCosts` not `='Hard Costs'!B23`
3. List all named ranges in workbook documentation

**NEVER:** Use cell address references across sheets

**VIOLATION EXAMPLE:** `='Sheet1'!A5` → WRONG. Should use `=TotalRevenue`

---

### 1.3 File Organization
**RULE:** All documentation files in `warp-compliance/`, all system files in `warp-toolbox/core/`

**APPLY WHEN:** Creating or moving files

**STRUCTURE:**
- `warp-compliance/` = Documentation (rules, TODOs, procedures)
- `warp-toolbox/core/` = Executable scripts (PowerShell, HTML)
- `warp-toolbox/docs/` = User guides and references

**NEVER:** Mix documentation and executable files

---

## 2.0 🎯 **NUMBERED REFERENCE SYSTEM**

### 2.1 Use Numbered References
**RULE:** Always use numbered references when communicating about solutions, issues, or procedures.

**APPLY WHEN:** User mentions or Warp AI references any documented solution

**FORMAT:**
- `SECTION X.X` (e.g., SECTION 4.3)
- `RULE X.X` (e.g., RULE 1.1)
- `ISSUE X.X` (e.g., ISSUE 4.1)
- `TODO X.X.X` (e.g., TODO 1.1.2)

**PROCEDURE:**
1. User says: "Fix alignment issues"
2. Warp responds: "Applying SECTION 4.3 (ALIGNMENT NIGHTMARES) from DEBUGGING-CHECKLIST.md"
3. Apply the exact documented solution

**NEVER:** Ask "What do you mean?" when user provides numbered reference

**VIOLATION EXAMPLE:** User: "Apply SECTION 4.3" → Warp: "What alignment issues?" → WRONG

---

### 2.2 Maintain Hierarchical Numbering
**RULE:** When adding new items, follow sequential numbering (X.1, X.2, X.3... NOT X.A, X.X)

**APPLY WHEN:** Adding items to any numbered list (TODOs, rules, procedures, issues)

**PROCEDURE:**
1. Find appropriate category (1.0, 2.0, etc.)
2. Add with next sequential number
3. Update cross-references in related files

**NEVER:** Use letters, unnumbered items, or break sequence

---

## 3.0 ❓ **QUESTION PROCEDURES**

### 3.1 Ask Questions Before Creating
**RULE:** Before creating Excel sheets, forms, interfaces, or documents, ask standard questions from WARP-QUESTIONS-GUIDE.md

**APPLY WHEN:** User requests creation of:
- Excel workbooks → Ask SECTION 1.0 questions
- Forms → Ask SECTION 3.0 questions
- Interfaces → Ask SECTION 4.0 questions
- Charts → Ask SECTION 5.0 questions
- Documents → Ask SECTION 6.0 questions

**PROCEDURE:**
1. Check WARP-QUESTIONS-GUIDE.md Section 9.0 for saved defaults
2. If default exists → Use it automatically
3. If no default → Ask question
4. After answer → "Save as default? (yes/no)"
5. If yes → User updates Section 9.0, commit to GitHub

**NEVER:** Assume preferences without checking Section 9.0 first

---

### 3.2 Offer to Save Defaults
**RULE:** After every answered question, ask "Save this as default for future sessions? (yes/no)"

**APPLY WHEN:** User answers ANY question about preferences, formats, or settings

**PROCEDURE:**
1. User answers question (e.g., "Currency format: $ with commas")
2. Warp asks: "Save as default? (yes/no)"
3. If yes → Guide user to update WARP-QUESTIONS-GUIDE.md Section 9.0
4. Commit change to GitHub

**NEVER:** Forget to offer saving as default

---

## 4.0 🔧 **SYSTEMATIC APPROACH**

### 4.1 Fix ALL Instances
**RULE:** When fixing an issue, apply the fix to ALL occurrences, not just one.

**APPLY WHEN:** User reports ANY problem that might exist in multiple places

**PROCEDURE:**
1. Identify the issue
2. Search for ALL occurrences
3. Apply fix to EVERY instance
4. Verify no instances were missed

**NEVER:** Fix just the one instance user pointed out

**VIOLATION EXAMPLE:** User: "Tab alignment is off" → Warp fixes one tab → WRONG. Should fix ALL tabs.

---

### 4.2 Update Cross-References
**RULE:** When updating any file, update ALL cross-references in related files.

**APPLY WHEN:** Modifying any universal file

**MUST UPDATE:**
- If changing TODO-LIST.md → Update WARP-START-SESSION.md priorities
- If adding to DEBUGGING-CHECKLIST.md → Update quick reference section
- If modifying file locations → Update SAIT-DIRECTORY-STRUCTURE.md

**PROCEDURE:**
1. Make primary change
2. Identify all files that reference the changed content
3. Update each reference
4. Commit all files together

**NEVER:** Update files in isolation

---

### 4.3 Consistent Patterns
**RULE:** Maintain consistent patterns across all similar elements.

**APPLY WHEN:** Creating or modifying repetitive elements (tabs, forms, sections, etc.)

**EXAMPLES:**
- All tabs have same height
- All buttons have same styling
- All sections follow same layout
- All validation rules use same format

**NEVER:** Create one-off solutions that break patterns

---

## 5.0 💬 **COMMUNICATION RULES**

### 5.1 Confirm File Reading at SOS
**RULE:** At session start (after WarpSpeed), confirm which files were read and rules will be followed.

**APPLY WHEN:** Every WarpSpeed execution

**MUST DISPLAY:**
```
✅ FILES READ AND PROCEDURES LOADED:
   • WARP-MASTER-RULES.md (this file)
   • WARP-QUESTIONS-GUIDE.md
   • TODO-LIST.md
   [... all other files ...]

✅ WILL FOLLOW:
   • RULE 1.1: GitHub-first principle
   • RULE 2.1: Numbered reference system
   • RULE 3.1: Ask questions before creating
   • RULE 4.1: Fix ALL instances
   [... all applicable rules ...]
```

**NEVER:** Skip the confirmation or say "I understand" without listing specifics

---

### 5.2 Use Numbered References in Responses
**RULE:** When applying solutions or explaining actions, cite the rule/section number.

**APPLY WHEN:** Responding to user requests

**EXAMPLES:**
- "Applying RULE 1.1 (GitHub-first) - reading from GitHub now"
- "Following RULE 4.1 (Fix ALL instances) - updating all 7 tabs"
- "Per SECTION 4.3 of DEBUGGING-CHECKLIST.md, using max-height: 100vh"

**NEVER:** Just do things without explaining which rule you're following

---

### 5.3 Clarify Before Breaking Rules
**RULE:** If you MUST break a rule due to technical constraints, explain why and get confirmation.

**APPLY WHEN:** A rule cannot be followed due to technical limitations

**PROCEDURE:**
1. Explain: "RULE X.X requires [this], but [technical reason] prevents it"
2. Propose: "Alternative approach: [solution]"
3. Ask: "Proceed with alternative? (yes/no)"

**NEVER:** Silently break rules without explanation

---

## 6.0 📊 **EXCEL-SPECIFIC RULES**

### 6.1 Editable Cells Are Yellow
**RULE:** All user-editable cells MUST have yellow background (#FFFF99).

**APPLY WHEN:** Creating any Excel workbook

**PROCEDURE:**
1. Identify which cells users should edit
2. Apply yellow fill to those cells
3. Add note: "Yellow cells = editable"

**NEVER:** Leave editable cells with default formatting

---

### 6.2 Currency Format
**RULE:** Currency displays as `$#,##0` (no decimals unless cents matter).

**APPLY WHEN:** Displaying monetary values

**EXAMPLES:**
- Budget totals: $1,234,567 (no decimals)
- Unit prices: $1,234.56 (with decimals)

**NEVER:** Use inconsistent currency formats

---

### 6.3 Percentages as Whole Numbers
**RULE:** Display percentages as whole numbers (10%) not decimals (0.10).

**APPLY WHEN:** Showing percentage values in Excel

**FORMAT:** `0.0%` or `0%` depending on precision needed

**NEVER:** Show percentages as decimals (0.10)

---

## 7.0 🧹 **SESSION MANAGEMENT**

### 7.1 Run WarpSpeed at Start
**RULE:** Every session MUST start with user running `WarpSpeed` command.

**APPLY WHEN:** Beginning any work session

**WHAT HAPPENS:**
1. Reads all compliance files (7 files)
2. Checks TODO list (reports open items)
3. Offers cleanup routine
4. Displays confirmation

**NEVER:** Start work without WarpSpeed confirmation

---

### 7.2 Run EOS at End
**RULE:** Every session MUST end with user running `eos` command.

**APPLY WHEN:** Finishing any work session

**WHAT HAPPENS:**
1. Commits changes to GitHub
2. Generates session documentation
3. Updates completion tracker
4. Creates TODO list for next session

**NEVER:** End session without running eos

---

### 7.3 Cleanup When Prompted
**RULE:** When WarpSpeed offers cleanup routine, run it if uncommitted changes exist.

**APPLY WHEN:** WarpSpeed displays cleanup prompt

**PROCEDURE:**
1. WarpSpeed asks: "Run cleanup now? (y/n)"
2. If uncommitted changes or duplicates exist → Answer 'y'
3. Review cleanup report
4. Address issues found

**NEVER:** Skip cleanup if issues are reported

---

## 8.0 🎨 **UI/UX RULES**

### 8.1 Mobile-First Design
**RULE:** Always design and test for mobile (iPhone 12 Pro) before desktop.

**APPLY WHEN:** Creating any web interface

**PROCEDURE:**
1. Design for mobile viewport first (390x844)
2. Test all interactions on mobile
3. Then expand to desktop

**NEVER:** Design for desktop first and retrofit mobile

---

### 8.2 Touch Targets Minimum 44px
**RULE:** All interactive elements must be at least 44px for touch accessibility.

**APPLY WHEN:** Creating buttons, links, icons, or any clickable element

**NEVER:** Use smaller touch targets on mobile interfaces

---

### 8.3 Prevent Infinite Scrolling
**RULE:** All sections must have `max-height: 100vh` and `overflow-y: auto` on mobile.

**APPLY WHEN:** Creating sectioned layouts

**NEVER:** Allow sections to scroll infinitely breaking layout

---

## 9.0 📝 **DOCUMENTATION RULES**

### 9.1 Update Documentation Immediately
**RULE:** When creating new procedures or solving new problems, document them immediately in the appropriate file.

**APPLY WHEN:** Any new solution, procedure, or issue is discovered

**WHERE TO DOCUMENT:**
- New solutions → DEBUGGING-CHECKLIST.md
- New procedures → WARP-PROCEDURES-HIERARCHY.md
- New rules → WARP-MASTER-RULES.md (this file)
- Open work → TODO-LIST.md

**NEVER:** Delay documentation until later

---

### 9.2 Use Descriptive Commit Messages
**RULE:** All Git commits must have descriptive messages with numbered references.

**APPLY WHEN:** Committing any changes

**FORMAT:**
```
Brief title (50 chars max)

COMPLETED:
✅ Item 1 (RULE X.X applied)
✅ Item 2 (SECTION Y.Y used)

FILES MODIFIED:
- file1.md
- file2.ps1

NEXT: What comes next
```

**NEVER:** Use vague commits like "updates" or "fixes"

---

## 10.0 🚨 **CRITICAL VIOLATIONS TO AVOID**

### 10.1 NEVER Ignore Numbered References
**VIOLATION:** User says "Apply SECTION 4.3" → Warp asks "What do you mean?"

**CORRECT:** User says "Apply SECTION 4.3" → Warp reads DEBUGGING-CHECKLIST.md SECTION 4.3 and applies exact solution

---

### 10.2 NEVER Work with Local Files First
**VIOLATION:** Reading local copy of DEBUGGING-CHECKLIST.md without checking GitHub

**CORRECT:** Read from `https://raw.githubusercontent.com/NeVoTM/2829-niagara-street/main/warp-compliance/DEBUGGING-CHECKLIST.md` first

---

### 10.3 NEVER Fix Just One Instance
**VIOLATION:** User reports "tab alignment is off" → Warp fixes one tab

**CORRECT:** Search for ALL tabs, fix ALL alignment issues

---

### 10.4 NEVER Assume Preferences
**VIOLATION:** Creating Excel without asking about colors, formats, or layout

**CORRECT:** Check Section 9.0 of WARP-QUESTIONS-GUIDE.md for defaults, ask if none saved

---

### 10.5 NEVER Skip SOS Confirmation
**VIOLATION:** User runs WarpSpeed → Warp doesn't display what files were read

**CORRECT:** Display complete list of files read and rules that will be followed

---

## 11.0 ✅ **RULE COMPLIANCE CHECKLIST**

**At session start, Warp AI confirms:**
- [ ] Read WARP-MASTER-RULES.md (this file)
- [ ] Will follow GitHub-first principle (RULE 1.1)
- [ ] Will use numbered references (RULE 2.1)
- [ ] Will ask questions before creating (RULE 3.1)
- [ ] Will fix ALL instances (RULE 4.1)
- [ ] Will update cross-references (RULE 4.2)
- [ ] Will confirm file reading (RULE 5.1)
- [ ] Will save defaults when offered (RULE 3.2)

**During work, Warp AI:**
- [ ] Cites rule numbers when applying solutions
- [ ] Checks Section 9.0 before asking questions
- [ ] Applies fixes to ALL instances
- [ ] Updates cross-references

**At session end, Warp AI:**
- [ ] Commits to GitHub first (RULE 1.1)
- [ ] Uses descriptive commit messages (RULE 9.2)
- [ ] User runs eos (RULE 7.2)

---

## 12.0 📚 **RULE INDEX - QUICK REFERENCE**

| Rule | Description | Apply When |
|------|-------------|------------|
| 1.1 | GitHub-first principle | Working with universal files |
| 1.2 | Named ranges in Excel | Creating multi-sheet workbooks |
| 1.3 | File organization | Creating/moving files |
| 2.1 | Use numbered references | Communicating about solutions |
| 2.2 | Maintain hierarchical numbering | Adding new items |
| 3.1 | Ask questions before creating | Creating anything new |
| 3.2 | Offer to save defaults | User answers questions |
| 4.1 | Fix ALL instances | Solving any problem |
| 4.2 | Update cross-references | Modifying universal files |
| 4.3 | Consistent patterns | Creating repetitive elements |
| 5.1 | Confirm file reading at SOS | Every WarpSpeed run |
| 5.2 | Use numbered references in responses | Explaining actions |
| 5.3 | Clarify before breaking rules | Technical limitations |
| 6.1 | Editable cells are yellow | Creating Excel workbooks |
| 6.2 | Currency format | Displaying money |
| 6.3 | Percentages as whole numbers | Showing percentages |
| 7.1 | Run WarpSpeed at start | Beginning sessions |
| 7.2 | Run EOS at end | Ending sessions |
| 7.3 | Cleanup when prompted | WarpSpeed offers cleanup |
| 8.1 | Mobile-first design | Creating web interfaces |
| 8.2 | Touch targets 44px minimum | Interactive elements |
| 8.3 | Prevent infinite scrolling | Sectioned layouts |
| 9.1 | Update documentation immediately | New solutions/procedures |
| 9.2 | Descriptive commit messages | All Git commits |

---

**Last Updated:** 2025-11-07  
**Version:** 1.0  
**Location:** `warp-compliance/WARP-MASTER-RULES.md`  
**Status:** MASTER SOURCE - All other files reference this

---

**END OF MASTER RULES**

