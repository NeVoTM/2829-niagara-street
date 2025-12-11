#!/usr/bin/env python3
"""
Export progress_shared.db to CSV file for inspection
"""

import sqlite3
import csv
from datetime import datetime
from pathlib import Path

def export_database():
    db_file = Path("progress_shared.db")
    
    if not db_file.exists():
        print("❌ progress_shared.db not found!")
        return
    
    # Connect to database
    conn = sqlite3.connect(db_file)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    # Get all records
    cursor.execute("""
        SELECT 
            phone,
            name,
            status,
            attempts,
            last_error,
            last_attempt_at,
            sent_at,
            sent_by_account,
            last_attempted_by_account
        FROM messages
        ORDER BY id
    """)
    
    rows = cursor.fetchall()
    
    if not rows:
        print("⚠️  Database is empty!")
        conn.close()
        return
    
    # Export to CSV
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file = Path(f"database_export_{timestamp}.csv")
    
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        
        # Write header
        writer.writerow([
            'Phone',
            'Name',
            'Status',
            'Attempts',
            'Last_Error',
            'Last_Attempt_At',
            'Sent_At',
            'Sent_By_Account',
            'Last_Attempted_By_Account'
        ])
        
        # Write data
        for row in rows:
            writer.writerow([
                row['phone'],
                row['name'],
                row['status'],
                row['attempts'],
                row['last_error'] or '',
                row['last_attempt_at'] or '',
                row['sent_at'] or '',
                row['sent_by_account'] or '',
                row['last_attempted_by_account'] or ''
            ])
    
    conn.close()
    
    # Show statistics
    print("=" * 70)
    print(f"DATABASE EXPORTED: {output_file}")
    print("=" * 70)
    print(f"\n✅ Exported {len(rows)} records\n")
    
    # Show breakdown
    from collections import Counter
    statuses = Counter(row['status'] for row in rows)
    
    print("Status breakdown:")
    for status, count in statuses.items():
        print(f"  {status:15}: {count:4}")
    
    print("\nAccount breakdown (sent messages):")
    accounts = Counter(row['sent_by_account'] for row in rows if row['status'] == 'sent')
    for account, count in accounts.items():
        account_name = account or 'None'
        print(f"  {account_name:15}: {count:4}")
    
    print(f"\n📁 You can open this file in Excel: {output_file.absolute()}")

if __name__ == "__main__":
    export_database()
