#!/usr/bin/env python3
"""
Import CSV and reset failed records to pending
"""
import sqlite3
import pandas as pd
import hashlib
import json

def reset_and_import():
    """Import records and reset failed to pending"""
    
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
    print(f"  - sent: {len(df[df['Status'] == 'sent'])}")
    print(f"  - failed: {len(df[df['Status'] == 'failed'])}")
    
    # Connect to database (use progress_shared.db for Chrome)
    db_file = 'progress_shared.db'
    print(f"Working with {db_file}...")
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    
    # Clear existing records
    print("\nClearing existing database records...")
    cursor.execute('DELETE FROM messages')
    conn.commit()
    
    # Import all records, converting 'failed' to 'pending'
    imported = 0
    reset_count = 0
    
    for idx, row in df.iterrows():
        phone = str(row['Phone']).strip()
        name = str(row['Name']).strip() if pd.notna(row['Name']) else ''
        status = str(row['Status']).strip().lower()
        
        # Reset failed to pending
        if status == 'failed':
            status = 'pending'
            reset_count += 1
        
        attempts = 0  # Reset attempts
        last_error = None  # Clear errors
        last_attempt_at = None  # Clear attempt time
        sent_at = str(row['Sent_At']) if pd.notna(row['Sent_At']) and status == 'sent' else None
        account_label = str(row['Sent_By_Account']) if pd.notna(row['Sent_By_Account']) else 'account1'
        
        cursor.execute(
            '''INSERT OR REPLACE INTO messages 
               (phone, name, status, attempts, last_error, last_attempt_at, sent_at, account_label, message_hash)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
            (phone, name, status, attempts, last_error, last_attempt_at, sent_at, account_label, message_hash)
        )
        imported += 1
    
    conn.commit()
    
    print(f"\n✅ Import complete!")
    print(f"  - Imported {imported} records")
    print(f"  - Reset {reset_count} failed records to pending")
    
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
    reset_and_import()
