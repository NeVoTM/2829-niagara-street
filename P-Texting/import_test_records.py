#!/usr/bin/env python3
"""
Import records from test_numbers_with_dates.csv into progress.db
"""
import sqlite3
import csv
import hashlib
import json
from datetime import datetime
from pathlib import Path

def import_test_records():
    """Import test records into the database"""
    
    # Connect to database (shared DB for Chrome)
    db_file = 'progress_shared.db'
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    print(f"Working with {db_file}...")
    
    # Get message hash from config (same way the sender does)
    try:
        with open('config.json', 'r') as f:
            config = json.load(f)
        content = config.get('message_text', '')
        if config.get('image_path'):
            content += f"|{config['image_path']}"
        message_hash = hashlib.sha256(content.encode()).hexdigest()[:16]
        print(f"Using message hash: {message_hash}")
    except Exception as e:
        # Default fallback if config doesn't exist
        message_hash = hashlib.sha256('default'.encode()).hexdigest()[:16]
        print(f"Warning: Could not load config, using default hash: {message_hash}")
    
    # Read CSV file
    csv_file = 'test_numbers_with_dates.csv'
    
    if not Path(csv_file).exists():
        print(f"Error: {csv_file} not found!")
        conn.close()
        return
    
    # Read and import records
    imported = 0
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            phone = row.get('Phone', '').strip()
            name = row.get('Name', '').strip()
            date = row.get('Date', '').strip()
            
            if phone and name:
                # Check if record already exists
                cursor.execute(
                    'SELECT COUNT(*) FROM messages WHERE phone = ? AND name = ?',
                    (phone, name)
                )
                
                if cursor.fetchone()[0] == 0:
                    # Insert new record (schema: phone, name, status, message_hash for shared DB)
                    cursor.execute(
                        '''INSERT INTO messages (phone, name, status, attempts, message_hash)
                           VALUES (?, ?, 'pending', 0, ?)''',
                        (phone, name, message_hash)
                    )
                    imported += 1
                    print(f"✓ Added: {name} - {phone} (scheduled for {date})")
                else:
                    print(f"⊗ Skipped (duplicate): {name} - {phone}")
    
    # Commit and close
    conn.commit()
    conn.close()
    
    print(f"\n✅ Import complete! Added {imported} new records to database.")
    
    # Show database summary
    conn = sqlite3.connect('progress.db')
    cursor = conn.cursor()
    cursor.execute('SELECT COUNT(*) FROM messages')
    total = cursor.fetchone()[0]
    
    cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
    status_counts = cursor.fetchall()
    
    print(f"\nDatabase summary:")
    print(f"  Total records: {total}")
    for status, count in status_counts:
        print(f"  {status}: {count}")
    
    conn.close()

if __name__ == '__main__':
    import_test_records()
