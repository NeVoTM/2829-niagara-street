revenue = 55272000
hard = 32609001
soft = 4823617
sc_cash = 2000000

total_cost = hard + soft + sc_cash
profit = revenue - total_cost
margin = (profit / revenue) * 100

print(f'Revenue: ${revenue:,.0f}')
print(f'Hard Costs: ${hard:,.0f}')
print(f'Soft Costs: ${soft:,.0f}')
print(f'SC Cash Payments: ${sc_cash:,.0f}')
print(f'TOTAL COSTS: ${total_cost:,.0f}')
print()
print(f'Profit: ${profit:,.0f}')
print(f'Margin: {margin:.1f}%')
print()

if margin < 30:
    shortfall = (0.30 * revenue) - profit
    print(f'❌ BELOW 30% - need to reduce costs by ${shortfall:,.0f}')
    print(f'   Target costs: ${revenue * 0.70:,.0f}')
else:
    print(f'✅ MEETS 30% TARGET!')
