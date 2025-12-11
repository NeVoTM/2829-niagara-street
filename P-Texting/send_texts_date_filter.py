#!/usr/bin/env python3
"""
Google Voice Automated Texting Tool - WITH DATE FILTERING (CHROME VERSION)
Sends SMS/MMS messages ONLY to contacts with today's date

NOTE: This version is for CHROME only. For Firefox, use send_texts_date_filter_firefox.py
"""

import json
import sqlite3
import hashlib
import logging
import time
import random
import os
import sys
import socket
import urllib.request
import urllib.error
from datetime import datetime, timedelta, date
from pathlib import Path
from typing import Optional, Dict, List, Tuple

import pandas as pd
import phonenumbers
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, WebDriverException

# Import all classes from original send_texts.py (in junk folder)
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'junk'))
from send_texts import Config, Database, BrowserManager, GoogleVoiceSender, setup_logging


def check_remote_debugging_available(host='127.0.0.1', port=9222, timeout=2.0):
    """Check if Chrome remote debugging is available"""
    # Try socket connection to check if port is listening
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        
        if result == 0:
            logging.info(f"✓ Chrome remote debugging port {port} is available")
            return True, f"Chrome remote debugging available on {host}:{port}"
        else:
            return False, f"Port {port} not listening"
    except Exception as e:
        return False, str(e)


def create_remote_debugging_driver(config, host='127.0.0.1', port=9222):
    """Create browser driver that connects to existing browser instance"""
    browser = config.get('browser', 'chrome').lower()
    logging.info(f"Creating {browser} driver with remote debugging at {host}:{port}...")
    
    if browser == 'edge':
        from selenium.webdriver.edge.options import Options as EdgeOptions
        options = EdgeOptions()
        options.add_experimental_option("debuggerAddress", f"{host}:{port}")
        driver = webdriver.Edge(options=options)
    else:
        # Default to Chrome
        options = webdriver.ChromeOptions()
        options.add_experimental_option("debuggerAddress", f"{host}:{port}")
        driver = webdriver.Chrome(options=options)
    
    logging.info(f"Connected to {browser} via remote debugging")
    return driver


def find_google_voice_tab(driver):
    """Find and switch to Google Voice tab, or open new one"""
    original_window = driver.current_window_handle
    
    # Check all windows/tabs
    for window_handle in driver.window_handles:
        driver.switch_to.window(window_handle)
        if "voice.google.com" in driver.current_url:
            logging.info(f"Found existing Google Voice tab: {driver.current_url}")
            return True
    
    # No Google Voice tab found, open a new one
    logging.info("No Google Voice tab found, opening new one...")
    driver.switch_to.window(original_window)
    driver.execute_script("window.open('https://voice.google.com/messages', '_blank');")
    time.sleep(2)
    
    # Switch to the new tab
    driver.switch_to.window(driver.window_handles[-1])
    return True


