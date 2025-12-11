#!/usr/bin/env python3
"""
Extract Google Voice Account Information

This script attempts to extract the email address and phone number
from an active Google Voice session in the browser.

Two methods:
1. From browser cookies/session (if logged in)
2. From Google Voice web page elements (recommended)
"""

import sys
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException

def connect_to_existing_browser(port=9222, browser='chrome'):
    """Connect to existing browser with remote debugging"""
    print(f"Connecting to {browser} on port {port}...")
    
    try:
        if browser.lower() == 'edge':
            from selenium.webdriver.edge.options import Options as EdgeOptions
            options = EdgeOptions()
            options.add_experimental_option("debuggerAddress", f"127.0.0.1:{port}")
            driver = webdriver.Edge(options=options)
        else:
            # Default to Chrome
            options = webdriver.ChromeOptions()
            options.add_experimental_option("debuggerAddress", f"127.0.0.1:{port}")
            driver = webdriver.Chrome(options=options)
        
        print(f"✓ Connected to {browser}")
        return driver
    except Exception as e:
        print(f"✗ Failed to connect: {e}")
        return None

def find_google_voice_tab(driver):
    """Find and switch to Google Voice tab"""
    print("\nLooking for Google Voice tab...")
    
    for window_handle in driver.window_handles:
        driver.switch_to.window(window_handle)
        if "voice.google.com" in driver.current_url:
            print(f"✓ Found Google Voice tab: {driver.current_url}")
            return True
    
    print("✗ No Google Voice tab found")
    print("\nPlease:")
    print("1. Open Google Voice in the browser: https://voice.google.com")
    print("2. Make sure you're logged in")
    print("3. Run this script again")
    return False

def extract_email_from_page(driver):
    """Extract email from Google Voice page"""
    print("\nExtracting email address...")
    
    # Method 1: Try to find profile button/avatar with email
    selectors = [
        # Google account button (usually shows email or profile pic)
        "button[aria-label*='Google Account']",
        "button[aria-label*='account']",
        "a[aria-label*='Google Account']",
        
        # Profile avatar
        "img[alt*='profile']",
        "img[alt*='account']",
        
        # Sometimes email is in page metadata
        "meta[name='email']",
        "meta[property='email']",
    ]
    
    for selector in selectors:
        try:
            element = driver.find_element(By.CSS_SELECTOR, selector)
            # Try to get email from aria-label, title, or data attributes
            for attr in ['aria-label', 'title', 'data-email', 'alt']:
                value = element.get_attribute(attr)
                if value and '@' in value:
                    print(f"✓ Found email: {value}")
                    return value
        except:
            continue
    
    # Method 2: Try to click profile button and read email
    try:
        profile_button = driver.find_element(By.CSS_SELECTOR, "button[aria-label*='Google Account']")
        profile_button.click()
        
        # Wait for dropdown/menu to appear
        import time
        time.sleep(1)
        
        # Try to find email in dropdown
        email_elements = driver.find_elements(By.CSS_SELECTOR, "[class*='email'], [class*='account']")
        for elem in email_elements:
            text = elem.text
            if '@' in text and '.com' in text:
                print(f"✓ Found email from dropdown: {text}")
                return text
    except:
        pass
    
    # Method 3: Execute JavaScript to find email in page
    try:
        script = """
        // Try to find email in various places
        const bodyText = document.body.innerText;
        const emailRegex = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g;
        const matches = bodyText.match(emailRegex);
        return matches ? matches[0] : null;
        """
        email = driver.execute_script(script)
        if email:
            print(f"✓ Found email via JavaScript: {email}")
            return email
    except:
        pass
    
    print("✗ Could not extract email automatically")
    print("\n💡 You'll need to add it manually to config.json:")
    print('   "voice_email": "your_email@gmail.com"')
    return None

