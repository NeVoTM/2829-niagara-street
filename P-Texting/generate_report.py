#!/usr/bin/env python3
"""
Generate report of sent messages from database matched against current CSV file
"""

import sqlite3
from datetime import datetime, date
from pathlib import Path
import json
import pandas as pd
import phonenumbers

def generate_report(output_file=None, message_hash=None, config_file='config.json'):
    """Generate detailed report of messages (optionally filtered by message_hash)"""
    
    # Create reports directory if it doesn't exist
    reports_dir = Path("reports")
    reports_dir.mkdir(exist_ok=True)
    
    # Load current config to get CSV file, browser, database, and calculate message hash
    csv_file = None
    browser = 'chrome'  # Default
    db_path = 'progress.db'  # Default
    
    try:
        with open(config_file, 'r') as f:
            config = json.load(f)
            csv_file = config.get('input_path')
            browser = config.get('browser', 'chrome').capitalize()  # Chrome or Firefox
            db_path = config.get('database_path', 'progress.db')  # Get database path from config
            
            # Calculate current message hash if not provided
            if message_hash is None:
                import hashlib
                content = config['message_text']
                if config.get('salutation'):
                    content = config['salutation'] + content
                if config.get('image_path'):
                    content += f"|{config['image_path']}"
                message_hash = hashlib.sha256(content.encode()).hexdigest()[:16]
    except Exception as e:
        print(f"Warning: Could not load config from {config_file}: {e}")
        message_hash = None
        csv_file = None
        browser = 'chrome'
        db_path = 'progress.db'
    
    # Generate timestamped filename if not provided (CSV format for Google Sheets)
    if output_file is None:
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        output_file = reports_dir / f"results_{timestamp}.csv"
    else:
        output_file = Path(output_file)
    
    # Read the current CSV file to get ALL contacts
    csv_contacts = []
    if csv_file and Path(csv_file).exists():
        try:
            # Read CSV
            if csv_file.endswith('.csv'):
                df = pd.read_csv(csv_file)
            else:
                df = pd.read_excel(csv_file)
            
            # Filter by today's date if Date column exists
            if 'Date' in df.columns:
                df['Date'] = pd.to_datetime(df['Date'], errors='coerce')
                today = date.today()
                df = df[df['Date'].dt.date == today]
            
            # Process each contact
            for _, row in df.iterrows():
                phone_raw = str(row.get('Phone', '')).strip()
                name = str(row.get('Name', '')).strip()
                
                # Normalize phone number
                try:
                    if phone_raw.startswith('+'):
                        clean = '+' + ''.join(filter(str.isdigit, phone_raw))
                    else:
                        clean = ''.join(filter(str.isdigit, phone_raw))
                    parsed = phonenumbers.parse(clean, 'US')
                    if phonenumbers.is_valid_number(parsed):
                        phone = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.E164)
                        csv_contacts.append({'phone': phone, 'name': name})
                except:
                    pass  # Skip invalid numbers
        except Exception as e:
            print(f"Warning: Could not read CSV file: {e}")
    
    # If no CSV contacts, fall back to database
    if not csv_contacts:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        if message_hash:
            cursor.execute('SELECT phone, name FROM messages WHERE message_hash = ?', (message_hash,))
        else:
            cursor.execute('SELECT phone, name FROM messages')
        csv_contacts = [{'phone': r[0], 'name': r[1]} for r in cursor.fetchall()]
        conn.close()
    
    # Now get status from database for each contact
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    rows = []
    for contact in csv_contacts:
        phone = contact['phone']
        name = contact['name']
        
        # Look up status in database
        cursor.execute('''
            SELECT status, attempts, last_error, last_attempt_at, sent_at, account_label
            FROM messages 
            WHERE phone = ?
            ORDER BY last_attempt_at DESC
            LIMIT 1
        ''', (phone,))
        
        db_row = cursor.fetchone()
        
        if db_row:
            status, attempts, last_error, last_attempt_at, sent_at, account = db_row
        else:
            # Contact not yet attempted
            status = 'pending'
            attempts = 0
            last_error = None
            last_attempt_at = None
            sent_at = None
            account = 'account1'
        
        rows.append((phone, name, status, attempts, last_error, last_attempt_at, sent_at, account))
    
    conn.close()
    
    # Count statistics
    sent = sum(1 for r in rows if r[2] == 'sent')
    failed = sum(1 for r in rows if r[2] == 'failed')
    pending = sum(1 for r in rows if r[2] == 'pending')
    
    # Generate CSV report (perfect for Google Sheets)
    import csv
    
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        
        # Header row with summary
        writer.writerow(['P-TEXTING MESSAGE REPORT'])
        writer.writerow([f'Generated: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}'])
        writer.writerow([f'Browser: {browser}  |  Sent: {sent}  |  Failed: {failed}  |  Pending: {pending}  |  Total: {len(rows)}'])
        writer.writerow([])  # Empty row
        
        # Column headers
        writer.writerow(['Status', 'Name', 'Phone', 'Attempts', 'Sent/Attempted At', 'Browser', 'Error'])
        
        # Data rows
        for row in rows:
            phone, name, status, attempts, last_error, last_attempt_at, sent_at, account = row
            
            # Status emoji
            status_display = {
                'sent': '✅ Sent',
                'failed': '❌ Failed',
                'pending': '⏳ Pending',
                'landline': '☎️ Landline (No Retry)',
                'limit_reached': '🛑 Limit Reached'
            }.get(status, status)
            
            # Use sent_at if available, otherwise last_attempt_at
            timestamp = sent_at if sent_at else last_attempt_at
            
            # Clean error message - but ONLY show errors for failed/pending messages
            # Successfully sent messages shouldn't show post-send cleanup errors
            clean_error = ''
            if last_error and status != 'sent':  # Only show errors if NOT successfully sent
                clean_error = last_error
                # Remove stacktrace
                if 'Stacktrace:' in clean_error:
                    clean_error = clean_error.split('Stacktrace:')[0].strip()
                # Remove selenium prefix
                if 'Message:' in clean_error:
                    clean_error = clean_error.split('Message:')[-1].strip()
                # Truncate
                if len(clean_error) > 150:
                    clean_error = clean_error[:150] + "..."
            
            writer.writerow([
                status_display,
                name or '(No name)',
                phone,
                attempts,
                timestamp or 'Not attempted',
                browser,  # Show browser used
                clean_error
            ])
    
    return str(output_file), sent, failed, pending, len(rows)

if __name__ == "__main__":
    import sys
    
    # Accept config file as command line argument
    config_file = sys.argv[1] if len(sys.argv) > 1 else 'config.json'
    
    output_file, sent, failed, pending, total = generate_report(config_file=config_file)
    print(f"✅ Report generated: {output_file}")
    print(f"   Sent: {sent}, Failed: {failed}, Pending: {pending}, Total: {total}")
