import openpyxl
from openpyxl import load_workbook

# Load workbook - first without data_only to see formulas
wb = load_workbook('outputs/NEVO_Interactive_Budget_V3.xlsx', data_only=False)

print("\n" + "="*70)
print("WORKBOOK VERIFICATION")
print("="*70)

# Check Hard Costs
ws_hard = wb['Hard Costs']
hard_total_row = None
for row in range(1, 100):
    if ws_hard[f'B{row}'].value == 'TOTAL HARD COSTS':
        hard_total_row = row
        break

if hard_total_row:
    hard_costs_formula = ws_hard[f'E{hard_total_row}'].value
    print(f"\n✓ Hard Costs Total Formula: {hard_costs_formula}")
else:
    print("\n✗ ERROR: Could not find Total Hard Costs")

# Check Soft Costs
ws_soft = wb['Soft Costs']
print("\n" + "-"*70)
print("SOFT COSTS BREAKDOWN (FORMULAS):")
print("-"*70)

for row in range(5, 20):
    category = ws_soft[f'A{row}'].value
    formula = ws_soft[f'B{row}'].value
    timing = ws_soft[f'C{row}'].value
    
    if category and formula and 'Note' not in str(category):
        print(f"{category:30s} {str(formula):40s}  |  {str(timing) if timing else ''}")
    
    if category == 'TOTAL SOFT COSTS':
        total_formula = formula
        total_row = row
        break

print("-"*70)
print(f"TOTAL FORMULA: {total_formula}")

# Check percentage formula
pct_row = total_row + 1
pct_formula = ws_soft[f'B{pct_row}'].value
print(f"\n% of Hard Costs Formula: {pct_formula}")
print(f"Target: 12.0%")

if pct_formula and 'TotalHardCosts' in str(pct_formula):
    print("✓ PASS: Percentage formula references TotalHardCosts")
else:
    print(f"✗ ERROR: Percentage formula doesn't reference TotalHardCosts: {pct_formula}")

# Check Summary sheet
ws_summary = wb['Summary']
print("\n" + "-"*70)
print("SUMMARY SHEET:")
print("-"*70)

for row in range(4, 15):
    label = ws_summary[f'A{row}'].value
    amount = ws_summary[f'B{row}'].value
    pct = ws_summary[f'C{row}'].value
    
    if label and amount:
        if pct and isinstance(pct, (int, float)):
            print(f"{label:30s} ${amount:>12,.0f}  |  {pct:>6.1%}")
        else:
            print(f"{label:30s} ${amount:>12,.0f}")

print("\n" + "="*70)
print("VERIFICATION COMPLETE")
print("="*70)
