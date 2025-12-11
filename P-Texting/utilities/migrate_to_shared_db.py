#!/usr/bin/env python3
"""
Migrate Chrome's progress_chrome.db to new shared database format
This preserves all Chrome's sent/failed/pending records
"""

import sqlite3
import shutil
from pathlib import Path
from datetime import datetime

def migrate_chrome_to_shared():
    """Migrate Chrome database to shared database"""
    
    chrome_db = Path("progress_chrome.db")
    shared_db = Path("progress_shared.db")
    
    # Check if Chrome database exists
    if not chrome_db.exists():
        print("❌ progress_chrome.db not found - nothing to migrate")
        return
    
    print("=" * 60)
    print("MIGRATING CHROME DATA TO SHARED DATABASE")
    print("=" * 60)
    
    # Backup Chrome database
    backup_path = Path(f"progress_chrome_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.db")
    shutil.copy2(chrome_db, backup_path)
    print(f"✅ Backed up Chrome database to: {backup_path}")
    
    # Connect to both databases
    chrome_conn = sqlite3.connect(chrome_db)
    chrome_conn.row_factory = sqlite3.Row
    
    # Create or connect to shared database
    shared_conn = sqlite3.connect(shared_db)
    shared_cursor = shared_conn.cursor()
    
    # Create new schema in shared database
    print("\n📊 Creating shared database schema...")
    shared_cursor.execute("""
        CREATE TABLE IF NOT EXISTS messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phone TEXT NOT NULL,
            name TEXT,
            status TEXT CHECK(status IN ('pending','sending','sent','failed','limit_reached','landline')) NOT NULL,
            attempts INTEGER DEFAULT 0,
            last_error TEXT,
            last_attempt_at TIMESTAMP,
            sent_at TIMESTAMP,
            sent_by_account TEXT,
            last_attempted_by_account TEXT,
            message_hash TEXT NOT NULL,
            UNIQUE(phone, message_hash)
        )
    """)
    shared_cursor.execute("""
        CREATE INDEX IF NOT EXISTS idx_status ON messages(status)
    """)
    shared_cursor.execute("""
        CREATE INDEX IF NOT EXISTS idx_message_hash ON messages(message_hash)
    """)
    
    # Get all Chrome records
    chrome_cursor = chrome_conn.cursor()
    chrome_cursor.execute("SELECT * FROM messages")
    chrome_records = chrome_cursor.fetchall()
    
    print(f"\n📋 Found {len(chrome_records)} records in Chrome database")
    
    if len(chrome_records) == 0:
        print("⚠️  No records to migrate")
        chrome_conn.close()
        shared_conn.close()
        return
    
    # Migrate records
    migrated = 0
    skipped = 0
    
    for record in chrome_records:
        # Map old account_label to new sent_by_account
        sent_by = record['account_label'] if record['status'] == 'sent' else None
        last_attempted_by = record['account_label']
        
        try:
            shared_cursor.execute("""
                INSERT INTO messages 
                (phone, name, status, attempts, last_error, last_attempt_at, sent_at, 
                 sent_by_account, last_attempted_by_account, message_hash)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(phone, message_hash) DO NOTHING
            """, (
                record['phone'],
                record['name'],
                record['status'],
                record['attempts'],
                record['last_error'],
                record['last_attempt_at'],
                record['sent_at'],
                sent_by,
                last_attempted_by,
                record['message_hash']
            ))
            
            if shared_cursor.rowcount > 0:
                migrated += 1
            else:
                skipped += 1
                
        except Exception as e:
            print(f"❌ Error migrating {record['phone']}: {e}")
            skipped += 1
    
    shared_conn.commit()
    
    # Show statistics
    print("\n" + "=" * 60)
    print("MIGRATION COMPLETE")
    print("=" * 60)
    print(f"✅ Migrated: {migrated} records")
    print(f"⏭️  Skipped (duplicates): {skipped} records")
    
    # Show breakdown by status
    shared_cursor.execute("""
        SELECT status, COUNT(*) as count 
        FROM messages 
        GROUP BY status
    """)
    
    print("\n📊 Shared database now contains:")
    for row in shared_cursor.fetchall():
        print(f"   {row[0]}: {row[1]}")
    
    # Show breakdown by account
    shared_cursor.execute("""
        SELECT 
            COALESCE(sent_by_account, 'Not yet sent') as account,
            COUNT(*) as count 
        FROM messages 
        WHERE status = 'sent'
        GROUP BY sent_by_account
    """)
    
    print("\n📊 Sent messages by account:")
    for row in shared_cursor.fetchall():
        print(f"   {row[0]}: {row[1]}")
    
    chrome_conn.close()
    shared_conn.close()
    
    print("\n✅ All done! You can now use progress_shared.db with all browsers")
    print(f"📁 Original Chrome database backed up to: {backup_path}")

if __name__ == "__main__":
    migrate_chrome_to_shared()
