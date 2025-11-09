# 👤 USER PREFERENCES & STYLE GUIDE
## Tiffany's Specific Formatting Standards

**Purpose:** Document exact preferences so Warp AI never has to ask twice  
**Location:** `warp-compliance/USER-PREFERENCES.md`  
**GitHub:** https://github.com/NeVoTM/2829-niagara-street/blob/main/warp-compliance/USER-PREFERENCES.md

---

## 1.0 📊 NUMBER FORMATTING

### 1.1 Percentages
**Rule:** Always 1 decimal place unless more precision required

**Examples:**
```
✅ CORRECT:   10.5%   |   85.3%   |   0.7%
❌ WRONG:     10%     |   85%     |   1%
❌ WRONG:     10.50%  |   85.35%  |   0.72%
```

**Exception:** Financial calculations requiring precision may use 2 decimals (10.52%)

### 1.2 Currency
**Rule:** No decimal places for whole dollar amounts

**Examples:**
```
✅ CORRECT:   $1,234,567   |   $500   |   $1,000,000
❌ WRONG:     $1,234,567.00 |   $500.00 |   $1,000,000.00
```

**Exception:** When cents matter: $1,234.56

### 1.3 Large Numbers
**Rule:** Use commas for thousands separator

**Examples:**
```
✅ CORRECT:   1,234,567   |   10,000   |   500,000
❌ WRONG:     1234567     |   10000    |   500000
```

---

## 2.0 💬 COMMUNICATION STYLE

### 2.1 General Tone
**Rule:** Direct, efficient, no unnecessary pleasantries

**Examples:**
```
✅ CORRECT:   "Fixed the alignment issue in all tabs"
❌ WRONG:     "I hope this helps! I've tried to fix the alignment..."
```

### 2.2 Efficiency Focus
**Rule:** Bundle information, minimize back-and-forth

**Examples:**
```
✅ CORRECT:   "3 options: A) ..., B) ..., C) ... Which one?"
❌ WRONG:     "Would you like option A?" [wait] "Or maybe B?" [wait]
```

### 2.3 Cost Awareness
**Rule:** User pays $0.005 per message - no wasted confirmations

**Examples:**
```
✅ CORRECT:   [Just do it if it's safe]
❌ WRONG:     "Should I proceed with this? Are you sure? Confirm?"
```

---

## 3.0 🎨 COLOR SCHEMES

### 3.1 Excel - Editable Cells
**Rule:** Yellow background for user-editable cells

**Sample:**
```
Background: #FFFF99 (Light yellow)
Text: Black
Border: Standard grid
```

### 3.2 Status Indicators
**Rule:** Traffic light system

**Samples:**
```
🔴 Red:    Critical/Error    (#FF0000)
🟡 Yellow: Warning/Pending   (#FFFF00)
🟢 Green:  Success/Complete  (#00FF00)
```

---

## 4.0 📐 LAYOUT PATTERNS

### 4.1 Mobile-First Design
**Rule:** Design for iPhone 12 Pro (390x844px) FIRST

**Pattern:**
```
1. Mobile layout (390px width)
2. Test all interactions
3. Then expand to desktop
4. Never design desktop-first
```

### 4.2 Touch Targets
**Rule:** Minimum 44px for any clickable element

**Sample:**
```
Button height: 44px minimum
Icon size: 44px × 44px minimum
Spacing between targets: 8px minimum
```

### 4.3 Excel Tab Structure
**Rule:** Consistent height and styling across all tabs

**Pattern:**
```
Tab 1: Overview     - Always first, summary view
Tab 2-N: Details    - Consistent formatting
Last Tab: Settings  - Configuration/inputs
```

---

## 5.0 📁 FILE ORGANIZATION

### 5.1 Documentation
**Rule:** All docs in `warp-compliance/`

**Pattern:**
```
warp-compliance/
  ├── WARP-MASTER-RULES.md     (System rules)
  ├── USER-PREFERENCES.md       (This file)
  ├── DEBUGGING-CHECKLIST.md    (Solutions)
  └── TODO-LIST.md              (Work items)
```

### 5.2 Scripts
**Rule:** All executable files in `warp-toolbox/core/`

**Pattern:**
```
warp-toolbox/core/
  ├── WarpSpeed.ps1
  ├── QuickStart.ps1
  └── EOS-Routine.ps1
```

