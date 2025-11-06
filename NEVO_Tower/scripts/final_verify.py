revenue = 55272000
hard = 32609001
sc_cash = 2000000
GSF = 108675

# Soft costs with new rates
ae = hard * 0.038
marketing = revenue * 0.020
loan = (8000000 + hard) * 0.75
interest = loan * 0.5 * 0.085
fixed = 50000 + 30000 + 15000 + 20000 + 10000 + 5000 + 3000 + 2000
soft = ae + marketing + interest + fixed

total_cost = sc_cash + hard + soft
profit = revenue - total_cost
margin = (profit / revenue) * 100

print("=" * 60)
print("FINAL NEVO TOWER BUDGET VERIFICATION")
print("=" * 60)
print()
print(f"Revenue: ${revenue:,.0f}")
print()
print(f"COSTS:")
print(f"  SC Cash Payments: ${sc_cash:,.0f}")
print(f"  Hard Costs: ${hard:,.0f} (${hard/GSF:.2f}/GSF)")
print(f"  Soft Costs:")
print(f"    A&E (3.8%): ${ae:,.0f}")
print(f"    Marketing (2.0%): ${marketing:,.0f}")
print(f"    Financing: ${interest:,.0f}")
print(f"    Fixed items: ${fixed:,.0f}")
print(f"  TOTAL SOFT: ${soft:,.0f} (${soft/GSF:.2f}/GSF)")
print()
print(f"TOTAL COSTS: ${total_cost:,.0f} (${total_cost/GSF:.2f}/GSF)")
print()
print(f"PROFIT: ${profit:,.0f}")
print(f"MARGIN: {margin:.1f}%")
print()
print("=" * 60)
print("TARGET VERIFICATION:")
print("=" * 60)

# Check 1: Hard costs ~$300/GSF
hard_gsf = hard / GSF
if 299 <= hard_gsf <= 301:
    print(f"✅ Hard Costs: ${hard_gsf:.2f}/GSF (target $300/GSF)")
else:
    print(f"❌ Hard Costs: ${hard_gsf:.2f}/GSF (target $300/GSF)")

# Check 2: Soft costs ≤ 15% of hard
soft_pct = (soft / hard) * 100
soft_gsf = soft / GSF
if soft_pct <= 15:
    print(f"✅ Soft Costs: {soft_pct:.1f}% of hard (${soft_gsf:.2f}/GSF)")
else:
    print(f"❌ Soft Costs: {soft_pct:.1f}% of hard (${soft_gsf:.2f}/GSF) - exceeds 15%!")

# Check 3: Profit margin ≥ 30%
if margin >= 30:
    print(f"✅ Profit Margin: {margin:.1f}% (target ≥30%)")
else:
    print(f"❌ Profit Margin: {margin:.1f}% (target ≥30%)")

print()
if hard_gsf >= 299 and soft_pct <= 15 and margin >= 30:
    print("🎉 ALL TARGETS MET!")
else:
    print("⚠️  Some targets not met")
