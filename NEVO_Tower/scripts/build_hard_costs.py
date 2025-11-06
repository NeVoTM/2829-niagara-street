"""
NEVO Tower Hard Cost Model
Detailed CSI MasterFormat cost breakdown for pour-in-place concrete mid-rise
"""

import json
from pathlib import Path
from datetime import datetime

# Load parsed data
with open('data/nevo_parsed.json', 'r') as f:
    project_data = json.load(f)

TOTAL_GSF = project_data['building_totals']['total_gsf']
TOTAL_NSF = project_data['building_totals']['total_nsf']

# CSI Division costs ($/GSF) for mid-rise PIP concrete in Miami-Dade
CSI_COSTS = {
    '01_general_requirements': {
        'name': 'General Requirements',
        'rate_per_gsf': 18.50,
        'description': 'Supervision, temp facilities, safety, QC'
    },
    '02_existing_conditions': {
        'name': 'Existing Conditions & Site Work',
        'rate_per_gsf': 5.20,
        'description': 'Demo, clearing, erosion control'
    },
    '03_concrete': {
        'name': 'Concrete - Pour-in-Place PT',
        'rate_per_gsf': 52.00,
        'description': 'PT slabs, columns, walls, foundations, formwork, rebar'
    },
    '04_masonry': {
        'name': 'Masonry',
        'rate_per_gsf': 2.80,
        'description': 'CMU shear walls, veneer accents'
    },
    '05_metals': {
        'name': 'Metals',
        'rate_per_gsf': 8.50,
        'description': 'Structural steel minor, railings, stairs'
    },
    '06_wood_plastics': {
        'name': 'Wood & Plastics',
        'rate_per_gsf': 3.20,
        'description': 'Blocking, grounds, trim, minimal'
    },
    '07_thermal_moisture': {
        'name': 'Thermal & Moisture Protection',
        'rate_per_gsf': 22.00,
        'description': 'Waterproofing, roofing, insulation, sealants, HVHZ envelope'
    },
    '08_openings': {
        'name': 'Openings',
        'rate_per_gsf': 28.00,
        'description': 'Doors, frames, hardware, HVHZ glazing, curtain wall'
    },
    '09_finishes': {
        'name': 'Finishes',
        'rate_per_gsf': 42.00,
        'description': 'Drywall, paint, tile, flooring, ceilings, millwork'
    },
    '10_specialties': {
        'name': 'Specialties',
        'rate_per_gsf': 4.50,
        'description': 'Toilet accessories, signage, mailboxes'
    },
    '11_equipment': {
        'name': 'Equipment',
        'rate_per_gsf': 3.80,
        'description': 'Gym equipment, pool equipment, appliances'
    },
    '12_furnishings': {
        'name': 'Furnishings',
        'rate_per_gsf': 1.20,
        'description': 'Common area furniture minimal'
    },
    '13_special_construction': {
        'name': 'Special Construction',
        'rate_per_gsf': 1.80,
        'description': 'Pool shell, special features'
    },
    '14_conveying': {
        'name': 'Conveying Equipment',
        'rate_per_gsf': 3.10,
        'description': '2 elevators, 7 stops each'
    },
    '21_fire_suppression': {
        'name': 'Fire Suppression',
        'rate_per_gsf': 7.50,
        'description': 'Wet pipe sprinklers, standpipes, fire pump'
    },
    '22_plumbing': {
        'name': 'Plumbing',
        'rate_per_gsf': 10.00,
        'description': 'Domestic water, waste, vent, fixtures'
    },
    '23_hvac': {
        'name': 'HVAC',
        'rate_per_gsf': 15.00,
        'description': 'Mini-splits, ventilation, controls'
    },
    '26_electrical': {
        'name': 'Electrical',
        'rate_per_gsf': 17.50,
        'description': 'Service, distribution, lighting, EV chargers'
    },
    '27_communications': {
        'name': 'Communications',
        'rate_per_gsf': 2.80,
        'description': 'Data, telephone, AV, intercom'
    },
    '28_electronic_safety': {
        'name': 'Electronic Safety & Security',
        'rate_per_gsf': 2.50,
        'description': 'Fire alarm, access control, CCTV'
    },
    '31_earthwork': {
        'name': 'Earthwork',
        'rate_per_gsf': 4.20,
        'description': 'Excavation, backfill, compaction'
    },
    '32_exterior_improvements': {
        'name': 'Exterior Improvements',
        'rate_per_gsf': 5.50,
        'description': 'Paving, landscaping, irrigation, site lighting'
    },
    '33_utilities': {
        'name': 'Utilities',
        'rate_per_gsf': 3.20,
        'description': 'Water, sewer, storm, electric service to building'
    },
}

