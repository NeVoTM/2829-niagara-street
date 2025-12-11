import sqlite3

conn = sqlite3.connect('progress_chrome.db')
cursor = conn.cursor()

# Count landlines
cursor.execute("SELECT COUNT(*) FROM messages WHERE status='landline'")
landlines = cursor.fetchone()[0]

print(f'\n🔍 Landline Detection Status:')
print(f'   Landlines detected: {landlines}')
print()

# All status counts
print('📊 All Status Counts:')
cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status ORDER BY status')
for status, count in cursor.fetchall():
    emoji = {'sent': '✅', 'failed': '❌', 'pending': '⏳', 'landline': '☎️', 'limit_reached': '🛑'}.get(status, '•')
    print(f'   {emoji} {status}: {count}')

conn.close()
