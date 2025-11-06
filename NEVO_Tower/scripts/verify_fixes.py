import openpyxl

wb = openpyxl.load_workbook('outputs/NEVO_Interactive_Budget_V3.xlsx')

print("\n" + "="*70)
print("VERIFICATION OF 4 FIXES")
print("="*70)

# Fix 1: Check alignment in Summary sheet
ws_summary = wb['Summary']
print("\n1. SUMMARY SHEET - Column C Alignment:")
for row in range(5, 10):
    label = ws_summary[f'A{row}'].value
    value_b = ws_summary[f'B{row}'].value
    value_c = ws_summary[f'C{row}'].value
    if label:
        print(f"   Row {row}: {label:30s} | C={value_c}")

# Fix 2: Check column widths
print(f"\n2. COLUMN WIDTHS:")
print(f"   Summary B: {ws_summary.column_dimensions['B'].width}")
print(f"   Summary C: {ws_summary.column_dimensions['C'].width}")

ws_assumptions = wb['Assumptions']
print(f"   Assumptions B: {ws_assumptions.column_dimensions['B'].width}")
print(f"   Assumptions C: {ws_assumptions.column_dimensions['C'].width}")

# Fix 3: Check Hard Costs GSF formula
ws_hard = wb['Hard Costs']
print(f"\n3. HARD COSTS - GSF Formula:")
for row in range(4, 8):
    desc = ws_hard[f'B{row}'].value
    gsf_formula = ws_hard[f'D{row}'].value
    if desc:
        print(f"   {desc:30s} | GSF: {gsf_formula}")

# Fix 4: Check pre-sales payment structure
ws_cash = wb['24-Month Cash Flow']
print(f"\n4. PRE-SALES PAYMENT STRUCTURE:")
print(f"   Header: {ws_cash['F4'].value}")
for month in [1, 5, 9]:
    row = 4 + month
    units = ws_cash[f'E{row}'].value
    formula = ws_cash[f'F{row}'].value
    print(f"   Month {month}: Units={units} | Formula: {formula}")

print("\n" + "="*70)
print("VERIFICATION COMPLETE")
print("="*70)
