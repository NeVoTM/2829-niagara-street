#!/usr/bin/env python3
"""
Import all records from CSV export back into progress.db
"""
import sqlite3
import pandas as pd
import hashlib
import json
from pathlib import Path

def import_from_csv():
    """Import records from CSV export"""
    
    # Get message hash from config
    try:
        with open('config.json', 'r') as f:
            config = json.load(f)
        content = config.get('message_text', '')
        if config.get('image_path'):
            content += f"|{config['image_path']}"
        message_hash = hashlib.sha256(content.encode()).hexdigest()[:16]
        print(f"Using message hash: {message_hash}")
    except Exception as e:
        message_hash = hashlib.sha256('default'.encode()).hexdigest()[:16]
        print(f"Warning: Could not load config, using default hash: {message_hash}")
    
    # Read CSV
    csv_file = 'database_export_20251123_222640.csv'
    print(f"\nReading {csv_file}...")
    df = pd.read_csv(csv_file)
    print(f"Found {len(df)} records in CSV")
    
    # Connect to database
    conn = sqlite3.connect('progress.db')
    cursor = conn.cursor()
    
    # Clear existing records (optional - ask first)
    print("\nClearing existing database records...")
    cursor.execute('DELETE FROM messages')
    conn.commit()
    
    # Import all records
    imported = 0
    for idx, row in df.iterrows():
        phone = str(row['Phone']).strip()
        name = str(row['Name']).strip() if pd.notna(row['Name']) else ''
        status = str(row['Status']).strip().lower()
        attempts = int(row['Attempts']) if pd.notna(row['Attempts']) else 0
        last_error = str(row['Last_Error']) if pd.notna(row['Last_Error']) else None
        last_attempt_at = str(row['Last_Attempt_At']) if pd.notna(row['Last_Attempt_At']) else None
        sent_at = str(row['Sent_At']) if pd.notna(row['Sent_At']) else None
        account_label = str(row['Sent_By_Account']) if pd.notna(row['Sent_By_Account']) else 'account1'
        
        cursor.execute(
            '''INSERT INTO messages 
               (phone, name, status, attempts, last_error, last_attempt_at, sent_at, account_label, message_hash)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
            (phone, name, status, attempts, last_error, last_attempt_at, sent_at, account_label, message_hash)
        )
        imported += 1
    
    conn.commit()
    
    print(f"\n✅ Import complete! Imported {imported} records.")
    
    # Show summary
    cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
    status_counts = cursor.fetchall()
    
    cursor.execute('SELECT COUNT(*) FROM messages')
    total = cursor.fetchone()[0]
    
    print(f"\nDatabase summary:")
    print(f"  Total records: {total}")
    for status, count in status_counts:
        print(f"  {status}: {count}")
    
    conn.close()

if __name__ == '__main__':
    import_from_csv()
