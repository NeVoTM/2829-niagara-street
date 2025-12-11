#!/usr/bin/env python3
"""
Database Migration: Add Enhanced Tracking Fields

Adds fields to track:
- sent_by_email: Which email/account was used
- sent_by_tel: Which phone number sent the message  
- sent_by_browser: Which browser was used (chrome, edge, firefox, opera, etc.)

This enables multi-account rotation and helps avoid detection by varying:
1. Browser fingerprints (Chrome, Edge, Firefox, Opera, Brave, Vivaldi)
2. Google Voice accounts (multiple emails)
3. Google Voice phone numbers (multiple numbers per account or different accounts)
"""

import sqlite3
import sys
from pathlib import Path

def add_tracking_fields(db_path):
    """Add new tracking fields to messages table"""
    
    print(f"Connecting to database: {db_path}")
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Check current schema
    cursor.execute("PRAGMA table_info(messages)")
    columns = [row[1] for row in cursor.fetchall()]
    print(f"Current columns: {', '.join(columns)}")
    
    # Add new columns if they don't exist
    new_columns = [
        ("sent_by_email", "TEXT", "Email/account that sent the message"),
        ("sent_by_tel", "TEXT", "Phone number that sent the message"),
        ("sent_by_browser", "TEXT", "Browser used (chrome, edge, firefox, etc.)"),
        ("sent_by_ip", "TEXT", "IP address when message was sent (for VPN/proxy rotation)")
    ]
    
    for col_name, col_type, description in new_columns:
        if col_name not in columns:
            print(f"Adding column: {col_name} ({description})")
            cursor.execute(f"ALTER TABLE messages ADD COLUMN {col_name} {col_type}")
            conn.commit()
        else:
            print(f"Column already exists: {col_name}")
    
    # Verify changes
    cursor.execute("PRAGMA table_info(messages)")
    columns_after = [row[1] for row in cursor.fetchall()]
    print(f"\nUpdated columns: {', '.join(columns_after)}")
    
    conn.close()
    print("\n✓ Migration complete!")

def main():
    # Default to progress_shared.db in current directory
    if len(sys.argv) > 1:
        db_path = sys.argv[1]
    else:
        db_path = Path(__file__).parent.parent / "progress_shared.db"
    
    if not Path(db_path).exists():
        print(f"ERROR: Database not found: {db_path}")
        sys.exit(1)
    
    # Backup warning
    print("=" * 60)
    print("DATABASE MIGRATION - Add Tracking Fields")
    print("=" * 60)
    print(f"Database: {db_path}")
    print("\nThis will add 4 new columns to the messages table:")
    print("  1. sent_by_email   - Email account used")
    print("  2. sent_by_tel     - Phone number used")  
    print("  3. sent_by_browser - Browser used")
    print("  4. sent_by_ip      - IP address (for VPN/proxy rotation)")
    print("\nRecommendation: Backup your database first!")
    print("=" * 60)
    
    response = input("\nContinue with migration? (yes/no): ")
    if response.lower() not in ['yes', 'y']:
        print("Migration cancelled.")
        sys.exit(0)
    
    add_tracking_fields(db_path)

if __name__ == "__main__":
    main()
