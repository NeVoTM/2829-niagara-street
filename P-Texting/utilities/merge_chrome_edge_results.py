#!/usr/bin/env python3
"""
Merge Chrome and Edge database results into progress_shared.db
Detect duplicates and reconcile statuses
"""
import sqlite3
import pandas as pd
import hashlib
import json

def load_db_to_df(db_file):
    """Load database into pandas DataFrame"""
    conn = sqlite3.connect(db_file)
    df = pd.read_sql_query("SELECT * FROM messages", conn)
    conn.close()
    return df

def merge_databases():
    """Merge Chrome and Edge results"""
    
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
    
    print("\nLoading databases...")
    
    # Load Chrome database
    df_chrome = load_db_to_df('progress_chrome.db')
    print(f"\nChrome DB (progress_chrome.db):")
    print(f"  Total: {len(df_chrome)}")
    print(df_chrome['status'].value_counts().to_string())
    
    # Load Edge database
    df_edge = load_db_to_df('progress_edge.db')
    print(f"\nEdge DB (progress_edge.db):")
    print(f"  Total: {len(df_edge)}")
    print(df_edge['status'].value_counts().to_string())
    
    # Create master records dictionary keyed by phone number
    master_records = {}
    
    print("\n" + "="*60)
    print("MERGING LOGIC:")
    print("="*60)
    
    # Process Chrome records first
    for idx, row in df_chrome.iterrows():
        phone = row['phone']
        master_records[phone] = {
            'phone': phone,
            'name': row['name'],
            'status': row['status'],  # failed or sent
            'attempts': row['attempts'],
            'last_error': row['last_error'],
            'last_attempt_at': row['last_attempt_at'],
            'sent_at': row['sent_at'],
            'sent_by': 'chrome' if row['status'] == 'sent' else None,
            'chrome_status': row['status'],
            'edge_status': None,
            'is_duplicate': False
        }
    
    # Process Edge records and detect conflicts/duplicates
    duplicates_found = 0
    edge_sent_chrome_pending = 0
    
    for idx, row in df_edge.iterrows():
        phone = row['phone']
        
        if phone in master_records:
            # This number was also in Chrome
            chrome_rec = master_records[phone]
            chrome_rec['edge_status'] = row['status']
            
            # Determine final status based on priority:
            # 1. If either sent, mark as sent (take the one that succeeded)
            # 2. If both failed/pending, keep as failed/pending
            # 3. If statuses differ (one sent, one failed), mark as duplicate issue
            
            if row['status'] == 'sent' and chrome_rec['chrome_status'] == 'sent':
                # Both sent - mark as duplicate (keep status as sent, note in error)
                chrome_rec['is_duplicate'] = True
                chrome_rec['status'] = 'sent'
                chrome_rec['last_error'] = 'DUPLICATE: Sent by both Chrome and Edge'
                chrome_rec['attempts'] = chrome_rec['attempts'] + row['attempts']
                duplicates_found += 1
                print(f"  DUPLICATE SENT: {phone} ({chrome_rec['name']}) - sent by both Chrome and Edge")
            
            elif row['status'] == 'sent' and chrome_rec['chrome_status'] != 'sent':
                # Edge sent, Chrome failed/pending
                chrome_rec['status'] = 'sent'
                chrome_rec['sent_at'] = row['sent_at']
                chrome_rec['sent_by'] = 'edge'
                chrome_rec['attempts'] = chrome_rec['attempts'] + row['attempts']
                edge_sent_chrome_pending += 1
                print(f"  Edge succeeded: {phone} ({chrome_rec['name']}) - Chrome failed, Edge sent")
            
            elif row['status'] != 'sent' and chrome_rec['chrome_status'] == 'sent':
                # Chrome sent, Edge failed/pending - keep Chrome success
                chrome_rec['attempts'] = chrome_rec['attempts'] + row['attempts']
            
            else:
                # Both failed or pending - combine attempts
                total_attempts = chrome_rec['attempts'] + row['attempts']
                chrome_rec['attempts'] = total_attempts
                
                # Determine status based on attempts:
                # - If Chrome failed with exactly 2 attempts, mark as failed
                # - If Chrome failed with 1 attempt, give it another chance (pending)
                if chrome_rec['chrome_status'] == 'failed':
                    if chrome_rec['attempts'] == 2:
                        chrome_rec['status'] = 'failed'
                    else:
                        # Give it another chance (1 attempt only)
                        chrome_rec['status'] = 'pending'
                elif row['status'] == 'pending' or chrome_rec['status'] == 'pending':
                    chrome_rec['status'] = 'pending'
        else:
            # This number is only in Edge
            master_records[phone] = {
                'phone': phone,
                'name': row['name'],
                'status': row['status'],
                'attempts': row['attempts'],
                'last_error': row['last_error'],
                'last_attempt_at': row['last_attempt_at'],
                'sent_at': row['sent_at'],
                'sent_by': 'edge' if row['status'] == 'sent' else None,
                'chrome_status': None,
                'edge_status': row['status'],
                'is_duplicate': False
            }
    
    print(f"\n  Total duplicate sends: {duplicates_found}")
    print(f"  Edge rescued Chrome failures: {edge_sent_chrome_pending}")
    
    # Count final statuses
    status_counts = {'sent': 0, 'failed': 0, 'pending': 0, 'duplicated': 0}
    for rec in master_records.values():
        status = rec['status']
        if status == 'sent' and rec['is_duplicate']:
            status_counts['duplicated'] += 1
        elif status in status_counts:
            status_counts[status] += 1
    
    print("\n" + "="*60)
    print("MERGED RESULTS:")
    print("="*60)
    print(f"  Sent: {status_counts['sent']}")
    print(f"  Failed: {status_counts['failed']}")
    print(f"  Pending: {status_counts['pending']}")
    print(f"  Duplicated: {status_counts['duplicated']}")
    print(f"  Total: {len(master_records)}")
    
    # Write to shared database
    print("\n" + "="*60)
    print("Writing to progress_shared.db...")
    print("="*60)
    
    conn = sqlite3.connect('progress_shared.db')
    cursor = conn.cursor()
    
    # Clear existing records
    cursor.execute('DELETE FROM messages')
    conn.commit()
    
    # Insert merged records
    for rec in master_records.values():
        cursor.execute(
            '''INSERT INTO messages 
               (phone, name, status, attempts, last_error, last_attempt_at, sent_at, sent_by_account, message_hash)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
            (rec['phone'], rec['name'], rec['status'], rec['attempts'], 
             rec['last_error'], rec['last_attempt_at'], rec['sent_at'], 
             rec['sent_by'], message_hash)
        )
    
    conn.commit()
    
    # Verify
    cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
    final_counts = dict(cursor.fetchall())
    
    cursor.execute('SELECT COUNT(*) FROM messages')
    total = cursor.fetchone()[0]
    
    print(f"\n✅ Database updated!")
    print(f"\nFinal counts in progress_shared.db:")
    for status in ['sent', 'failed', 'pending', 'duplicated']:
        count = final_counts.get(status, 0)
        print(f"  {status}: {count}")
    print(f"  Total: {total}")
    
    # Check if pending matches expected 209
    expected_pending = 209
    actual_pending = final_counts.get('pending', 0)
    if actual_pending != expected_pending:
        print(f"\n⚠️  WARNING: Expected {expected_pending} pending, but got {actual_pending}")
        print(f"   Difference: {actual_pending - expected_pending}")
    else:
        print(f"\n✅ Pending count matches expected: {expected_pending}")
    
    conn.close()
    
    # Show detailed breakdown
    print("\n" + "="*60)
    print("DETAILED BREAKDOWN:")
    print("="*60)
    print(f"Chrome only records: {sum(1 for r in master_records.values() if r['edge_status'] is None)}")
    print(f"Edge only records: {sum(1 for r in master_records.values() if r['chrome_status'] is None)}")
    print(f"Both Chrome and Edge: {sum(1 for r in master_records.values() if r['chrome_status'] and r['edge_status'])}")

if __name__ == '__main__':
    merge_databases()