---

## 6.0 🔧 TECHNICAL PREFERENCES

### 6.1 Excel Formulas
**Rule:** Use named ranges, NEVER cell addresses

**Examples:**
```
✅ CORRECT:   =TotalRevenue * GrossMargin
❌ WRONG:     ='Sheet1'!B23 * 'Sheet2'!C15
```

### 6.2 Git Commit Messages
**Rule:** Include numbered references and structured format

**Pattern:**
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

---

## 7.0 🎯 EFFICIENCY SHORTCUTS

### 7.1 Mouse-Clickable Solutions
**Rule:** Always prefer clickable over typing

**Examples:**
```
✅ CORRECT:   [Provide .ps1 script to run]
❌ WRONG:     "Type these 10 commands one by one"
```

### 7.2 Auto-Answer/Auto-Confirm
**Rule:** Default to "yes" unless truly dangerous

**Examples:**
```
✅ CORRECT:   [Just update the file]
❌ WRONG:     "Should I update? Are you sure? Confirm?"
```

---

## 8.0 📝 DOCUMENTATION STANDARDS

### 8.1 Numbered References
**Rule:** Always use SECTION X.X or RULE X.X format

**Examples:**
```
✅ CORRECT:   "Apply SECTION 4.3 from DEBUGGING-CHECKLIST.md"
❌ WRONG:     "Apply the alignment fix we discussed"
```

### 8.2 Cross-References
**Rule:** Update ALL related files when making changes

**Pattern:**
```
If changing: TODO-LIST.md
Also update: WARP-START-SESSION.md (priorities)
Also update: SESSION-COMPLETION-TRACKER.md (progress)
```

---

## 9.0 🔍 SELF-CHECK REQUIREMENTS

**When using `r` command, verify output against:**
1. WARP-MASTER-RULES.md (system rules)
2. USER-PREFERENCES.md (this file - user preferences)

**Format verification checklist:**
- [ ] Percentages: 1 decimal place?
- [ ] Currency: No unnecessary decimals?
- [ ] Colors: Using specified hex codes?
- [ ] Layout: Mobile-first applied?
- [ ] Communication: Direct and efficient?

---


### 3.3 Text Shadows for Readability
**Rule:** Use text shadows when text appears over images/videos

**Sample:**
```css
.text-over-image {
    text-shadow: 2px 2px 4px rgba(0,0,0,0.8);
    color: white;
}
```

**Usage:** Ensures text is readable over any background

---

## 4.4 Chart Height Standard

### Mobile Charts
**Rule:** Maximum height 280px for mobile charts

**Sample:**
```css
.chart-container {
    max-height: 280px;
    overflow-y: auto;
}
```

**Reason:** Prevents infinite scrolling on mobile devices

---

## 5.3 File Naming Conventions

### PowerShell Scripts
**Rule:** Use PascalCase for PowerShell files

**Examples:**
```
✅ CORRECT:   CleanAndHealthy.ps1   |   QuickStart.ps1
❌ WRONG:     clean-and-healthy.ps1 |   quickstart.ps1
```

### Documentation Files
**Rule:** Use kebab-case for Markdown files

**Examples:**
```
✅ CORRECT:   warp-compliance-system.md   |   user-preferences.md
❌ WRONG:     WarpComplianceSystem.md     |   UserPreferences.md
```

---

## 10.0 📅 SESSION DOCUMENTATION

### 10.1 Date Format
**Rule:** YYYY-MM-DD-HHMM format for session files

**Examples:**
```
✅ CORRECT:   SESSION-DOCUMENTATION-2025-11-09-0102.md
❌ WRONG:     Session-11-9-2025.md
```

### 10.2 Progress Tracking
**Rule:** Show percentage with 1 decimal place

**Examples:**
```
✅ CORRECT:   67.5% complete
❌ WRONG:     67% or 67.50%
```

---

## 10.3 TODO Priority Colors

**Rule:** Consistent color scheme for priority levels

**Pattern:**
```
🔴 1.0 CRITICAL     - Red (#FF0000)
🟡 2.0 IMPORTANT    - Yellow (#FFFF00)  
⚪ 3.0+ NORMAL       - White/Gray
```

**Usage:** Visual priority indication in TODO lists


**Last Updated:** 2025-11-09  
**Version:** 1.0  
**Status:** Living document - add preferences as discovered