def calculate_hard_costs():
    """Calculate detailed hard costs by CSI division"""
    
    print("="*80)
    print("NEVO TOWER HARD COST MODEL")
    print("Pour-in-Place Post-Tensioned Concrete | Mid-Rise | Miami-Dade")
    print("="*80)
    print(f"\nTotal GSF: {TOTAL_GSF:,}")
    print(f"Total NSF: {TOTAL_NSF:,}\n")
    
    # Calculate costs by division
    division_costs = {}
    subtotal = 0
    
    print("CSI MASTERFORMAT BREAKDOWN:")
    print("-" * 80)
    print(f"{'Division':<10} {'Description':<40} {'$/GSF':>10} {'Total':>15}")
    print("-" * 80)
    
    for div_code, div_data in CSI_COSTS.items():
        cost = div_data['rate_per_gsf'] * TOTAL_GSF
        division_costs[div_code] = {
            'name': div_data['name'],
            'rate_per_gsf': div_data['rate_per_gsf'],
            'total_cost': cost,
            'description': div_data['description']
        }
        subtotal += cost
        
        print(f"{div_code:<10} {div_data['name']:<40} ${div_data['rate_per_gsf']:>9.2f} ${cost:>14,.0f}")
    
    print("-" * 80)
    print(f"{'SUBTOTAL':<10} {'Construction Cost before GC & Contingency':<40} ${subtotal/TOTAL_GSF:>9.2f} ${subtotal:>14,.0f}")
    print()
    
    # General Conditions (9% of subtotal)
    gc_rate = 0.09
    general_conditions = subtotal * gc_rate
    print(f"General Conditions ({gc_rate*100:.0f}%): ${general_conditions:,.0f}")
    
    # Overhead & Profit (10% of subtotal + GC)
    ohp_rate = 0.10
    subtotal_with_gc = subtotal + general_conditions
    overhead_profit = subtotal_with_gc * ohp_rate
    print(f"Overhead & Profit ({ohp_rate*100:.0f}%): ${overhead_profit:,.0f}")
    
    # Subtotal before contingency
    subtotal_before_contingency = subtotal_with_gc + overhead_profit
    print(f"\nSubtotal before contingency: ${subtotal_before_contingency:,.0f}")
    
    # Contingency (8% design + 5% construction + 3% owner = 16%)
    design_contingency = subtotal_before_contingency * 0.08
    construction_contingency = subtotal_before_contingency * 0.05
    owner_contingency = subtotal_before_contingency * 0.03
    total_contingency = design_contingency + construction_contingency + owner_contingency
    
    print(f"\nContingencies:")
    print(f"  Design (8%): ${design_contingency:,.0f}")
    print(f"  Construction (5%): ${construction_contingency:,.0f}")
    print(f"  Owner (3%): ${owner_contingency:,.0f}")
    print(f"  Total Contingency (16%): ${total_contingency:,.0f}")
    
    # TOTAL HARD COSTS
    total_hard_costs = subtotal_before_contingency + total_contingency
    cost_per_gsf = total_hard_costs / TOTAL_GSF
    cost_per_nsf = total_hard_costs / TOTAL_NSF
    
    print("\n" + "="*80)
    print("TOTAL HARD COSTS SUMMARY")
    print("="*80)
    print(f"Total Hard Costs: ${total_hard_costs:,.0f}")
    print(f"Cost per GSF: ${cost_per_gsf:,.2f}")
    print(f"Cost per NSF: ${cost_per_nsf:,.2f}")
    
    # Comparison to baseline
    baseline_cost = 32602500
    baseline_per_gsf = 300
    variance = total_hard_costs - baseline_cost
    variance_pct = (variance / baseline_cost) * 100
    
    print(f"\nBaseline Comparison:")
    print(f"  CSV Baseline: ${baseline_cost:,.0f} @ ${baseline_per_gsf}/GSF")
    print(f"  This Estimate: ${total_hard_costs:,.0f} @ ${cost_per_gsf:.2f}/GSF")
    print(f"  Variance: ${variance:+,.0f} ({variance_pct:+.1f}%)")
    
    # Save detailed output
    output = {
        'project_info': {
            'name': 'NEVO Tower',
            'total_gsf': TOTAL_GSF,
            'total_nsf': TOTAL_NSF,
            'construction_type': 'Pour-in-Place Post-Tensioned Concrete',
            'classification': 'Mid-rise (under 75 feet)',
        },
        'csi_divisions': division_costs,
        'summary': {
            'construction_subtotal': subtotal,
            'general_conditions': general_conditions,
            'overhead_profit': overhead_profit,
            'subtotal_before_contingency': subtotal_before_contingency,
            'design_contingency': design_contingency,
            'construction_contingency': construction_contingency,
            'owner_contingency': owner_contingency,
            'total_contingency': total_contingency,
            'total_hard_costs': total_hard_costs,
            'cost_per_gsf': cost_per_gsf,
            'cost_per_nsf': cost_per_nsf,
        },
        'baseline_comparison': {
            'baseline_total': baseline_cost,
            'baseline_per_gsf': baseline_per_gsf,
            'variance_amount': variance,
            'variance_percent': variance_pct,
        },
        'generated_date': datetime.now().isoformat(),
    }
    
    # Save JSON
    output_path = Path('data/hard_costs_detail.json')
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"\n✅ Hard cost details saved to: {output_path}")
    print("="*80)
    
    return output

if __name__ == "__main__":
    calculate_hard_costs()