class PhoneNumberProcessorWithDate:
    """Phone number normalization and validation WITH DATE FILTERING"""
    
    @staticmethod
    def normalize(phone: str, region: str = "US") -> Optional[str]:
        """Normalize phone number to E.164 format"""
        try:
            # Remove all non-digits except leading +
            if phone.startswith('+'):
                clean = '+' + ''.join(filter(str.isdigit, phone))
            else:
                clean = ''.join(filter(str.isdigit, phone))
            
            # Parse with phonenumbers library
            parsed = phonenumbers.parse(clean, region)
            
            if phonenumbers.is_valid_number(parsed):
                return phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.E164)
            else:
                return None
        except phonenumbers.NumberParseException:
            return None
    
    @staticmethod
    def load_from_file_with_date_filter(file_path: str, phone_col: str, name_col: str, 
                                        date_col: str = "Date", region: str = "US") -> List[Dict]:
        """Load and normalize phone numbers from CSV/Excel - FILTER BY TODAY'S DATE"""
        # Read file based on extension
        file_path = Path(file_path)
        if file_path.suffix.lower() == '.csv':
            df = pd.read_csv(file_path)
        elif file_path.suffix.lower() in ['.xlsx', '.xls']:
            df = pd.read_excel(file_path)
        else:
            raise ValueError(f"Unsupported file format: {file_path.suffix}")
        
        # Validate columns
        if phone_col not in df.columns:
            raise ValueError(f"Phone column '{phone_col}' not found in file")
        if name_col not in df.columns:
            raise ValueError(f"Name column '{name_col}' not found in file")
        
        # Check for date column
        has_date_filter = date_col in df.columns
        today = date.today()
        
        logging.info(f"Date filtering: {'ENABLED' if has_date_filter else 'DISABLED (no Date column found)'}")
        if has_date_filter:
            logging.info(f"Today's date: {today.strftime('%Y-%m-%d')}")
        
        # Filter by today's date if column exists
        if has_date_filter:
            # Convert date column to datetime, handling various formats
            df[date_col] = pd.to_datetime(df[date_col], errors='coerce')
            
            # Filter for today AND earlier dates (to catch pending records from yesterday)
            df_ready = df[df[date_col].dt.date <= today]
            
            # Count breakdown for logging
            earlier = len(df[df[date_col].dt.date < today])
            today_count = len(df[df[date_col].dt.date == today])
            
            logging.info(f"Found {len(df_ready)} contacts with date <= today out of {len(df)} total")
            if earlier > 0:
                logging.info(f"  WARNING: {earlier} records from earlier dates (will process pending ones)")
            if today_count > 0:
                logging.info(f"  OK: {today_count} records from today")
            
            if len(df_ready) == 0:
                logging.warning(f"No contacts found for today or earlier. No messages will be sent.")
                return []
            
            df = df_ready
        
        # Process numbers
        results = []
        for idx, row in df.iterrows():
            phone = str(row[phone_col]).strip()
            name = str(row[name_col]).strip() if pd.notna(row[name_col]) else ""
            
            normalized = PhoneNumberProcessorWithDate.normalize(phone, region)
            if normalized:
                results.append({
                    'phone': normalized,
                    'name': name,
                    'original': phone
                })
            else:
                logging.warning(f"Row {idx+2}: Invalid phone number '{phone}' - skipped")
        
        # Deduplicate
        seen = set()
        deduped = []
        for item in results:
            if item['phone'] not in seen:
                seen.add(item['phone'])
                deduped.append(item)
        
        logging.info(f"Loaded {len(deduped)} valid unique numbers (date <= today)")
        return deduped


