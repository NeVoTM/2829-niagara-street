# Lessons Learned: Excel Workbook Development
## Session Date: 2025-11-06

This document captures critical lessons learned during the NEVO Tower Interactive Budget Workbook development to ensure future projects avoid similar issues.

---

## ⚠️ CRITICAL RULES FOR EXCEL DEVELOPMENT

### 1. **ALWAYS ASK CLARIFYING QUESTIONS BEFORE CREATING FILES**
   - **Never assume** format preferences without asking
   - **Always confirm:**
     - Should percentages be shown in a separate column?
     - Should all data use formulas or hard numbers?
     - What level of detail is needed (summary vs detailed)?
     - Should data be categorized (e.g., in-kind vs cash)?

### 2. **USE FORMULAS AND NAMED RANGES - NOT HARD NUMBERS**
   - ✅ **CORRECT**: `=TotalHardCosts*0.05` or `=TotalRevenue/TotalNSF`
   - ❌ **WRONG**: Hard-coded values like `32609001` or `108675`
   
   **Why**: 
   - Workbooks need to be reusable across projects
   - Hard numbers break when assumptions change
   - Named ranges make formulas readable and maintainable

### 3. **NUMBER FORMATTING STANDARDS**
   - **Currency**: `$#,##0` (with comma separators)
   - **Percentages**: `0.0%` (always show in formulas, not just display)
   - **Square Footage**: `#,##0` (with comma separators)
   - **Man-Hours**: `#,##0` (with comma separators)
   
   **Add % Column**: Always include a separate column for percentages showing:
   - Percentage of total project cost
   - Percentage of category totals
   - Material vs Labor splits

### 4. **PRESERVE DETAIL - DON'T DELETE**
   - When creating summaries, **DO NOT delete detailed breakdowns**
   - Example: GC RFQ sheet needs BOTH:
     - Detailed CSI division breakdown with worker types
     - Summary workforce categories
     - Materials vs labor splits with percentages
     - Man-hours calculations
   
   **The user said: "I need to watch you like a hawk"** - This means:
   - Don't remove data without explicit permission
   - When in doubt, include MORE detail, not less
   - Ask before simplifying or summarizing

### 5. **CATEGORIZATION REQUIREMENTS**
   - When dealing with costs, **always ask** if categorization is needed
   - Example: Soft costs categorized as:
     - **IN-KIND** (blue background): Services/sweat equity
     - **CASH** (red background): Actual cash outflows
   - Use visual indicators (colors, fonts) to distinguish categories

### 6. **FORMULA DEPENDENCY CHAIN**
   - Create named ranges in the correct order:
     1. Base data (GSF, NSF, Units)
     2. Cost assumptions (rates, percentages)
     3. Hard costs (with subtotals)
     4. Soft costs (referencing hard costs)
     5. Revenue
     6. Summary (referencing all of the above)
   
   - Define `TotalProjectCost` BEFORE trying to calculate percentages against it

### 7. **CASH FLOW DIRECTION LABELS**
   - Be precise about cash flow direction:
     - ✅ **SC Cash OUT** - Money flowing FROM developer TO SC
     - ❌ **SC Cash IN** - Implies SC is providing money (incorrect)
   - Always show negative cash flows correctly (developer perspective)

### 8. **AUTO-FIT WITH MERGED CELLS**
   - Cannot iterate over `sheet.columns` when merged cells exist
   - **Solution**: Use `sheet.iter_cols()` with enumeration
   - Handle `MergedCell` objects gracefully in auto-fit logic

### 9. **DUPLICATE FUNCTION DEFINITIONS**
   - Check for duplicate function names before creating large files
   - V2 file had TWO `create_cash_flow_sheet()` functions
   - This causes unpredictable behavior - last definition wins

### 10. **UNIT COUNT ACCURACY**
   - Double-check unit counts in formulas
   - Example: Project has 50 units but cash flow only calculated 48
   - Verify pre-sales velocity arrays sum to total units

---

## 📋 CHECKLIST FOR FUTURE EXCEL PROJECTS

