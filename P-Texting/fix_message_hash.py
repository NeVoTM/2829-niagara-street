#!/usr/bin/env python3
"""
Fix message hash - Update all records to use current config's message hash
"""

import sqlite3
import hashlib
import json
from datetime import datetime

# Get current message hash from config
config = json.load(open('config.json'))
content = config['message_text']
if config.get('image_path'):
    content += f"|{config['image_path']}"

current_hash = hashlib.sha256(content.encode()).hexdigest()[:16]

print("=" * 60)
print("MESSAGE HASH FIX")
print("=" * 60)
print(f"\nCurrent config message hash: {current_hash}")

# Connect to database
conn = sqlite3.connect('progress_shared.db')
cursor = conn.cursor()

# Show current hashes
cursor.execute('SELECT message_hash, COUNT(*) FROM messages GROUP BY message_hash')
print("\nCurrent message hashes in database:")
for row in cursor.fetchall():
    print(f"  {row[0]}: {row[1]} records")

# Backup first
import shutil
backup_file = f'progress_shared_before_hash_fix_{datetime.now().strftime("%Y%m%d_%H%M%S")}.db'
shutil.copy('progress_shared.db', backup_file)
print(f"\nBackup created: {backup_file}")

# Update ALL records to use current hash
cursor.execute('UPDATE messages SET message_hash = ?', (current_hash,))
affected = cursor.rowcount
conn.commit()

print(f"\n✓ Updated {affected} records to use hash: {current_hash}")

# Verify
cursor.execute('SELECT message_hash, COUNT(*) FROM messages GROUP BY message_hash')
print("\nAfter update:")
for row in cursor.fetchall():
    print(f"  {row[0]}: {row[1]} records")

conn.close()
print("\n" + "=" * 60)
print("Done! All records now use the same message hash.")
print("=" * 60)