def main():
    """Main entry point with date filtering"""
    print("="*60)
    print("Google Voice Automated Texting Tool - DATE FILTERED")
    print("="*60)
    
    # Get config file from command line or use default
    config_file = sys.argv[1] if len(sys.argv) > 1 else "config.json"
    print(f"Using config file: {config_file}")
    
    # Load config
    try:
        config = Config(config_file)
    except Exception as e:
        print(f"Error loading config {config_file}: {e}")
        # Fall back to config.json for backwards compatibility
        if config_file != "config.json":
            try:
                print("Trying config.json as fallback...")
                config = Config("config.json")
            except:
                return 1
        else:
            return 1
    
    # Setup logging
    setup_logging(config['log_path'])
    
    logging.info("Starting Google Voice sender WITH DATE FILTERING (Chrome)...")
    logging.info(f"Account: {config['account_label']}")
    logging.info(f"Browser: Chrome")
    
    # Initialize database
    db = Database(config['database_path'])
    
    # Load phone numbers WITH DATE FILTER
    try:
        numbers = PhoneNumberProcessorWithDate.load_from_file_with_date_filter(
            config['input_path'],
            config['phone_column'],
            config['name_column'],
            config.get('date_column', 'Date'),
            config['region_default_country_code']
        )
    except Exception as e:
        logging.error(f"Error loading phone numbers: {e}")
        return 1
    
    if not numbers:
        logging.error("No valid phone numbers found for today's date")
        try:
            print("\n⚠️  No contacts found for today's date!")
        except:
            print("\nNo contacts found for today's date!")
        print("Check your CSV file has a 'Date' column with today's date.")
        return 1
    
    try:
        print(f"\n✅ Found {len(numbers)} contacts for today")
    except:
        print(f"\nFound {len(numbers)} contacts for today")
    
    # Compute message hash for this campaign (must match GoogleVoiceSender._compute_message_hash)
    content = config['message_text']
    if config.get('image_path'):
        content += f"|{config['image_path']}"
    message_hash = hashlib.sha256(content.encode()).hexdigest()[:16]
    
    logging.info(f"Computed message hash: {message_hash}")
    
    # Insert/update numbers into database - CSV is the source of truth
    print(f"Preparing {len(numbers)} contacts...")
    # Use upsert_numbers to add new contacts
    db.upsert_numbers(numbers, message_hash)
    
    # IMPORTANT: Reset any contacts from CSV that exist in DB but are marked as 'sent'
    # The CSV with today's date is the source of truth for what should be sent TODAY
    cursor = db.conn.cursor()
    phones_to_reset = [num['phone'] for num in numbers]
    placeholders = ','.join(['?' for _ in phones_to_reset])
    cursor.execute(f"""
        UPDATE messages 
        SET status='pending', attempts=0, sent_at=NULL, last_error=NULL
        WHERE phone IN ({placeholders})
        AND status != 'pending'
        AND message_hash = ?
    """, phones_to_reset + [message_hash])
    reset_count = cursor.rowcount
    db.conn.commit()
    
    if reset_count > 0:
        logging.info(f"Reset {reset_count} previously sent/failed contacts to pending (CSV says send today)")
        print(f"Reset {reset_count} contacts to pending based on CSV date")
    
    print("Ready to send!")
    
    # Check Chrome remote debugging is available
    port = config.get('remote_debugging_port', 9222)
    browser_name = config.get('browser', 'Chrome').capitalize()
    logging.info(f"Checking {browser_name} remote debugging on port {port}...")
    available, debug_info = check_remote_debugging_available('127.0.0.1', port)
    
    if not available:
        error_msg = f"Could not connect to {browser_name} remote debugging on 127.0.0.1:{port}.\n"
        error_msg += f"Please start {browser_name} with remote debugging enabled:\n"
        error_msg += f"  Option 1: Use the 'Start {browser_name} Debug' button in the GUI\n"
        error_msg += f"  Option 2: Run start_{config.get('browser', 'chrome')}_debug.bat in P-Texting folder\n"
        error_msg += "Then navigate to https://voice.google.com/messages and try again.\n"
        error_msg += f"\nError details: {debug_info}\n"
        logging.error(error_msg)
        print(f"\n❌ {error_msg}")
        return 1
    
    logging.info(f"✓ Connected to {browser_name}: {debug_info}")
    
    # Create driver (connects to existing browser instance)
    driver = None
    try:
        logging.info(f"Connecting to existing {browser_name} browser...")
        driver = create_remote_debugging_driver(config, '127.0.0.1', port)
        
        # Find or open Google Voice tab
        find_google_voice_tab(driver)
        
        # Initialize sender and run
        sender = GoogleVoiceSender(driver, config, db)
        sender.initialize()
        sender.run()
        
    except KeyboardInterrupt:
        logging.info("\nStopped by user. Progress saved.")
    except Exception as e:
        logging.error(f"Fatal error: {e}", exc_info=True)
        return 1
    finally:
        # DO NOT QUIT THE DRIVER - leave browser window open
        if driver:
            logging.info("\n" + "="*60)
            logging.info(f"COMPLETE! {browser_name} window left open for you to review.")
            logging.info("Check Google Voice to see sent messages!")
            logging.info("="*60)
        db.close()
    
    logging.info("Done!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
