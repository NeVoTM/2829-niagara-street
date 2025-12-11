#!/usr/bin/env python3
"""
Google Voice Login Helper
Opens Google Voice in your Chrome profile so you can log in manually
"""

import json
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options
import time

def main():
    print("=" * 60)
    print("Google Voice Login Helper")
    print("=" * 60)
    
    # Load config
    with open("config.json", "r") as f:
        config = json.load(f)
    
    # Setup Chrome options
    chrome_options = Options()
    
    profile_path = config.get("browser_profile_path", "")
    if profile_path:
        # Split into user-data-dir and profile-directory
        import os
        user_data_dir = os.path.dirname(profile_path)
        profile_dir = os.path.basename(profile_path)
        
        chrome_options.add_argument(f"--user-data-dir={user_data_dir}")
        chrome_options.add_argument(f"--profile-directory={profile_dir}")
        print(f"✓ Using Chrome profile: {profile_dir}")
    
    print("\n🌐 Opening Google Voice...")
    print("\nPLEASE DO THE FOLLOWING:")
    print("1. Log into your Google account if needed")
    print("2. Go to Google Voice and verify you can see your messages")
    print("3. Keep this browser window OPEN")
    print("4. Press Ctrl+C in this terminal when done")
    print("\n" + "=" * 60)
    
    try:
        driver = webdriver.Chrome(options=chrome_options)
        driver.get("https://voice.google.com")
        
        print("\n✓ Browser opened successfully!")
        print("Waiting for you to log in...")
        print("Press Ctrl+C when finished")
        
        # Keep browser open
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\n\n✅ Login process completed!")
        print("You can now close the browser and use the P-Texting app")
        driver.quit()
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("\nTry running the app and logging in manually when Chrome opens")

if __name__ == "__main__":
    main()
