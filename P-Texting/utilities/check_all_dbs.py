#!/usr/bin/env python3
"""
Check status counts in all database files
"""
import sqlite3
from pathlib import Path

db_files = [
    'progress.db',
    'progress_shared.db',
    'progress_chrome.db',
    'progress_firefox.db',
    'progress_edge.db'
]

for db_file in db_files:
    if Path(db_file).exists():
        print(f"\n{db_file}:")
        print("="*50)
        try:
            conn = sqlite3.connect(db_file)
            cursor = conn.cursor()
            
            # Get status counts
            cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
            status_counts = cursor.fetchall()
            
            cursor.execute('SELECT COUNT(*) FROM messages')
            total = cursor.fetchone()[0]
            
            for status, count in status_counts:
                print(f"  {status}: {count}")
            print(f"  Total: {total}")
            
            conn.close()
        except Exception as e:
            print(f"  Error: {e}")
    else:
        print(f"\n{db_file}: NOT FOUND")