### Before Writing Code:
- [ ] Ask user about format preferences (% columns, categories, etc.)
- [ ] Confirm level of detail needed (summary vs detailed)
- [ ] Understand data categorization needs
- [ ] Clarify formula vs hard-number preferences
- [ ] Verify number formatting standards

### While Writing Code:
- [ ] Use named ranges for ALL cross-sheet references
- [ ] Apply proper number formatting to ALL cells
- [ ] Include % columns showing proportions
- [ ] Preserve all detail from original data
- [ ] Use formulas instead of calculated values
- [ ] Add visual indicators (colors) for categories
- [ ] Test for merged cell issues in auto-fit logic
- [ ] Check for duplicate function definitions

### After Writing Code:
- [ ] Verify all formulas calculate correctly
- [ ] Check unit counts and totals match expectations
- [ ] Confirm cash flow directions are labeled correctly
- [ ] Ensure all detail sections are present
- [ ] Test that named ranges work across sheets
- [ ] Validate percentage calculations
- [ ] Verify auto-fit works with merged cells

---

## 🎯 KEY TAKEAWAY

**"WHEN CREATING FILES, ESPECIALLY EXCEL:**
**1. ASK QUESTIONS ABOUT FORMAT**
**2. USE FORMULAS & NAMED RANGES (NOT HARD NUMBERS)**
**3. SHOW % IN SEPARATE COLUMNS**
**4. PRESERVE ALL DETAIL**
**5. THIS MAKES IT REUSABLE FOR NEXT PROJECTS"**

This approach ensures that workbooks are:
- **Transparent**: All calculations visible via formulas
- **Reusable**: Named ranges work across different projects
- **Maintainable**: Easy to update assumptions and see impacts
- **Professional**: Proper formatting and categorization
- **Complete**: No detail lost in "simplification"

---

## 📁 PROJECT-SPECIFIC CORRECTIONS APPLIED

### NEVO Tower Budget Workbook (V3)

**11 Corrections Applied:**
1. Summary sheet - % in column C for all costs
2. Assumptions sheet - % in columns C and D
3. Soft costs - Categorized IN-KIND vs CASH, = 12% of project cost
4. All formulas use named ranges (no hard numbers)
5. Cash flow - 50 units (not 48), SC Cash OUT label
6. Project deal sheet - Developer Cash OUT to SC (correct direction)
7. Auto-fit columns (handling merged cells)
8. SF formatted with commas (#,##0)
9. Soft costs visual categorization (blue/red)
10. Revenue per NSF uses named ranges
11. All sheets properly formatted

**Full Detail Restored:**
- GC RFQ Sheet includes:
  - 23 CSI divisions with worker types and crew sizes
  - Materials % and Labor % for each division
  - Man-hours calculated at $45/hour average
  - Workforce summary by 5 categories
  - Peak workers calculation
  - Total labor cost by category

---

## 🔄 REUSABILITY NOTES

This workbook is now a **TEMPLATE** for future development projects because:
- All calculations use formulas and named ranges
- Easy to update assumptions and see cascading impacts
- Clear categorization of costs (in-kind vs cash)
- Detailed workforce breakdown for GC bidding
- Cash flow modeling with pre-sales velocity
- All metrics calculate automatically

**To adapt for a new project:**
1. Update Assumptions sheet (GSF, NSF, units, rates)
2. Update Hard Costs sheet (CSI division rates for local market)
3. Update Revenue sheet (unit mix and pricing)
4. All other sheets auto-calculate via named ranges

---

## 📖 REFERENCE FILES

- **Final Workbook**: `outputs/NEVO_Interactive_Budget_V3.xlsx`
- **Script**: `scripts/make_interactive_workbook_v3.py`
- **Corrections Doc**: `BRIDGE_LOAN_CORRECTIONS.md`
- **Changes Summary**: `FINAL_CHANGES_SUMMARY.md`

---

*Remember: The goal is not just to create a working spreadsheet, but to create a REUSABLE TOOL that can be adapted for future projects with minimal changes.*
