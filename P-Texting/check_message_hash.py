#!/usr/bin/env python3
"""Check the actual message_hash in the database"""

import sqlite3

db_path = "progress_shared.db"
test_phones = ["+13059055068", "+17164211210", "+17163162027"]

conn = sqlite3.connect(db_path)
c = conn.cursor()

print("=" * 70)
print("MESSAGE HASH CHECK")
print("=" * 70)

for phone in test_phones:
    c.execute("SELECT name, status, message_hash FROM messages WHERE phone = ?", (phone,))
    row = c.fetchone()
    if row:
        print(f"{row[0]:15} ({phone})")
        print(f"  Status: {row[1]}")
        print(f"  Hash:   {row[2]}")
    else:
        print(f"{phone}: NOT IN DATABASE")

conn.close()
input("\nPress Enter to exit...")
