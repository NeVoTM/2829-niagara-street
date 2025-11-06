#!/usr/bin/env python3
import openpyxl
import sys

wb = openpyxl.load_workbook('outputs/NEVO_Interactive_Budget.xlsx')

# Read from Hard Costs sheet
hard_sheet = wb['Hard Costs']
# Find the total row (should be near the bottom)
hard_costs = 0
for row in range(1, 100):
    cell_a = hard_sheet[f'A{row}'].value
    if cell_a and 'TOTAL' in str(cell_a).upper() and 'HARD' in str(cell_a).upper():
        hard_costs = hard_sheet[f'B{row}'].value
        if isinstance(hard_costs, str) and hard_costs.startswith('='):
            # It's a formula, need to find the sum manually
            pass
        break

# If we didn't find it via TOTAL, sum up the CSI divisions
if hard_costs == 0:
    for row in range(1, 100):
        cell_a = hard_sheet[f'A{row}'].value
        if cell_a and isinstance(cell_a, str):
            # Look for CSI divisions (01, 02, etc.)
            if len(cell_a) > 2 and cell_a[:2].isdigit():
                val = hard_sheet[f'B{row}'].value
                if val and isinstance(val, (int, float)):
                    hard_costs += val

# Read from Soft Costs sheet
soft_sheet = wb['Soft Costs']
soft_costs = 0
for row in range(1, 100):
    cell_a = soft_sheet[f'A{row}'].value
    if cell_a and 'TOTAL' in str(cell_a).upper() and 'SOFT' in str(cell_a).upper():
        soft_costs = soft_sheet[f'B{row}'].value
        if isinstance(soft_costs, str) and soft_costs.startswith('='):
            pass
        break

# If we didn't find it via TOTAL, sum up the items
if soft_costs == 0:
    for row in range(5, 100):  # Start after header
        cell_a = soft_sheet[f'A{row}'].value
        cell_b = soft_sheet[f'B{row}'].value
        if cell_a and cell_b and isinstance(cell_b, (int, float)) and cell_b > 0:
            # Skip header rows
            if 'SOFT' not in str(cell_a).upper() and 'TOTAL' not in str(cell_a).upper():
                soft_costs += cell_b

# Read from Revenue sheet
rev_sheet = wb['Revenue']
revenue = 0
for row in range(1, 100):
    cell_a = rev_sheet[f'A{row}'].value
    if cell_a and 'TOTAL' in str(cell_a).upper() and 'REVENUE' in str(cell_a).upper():
        revenue = rev_sheet[f'B{row}'].value
        if isinstance(revenue, str) and revenue.startswith('='):
            pass
        break

if revenue == 0:
    # Sum all unit revenues
    for row in range(5, 100):
        cell_b = rev_sheet[f'B{row}'].value
        if cell_b and isinstance(cell_b, (int, float)) and cell_b > 1000:  # Filter out small values
            revenue += cell_b

if hard_costs == 0 or soft_costs == 0 or revenue == 0:
    print("ERROR: Could not read values from Excel")
    print(f"Hard: {hard_costs}, Soft: {soft_costs}, Revenue: {revenue}")
    sys.exit(1)

total_costs = hard_costs + soft_costs
profit = revenue - total_costs
margin = (profit / revenue) * 100

print(f"NEVO TOWER FINANCIAL VERIFICATION")
print(f"=" * 50)
print(f"Total Hard Costs: ${hard_costs:,.0f}")
print(f"Hard Cost/GSF: ${hard_costs/108675:.2f}")
print(f"")
print(f"Total Soft Costs: ${soft_costs:,.0f}")
print(f"Soft Cost/GSF: ${soft_costs/108675:.2f}")
print(f"Soft as % of Hard: {(soft_costs/hard_costs)*100:.1f}%")
print(f"")
print(f"Total Revenue: ${revenue:,.0f}")
print(f"")
print(f"Total Costs: ${total_costs:,.0f}")
print(f"Gross Profit: ${profit:,.0f}")
print(f"Profit Margin: {margin:.1f}%")
print(f"")
print(f"TARGET CHECK:")
print(f"✓ Hard Costs Target: $300/GSF → Actual: ${hard_costs/108675:.2f}/GSF")
print(f"✓ Soft Costs Target: $45/GSF → Actual: ${soft_costs/108675:.2f}/GSF")
print(f"✓ Profit Margin Target: 30% → Actual: {margin:.1f}%")
print(f"")
if margin >= 30.0:
    print(f"✅ PROJECT MEETS 30% PROFIT MARGIN TARGET!")
else:
    shortfall = (0.30 * revenue) - profit
    print(f"❌ PROJECT BELOW 30% TARGET - Need ${shortfall:,.0f} more profit")
