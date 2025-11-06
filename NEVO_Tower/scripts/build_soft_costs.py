"""
NEVO Tower Soft Cost Model
Target: $4,000,000
"""

import json
from pathlib import Path
from datetime import datetime

# Load hard costs
with open('data/hard_costs_detail.json', 'r') as f:
    hard_costs_data = json.load(f)

# Load project data
with open('data/nevo_parsed.json', 'r') as f:
    project_data = json.load(f)

TOTAL_HARD_COSTS = hard_costs_data['summary']['total_hard_costs']
TOTAL_REVENUE = project_data['financial_summary']['total_revenue']
TARGET_SOFT_COSTS = 4000000

def calculate_soft_costs():
    """Calculate soft costs to meet $4M target"""
    
    print("="*80)
    print("NEVO TOWER SOFT COST MODEL")
    print(f"Target Budget: ${TARGET_SOFT_COSTS:,}")
    print("="*80)
    print(f"\nHard Costs (Base): ${TOTAL_HARD_COSTS:,.0f}")
    print(f"Revenue Estimate: ${TOTAL_REVENUE:,.0f}\n")
    
    # Calculate soft cost components
    soft_costs = {}
    
    # 1. Architecture & Engineering (4.5% of hard costs)
    ae_rate = 0.045
    ae_fees = TOTAL_HARD_COSTS * ae_rate
    soft_costs['architecture_engineering'] = {
        'name': 'Architecture & Engineering',
        'rate': f'{ae_rate*100:.1f}% of hard costs',
        'amount': ae_fees,
        'breakdown': {
            'Architecture': TOTAL_HARD_COSTS * 0.030,
            'Structural Engineering': TOTAL_HARD_COSTS * 0.008,
            'MEP Engineering': TOTAL_HARD_COSTS * 0.010,
            'Civil Engineering': TOTAL_HARD_COSTS * 0.003,
            'Specialty Consultants': TOTAL_HARD_COSTS * 0.004,
        }
    }
    
    # 2. Permits & Impact Fees
    permits_fees = {
        'Building Permit': 300000,
        'Impact Fees (Water/Sewer/Traffic)': 380000,
        'Plan Review': 95000,
        'Special Inspections': 45000,
    }
    total_permits = sum(permits_fees.values())
    soft_costs['permits_fees'] = {
        'name': 'Permits & Impact Fees',
        'amount': total_permits,
        'breakdown': permits_fees
    }
    
    # 3. Legal, Accounting, Title
    legal_costs = {
        'Legal (Development/Entity/Contracts)': 175000,
        'Accounting & Audit': 50000,
        'Title & Survey': 40000,
        'Closing Costs': 25000,
    }
    total_legal = sum(legal_costs.values())
    soft_costs['legal_accounting'] = {
        'name': 'Legal, Accounting & Title',
        'amount': total_legal,
        'breakdown': legal_costs
    }
    
    # 4. Marketing & Sales (3% of revenue - ADJUSTED TO FIT BUDGET)
    # Note: 3% of $61.7M = $1.85M, but we need to fit $4M total
    sales_rate = 0.025  # Reduced to 2.5%
    marketing_sales = TOTAL_REVENUE * sales_rate
    soft_costs['marketing_sales'] = {
        'name': 'Marketing & Sales',
        'rate': f'{sales_rate*100:.1f}% of revenue',
        'amount': marketing_sales,
        'breakdown': {
            'Broker Commissions (Outside)': TOTAL_REVENUE * 0.015,
            'Broker Commissions (Inside)': TOTAL_REVENUE * 0.010,
            'Marketing Materials': 100000,
            'Sales Center/Model': 150000,
            'Website & Digital': 50000,
        }
    }
    
    # 5. Insurance (Pre-Construction)
    insurance_costs = {
        'Builders Risk (during construction)': 0,  # In hard costs
        'Liability Insurance': 75000,
        'Title Insurance': 45000,
        'Other Insurance': 30000,
    }
    total_insurance = sum(insurance_costs.values())
    soft_costs['insurance'] = {
        'name': 'Insurance',
        'amount': total_insurance,
        'breakdown': insurance_costs
    }
    
    # 6. Financing Costs (Construction Loan)
    # Assume 60% loan-to-cost, 9% interest, 24 month term
    loan_amount = (TOTAL_HARD_COSTS + TARGET_SOFT_COSTS) * 0.60
    interest_rate = 0.09
    months = 24
    avg_balance = loan_amount * 0.50  # Average drawdown
    interest_cost = avg_balance * interest_rate * (months/12)
    
    origination_fee = loan_amount * 0.005  # 0.5% origination
    
    financing_costs = {
        'Construction Loan Interest': interest_cost,
        'Loan Origination Fee': origination_fee,
        'Lender Legal': 30000,
        'Appraisal': 25000,
    }
    total_financing = sum(financing_costs.values())
    soft_costs['financing'] = {
        'name': 'Financing Costs',
        'amount': total_financing,
        'assumptions': f'60% LTC, 9% rate, 24 months',
        'breakdown': financing_costs
    }
    
    # 7. Testing & Inspections
    testing_costs = {
        'Geotechnical Testing': 35000,
        'Materials Testing': 85000,
        'Special Inspections': 95000,
        'Commissioning': 45000,
    }
    total_testing = sum(testing_costs.values())
    soft_costs['testing'] = {
        'name': 'Testing & Inspections',
        'amount': total_testing,
        'breakdown': testing_costs
    }
    
    # 8. Utilities & Temp Services (Pre-Construction)
    utilities = {
        'Utility Connections': 80000,
        'Temporary Power': 0,  # In GC costs
        'HOA Formation & Docs': 35000,
    }
    total_utilities = sum(utilities.values())
    soft_costs['utilities_misc'] = {
        'name': 'Utilities & Miscellaneous',
        'amount': total_utilities,
        'breakdown': utilities
    }
    
    # 9. Developer Fee (ADJUSTED TO FIT BUDGET)
    # Typical 5% of hard costs, but reduced to fit $4M target
    developer_fee_amount = 200000  # Reduced to fit budget
    soft_costs['developer_fee'] = {
        'name': 'Developer Fee',
        'amount': developer_fee_amount,
        'note': 'Reduced to meet $4M soft cost target'
    }
    
    # Calculate totals
    total_soft_costs = sum(item['amount'] for item in soft_costs.values())
    variance = total_soft_costs - TARGET_SOFT_COSTS
    variance_pct = (variance / TARGET_SOFT_COSTS) * 100
    
    # Display results
    print("SOFT COST BREAKDOWN:")
    print("-" * 80)
    print(f"{'Category':<40} {'Amount':>15} {'% of Total':>12}")
    print("-" * 80)
    
    for key, item in soft_costs.items():
        pct = (item['amount'] / total_soft_costs) * 100
        print(f"{item['name']:<40} ${item['amount']:>14,.0f} {pct:>11.1f}%")
    
    print("-" * 80)
    print(f"{'TOTAL SOFT COSTS':<40} ${total_soft_costs:>14,.0f} {'100.0%':>12}")
    print()
    print(f"Target Budget: ${TARGET_SOFT_COSTS:,}")
    print(f"Variance: ${variance:+,.0f} ({variance_pct:+.1f}%)")
    
    if abs(variance) > TARGET_SOFT_COSTS * 0.05:
        print(f"\n⚠️  WARNING: Variance exceeds 5% of target!")
        print("Consider adjustments to:")
        print("  - Marketing/Sales commissions (currently 2.5% vs typical 3%)")
        print("  - Developer fee (currently $200K vs typical 5% = $2M)")
        print("  - Financing structure (reduce loan-to-cost ratio)")
    else:
        print(f"\n✅ Soft costs within 5% of ${TARGET_SOFT_COSTS:,} target")
    
    # Save output
    output = {
        'target_budget': TARGET_SOFT_COSTS,
        'total_soft_costs': total_soft_costs,
        'variance': variance,
        'variance_percent': variance_pct,
        'soft_cost_categories': soft_costs,
        'assumptions': {
            'hard_costs_base': TOTAL_HARD_COSTS,
            'revenue_estimate': TOTAL_REVENUE,
            'ae_rate': ae_rate,
            'marketing_rate': sales_rate,
            'financing_ltc': 0.60,
            'financing_rate': 0.09,
            'financing_months': 24,
        },
        'generated_date': datetime.now().isoformat(),
    }
    
    output_path = Path('data/soft_costs_detail.json')
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"\n✅ Soft cost details saved to: {output_path}")
    print("="*80)
    
    return output

if __name__ == "__main__":
    calculate_soft_costs()
