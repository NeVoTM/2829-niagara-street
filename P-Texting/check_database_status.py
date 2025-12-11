#!/usr/bin/env python3
"""
Check database status - get counts by status
"""
import sqlite3
from pathlib import Path

def check_database_status(db_path='progress_shared.db'):
    """Get status counts from database"""
    
    if not Path(db_path).exists():
        return None, f"Database not found: {db_path}"
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Get status counts
        cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status')
        status_counts = dict(cursor.fetchall())
        
        # Get total
        cursor.execute('SELECT COUNT(*) FROM messages')
        total = cursor.fetchone()[0]
        
        conn.close()
        
        result = {
            'sent': status_counts.get('sent', 0),
            'failed': status_counts.get('failed', 0),
            'pending': status_counts.get('pending', 0),
            'total': total
        }
        
        return result, None
        
    except Exception as e:
        return None, f"Error reading database: {str(e)}"

def format_status(result):
    """Format status as readable text"""
    if not result:
        return "No data available"
    
    output = "Current Database Status\n\n"
    output += f"•  Sent: {result['sent']}\n"
    output += f"•  Failed: {result['failed']}\n"
    output += f"•  Pending: {result['pending']}\n"
    output += f"•  Total: {result['total']}"
    
    return output

if __name__ == '__main__':
    result, error = check_database_status()
    
    if error:
        print(f"Error: {error}")
    else:
        print(format_status(result))
