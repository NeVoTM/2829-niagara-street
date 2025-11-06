revenue = 55272000
hard = 32609001
sc_cash = 2000000
GSF = 108675

# Constraint 1: Soft costs max 15% of hard costs
max_soft_from_hard = hard * 0.15
print(f"CONSTRAINT 1: Soft costs ≤ 15% of hard costs")
print(f"  Max soft: ${max_soft_from_hard:,.0f}")
print(f"  Max soft/GSF: ${max_soft_from_hard/GSF:.2f}")
print()

# Constraint 2: Total costs for 30% margin
target_total_cost = revenue * 0.70
max_soft_from_margin = target_total_cost - hard - sc_cash
print(f"CONSTRAINT 2: 30% profit margin")
print(f"  Target total cost (70% of revenue): ${target_total_cost:,.0f}")
print(f"  Hard + SC Cash: ${hard + sc_cash:,.0f}")
print(f"  Max soft: ${max_soft_from_margin:,.0f}")
print(f"  Max soft/GSF: ${max_soft_from_margin/GSF:.2f}")
print()

# Use the smaller of the two constraints
max_soft = min(max_soft_from_hard, max_soft_from_margin)
print(f"FINAL MAX SOFT COSTS: ${max_soft:,.0f} (${max_soft/GSF:.2f}/GSF)")
print()

# Now calculate what we can afford
# Formula-based costs that we can't change much:
ae = hard * 0.045
marketing = revenue * 0.025
# Financing on $8M land + $32.6M hard = $40.6M × 75% = $30.45M loan
loan = (8000000 + hard) * 0.75
interest = loan * 0.5 * 0.085 * (12/12)
formula_costs = ae + marketing + interest

print(f"FORMULA-BASED SOFT COSTS (unavoidable):")
print(f"  A&E (4.5% of hard): ${ae:,.0f}")
print(f"  Marketing (2.5% of rev): ${marketing:,.0f}")
print(f"  Financing interest: ${interest:,.0f}")
print(f"  Total formula: ${formula_costs:,.0f}")
print()

remaining = max_soft - formula_costs
print(f"REMAINING FOR FIXED ITEMS: ${remaining:,.0f}")
print()

if remaining < 0:
    print(f"❌ PROBLEM: Formula costs exceed max soft costs by ${-remaining:,.0f}!")
    print(f"   Need to reduce A&E, Marketing, or Financing rates")
else:
    print(f"✅ Can allocate ${remaining:,.0f} to fixed soft cost items")
