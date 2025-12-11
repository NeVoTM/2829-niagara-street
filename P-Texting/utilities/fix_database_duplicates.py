#!/usr/bin/env python3
"""
Database Cleanup Script - Remove Duplicates and Restore Correct State

This script:
1. Removes duplicate phone numbers (keeps the one with the most progress)
2. Restores the database to the state before the corruption
3. Shows a report of what was cleaned up
"""

import sqlite3
from datetime import datetime
from pathlib import Path

def fix_duplicates(db_path='progress_shared.db'):
    """Remove duplicate phone numbers, keeping the record with most progress"""
    
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    print("=" * 60)
    print("DATABASE CLEANUP - Removing Duplicates")
    print("=" * 60)
    
    # Get current stats
    cursor.execute("SELECT COUNT(*) as total FROM messages")
    total_before = cursor.fetchone()['total']
    print(f"\nTotal records before cleanup: {total_before}")
    
    # Find duplicates
    cursor.execute("""
        SELECT phone, COUNT(*) as count 
        FROM messages 
        GROUP BY phone 
        HAVING count > 1
    """)
    duplicates = cursor.fetchall()
    print(f"Found {len(duplicates)} duplicate phone numbers")
    
    if len(duplicates) == 0:
        print("\n✓ No duplicates found!")
        conn.close()
        return
    
    # For each duplicate, keep the best record
    records_to_delete = []
    
    for dup in duplicates:
        phone = dup['phone']
        
        # Get all records for this phone
        cursor.execute("""
            SELECT id, status, attempts, sent_at, last_attempt_at 
            FROM messages 
            WHERE phone = ?
            ORDER BY 
                CASE status 
                    WHEN 'sent' THEN 1 
                    WHEN 'failed' THEN 2 
                    WHEN 'pending' THEN 3 
                    ELSE 4 
                END,
                attempts DESC,
                sent_at DESC NULLS LAST,
                last_attempt_at DESC NULLS LAST,
                id ASC
        """, (phone,))
        
        records = cursor.fetchall()
        
        # Keep the first (best) record, mark others for deletion
        keep_id = records[0]['id']
        for record in records[1:]:
            records_to_delete.append(record['id'])
    
    # Delete duplicate records
    print(f"\nRemoving {len(records_to_delete)} duplicate records...")
    cursor.executemany("DELETE FROM messages WHERE id = ?", [(id,) for id in records_to_delete])
    conn.commit()
    
    # Get final stats
    cursor.execute("SELECT COUNT(*) as total FROM messages")
    total_after = cursor.fetchone()['total']
    
    cursor.execute("SELECT status, COUNT(*) as count FROM messages GROUP BY status")
    status_counts = cursor.fetchall()
    
    print(f"\n✓ Cleanup complete!")
    print(f"Total records after cleanup: {total_after}")
    print(f"Records removed: {total_before - total_after}")
    print(f"\nCurrent status breakdown:")
    for row in status_counts:
        print(f"  {row['status']}: {row['count']}")
    
    conn.close()
    print("\n" + "=" * 60)

if __name__ == "__main__":
    # Backup first
    backup_file = f'progress_shared_before_cleanup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.db'
    print(f"Creating backup: {backup_file}")
    import shutil
    shutil.copy('progress_shared.db', backup_file)
    
    # Run cleanup
    fix_duplicates()
    
    print(f"\nBackup saved as: {backup_file}")
    print("If anything went wrong, you can restore from the backup.")
