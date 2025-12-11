#!/usr/bin/env python3
"""
Update CSV dates: pending records get 11-24, rest get 11-23
"""

import sqlite3
import pandas as pd

# Get all pending phone numbers from database
conn = sqlite3.connect('progress_shared.db')
cursor = conn.cursor()
cursor.execute("SELECT phone FROM messages WHERE status = 'pending'")
pending_phones = {row[0] for row in cursor.fetchall()}
conn.close()

print(f"Found {len(pending_phones)} pending phone numbers in database")

# Read CSV
csv_path = r'C:\Users\17274\Documents\HairColorNY\list_from_grok_CLEANED.csv'
df = pd.read_csv(csv_path)

print(f"CSV has {len(df)} total records")

# Update dates
updated_count = 0
for idx, row in df.iterrows():
    phone = str(row['Phone']).strip()
    
    # Normalize phone to match DB format (+1XXXXXXXXXX)
    phone_digits = ''.join(c for c in phone if c.isdigit())
    if len(phone_digits) == 10:
        phone_normalized = f'+1{phone_digits}'
    elif len(phone_digits) == 11 and phone_digits.startswith('1'):
        phone_normalized = f'+{phone_digits}'
    else:
        phone_normalized = f'+{phone_digits}'
    
    # Set date based on pending status
    if phone_normalized in pending_phones:
        df.at[idx, 'Date'] = '2025-11-24'
        updated_count += 1
    else:
        df.at[idx, 'Date'] = '2025-11-23'

print(f"Updated {updated_count} records to 2025-11-24 (pending)")
print(f"Set {len(df) - updated_count} records to 2025-11-23 (sent/failed/other)")

# Save
df.to_csv(csv_path, index=False)
print(f"\nSaved updated CSV to {csv_path}")
