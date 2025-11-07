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
