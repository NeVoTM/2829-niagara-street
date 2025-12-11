import sqlite3
from datetime import datetime

conn = sqlite3.connect('progress_shared.db')
cursor = conn.cursor()

today = datetime.now().date()

# Check sent today by each account
cursor.execute("""
    SELECT sent_by_account, COUNT(*) 
    FROM messages 
    WHERE status = 'sent' 
    AND DATE(sent_at) = ?
    GROUP BY sent_by_account
""", (today,))

print(f"Messages sent TODAY ({today}):")
for row in cursor.fetchall():
    print(f"  {row[0]}: {row[1]}")

# Check overall sent counts
cursor.execute("""
    SELECT sent_by_account, COUNT(*) 
    FROM messages 
    WHERE status = 'sent'
    GROUP BY sent_by_account
""")

print(f"\nTotal sent (all time):")
for row in cursor.fetchall():
    print(f"  {row[0]}: {row[1]}")

conn.close()
