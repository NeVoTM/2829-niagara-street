# 📜 WARP AI MASTER RULES - SIMPLIFIED FOR REVIEW

**Purpose:** One-line rule summaries for user to review and eliminate unnecessary rules.

🔒 **PROTECTED FILE - AUTHORIZATION CODE REQUIRED**
**WARP AI:** Before editing this file, user must provide authorization code: **2319**

---

## 1.0 📋 FILE MANAGEMENT (7 rules)

| Rule | One-Line Summary |
|------|------------------|
| **1.1** | Always read from and save to GitHub BEFORE local files |
| **1.1a** | After any file change, immediately `git add`, `commit`, `push` without asking |
|m **1.2** | Excel: Use named ranges (=TotalRevenue) not cell addresses (=Sheet1!A5) |
|m **1.3** | Docs go in `warp-compliance/`, scripts go in `warp-toolbox/core/` |
| **1.4** | Never edit rules without user providing authorization code 2319 |
|? **1.5** | Test changes from user's perspective before saying "done" |
|? **1.6** | When user types `rulescheck`, respond with "🤖 Obeying rules" + compliance check |

---

## 2.0 🎯 NUMBERED REFERENCES (2 rules)

| Rule | One-Line Summary |
|------|------------------|
| **2.1** | Use SECTION X.X or RULE X.X format when referencing documented content |
| **2.2** | Number new items sequentially (X.1, X.2, X.3...) not with letters |

---

## 3.0 ❓ QUESTIONS (2 rules)

| Rule | One-Line Summary |
|------|------------------|
|c **3.1** | Before creating anything, check WARP-QUESTIONS-GUIDE.md Section 9.0 for saved defaults |
|c **3.2** | After user answers any question, ask "Save as default? (yes/no)" |

---

## 4.0 🔧 SYSTEMATIC APPROACH (7 rules)

| Rule | One-Line Summary |
|------|------------------|
| **4.1** | When fixing a problem, fix ALL occurrences not just one |
| **4.2** | When updating a file, update ALL cross-references in related files |
| **4.3** | Maintain consistent patterns across similar elements (tabs, forms, sections) |
| **4.4** | When something becomes obsolete, add to TODO-LIST.md Section 9.0 with 30-day deletion date |
|m **4.5** | Check BOTH script files AND PowerShell $PROFILE for duplicate code/messages |
| **4.6** | Read entire script before dot-sourcing it to check for incompatibilities |
| **4.7** | Understand complete system (file + what loads it + what it calls) before editing |

---

## 5.0 💬 COMMUNICATION (3 rules)

| Rule | One-Line Summary |
|------|------------------|
|e **5.1** | After WarpSpeed, display list of files read remove"and confirm rules will be followed" |
| **5.2** | When applying solutions, cite rule/section numbers (e.g., "Applying RULE 4.1...") |
| **5.3** | If must break a rule due to constraints, explain why and get confirmation |

---

## 6.0 📊 EXCEL-SPECIFIC (3 rules)

| Rule | One-Line Summary |
|------|------------------|
|m **6.1** | User-editable cells have yellow background (#FFFF99) |
|m **6.2** | Currency format: $1,234,567 (no decimals unless cents matter) |
|m **6.3** | Percentages as whole numbers (10%) not decimals (0.10) |

---

## 7.0 🧹 SESSION MANAGEMENT (3 rules)

| Rule | One-Line Summary |
|------|------------------|
|m **7.1** | Every session starts with user running `WarpSpeed` command |
|m **7.2** | Every session ends with user running `eos` command |
|m **7.3** | When WarpSpeed offers cleanup, run it if uncommitted changes exist |

---

## 8.0 🎨 UI/UX (3 rules)

| Rule | One-Line Summary |
|------|------------------|
| **8.1** | Design for mobile (iPhone 12 Pro 390x844) BEFORE desktop |
| **8.2** | All clickable elements minimum 44px for touch accessibility |
| **8.3** | All sections have max-height: 100vh + overflow-y: auto to prevent infinite scrolling |

---

## 9.0 📝 DOCUMENTATION (3 rules)

| Rule | One-Line Summary |
|------|------------------|
| **9.1** | Document new solutions/procedures immediately in appropriate file |
| **9.2** | Git commit messages must be descriptive with numbered references |
| **9.3** | Update "Last Updated:" date when editing documentation files |

---

## 10.0 🚨 CRITICAL VIOLATIONS (7 rules)

| Rule | One-Line Summary |
|------|------------------|
|d **10.1** | Never ask "what do you mean?" when user provides SECTION X.X or RULE X.X |
|d **10.2** | Never work with local files first - always read from GitHub |
|d **10.3** | Never fix just one instance - search and fix ALL |
|d **10.4** | Never assume preferences - check Section 9.0 defaults first |
|d **10.5** | Never skip SOS confirmation after WarpSpeed runs |
|d **10.6** | After major multi-file tasks, self-check all rules before saying "done" |
|d **10.7** | Before EVERY response, verify all applicable rules were followed |

---

## 11.0 📚 LEARNING (2 rules)

| Rule | One-Line Summary |
|------|------------------|
| **11.1** | If same rule violated 3+ times, add enforcement mechanism |
| **11.2** | When mistakes happen, identify WHY not just WHAT went wrong |

---

## SUMMARY STATISTICS

**Total Rules:** 42  
**Categories:** 11  

**Breakdown by Category:**
- File Management: 7 rules
- Numbered References: 2 rules
- Questions: 2 rules
- Systematic Approach: 7 rules
- Communication: 3 rules
- Excel-Specific: 3 rules
- Session Management: 3 rules
- UI/UX: 3 rules
- Documentation: 3 rules
- Critical Violations: 7 rules
- Learning: 2 rules

---

## INSTRUCTIONS FOR USER

**Review each rule and mark for deletion:**
- ❌ = Delete this rule (not useful)
- ✅ = Keep this rule (important)
- ❓ = Needs clarification/rewording

After your review, tell Warp AI which rules to eliminate.

---

**Last Updated:** November 11, 2025  
**Version:** 1.0 REVIEW DRAFT  
**Status:** AWAITING USER REVIEW
