#!/usr/bin/env python3
"""Test reset with the REAL message hash computed from config"""

import sqlite3
import hashlib
import json

# Load Chrome config
with open("configs/config_chrome.json", 'r') as f:
    config = json.load(f)

# Compute message hash the SAME way the script does
content = config['message_text']
if config.get('image_path'):
    content += f"|{config['image_path']}"
message_hash = hashlib.sha256(content.encode()).hexdigest()[:16]

print("=" * 70)
print("TESTING WITH REAL MESSAGE HASH")
print("=" * 70)
print(f"\nComputed message hash: {message_hash}")

# The 3 phones from test_data_enhanced.csv with date 2025-11-28
test_phones = ["+13059055068", "+17164211210", "+17163162027"]

db_path = "progress_shared.db"
conn = sqlite3.connect(db_path)
c = conn.cursor()

print("\n1. Current status in database:")
for phone in test_phones:
    c.execute("SELECT name, status, attempts, message_hash FROM messages WHERE phone = ?", (phone,))
    row = c.fetchone()
    if row:
        print(f"   {row[0]:15} ({phone}): {row[1]:15} attempts={row[2]} hash={row[3]}")
    else:
        print(f"   {phone}: NOT IN DATABASE")

# Test the reset logic with REAL hash
print("\n2. Testing reset with computed message hash...")
placeholders = ','.join(['?' for _ in test_phones])

c.execute(f"""
    UPDATE messages 
    SET status='pending', attempts=0, sent_at=NULL, last_error=NULL
    WHERE phone IN ({placeholders})
    AND status != 'pending'
    AND message_hash = ?
""", test_phones + [message_hash])
reset_count = c.rowcount
conn.commit()

print(f"   Reset {reset_count} records to pending")

print("\n3. Status after reset:")
for phone in test_phones:
    c.execute("SELECT name, status, attempts FROM messages WHERE phone = ?", (phone,))
    row = c.fetchone()
    if row:
        print(f"   {row[0]:15} ({phone}): {row[1]:15} attempts={row[2]}")
    else:
        print(f"   {phone}: NOT IN DATABASE")

conn.close()

print("\n" + "=" * 70)
print("✅ Test complete!")
print("=" * 70)

if reset_count > 0:
    print(f"\n✅ SUCCESS: Reset {reset_count} records. Chrome should now send all {len(test_phones)} messages!")
else:
    print("\n⚠️  No records were reset. They may already be pending, or hash mismatch.")

input("\nPress Enter to exit...")
