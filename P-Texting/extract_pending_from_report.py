#!/usr/bin/env python3
"""
Extract ONLY pending records from Chrome report CSV
"""

import csv

# Read the Chrome report
report_file = r'C:\Users\17274\ME\2829-Niagara-Street\P-Texting\reports\results_2025-11-23_15-28-09.csv'

pending_records = []

with open(report_file, 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    
    # Skip header rows
    for _ in range(5):
        next(reader)
    
    # Read data rows
    for row in reader:
        if len(row) >= 3:
            status = row[0]
            name = row[1]
            phone = row[2]
            
            # Only get pending records
            if '⏳ Pending' in status or 'Pending' in status:
                pending_records.append({
                    'name': name,
                    'phone': phone
                })

print(f"Found {len(pending_records)} pending records in Chrome report")

# Create new CSV file for Edge
output_file = 'pending_for_edge_2025-11-24.csv'
with open(output_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    
    # Header matching your format
    writer.writerow(['Name', 'Phone', 'Date', 'Category', 'Location', 'Email', 'Original_Phone'])
    
    # Write pending records with today's date
    for record in pending_records:
        writer.writerow([
            record['name'],
            record['phone'],
            '2025-11-24',  # Today's date
            'Hair Care',
            '',
            '',
            record['phone']
        ])

print(f"\n✅ Created: {output_file}")
print(f"   Contains {len(pending_records)} pending records ONLY")
print(f"   Date: 2025-11-24")
print(f"\n📝 Update config.json to use this file:")
print(f'   "input_path": "{output_file}"')
