#!/usr/bin/env python3
"""
Export ONLY pending records from database to CSV
"""

import sqlite3
import csv
from datetime import datetime

# Connect to database
conn = sqlite3.connect('progress_shared.db')
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

# Get ONLY pending records
cursor.execute("""
    SELECT phone, name 
    FROM messages 
    WHERE status = 'pending'
    ORDER BY id
""")
pending = cursor.fetchall()
conn.close()

print(f"Found {len(pending)} PENDING records")

# Create CSV with today's date
output_file = 'pending_only_2025-11-24.csv'
with open(output_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    
    # Header
    writer.writerow(['Name', 'Phone', 'Date', 'Category', 'Location', 'Email', 'Original_Phone'])
    
    # Write pending records with today's date
    for record in pending:
        phone = record['phone']
        name = record['name'] or 'Unknown'
        
        writer.writerow([
            name,
            phone,
            '2025-11-24',  # Today
            'Hair Care',
            '',
            '',
            phone
        ])

print(f"\nCreated: {output_file}")
print(f"Contains {len(pending)} PENDING records ONLY")
print(f"Date: 2025-11-24")
print(f"\nUse this file in config.json as input_path")
