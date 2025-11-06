"""
Update NEVO Interactive Budget Excel with new land partner structure.

Land Partner Structure:
- Land contribution: $10M (in-kind equity)
- Cash at Month 0: $1M
- Cash at Month 6: $1M
- Total cash: $2M
- Remaining $8M paid from profits after loan payoff
"""

import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from datetime import datetime

# Load existing workbook
wb = openpyxl.load_workbook('C:/Users/17274/ME/2829-Niagara-Street/NEVO_Tower/outputs/NEVO_Interactive_Budget.xlsx')

# Update Assumptions sheet
ws_assumptions = wb['Assumptions']

# Find and update land cost section
# Change "Land Cost" to "Land Partner (In-Kind)"
for row in range(1, 50):
    cell_value = ws_assumptions[f'A{row}'].value
    if cell_value and 'Land Cost' in str(cell_value):
        ws_assumptions[f'A{row}'] = 'Land Partner (In-Kind Equity)'
        ws_assumptions[f'B{row}'].value = 10000000
        ws_assumptions[f'B{row}'].number_format = '$#,##0'
        # Add note
        ws_assumptions[f'C{row}'] = 'Land contributed as partnership equity'
        break

# Add new rows for land partner cash contributions
# Find where to insert (after land row)
insert_row = None
for row in range(1, 50):
    if ws_assumptions[f'A{row}'].value and 'Land Partner' in str(ws_assumptions[f'A{row}'].value):
        insert_row = row + 1
        break

if insert_row:
    # Insert rows for cash contributions
    ws_assumptions.insert_rows(insert_row, 3)
    
    # Land Partner Cash - Month 0
    ws_assumptions[f'A{insert_row}'] = 'Land Partner Cash (Month 0)'
    ws_assumptions[f'B{insert_row}'] = 1000000
    ws_assumptions[f'B{insert_row}'].number_format = '$#,##0'
    ws_assumptions[f'C{insert_row}'] = 'First cash injection at closing'
    
    # Land Partner Cash - Month 6
    ws_assumptions[f'A{insert_row+1}'] = 'Land Partner Cash (Month 6)'
    ws_assumptions[f'B{insert_row+1}'] = 1000000
    ws_assumptions[f'B{insert_row+1}'].number_format = '$#,##0'
    ws_assumptions[f'C{insert_row+1}'] = 'Second cash injection'
    
    # Land Partner Deferred
    ws_assumptions[f'A{insert_row+2}'] = 'Land Partner Deferred Payment'
    ws_assumptions[f'B{insert_row+2}'] = 8000000
    ws_assumptions[f'B{insert_row+2}'].number_format = '$#,##0'
    ws_assumptions[f'C{insert_row+2}'] = 'Paid from profits after loan payoff'

# Update Summary sheet
ws_summary = wb['Summary']

# Find Development Costs section and update
for row in range(1, 100):
    cell_value = ws_summary[f'A{row}'].value
    
    if cell_value == 'Land Cost':
        ws_summary[f'A{row}'] = 'Land Partner (In-Kind)'
        # Keep the $10M value but add note
        ws_summary[f'C{row}'] = 'Contributed as equity'
        
        # Add cash contributions
        ws_summary.insert_rows(row + 1, 2)
        
        ws_summary[f'A{row+1}'] = 'Land Partner Cash (M0+M6)'
        ws_summary[f'B{row+1}'] = 2000000
        ws_summary[f'B{row+1}'].number_format = '$#,##0'
        ws_summary[f'C{row+1}'] = '$1M at closing, $1M at Month 6'
        
        ws_summary[f'A{row+2}'] = 'Land Partner Deferred'
        ws_summary[f'B{row+2}'] = 8000000
        ws_summary[f'B{row+2}'].number_format = '$#,##0'
        ws_summary[f'C{row+2}'] = 'From profits after loan payoff'
        
        break

# Update Financing section
for row in range(1, 100):
    cell_value = ws_summary[f'A{row}'].value
    
    if cell_value and 'Total Development Cost' in str(cell_value):
        total_row = row
        
        # Find equity calculation rows below
        for r in range(total_row, total_row + 20):
            if ws_summary[f'A{r}'].value and 'Equity' in str(ws_summary[f'A{r}'].value):
                # Update equity calculation
                ws_summary[f'C{r}'] = 'Land ($10M) + Cash ($2M) = $12M + Developer equity'
                break

# Add new section for Capital Stack
capital_stack_row = None
for row in range(1, 100):
    if ws_summary[f'A{row}'].value and 'Profitability' in str(ws_summary[f'A{row}'].value):
        capital_stack_row = row + 10
        break

if capital_stack_row:
    ws_summary[f'A{capital_stack_row}'] = 'CAPITAL STACK BREAKDOWN'
    ws_summary[f'A{capital_stack_row}'].font = Font(bold=True, size=12)
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'Source'
    ws_summary[f'B{capital_stack_row}'] = 'Amount'
    ws_summary[f'C{capital_stack_row}'] = 'Notes'
    capital_stack_row += 1
    
    # Land Partner contributions
    ws_summary[f'A{capital_stack_row}'] = 'Land Partner - Land (In-Kind)'
    ws_summary[f'B{capital_stack_row}'] = 10000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'C{capital_stack_row}'] = 'Contributed as equity'
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'Land Partner - Cash (Upfront)'
    ws_summary[f'B{capital_stack_row}'] = 2000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'C{capital_stack_row}'] = '$1M Month 0 + $1M Month 6'
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'Land Partner - Deferred'
    ws_summary[f'B{capital_stack_row}'] = 8000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'C{capital_stack_row}'] = 'From profits after loan payoff'
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'Developer Equity'
    ws_summary[f'B{capital_stack_row}'] = 8000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'C{capital_stack_row}'] = '~20% of hard costs'
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'Construction Loan (75% LTC)'
    ws_summary[f'B{capital_stack_row}'] = 30000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'C{capital_stack_row}'] = '75% of hard costs'
    capital_stack_row += 1
    
    ws_summary[f'A{capital_stack_row}'] = 'TOTAL SOURCES'
    ws_summary[f'B{capital_stack_row}'] = 58000000
    ws_summary[f'B{capital_stack_row}'].number_format = '$#,##0'
    ws_summary[f'A{capital_stack_row}'].font = Font(bold=True)
    ws_summary[f'B{capital_stack_row}'].font = Font(bold=True)

# Save the updated workbook
output_path = 'C:/Users/17274/ME/2829-Niagara-Street/NEVO_Tower/outputs/NEVO_Interactive_Budget.xlsx'
wb.save(output_path)

print(f"✅ Successfully updated Excel workbook: {output_path}")
print("\nUpdates made:")
print("1. Changed 'Land Cost' to 'Land Partner (In-Kind Equity)' - $10M")
print("2. Added 'Land Partner Cash (Month 0)' - $1M")
print("3. Added 'Land Partner Cash (Month 6)' - $1M")
print("4. Added 'Land Partner Deferred Payment' - $8M (from profits)")
print("5. Added Capital Stack Breakdown section")
print("\nTotal Land Partner Investment: $20M ($10M land + $2M cash + $8M deferred)")
