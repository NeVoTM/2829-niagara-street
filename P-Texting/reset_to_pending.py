#!/usr/bin/env python3
"""Reset last 3 sent records back to pending"""

import sqlite3

db_path = "progress_shared.db"

conn = sqlite3.connect(db_path)
c = conn.cursor()

# Reset last 3 sent records
c.execute("""
    UPDATE messages 
    SET status='pending', attempts=0, sent_at=NULL 
    WHERE status='sent' 
    ORDER BY sent_at DESC 
    LIMIT 3
""")

print(f"✅ Reset {c.rowcount} records from 'sent' to 'pending'")

conn.commit()
conn.close()

print("\nNow click 'Send Messages' in Chrome GUI again!")
input("Press Enter to exit...")
