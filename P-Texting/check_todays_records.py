#!/usr/bin/env python3
"""Check status of today's records in database"""

import sqlite3
from datetime import date

db_path = "progress_shared.db"
today_str = "2025-11-28"

conn = sqlite3.connect(db_path)
c = conn.cursor()

# Check the 3 records with today's date
phones = ["+13059055068", "+17164211210", "+17163162027"]

print(f"Database Status for Today's Records ({today_str}):")
print("=" * 70)

for phone in phones:
    c.execute("SELECT phone, name, status, attempts, sent_at FROM messages WHERE phone = ?", (phone,))
    row = c.fetchone()
    if row:
        print(f"{row[1]:15} ({row[0]}): {row[2]:15} attempts={row[3]} sent_at={row[4]}")
    else:
        print(f"{phone}: NOT IN DATABASE")

print("\n" + "=" * 70)
c.execute("SELECT COUNT(*) FROM messages WHERE status='sent'")
sent_count = c.fetchone()[0]
print(f"Total sent in database: {sent_count}")

c.execute("SELECT COUNT(*) FROM messages WHERE status='pending'")
pending_count = c.fetchone()[0]
print(f"Total pending in database: {pending_count}")

conn.close()
input("\nPress Enter to exit...")
