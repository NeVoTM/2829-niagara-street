#!/usr/bin/env python3
"""
Google Voice Automated Texting Tool - WITH DATE FILTERING (FIREFOX VERSION)
Sends SMS/MMS messages ONLY to contacts with today's date

⚠️ FIREFOX LIMITATIONS:
- Launches a NEW Firefox instance each time (cannot connect to existing like Chrome)
- You MUST log in to Google Voice EVERY session
- Poor UX compared to Chrome version
- Use this only as a backup when Chrome hits daily limit

RECOMMENDED: Use send_texts_date_filter.py (Chrome version) as primary
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
import subprocess
from datetime import datetime, timedelta, date
from pathlib import Path
from typing import Optional, Dict, List, Tuple

import pandas as pd
import phonenumbers
from selenium import webdriver
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, WebDriverException

# Import all classes from original send_texts.py
from send_texts import Config, Database, BrowserManager, GoogleVoiceSender, setup_logging


def check_remote_debugging_available(browser='chrome', host='127.0.0.1', port=None, timeout=2.0):
    """Check if browser remote debugging is available"""
    # Set default port based on browser if not specified
    if port is None:
        if browser.lower() in ['chrome', 'edge', 'brave']:
            port = 9222
        elif browser.lower() == 'firefox':
            port = 6000
        else:
            port = 9222
    
    # Try socket connection to check if port is listening
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        
        if result == 0:
            logging.info(f"✓ Remote debugging port {port} is available for {browser.capitalize()}")
            return True, f"{browser.capitalize()} remote debugging available on {host}:{port}"
        else:
            return False, f"Port {port} not listening"
    except Exception as e:
        return False, str(e)


def close_all_firefox():
    """Close all Firefox instances before starting fresh"""
    # DISABLED - We want to connect to existing Firefox, not close it
    pass


def create_remote_debugging_driver(config, host='127.0.0.1'):
    """Launch Firefox for manual login (automation-detection bypassed)"""
    logging.info("="*60)
    logging.info("FIREFOX - MANUAL LOGIN MODE")
    logging.info("="*60)
    
    # Create/use persistent profile directory
    profile_path = Path("C:/temp/firefox_ptexting_profile")
    profile_path.mkdir(parents=True, exist_ok=True)
    
    logging.info(f"Using Firefox profile: {profile_path}")
    logging.info("Launching Firefox...")
    logging.info("")
    logging.info("[MANUAL SETUP REQUIRED]")
    logging.info("Please log in to Google Voice manually in the Firefox window.")
    logging.info("Once logged in, the automation will take over.")
    logging.info("")
    
    options = webdriver.FirefoxOptions()
    
    # Use persistent profile to stay logged in between sessions
    options.add_argument("-profile")
    options.add_argument(str(profile_path))
    
    service = FirefoxService(GeckoDriverManager().install())
    driver = webdriver.Firefox(service=service, options=options)
    
    # Manual control note
    logging.info("Firefox launched. Please proceed with login.")
    
    logging.info("[OK] Firefox launched successfully")
    
    # Navigate to Google Voice
    logging.info("Opening Google Voice...")
    driver.get("https://voice.google.com/messages")
    
    # Check if already logged in (profile persistence)
    logging.info("Checking login status...")
    time.sleep(3)
    
    # Look for signs of being logged in
    try:
        # If we can find the "Send new message" element, we're logged in
        if "voice.google.com" in driver.current_url:
            driver.find_element(By.XPATH, "//*[contains(text(), 'Send new message')]")
            logging.info("[OK] Already logged in! (Profile worked)")
        else:
            raise Exception("Not logged in")
    except:
        # Not logged in, wait for user
        logging.info("="*60)
        logging.info("PLEASE LOG IN")
        logging.info("="*60)
        logging.info("")
        logging.info("[!] PLEASE LOG IN TO GOOGLE VOICE NOW!")
        logging.info("")
        logging.info("Automation will wait 60 seconds for you to log in...")
        logging.info("Your login will be saved for next time!")
        logging.info("")
        
        # Wait for user to log in (give them time)
        time.sleep(60)
        
        logging.info("[OK] Proceeding with message sending...")
        logging.info("")
    
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
    print("Google Voice Automated Texting Tool - DATE FILTERED")
    print("="*60)
    
    # Load Firefox-specific config
    try:
        config = Config("config_firefox.json")
    except Exception as e:
        print(f"Error loading config: {e}")
        print("Note: Firefox version uses config_firefox.json")
        return 1
    
    # Setup logging
    setup_logging(config['log_path'])
    
    logging.info("Starting Google Voice sender WITH DATE FILTERING (Firefox)...")
    logging.info(f"Account: {config['account_label']}")
    logging.info(f"Browser: Firefox")
    logging.warning("[!] Firefox will launch a NEW instance - you must log in again")
    
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
    
    # Insert numbers into database (skip if already exists)
    db.upsert_numbers(numbers, config['account_label'], message_hash)
    
    # Determine browser and port
    browser = config.get('browser', 'chrome').lower()
    
    # Validate browser choice
    if browser not in ['chrome', 'edge', 'brave', 'firefox']:
        error_msg = f"Unsupported browser '{browser}' in config.json. Supported: chrome, firefox, edge, brave"
        logging.error(error_msg)
        print(f"\n❌ {error_msg}")
        return 1
    
    # Determine port based on browser
    if browser in ['chrome', 'edge', 'brave']:
        port = 9222
    elif browser == 'firefox':
        port = 6000
    
    # Firefox launches directly (no port check needed)
    logging.info("Firefox will launch automatically - no port check needed")
    
    # Create browser driver (connects to existing browser instance)
    driver = None
    try:
        logging.info(f"Connecting to existing {browser.capitalize()} browser...")
        driver = create_remote_debugging_driver(config)
        
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
            logging.info(f"COMPLETE! {browser.capitalize()} window left open for you to review.")
            logging.info("Check Google Voice to see sent messages!")
            logging.info("="*60)
        db.close()
    
    logging.info("Done!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
