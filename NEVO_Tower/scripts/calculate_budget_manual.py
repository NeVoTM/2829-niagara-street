#!/usr/bin/env python3
"""Manual calculation to verify we hit the targets"""

GSF = 108675

# CSI Divisions from script - ADJUSTED TO HIT $300/GSF TARGET
csi_rates = [
    10.53,  # 01 General Requirements
    4.56,   # 02 Existing Conditions
    39.47,  # 03 Concrete
    2.46,   # 04 Masonry
    7.45,   # 05 Metals
    2.81,   # 06 Wood & Plastics
    19.30,  # 07 Thermal & Moisture
    24.55,  # 08 Openings
    36.83,  # 09 Finishes
    3.95,   # 10 Specialties
    3.33,   # 11 Equipment
    1.05,   # 12 Furnishings
    1.58,   # 13 Special Construction
    2.72,   # 14 Conveying Equipment
    6.58,   # 21 Fire Suppression
    8.77,   # 22 Plumbing
    13.15,  # 23 HVAC
    13.15,  # 26 Electrical
    1.75,   # 27 Communications
    1.75,   # 28 Electronic Safety
    3.68,   # 31 Earthwork
    3.51,   # 32 Exterior Improvements
    2.81,   # 33 Utilities
]

# Calculate base construction cost
base_cost_per_sf = sum(csi_rates)
base_cost_total = base_cost_per_sf * GSF

print(f"BASE CONSTRUCTION COST:")
print(f"  Rate/SF: ${base_cost_per_sf:.2f}")
print(f"  Total: ${base_cost_total:,.0f}")
print()

# Add GC, OH&P, Contingencies (from script: 9%, 10%, 8%, 5%, 3%)
gc_rate = 0.09
gc_cost = base_cost_total * gc_rate

ohp_rate = 0.10
ohp_cost = (base_cost_total + gc_cost) * ohp_rate

subtotal_before_cont = base_cost_total + gc_cost + ohp_cost

design_cont = subtotal_before_cont * 0.08
constr_cont = subtotal_before_cont * 0.05
owner_cont = subtotal_before_cont * 0.03

total_hard_costs = subtotal_before_cont + design_cont + constr_cont + owner_cont

print(f"MARKUPS:")
print(f"  GC (9%): ${gc_cost:,.0f}")
print(f"  OH&P (10%): ${ohp_cost:,.0f}")
print(f"  Design Cont (8%): ${design_cont:,.0f}")
print(f"  Constr Cont (5%): ${constr_cont:,.0f}")
print(f"  Owner Cont (3%): ${owner_cont:,.0f}")
print()

print(f"TOTAL HARD COSTS: ${total_hard_costs:,.0f}")
print(f"Hard Cost/GSF: ${total_hard_costs/GSF:.2f}")
print()

# Soft Costs
# Fixed items - REDUCED TO HIT TARGET
fixed_soft = (
    180000 +  # Building Permit
    150000 +  # Impact Fees
    50000 +   # Plan Review
    100000 +  # Legal & Accounting
    80000 +   # Insurance
    70000 +   # Testing
    30000 +   # Utilities
    20000     # Developer Fee
)

# A&E (4.5% of hard costs)
ae_cost = total_hard_costs * 0.045

# Revenue (from pro_forma.json - CORRECTED)
revenue = (
    25200 * 1200 +  # Floors 4-5: 32 units × 25,200 NSF × $1,200/SF
    8680 * 1200 +   # Floor 6: 10 units × 8,680 NSF × $1,200/SF
    8680 * 1200 +   # Floor 7: 8 units × 8,680 NSF × $1,200/SF
    10500 * 400     # Floor 1: Chabad at cost $400/SF
)

# Marketing (2.5% of revenue)
marketing_cost = revenue * 0.025

# Financing (construction loan interest - 12 months, 8.5% rate)
# Loan amount = 75% of (land + hard costs) = 0.75 × ($8M + $32.6M) = $30.45M
# Avg balance = 50% × $30.45M = $15.225M
# Interest = $15.225M × 8.5% × (12/12) = $1,294,125
land_value = 8000000
loan_amount = (land_value + total_hard_costs) * 0.75
avg_balance = loan_amount * 0.5
duration_years = 12 / 12
interest_rate = 0.085
financing_cost = avg_balance * interest_rate * duration_years

total_soft_costs = fixed_soft + ae_cost + marketing_cost + financing_cost

print(f"SOFT COSTS:")
print(f"  Fixed Items: ${fixed_soft:,.0f}")
print(f"  A&E (4.5% of hard): ${ae_cost:,.0f}")
print(f"  Marketing (2.5% of rev): ${marketing_cost:,.0f}")
print(f"  Financing (loan interest): ${financing_cost:,.0f}")
print(f"  TOTAL SOFT: ${total_soft_costs:,.0f}")
print(f"  Soft Cost/GSF: ${total_soft_costs/GSF:.2f}")
print(f"  Soft as % of Hard: {(total_soft_costs/total_hard_costs)*100:.1f}%")
print()

print(f"REVENUE: ${revenue:,.0f}")
print()

total_costs = total_hard_costs + total_soft_costs
profit = revenue - total_costs
margin = (profit / revenue) * 100

print(f"PROFITABILITY:")
print(f"  Total Costs: ${total_costs:,.0f}")
print(f"  Gross Profit: ${profit:,.0f}")
print(f"  Profit Margin: {margin:.1f}%")
print()

print(f"=" * 60)
print(f"TARGET VERIFICATION:")
print(f"  ✓ Hard Costs Target: $300/GSF → Actual: ${total_hard_costs/GSF:.2f}/GSF")
target_hard = 300 * GSF
if abs(total_hard_costs - target_hard) < 100000:
    print(f"    ✅ WITHIN RANGE!")
else:
    diff = total_hard_costs - target_hard
    print(f"    ⚠️  Off by ${diff:,.0f}")

print(f"  ✓ Soft Costs Target: $45/GSF → Actual: ${total_soft_costs/GSF:.2f}/GSF")
target_soft = 45 * GSF
if abs(total_soft_costs - target_soft) < 100000:
    print(f"    ✅ WITHIN RANGE!")
else:
    diff = total_soft_costs - target_soft
    print(f"    ⚠️  Off by ${diff:,.0f}")

print(f"  ✓ Profit Margin Target: 30% → Actual: {margin:.1f}%")
if margin >= 30.0:
    print(f"    ✅ PROJECT MEETS 30% PROFIT MARGIN TARGET!")
else:
    shortfall = (0.30 * revenue) - profit
    print(f"    ❌ BELOW 30% - Need ${shortfall:,.0f} more profit")
