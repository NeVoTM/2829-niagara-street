#!/usr/bin/env python3
"""
Calculate soft costs breakdown with financing at 9% interest
"""

# From previous data: Total Hard Costs = ~$32,609,000
# Construction Subtotal ≈ 30,000,000 (rough estimate)

total_hard = 32609000
construction_sub = 30000000  # Approximate
ltc = 0.375
finance_rate = 0.09
duration = 9/12

bridge_loan = construction_sub * ltc
financing_costs = bridge_loan * finance_rate * duration

print(f'Construction Subtotal: ${construction_sub:,.0f}')
print(f'Bridge Loan (37.5% LTC): ${bridge_loan:,.0f}')
print(f'Financing Costs (9% for 9mo): ${financing_costs:,.0f}')
print(f'Financing as % of Hard Costs: {financing_costs/total_hard*100:.2f}%')
print()
print(f'Target Total Soft Costs: ${total_hard*0.12:,.0f}')
print(f'Remaining for other soft costs: ${total_hard*0.12 - financing_costs:,.0f}')
print(f'Remaining %: {(total_hard*0.12 - financing_costs)/total_hard*100:.2f}%')
print()

# Calculate adjustment factor
current_pct = 0.133  # Current total of other soft costs
remaining_pct = (total_hard*0.12 - financing_costs)/total_hard
factor = remaining_pct / current_pct

percentages = {
    'A&E': 0.04,
    'Marketing': 0.025,
    'Legal': 0.01,
    'Dev Fee': 0.015,
    'Permit': 0.015,
    'Impact': 0.01,
    'Plan': 0.005,
    'Insurance': 0.008,
    'Testing': 0.003,
    'Utilities': 0.002
}

print('Adjusted percentages:')
print()
for name, pct in percentages.items():
    new_pct = pct * factor
    print(f'{name:12} {new_pct*100:6.3f}%  ->  0.{int(new_pct*10000):04d}')

total_adjusted = sum(pct * factor for pct in percentages.values())
print(f'\nTotal other soft costs: {total_adjusted*100:.2f}%')
print(f'Financing: {financing_costs/total_hard*100:.2f}%')
print(f'Grand Total: {(total_adjusted + financing_costs/total_hard)*100:.2f}%')
