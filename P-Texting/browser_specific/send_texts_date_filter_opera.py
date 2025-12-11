#!/usr/bin/env python3
"""
Google Voice Automated Texting Tool - WITH DATE FILTERING (OPERA VERSION)
Sends SMS/MMS messages ONLY to contacts with today's date

NOTE: This version is for OPERA browser only.
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
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service

# Import all classes from original send_texts.py (in junk folder)
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'junk'))
from send_texts import Config, Database, BrowserManager, GoogleVoiceSender, setup_logging


def check_remote_debugging_available(host='127.0.0.1', port=9225, timeout=2.0):
    """Check if Opera remote debugging is available"""
    # Try socket connection to check if port is listening
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        
        if result == 0:
            logging.info(f"✓ Opera remote debugging port {port} is available")
            return True, f"Opera remote debugging available on {host}:{port}"
        else:
            return False, f"Port {port} not listening"
    except Exception as e:
        return False, str(e)


def create_remote_debugging_driver(config, host='127.0.0.1', port=9225):
    """Create Opera driver that connects to existing Opera instance"""
    logging.info(f"Creating Opera driver with remote debugging at {host}:{port}...")
    
    options = webdriver.ChromeOptions()
    options.add_experimental_option("debuggerAddress", f"{host}:{port}")
    
    # Use webdriver-manager to get ChromeDriver version 140 (matches Opera 140)
    service = Service(ChromeDriverManager(driver_version="140.0.7339.249").install())
    driver = webdriver.Chrome(service=service, options=options)
    logging.info(f"✓ Connected to Opera via remote debugging")
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
            
            # Filter for today only
            df_today = df[df[date_col].dt.date == today]
            
            logging.info(f"Found {len(df_today)} contacts with today's date out of {len(df)} total")
            
            if len(df_today) == 0:
                logging.warning(f"No contacts found for today ({today}). No messages will be sent.")
                return []
            
            df = df_today
        
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
        
        logging.info(f"Loaded {len(deduped)} valid unique numbers for today")
        return deduped


def main():
    """Main entry point with date filtering"""
    print("="*60)
    print("Google Voice Automated Texting Tool - DATE FILTERED (OPERA)")
    print("="*60)
    
    # Load Opera-specific config
    try:
        config_path = Path("configs/config_opera.json")
        config = Config(str(config_path))
    except Exception as e:
        print(f"Error loading config: {e}")
        print(f"Note: Opera version uses configs/config_opera.json")
        return 1
    
    # Setup logging
    setup_logging(config['log_path'])
    logging.info("="*60)
    logging.info("Starting Google Voice automation session (OPERA)")
    logging.info(f"Browser: {config['browser']}")
    logging.info(f"Account: {config['account_label']}")
    logging.info(f"Port: {config['remote_debugging_port']}")
    logging.info("="*60)
    
    # Check remote debugging
    available, msg = check_remote_debugging_available(port=config['remote_debugging_port'])
    if not available:
        print(f"\n❌ ERROR: Opera remote debugging not available!")
        print(f"   Reason: {msg}")
        print(f"\n🔧 Please run 'start_opera_debug.bat' first!")
        print(f"   This will start Opera with remote debugging on port {config['remote_debugging_port']}")
        print(f"\n   Once Opera is running, come back and run this script again.\n")
        input("Press Enter to exit...")
        return 1
    
    logging.info("✓ Opera remote debugging verified")
    
    # Load contacts with DATE FILTER
    try:
        contacts = PhoneNumberProcessorWithDate.load_from_file_with_date_filter(
            config['input_path'],
            config['phone_column'],
            config['name_column'],
            config['date_column'],
            config['region_default_country_code']
        )
        
        if not contacts:
            print("\n⚠️  No contacts to send to today!")
            print("    The Date column filter found no matches for today's date.")
            print(f"    Today is: {date.today().strftime('%Y-%m-%d')}")
            print("\n    This is normal if you schedule contacts for specific dates.\n")
            input("Press Enter to exit...")
            return 0
            
    except Exception as e:
        logging.error(f"Failed to load contacts: {e}")
        print(f"\n❌ Error loading contacts: {e}\n")
        input("Press Enter to exit...")
        return 1
    
    print(f"\n📋 Loaded {len(contacts)} contacts for TODAY")
    print(f"📊 Account: {config['account_label']}")
    print(f"🌐 Browser: Opera on port {config['remote_debugging_port']}")
    print(f"🎯 Daily limit: {config['daily_limit']}")
    print(f"\nℹ️  This will send ONLY to contacts with today's date in the Date column\n")
    
    # Initialize database
    try:
        db = Database(config['database_path'])
    except Exception as e:
        logging.error(f"Database initialization failed: {e}")
        print(f"\n❌ Database error: {e}\n")
        input("Press Enter to exit...")
        return 1
    
    # Create browser driver (connects to existing Opera)
    try:
        driver = create_remote_debugging_driver(config, port=config['remote_debugging_port'])
        
        # Find or open Google Voice tab
        find_google_voice_tab(driver)
        
        # Wait a moment for page to be ready
        time.sleep(2)
        
    except Exception as e:
        logging.error(f"Failed to connect to Opera: {e}")
        print(f"\n❌ Error connecting to Opera: {e}")
        print(f"\n   Make sure Opera is running via start_opera_debug.bat\n")
        input("Press Enter to exit...")
        return 1
    
    # Send messages
    try:
        sender = GoogleVoiceSender(driver, config, db)
        sender.run(contacts)
    except KeyboardInterrupt:
        print("\n\n⏸️  Interrupted by user - progress saved!\n")
        logging.info("Session interrupted by user")
    except Exception as e:
        logging.error(f"Sending failed: {e}", exc_info=True)
        print(f"\n❌ Error during sending: {e}\n")
    finally:
        # Don't close driver - leave Opera open
        print("\n✅ Session complete - Opera stays open")
        logging.info("Session complete - browser left open")
    
    input("\nPress Enter to exit...")
    return 0


if __name__ == "__main__":
    sys.exit(main())
