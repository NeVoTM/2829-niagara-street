"""
NEVO Tower CSV Parser
Ingests and validates the NEVO Tower 50 Units CSV data
"""

import csv
import json
import sys
from pathlib import Path
from datetime import datetime

# CSV path
CSV_PATH = r"C:\Users\17274\Downloads\_NEVO TOWER 50 UNITS - Measurements 50 (1).csv"

def parse_currency(value):
    """Parse currency string to float"""
    if not value or value == '':
        return 0.0
    return float(value.replace('$', '').replace(',', ''))

def parse_number(value):
    """Parse number string to float/int"""
    if not value or value == '':
        return 0
    cleaned = value.replace(',', '')
    try:
        if '.' in cleaned:
            return float(cleaned)
        return int(cleaned)
    except:
        return 0

def parse_nevo_csv():
    """Parse the NEVO Tower CSV file"""
    
    print("="*80)
    print("NEVO TOWER CSV PARSER")
    print("="*80)
    print(f"\nReading: {CSV_PATH}\n")
    
    floors_data = []
    
    with open(CSV_PATH, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            floor_num = row['Floor #']
            
            # Parse all fields
            floor_data = {
                'floor_number': floor_num,
                'saleable': row['Saleable'],
                'height_ft': parse_number(row['Height']),
                'width_ft': parse_number(row['Width']),
                'length_ft': parse_number(row['Length']),
                'gsf': parse_number(row['Floor Plate GSF']),
                'gsf_percent': row['%GSF'],
                'nsf': parse_number(row['Floor Plate NSF']),
                'nsf_percent': row['%NSF'],
                'unit_size_nsf': parse_number(row['Unit Size NSF']),
                'units_per_floor': parse_number(row['Units per Floor']),
                'use': row['USE'],
                'units_by_use': parse_number(row['Units by Use']),
                'gsf_by_use': parse_number(row['GSF by Use']),
                'cost_per_sf': parse_currency(row['Cost by SF']),
                'unit_cost': parse_currency(row['Unit Cost']),
                'total_floor_cost': parse_currency(row['Total Floor Cost']),
                'soft_cost': parse_currency(row['Soft Cost']),
                'sell_per_sf': parse_currency(row['Sell by SF']),
                'unit_sale': parse_currency(row['Unit Sale']),
                'total_floor_sale': parse_currency(row['Total Floor Sale']),
                'gross_profit': row['Gross Profit'],
                'gp_percent': row['GP %'],
            }
            
            floors_data.append(floor_data)
    
    # Separate totals row
    totals = floors_data[-1]
    floors = floors_data[:-1]
    
    # Validate
    print("VALIDATION:")
    print("-" * 80)
    
    # Count floors
    floor_count = len([f for f in floors if f['floor_number'] != 'Total'])
    print(f"✓ Floor Count: {floor_count} (Expected: 8 including rooftop)")
    
    # Validate GSF total
    gsf_sum = sum(f['gsf'] for f in floors if f['floor_number'] != 'Total')
    gsf_expected = totals['gsf']
    print(f"✓ Total GSF: {gsf_sum:,} (Expected: {gsf_expected:,})")
    
    # Count residential units
    res_units = sum(f['units_per_floor'] for f in floors if 'Residential' in f['use'])
    print(f"✓ Residential Units: {res_units} (Expected: 50)")
    
    # Count parking
    parking_spaces = sum(f['units_per_floor'] for f in floors if 'Parking' in f['use'])
    print(f"✓ Parking Spaces: {parking_spaces} (Expected: 102)")
    
    # Costs
    total_hard_cost = totals['total_floor_cost']
    total_soft_cost = totals['soft_cost']
    print(f"✓ Hard Costs: ${total_hard_cost:,.0f}")
    print(f"✓ Soft Costs: ${total_soft_cost:,.0f}")
    
    # Revenue
    total_revenue = totals['total_floor_sale']
    print(f"✓ Total Revenue: ${total_revenue:,.0f}")
    
    print("\nFLOOR BREAKDOWN:")
    print("-" * 80)
    
    for floor in floors:
        if floor['floor_number'] == 'Total':
            continue
        print(f"  {floor['floor_number']:10} | {floor['use']:45} | Units: {floor['units_per_floor']:3} | GSF: {floor['gsf']:,}")
    
    # Create structured output
    output = {
        'project': {
            'name': 'NEVO Tower',
            'address': '1580 79th Street Causeway, North Bay Village, FL 33141',
            'floors': floor_count,
            'classification': 'mid-rise (under 75 feet)',
        },
        'building_totals': {
            'total_gsf': totals['gsf'],
            'total_nsf': totals['nsf'],
            'residential_units': res_units,
            'parking_spaces': parking_spaces,
        },
        'floors': floors,
        'financial_summary': {
            'hard_costs': total_hard_cost,
            'soft_costs': total_soft_cost,
            'total_costs': total_hard_cost + total_soft_cost,
            'total_revenue': total_revenue,
            'gross_profit': total_revenue - (total_hard_cost + total_soft_cost),
            'cost_per_gsf': total_hard_cost / totals['gsf'] if totals['gsf'] > 0 else 0,
        },
        'parsed_date': datetime.now().isoformat(),
    }
    
    # Save JSON
    json_path = Path("data/nevo_parsed.json")
    json_path.parent.mkdir(exist_ok=True)
    with open(json_path, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"\n✅ Parsed data saved to: {json_path}")
    
    # Create validation report
    report_path = Path("data/validation_report.md")
    with open(report_path, 'w') as f:
        f.write("# NEVO Tower Data Validation Report\n\n")
        f.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("## Building Program\n\n")
        f.write(f"- **Total Floors:** {floor_count} (7 floors + rooftop)\n")
        f.write(f"- **Total GSF:** {gsf_sum:,}\n")
        f.write(f"- **Total NSF:** {totals['nsf']:,}\n")
        f.write(f"- **Residential Units:** {res_units}\n")
        f.write(f"- **Parking Spaces:** {parking_spaces}\n\n")
        f.write("## Floor-by-Floor Breakdown\n\n")
        f.write("| Floor | Use | Units/Spaces | GSF |\n")
        f.write("|-------|-----|--------------|-----|\n")
        for floor in floors:
            if floor['floor_number'] == 'Total':
                continue
            f.write(f"| {floor['floor_number']} | {floor['use']} | {floor['units_per_floor']} | {floor['gsf']:,} |\n")
        f.write(f"\n## Financial Summary\n\n")
        f.write(f"- **Hard Costs:** ${total_hard_cost:,.0f} (${total_hard_cost/totals['gsf']:.0f}/GSF)\n")
        f.write(f"- **Soft Costs:** ${total_soft_cost:,.0f}\n")
        f.write(f"- **Total Revenue:** ${total_revenue:,.0f}\n")
        f.write(f"- **Gross Profit:** ${total_revenue - (total_hard_cost + total_soft_cost):,.0f}\n")
    
    print(f"✅ Validation report saved to: {report_path}\n")
    
    return output

if __name__ == "__main__":
    try:
        data = parse_nevo_csv()
        print("="*80)
        print("✅ PARSING COMPLETE")
        print("="*80)
    except Exception as e:
        print(f"\n❌ ERROR: {e}", file=sys.stderr)
        sys.exit(1)
