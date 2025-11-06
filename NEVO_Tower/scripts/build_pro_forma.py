"""
NEVO Tower Pro Forma
Financial analysis at $1,000/SF target
"""

import json
from pathlib import Path
from datetime import datetime

# Load all data
with open('data/nevo_parsed.json', 'r') as f:
    project_data = json.load(f)

with open('data/hard_costs_detail.json', 'r') as f:
    hard_costs = json.load(f)

with open('data/soft_costs_detail.json', 'r') as f:
    soft_costs = json.load(f)

# Constants
LAND_COST = 10000000
TARGET_PRICE_PSF = 1000
TOTAL_NSF = project_data['building_totals']['total_nsf']
RESIDENTIAL_UNITS = project_data['building_totals']['residential_units']

def calculate_pro_forma():
    """Calculate comprehensive pro forma"""
    
    print("="*80)
    print("NEVO TOWER PRO FORMA")
    print("="*80)
    
    # COSTS
    land = LAND_COST
    hard = hard_costs['summary']['total_hard_costs']
    soft = soft_costs['total_soft_costs']
    
    total_costs = land + hard + soft
    
    print(f"\nTOTAL DEVELOPMENT COST:")
    print("-" * 80)
    print(f"  Land Acquisition:           ${land:>15,.0f}")
    print(f"  Hard Costs:                 ${hard:>15,.0f}")
    print(f"  Soft Costs:                 ${soft:>15,.0f}")
    print("-" * 80)
    print(f"  TOTAL PROJECT COST:         ${total_costs:>15,.0f}")
    print(f"  Cost per NSF:               ${total_costs/TOTAL_NSF:>15,.2f}")
    print(f"  Cost per Unit:              ${total_costs/RESIDENTIAL_UNITS:>15,.0f}")
    
    # REVENUE at $1,000/SF
    # Parse units by type from CSV
    total_revenue = 0
    unit_sales = []
    
    floors = project_data['floors']
    for floor in floors:
        if 'Residential' in floor['use']:
            nsf = floor['nsf']
            units = floor['units_per_floor']
            
            if 'Hospitality' in floor['use']:
                price_psf = 1100  # Premium for hospitality units
            elif 'Condos' in floor['use']:
                price_psf = 950   # Slightly lower for 3BR condos
            else:
                price_psf = 1000
            
            floor_revenue = nsf * price_psf
            total_revenue += floor_revenue
            
            unit_sales.append({
                'floor': floor['floor_number'],
                'type': floor['use'],
                'units': units,
                'nsf': nsf,
                'price_psf': price_psf,
                'revenue': floor_revenue,
                'avg_unit_price': floor_revenue / units if units > 0 else 0
            })
    
    # Chabad/Mikvah sold at cost
    chabad_floor = [f for f in floors if 'Chabad' in f['use']][0]
    chabad_cost = chabad_floor['total_floor_cost']
    chabad_revenue = chabad_cost  # Sold at cost, zero margin
    
    total_revenue += chabad_revenue
    
    avg_price_psf = (total_revenue - chabad_revenue) / (TOTAL_NSF - chabad_floor['nsf'])
    
    print(f"\nREVENUE ANALYSIS:")
    print("-" * 80)
    print(f"{'Floor':<10} {'Type':<35} {'Units':>6} {'$/SF':>8} {'Revenue':>15}")
    print("-" * 80)
    
    for sale in unit_sales:
        print(f"{sale['floor']:<10} {sale['type']:<35} {sale['units']:>6} ${sale['price_psf']:>7,.0f} ${sale['revenue']:>14,.0f}")
    
    print(f"{'1':<10} {'Chabad/Mikvah (at cost)':<35} {'1':>6} {'Cost':>8} ${chabad_revenue:>14,.0f}")
    print("-" * 80)
    print(f"{'TOTAL':<10} {'':<35} {RESIDENTIAL_UNITS+1:>6} ${avg_price_psf:>7,.0f} ${total_revenue:>14,.0f}")
    
    # PROFITABILITY
    gross_profit = total_revenue - total_costs
    profit_margin = (gross_profit / total_revenue) * 100
    roi = (gross_profit / total_costs) * 100
    
    profit_per_unit = gross_profit / RESIDENTIAL_UNITS
    profit_per_sf = gross_profit / TOTAL_NSF
    
    print(f"\nPROFITABILITY:")
    print("-" * 80)
    print(f"  Total Revenue:              ${total_revenue:>15,.0f}")
    print(f"  Total Costs:                ${total_costs:>15,.0f}")
    print(f"  Gross Profit:               ${gross_profit:>15,.0f}")
    print()
    print(f"  Profit Margin:              {profit_margin:>14.1f}%")
    print(f"  Return on Cost (ROI):       {roi:>14.1f}%")
    print()
    print(f"  Profit per Unit:            ${profit_per_unit:>15,.0f}")
    print(f"  Profit per SF:              ${profit_per_sf:>15,.2f}")
    
    # SENSITIVITY ANALYSIS
    print(f"\nSENSITIVITY ANALYSIS:")
    print("-" * 80)
    
    scenarios = [
        {'name': 'Base Case', 'price_adj': 0, 'cost_adj': 0},
        {'name': 'Revenue -10%', 'price_adj': -0.10, 'cost_adj': 0},
        {'name': 'Revenue +10%', 'price_adj': 0.10, 'cost_adj': 0},
        {'name': 'Costs +10%', 'price_adj': 0, 'cost_adj': 0.10},
        {'name': 'Costs -10%', 'price_adj': 0, 'cost_adj': -0.10},
        {'name': 'Both +10%', 'price_adj': 0.10, 'cost_adj': 0.10},
        {'name': 'Rev +10%, Cost -10%', 'price_adj': 0.10, 'cost_adj': -0.10},
    ]
    
    print(f"{'Scenario':<25} {'Revenue':>15} {'Costs':>15} {'Profit':>15} {'Margin':>10} {'ROI':>10}")
    print("-" * 80)
    
    sensitivity_results = []
    for scenario in scenarios:
        rev = total_revenue * (1 + scenario['price_adj'])
        cost = total_costs * (1 + scenario['cost_adj'])
        profit = rev - cost
        margin = (profit / rev) * 100
        roi_val = (profit / cost) * 100
        
        sensitivity_results.append({
            'scenario': scenario['name'],
            'revenue': rev,
            'costs': cost,
            'profit': profit,
            'margin': margin,
            'roi': roi_val
        })
        
        print(f"{scenario['name']:<25} ${rev:>14,.0f} ${cost:>14,.0f} ${profit:>14,.0f} {margin:>9.1f}% {roi_val:>9.1f}%")
    
    # COMPARISON TO BASELINE
    baseline_revenue = project_data['financial_summary']['total_revenue']
    baseline_costs = project_data['financial_summary']['total_costs']
    baseline_profit = project_data['financial_summary']['gross_profit']
    
    print(f"\nBASELINE COMPARISON:")
    print("-" * 80)
    print(f"{'Metric':<30} {'CSV Baseline':>18} {'This Pro Forma':>18} {'Variance':>15}")
    print("-" * 80)
    
    comparisons = [
        ('Revenue', baseline_revenue, total_revenue),
        ('Total Costs', baseline_costs, total_costs),
        ('Gross Profit', baseline_profit, gross_profit),
    ]
    
    for metric, baseline, current in comparisons:
        variance = current - baseline
        print(f"{metric:<30} ${baseline:>17,.0f} ${current:>17,.0f} ${variance:>14,.0f}")
    
    # Save output
    output = {
        'development_costs': {
            'land': land,
            'hard_costs': hard,
            'soft_costs': soft,
            'total': total_costs,
            'cost_per_nsf': total_costs / TOTAL_NSF,
            'cost_per_unit': total_costs / RESIDENTIAL_UNITS,
        },
        'revenue': {
            'total_revenue': total_revenue,
            'residential_revenue': total_revenue - chabad_revenue,
            'chabad_revenue': chabad_revenue,
            'avg_price_psf': avg_price_psf,
            'unit_sales': unit_sales,
        },
        'profitability': {
            'gross_profit': gross_profit,
            'profit_margin_pct': profit_margin,
            'return_on_cost_pct': roi,
            'profit_per_unit': profit_per_unit,
            'profit_per_sf': profit_per_sf,
        },
        'sensitivity': sensitivity_results,
        'baseline_comparison': {
            'baseline_revenue': baseline_revenue,
            'baseline_costs': baseline_costs,
            'baseline_profit': baseline_profit,
            'current_revenue': total_revenue,
            'current_costs': total_costs,
            'current_profit': gross_profit,
        },
        'generated_date': datetime.now().isoformat(),
    }
    
    output_path = Path('data/pro_forma.json')
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"\n✅ Pro forma saved to: {output_path}")
    print("="*80)
    
    return output

if __name__ == "__main__":
    calculate_pro_forma()
