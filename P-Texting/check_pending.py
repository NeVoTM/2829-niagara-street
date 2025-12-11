import sqlite3

conn = sqlite3.connect('progress_shared.db')
cursor = conn.cursor()

cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
print('Database status:')
for row in cursor.fetchall():
    print(f'  {row[0]}: {row[1]}')

cursor.execute('SELECT COUNT(*) FROM messages WHERE status IN ("pending", "failed") AND attempts < 3')
print(f'\nPending/Failed ready to send (attempts < 3): {cursor.fetchone()[0]}')

cursor.execute('SELECT message_hash, COUNT(*) FROM messages GROUP BY message_hash')
print(f'\nMessage hashes in database:')
for row in cursor.fetchall():
    print(f'  {row[0]}: {row[1]} records')

conn.close()
