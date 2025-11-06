# FINAL CHANGES SUMMARY - NEVO Tower Excel Workbook

**Date:** 2025-01-06  
**Status:** ✅ Complete

---

## ALL CHANGES IMPLEMENTED

### 1. ✅ Interest Calculation Fixed
**Issue:** Interest was incorrectly calculated on $8M land  
**Fix:** Interest now calculated ONLY on hard costs + $2M SC cash
- **Loan basis:** (TotalHardCosts + $2M) × 75% LTC
- **NO interest on $8M in-kind land contribution**
- Formula: `=(TotalHardCosts+LandPartner_Cash1+LandPartner_Cash2)*LTC*0.5*Finance_Rate*(Duration/12)`

### 2. ✅ Changed to 24-Month Schedule
**Issue:** Project was on 18-month schedule  
**Fix:** Updated to 24-month construction timeline
- Duration changed from 12 to 24 months in Assumptions
- Interest calculated over 24 months with declining balance (50% avg)
- Cash flow sheet shows 24-month draw schedule

### 3. ✅ Added 24-Month Cash Flow Sheet
**New sheet:** "24-Month Cash Flow"
- Month-by-month hard cost draws
- Cumulative totals and % complete
- SC payment milestones noted (Month 1: $1.25M, Month 6: $750K)
- Front-loaded for foundation, peaks mid-project

### 4. ✅ Added "HOW TO SYNC" Instructions Sheet
**New sheet:** "HOW TO SYNC"
- Step-by-step instructions for editing the workbook
- Explains yellow cells = editable, white = calculated
- Documents named ranges structure
- Backup procedures

### 5. ✅ All Sheets Now in Excel
**Complete workbook with 8 sheets:**
1. **Summary** - Executive overview with all metrics
2. **Assumptions** - Editable rates, percentages, SC structure
3. **Hard Costs** - CSI divisions with $/GSF and % columns
4. **Soft Costs** - Fixed + formula-based with $/GSF
5. **Revenue** - Unit types and pricing
6. **24-Month Cash Flow** - Monthly draw schedule
7. **HOW TO SYNC** - User instructions
8. ~~GC RFQ~~ (Not yet added - can add if needed)

### 6. ✅ Added $/GSF Rows
- Hard Costs sheet: Cost per GSF row after total
- Soft Costs sheet: Cost per GSF row after total
- Summary sheet: Cost per GSF for both hard costs and total project cost

### 7. ✅ Added % Column in Hard Costs
- Shows actual percentages from Assumptions sheet
- GC, OH&P, and all contingencies display their rates
- Formulas linked to Assumptions named ranges

### 8. ✅ Cleaned Up Outputs Folder
**Kept only:**
- NEVO_Interactive_Budget.xlsx
- CORRECTION_SUMMARY.md

**Deleted:**
- 18_MONTH_CASH_FLOW.md
- CORRECT_FINANCING_SUMMARY.md
- FINAL_VERIFIED_BUDGET.md
- HOW_TO_SYNC.txt
- NEVO_FINANCING_MODEL.md
- UPDATED_SUMMARY.md

---

## FINAL VERIFIED NUMBERS

### Project Costs
| Item | Amount | $/GSF |
|------|--------|-------|
| Hard Costs | $32,609,001 | $300.06 |
| Soft Costs | $3,773,994 | $34.73 |
| SC Cash Payments | $2,000,000 | $18.40 |
| **Total Costs** | **$38,382,995** | **$353.19** |

### Financing
- **Loan Basis:** Hard Costs + SC Cash = $34,609,001
- **Loan Amount (75%):** $25,956,751
- **Average Balance (50%):** $12,978,376
- **Interest Rate:** 8.5%
- **Duration:** 24 months
- **Interest Cost:** $2,216,925 (24-month declining balance)
- **NO interest on $8M land** ✅

### Revenue & Profit
- **Total Revenue:** $55,272,000
- **Gross Profit:** $16,889,005
- **Profit Margin:** **30.6%** ✅

### Target Verification
✅ Hard Costs: $300.06/GSF (target $300/GSF)  
✅ Soft Costs: 11.6% of hard costs (target ≤15%)  
✅ Profit Margin: 30.6% (target ≥30%)  

---

## SC PARTNERSHIP STRUCTURE (CORRECTED)

1. **Land (In-Kind):** $8,000,000
   - SC contributes land valued at $10M total
   - $2M paid in cash upfront by developer
   - Only $8M counted as in-kind equity
   - **NO interest charged on this $8M** ✅

2. **SC Cash Payments FROM Developer:**
   - Month 0: $1,250,000 (key money)
   - Month 6: $750,000
   - Total: $2,000,000 (counted as project cost)

3. **SC Land Payment AT EXIT:** $8,000,000
   - Paid from proceeds after loan payoff
   - NOT counted as project cost
   - Paid BEFORE 50/50 profit split

4. **Profit Split:** 50/50 after SC land payment

---

## KEY IMPROVEMENTS

1. **Interest reduced** by not including $8M land
2. **24-month realistic timeline** instead of compressed 18 months
3. **Comprehensive Excel workbook** with all data in one place
4. **Clear instructions** for users via HOW TO SYNC sheet
5. **Clean outputs folder** with only essential files
6. **All targets met:** 30% margin, $300/GSF hard, <15% soft

---

## EXCEL WORKBOOK FEATURES

✅ **Yellow cells** = User can edit  
✅ **White cells** = Auto-calculated (don't edit)  
✅ **Named ranges** = Connect sheets automatically  
✅ **$/GSF metrics** = Easy cost tracking  
✅ **% columns** = Show actual rates from Assumptions  
✅ **24-month cash flow** = Realistic funding schedule  
✅ **Instructions sheet** = Built-in user guide  

---

## NEXT STEPS

If you want to add more sheets to the Excel workbook:
- GC RFQ with CSI divisions and labor/material splits
- Pre-sales tracking sheet
- Unit mix and pricing alternatives
- Sensitivity analysis

The workbook is now your **MASTER document** for all budget calculations!
