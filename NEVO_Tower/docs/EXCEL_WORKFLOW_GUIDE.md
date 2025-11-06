# NEVO Tower - Interactive Excel Budget System
## Two-Way Sync: Excel ↔ Python ↔ Reports

---

## Overview

You now have a **fully interactive budget system** where you can edit costs in Excel and have all Python models and reports automatically regenerate.

### System Components

1. **Interactive Excel Workbook** (`outputs/NEVO_Interactive_Budget.xlsx`)
   - 5 sheets: Summary, Assumptions, Hard Costs, Soft Costs, Revenue
   - All formulas auto-calculate in real-time
   - Yellow cells = editable inputs
   - Compatible with Google Sheets import

2. **Python Sync Script** (`scripts/sync_from_excel.py`)
   - Reads Excel workbook (auto-calculates formulas via Excel COM)
   - Updates JSON data files
   - Regenerates markdown reports

3. **Workbook Generator** (`scripts/make_interactive_workbook.py`)
   - Recreates Excel file from scratch with current data
   - Run this if you need a fresh start

---

## Quick Start

### 1. Open the Excel File

```bash
start outputs\NEVO_Interactive_Budget.xlsx
```

Or navigate to the file in Windows Explorer and double-click.

### 2. Edit Yellow Cells

**Yellow-highlighted cells** are editable. Edit any of these:

#### Assumptions Sheet
- Land Cost
- GC Overhead & Profit %
- General Conditions %
- All Contingency %
- A&E Fee Rate
- Marketing Rate
- Financing parameters

#### Hard Costs Sheet
- Any CSI Division rate ($/GSF)
- All rates are editable - formulas calculate totals automatically

#### Soft Costs Sheet
- Building Permit
- Impact Fees
- Legal & Accounting
- Insurance
- Testing & Inspections
- Developer Fee
- (A&E and Marketing are formula-driven from Assumptions)

#### Revenue Sheet
- Unit pricing ($/SF) for each unit type
- Change pricing to test different scenarios

### 3. Watch Formulas Calculate

As you edit yellow cells, Excel automatically recalculates:
- Hard cost subtotals
- Soft cost totals
- Total project cost
- Total revenue
- Profit/loss
- Margins and ROI

**Summary Sheet** shows real-time executive dashboard.

### 4. Save the File

```
Ctrl+S or File > Save
```

### 5. Run Python Sync

```bash
python scripts\sync_from_excel.py
```

This will:
- ✅ Open Excel via COM to ensure formulas are calculated
- ✅ Read all values from the workbook
- ✅ Update `data/hard_costs_detail.json`
- ✅ Update `data/soft_costs_detail.json`
- ✅ Update `data/pro_forma.json`
- ✅ Generate `outputs/UPDATED_SUMMARY.md` with full financial report

### 6. Review Updated Reports

Open the generated markdown file:

```bash
code outputs\UPDATED_SUMMARY.md
```

This report includes:
- Complete cost breakdown
- Revenue analysis
- Profitability metrics
- Feasibility assessment
- Breakeven analysis (if project is underwater)

---

## Workflow Examples

### Example 1: Test Different Pricing

1. Open Excel
2. Go to **Revenue** sheet
3. Change Hospitality pricing from $1,100/SF to $1,200/SF
4. Watch Summary sheet update instantly
5. Save file
6. Run `python scripts\sync_from_excel.py`
7. Review `outputs/UPDATED_SUMMARY.md` for detailed analysis

### Example 2: Reduce Hard Costs

1. Open Excel
2. Go to **Hard Costs** sheet
3. Lower expensive divisions:
   - Concrete from $52/GSF → $48/GSF
   - Finishes from $42/GSF → $38/GSF
4. See totals recalculate
5. Save and sync

### Example 3: Adjust Contingencies

1. Open Excel
2. Go to **Assumptions** sheet
3. Change contingency percentages:
   - Design Contingency: 8% → 5%
   - Construction Contingency: 5% → 3%
4. Watch hard costs decrease
5. Save and sync

### Example 4: Change Financing Terms

1. Open Excel
2. Go to **Assumptions** sheet
3. Adjust:
   - Financing Rate: 9% → 7%
   - Loan to Cost: 60% → 70%
   - Construction Duration: 24 → 20 months
4. Soft costs (financing) will update
5. Save and sync

---

## File Structure

```
NEVO_Tower/
├── outputs/
│   ├── NEVO_Interactive_Budget.xlsx  ← Edit this file
│   └── UPDATED_SUMMARY.md            ← Generated report
├── data/
│   ├── hard_costs_detail.json        ← Auto-updated by sync
│   ├── soft_costs_detail.json        ← Auto-updated by sync
│   └── pro_forma.json                ← Auto-updated by sync
├── scripts/
│   ├── make_interactive_workbook.py  ← Regenerate Excel from Python
│   └── sync_from_excel.py            ← Sync Excel → Python
└── docs/
    └── EXCEL_WORKFLOW_GUIDE.md       ← This file
```

---

## Excel Workbook Structure

### Sheet 1: Summary (Executive Dashboard)
- Total Development Cost breakdown
- Total Revenue
- Profitability metrics (Profit, Margin, ROI)
- Per-unit metrics

**All values are formulas** - they update automatically when you edit other sheets.

### Sheet 2: Assumptions
- Project info (GSF, NSF, units, etc.)
- All cost assumptions (percentages and rates)
- Financing parameters

**Yellow cells are editable** - these drive calculations throughout the workbook.

