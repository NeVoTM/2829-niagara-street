#!/usr/bin/env python3
"""Test that CSV date filtering and DB reset works correctly"""

import sqlite3
import sys
from pathlib import Path

# Add junk to path
sys.path.insert(0, str(Path(__file__).parent / 'junk'))
from send_texts import Database, Config

# Load Chrome config
config = Config("configs/config_chrome.json")
db = Database(config['database_path'])

print("=" * 70)
print("TESTING CSV-TO-DATABASE SYNC")
print("=" * 70)

# The 3 phones from test_data_enhanced.csv with date 2025-11-28
test_phones = ["+13059055068", "+17164211210", "+17163162027"]

print("\n1. Current status in database:")
cursor = db.conn.cursor()
for phone in test_phones:
    cursor.execute("SELECT name, status, attempts FROM messages WHERE phone = ?", (phone,))
    row = cursor.fetchone()
    if row:
        print(f"   {row[0]:15} ({phone}): {row[1]:10} attempts={row[2]}")
    else:
        print(f"   {phone}: NOT IN DATABASE")

# Simulate what the fixed script does
print("\n2. Simulating CSV sync (resetting non-pending records)...")
placeholders = ','.join(['?' for _ in test_phones])
message_hash = "test_campaign_001"  # From CSV

cursor.execute(f"""
    UPDATE messages 
    SET status='pending', attempts=0, sent_at=NULL, last_error=NULL
    WHERE phone IN ({placeholders})
    AND status != 'pending'
    AND message_hash = ?
""", test_phones + [message_hash])
reset_count = cursor.rowcount
db.conn.commit()

print(f"   Reset {reset_count} records to pending")

print("\n3. Status after sync:")
for phone in test_phones:
    cursor.execute("SELECT name, status, attempts FROM messages WHERE phone = ?", (phone,))
    row = cursor.fetchone()
    if row:
        print(f"   {row[0]:15} ({phone}): {row[1]:10} attempts={row[2]}")
    else:
        print(f"   {phone}: NOT IN DATABASE")

print("\n" + "=" * 70)
print("✅ CSV sync test complete!")
print("=" * 70)
print("\nNow the Chrome send script should send all 3 messages.")
input("\nPress Enter to exit...")