def extract_phone_from_page(driver):
    """Extract phone number from Google Voice page"""
    print("\nExtracting phone number...")
    
    # Method 1: Look for phone number in page elements
    selectors = [
        # Settings/account area often shows the number
        "[class*='phone']",
        "[class*='number']",
        "[aria-label*='phone']",
        "[title*='phone']",
        
        # Sometimes in header or sidebar
        "header [class*='number']",
        "[class*='account'] [class*='number']",
    ]
    
    for selector in selectors:
        try:
            elements = driver.find_elements(By.CSS_SELECTOR, selector)
            for elem in elements:
                text = elem.text
                # Look for phone number pattern: +1xxxxxxxxxx or (xxx) xxx-xxxx
                if text and (text.startswith('+1') or text.startswith('(')) and len(text) >= 10:
                    # Clean up the number
                    cleaned = ''.join(c for c in text if c.isdigit() or c == '+')
                    if len(cleaned) >= 10:
                        print(f"✓ Found phone number: {text}")
                        return text
        except:
            continue
    
    # Method 2: Execute JavaScript to find phone number
    try:
        script = """
        // Try to find phone number in page text
        const bodyText = document.body.innerText;
        
        // Patterns: +1xxxxxxxxxx or (xxx) xxx-xxxx
        const patterns = [
            /\\+1\\d{10}/g,
            /\\(\\d{3}\\)\\s*\\d{3}-\\d{4}/g,
            /\\d{3}-\\d{3}-\\d{4}/g
        ];
        
        for (let pattern of patterns) {
            const matches = bodyText.match(pattern);
            if (matches && matches.length > 0) {
                return matches[0];
            }
        }
        return null;
        """
        phone = driver.execute_script(script)
        if phone:
            print(f"✓ Found phone number via JavaScript: {phone}")
            return phone
    except:
        pass
    
    # Method 3: Try to navigate to settings page where number is shown
    try:
        print("\n  Trying to navigate to settings page...")
        current_url = driver.current_url
        
        # Try settings URL
        driver.get("https://voice.google.com/u/0/settings")
        import time
        time.sleep(2)
        
        # Look for number on settings page
        body_text = driver.find_element(By.TAG_NAME, "body").text
        
        # Search for phone pattern in settings page
        import re
        patterns = [
            r'\+1\d{10}',
            r'\(\d{3}\)\s*\d{3}-\d{4}',
            r'\d{3}-\d{3}-\d{4}'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, body_text)
            if match:
                phone = match.group(0)
                print(f"✓ Found phone number from settings: {phone}")
                driver.get(current_url)  # Go back
                return phone
        
        driver.get(current_url)  # Go back
    except:
        pass
    
    print("✗ Could not extract phone number automatically")
    print("\n💡 You can find your Google Voice number at: https://voice.google.com/u/0/settings")
    print('   Then add it manually to config.json:')
    print('   "voice_phone": "+13055551234"')
    return None

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Extract Google Voice account info from browser")
    parser.add_argument('--port', type=int, default=9222, help='Remote debugging port (default: 9222)')
    parser.add_argument('--browser', type=str, default='chrome', help='Browser type (chrome, edge)')
    args = parser.parse_args()
    
    print("=" * 70)
    print("EXTRACT GOOGLE VOICE ACCOUNT INFORMATION")
    print("=" * 70)
    print()
    print("This script will attempt to extract:")
    print("  1. Email address (logged in account)")
    print("  2. Phone number (Google Voice number)")
    print()
    print("Requirements:")
    print("  - Browser must be running with remote debugging")
    print("  - Must be logged into Google Voice")
    print("  - Google Voice tab must be open")
    print()
    print("=" * 70)
    print()
    
    # Connect to browser
    driver = connect_to_existing_browser(args.port, args.browser)
    if not driver:
        print("\n✗ Failed to connect to browser")
        print("\nMake sure:")
        print("  1. Browser is running with remote debugging")
        print(f"  2. Port {args.port} is correct")
        print("  3. Run the appropriate start_XXX_debug.bat first")
        return
    
    # Find Google Voice tab
    if not find_google_voice_tab(driver):
        return
    
    # Extract information
    email = extract_email_from_page(driver)
    phone = extract_phone_from_page(driver)
    
    # Summary
    print("\n" + "=" * 70)
    print("RESULTS")
    print("=" * 70)
    print()
    
    if email or phone:
        print("✓ Successfully extracted some information:")
        print()
        if email:
            print(f"  Email: {email}")
        if phone:
            print(f"  Phone: {phone}")
        print()
        print("Add these to your config.json:")
        print("{")
        if email:
            print(f'  "voice_email": "{email}",')
        else:
            print(f'  "voice_email": "your_email@gmail.com",  // NEEDS MANUAL ENTRY')
        if phone:
            print(f'  "voice_phone": "{phone}"')
        else:
            print(f'  "voice_phone": "+13055551234"  // NEEDS MANUAL ENTRY')
        print("}")
    else:
        print("✗ Could not extract information automatically")
        print()
        print("Manual steps:")
        print("  1. Go to: https://voice.google.com/u/0/settings")
        print("  2. Note your email (top right, click profile)")
        print("  3. Note your phone number (shown on settings page)")
        print("  4. Add to config.json:")
        print('     "voice_email": "your_email@gmail.com",')
        print('     "voice_phone": "+13055551234"')
    
    print()
    print("=" * 70)

if __name__ == "__main__":
    main()