### Sheet 3: Hard Costs
- 23 CSI MasterFormat divisions
- Each division: Rate ($/GSF) × GSF = Total
- GC costs calculated as % of construction
- Contingencies calculated as % of subtotal

**Yellow cells**: All rates ($/GSF) are editable.

### Sheet 4: Soft Costs
- 11 soft cost line items
- Some formula-driven (A&E, Marketing, Financing)
- Some lump sum (Permits, Legal, etc.)

**Yellow cells**: Lump sum amounts are editable.

### Sheet 5: Revenue
- Revenue by unit type
- Units × NSF × Price/SF = Revenue
- Totals by floor/type

**Yellow cells**: Price per SF is editable.

---

## Formula Logic

### Hard Costs Calculation Flow

```
1. CSI Divisions (rates × GSF) = Construction Subtotal
2. + General Conditions (9% of construction)
3. + Overhead & Profit (10% of construction + GC)
4. = Subtotal Before Contingency
5. + Design Contingency (8%)
6. + Construction Contingency (5%)
7. + Owner Contingency (3%)
8. = TOTAL HARD COSTS
```

### Soft Costs Formula-Driven Items

```
A&E = Total Hard Costs × 4.5%
Marketing = Total Revenue × 2.5%
Financing = (Land + Hard) × LTC × 0.5 × Rate × (Duration/12)
```

### Summary Calculations

```
Total Cost = Land + Hard Costs + Soft Costs
Gross Profit = Total Revenue - Total Cost
Profit Margin = Gross Profit / Total Revenue
ROI = Gross Profit / Total Cost
```

---

## Troubleshooting

### Issue: Formulas showing #VALUE!

**Solution**: Save the Excel file in Excel (Ctrl+S) before running sync script. The sync script uses Excel COM automation to calculate formulas, but the file must be saved first.

### Issue: Sync script fails with "No module named 'win32com'"

**Solution**: Install pywin32:
```bash
pip install pywin32
```

### Issue: Excel file is corrupted or won't open

**Solution**: Regenerate from Python:
```bash
python scripts\make_interactive_workbook.py
```

This creates a fresh Excel file from the current JSON data.

### Issue: Numbers don't match expected values

**Solution**: 
1. Check that you edited the correct yellow cells
2. Verify the Assumptions sheet has correct percentages
3. Ensure all formulas are calculating (look for #VALUE! or #REF! errors)
4. If needed, regenerate: `python scripts\make_interactive_workbook.py`

---

## Advanced: Google Sheets Import

The Excel workbook can be imported to Google Sheets:

1. Go to Google Drive
2. Click **New** > **File Upload**
3. Select `NEVO_Interactive_Budget.xlsx`
4. Right-click the uploaded file > **Open with** > **Google Sheets**
5. Edit as needed
6. **Download** as Excel format
7. Run sync script

**Note**: Some advanced Excel features may not transfer perfectly to Google Sheets, but core formulas will work.

---

## Tips & Best Practices

### 1. Make Small Changes
Test one change at a time so you can understand its impact.

### 2. Use Summary Sheet
Keep Summary sheet visible to see real-time impact of your edits.

### 3. Save Versions
Save different Excel files for different scenarios:
- `NEVO_Budget_Base.xlsx`
- `NEVO_Budget_HighPrice.xlsx`
- `NEVO_Budget_LowCost.xlsx`

Then sync each version to generate different reports.

### 4. Document Changes
Add notes in Excel (right-click cell > Insert Comment) to document why you changed a value.

### 5. Regenerate When Needed
If the Excel file gets messy or formulas break, just regenerate:
```bash
python scripts\make_interactive_workbook.py
```

### 6. Sync Regularly
After making edits, sync immediately to update JSON files:
```bash
python scripts\sync_from_excel.py
```

---

## Command Reference

### Create fresh Excel workbook from Python data
```bash
python scripts\make_interactive_workbook.py
```

### Sync Excel edits back to Python
```bash
python scripts\sync_from_excel.py
```

### Rebuild entire budget from scratch
```bash
python scripts\build_hard_costs.py
python scripts\build_soft_costs.py
python scripts\build_pro_forma.py
python scripts\make_interactive_workbook.py
```

---

## What's Editable?

### ✅ YOU CAN EDIT (Yellow Cells)

**Assumptions Sheet:**
- All cost assumptions
- All financial parameters
- Project parameters (use with caution)

**Hard Costs Sheet:**
- All CSI division rates ($/GSF)

**Soft Costs Sheet:**
- Building Permit amount
- Impact Fees amount
- Plan Review amount
- Legal & Accounting amount
- Insurance amount
- Testing & Inspections amount
- Utilities & Misc amount
- Developer Fee amount

**Revenue Sheet:**
- All unit pricing ($/SF)

### ❌ DO NOT EDIT (Formula Cells)

- Summary sheet (all formulas)
- Hard Costs: GSF column, Total column, subtotals
- Soft Costs: A&E, Marketing, Financing (formula-driven)
- Revenue: NSF column, Total Revenue column

---

## Next Steps

1. **Open the Excel file** and explore all sheets
2. **Make a test edit** (e.g., change a price or cost)
3. **Watch the Summary sheet** update in real-time
4. **Save** the file
5. **Run sync**: `python scripts\sync_from_excel.py`
6. **Review** the generated report: `outputs\UPDATED_SUMMARY.md`

---

## Questions?

- Review the generated reports in `outputs/`
- Check the JSON files in `data/` to see the underlying data
- Run scripts with `--help` for more options (if implemented)

**Happy budgeting!** 🎉
