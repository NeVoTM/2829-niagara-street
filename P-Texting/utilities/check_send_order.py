import sqlite3

conn = sqlite3.connect('progress_shared.db')
cur = conn.cursor()

# Check what Edge will send first
cur.execute('''
    SELECT phone, name, status, attempts 
    FROM messages 
    WHERE status IN ("pending", "failed") 
    ORDER BY attempts ASC, status DESC 
    LIMIT 15
''')

rows = cur.fetchall()

print("=" * 70)
print("FIRST 15 RECORDS EDGE WILL SEND:")
print("=" * 70)
print()

if rows:
    for i, row in enumerate(rows, 1):
        phone, name, status, attempts = row
        print(f"{i:2}. {phone:15} ({name:30}) - {status:8} (attempts: {attempts})")
else:
    print("No pending or failed records found!")

print()
print("=" * 70)

# Show overall stats
cur.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
stats = cur.fetchall()

print("DATABASE STATS:")
print("=" * 70)
for status, count in stats:
    print(f"  {status:15}: {count}")

conn.close()
