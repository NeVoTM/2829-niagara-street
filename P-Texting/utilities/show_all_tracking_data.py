#!/usr/bin/env python3
"""
Demonstrate All Trackable Data Points

This script shows ALL the data we can automatically capture for each message send.
These data points help avoid detection and track rotation effectiveness.
"""

import json
import sys
import platform
import socket
from pathlib import Path
from datetime import datetime

# Add parent directory to path to import utilities
sys.path.insert(0, str(Path(__file__).parent))
from get_ip_address import get_public_ip, get_public_ip_with_info

def get_browser_info(config_path="config.json"):
    """Get browser info from config file"""
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
        return {
            'browser': config.get('browser', 'UNKNOWN'),
            'remote_debugging_port': config.get('remote_debugging_port', 'UNKNOWN'),
            'browser_profile_path': config.get('browser_profile_path', 'UNKNOWN')
        }
    except Exception as e:
        return {'error': str(e)}

def get_account_info(config_path="config.json"):
    """Get account info from config file"""
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
        return {
            'account_label': config.get('account_label', 'UNKNOWN'),
            'voice_email': config.get('voice_email', 'NOT SET'),
            'voice_phone': config.get('voice_phone', 'NOT SET')
        }
    except Exception as e:
        return {'error': str(e)}

def get_system_info():
    """Get system information"""
    return {
        'os': platform.system(),
        'os_version': platform.version(),
        'machine': platform.machine(),
        'hostname': socket.gethostname(),
        'python_version': platform.python_version()
    }

def get_network_info():
    """Get network information"""
    try:
        # Local IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except:
        local_ip = "UNKNOWN"
    
    # Public IP with details
    public_info = get_public_ip_with_info()
    
    return {
        'local_ip': local_ip,
        'public_ip': public_info.get('ip', 'UNKNOWN'),
        'city': public_info.get('city', 'UNKNOWN'),
        'region': public_info.get('region', 'UNKNOWN'),
        'country': public_info.get('country', 'UNKNOWN'),
        'isp': public_info.get('org', 'UNKNOWN')
    }

def get_timestamp_info():
    """Get timestamp information"""
    now = datetime.now()
    return {
        'timestamp': now.isoformat(),
        'date': now.strftime('%Y-%m-%d'),
        'time': now.strftime('%H:%M:%S'),
        'day_of_week': now.strftime('%A'),
        'timezone': now.astimezone().tzname()
    }

def display_all_data():
    """Display all trackable data points"""
    
    print("=" * 70)
    print("P-TEXTING: ALL TRACKABLE DATA POINTS")
    print("=" * 70)
    print()
    
    # 1. TIMESTAMP INFO
    print("📅 TIMESTAMP INFORMATION")
    print("-" * 70)
    timestamp = get_timestamp_info()
    for key, value in timestamp.items():
        print(f"  {key:20s}: {value}")
    print()
    
    # 2. BROWSER INFO (sent_by_browser)
    print("🌐 BROWSER INFORMATION (sent_by_browser)")
    print("-" * 70)
    browser = get_browser_info()
    for key, value in browser.items():
        print(f"  {key:20s}: {value}")
    print()
    
    # 3. ACCOUNT INFO (sent_by_email, sent_by_tel)
    print("📧 ACCOUNT INFORMATION (sent_by_email, sent_by_tel)")
    print("-" * 70)
    account = get_account_info()
    for key, value in account.items():
        print(f"  {key:20s}: {value}")
    print()
    
    # 4. NETWORK INFO (sent_by_ip)
    print("🗺️  NETWORK INFORMATION (sent_by_ip)")
    print("-" * 70)
    network = get_network_info()
    for key, value in network.items():
        print(f"  {key:20s}: {value}")
    print()
    
    # 5. SYSTEM INFO (additional context)
    print("💻 SYSTEM INFORMATION (additional context)")
    print("-" * 70)
    system = get_system_info()
    for key, value in system.items():
        print(f"  {key:20s}: {value}")
    print()
    
    # 6. SUMMARY OF ROTATION VARIABLES
    print("=" * 70)
    print("🎯 4 CRITICAL ROTATION VARIABLES (Will be saved to database)")
    print("=" * 70)
    print(f"  1. sent_by_browser : {browser.get('browser', 'UNKNOWN')}")
    print(f"  2. sent_by_email   : {account.get('voice_email', 'NOT SET')}")
    print(f"  3. sent_by_tel     : {account.get('voice_phone', 'NOT SET')}")
    print(f"  4. sent_by_ip      : {network.get('public_ip', 'UNKNOWN')}")
    print()
    
    # 7. DETECTION AVOIDANCE SUMMARY
    print("=" * 70)
    print("✅ DATA POINTS SUCCESSFULLY CAPTURED")
    print("=" * 70)
    
    capturable = [
        ("Browser Type", browser.get('browser', 'UNKNOWN'), "✅ YES"),
        ("Browser Port", browser.get('remote_debugging_port', 'UNKNOWN'), "✅ YES"),
        ("Email Account", account.get('voice_email', 'NOT SET'), "⚠️  NEEDS CONFIG" if account.get('voice_email') == 'NOT SET' else "✅ YES"),
        ("Phone Number", account.get('voice_phone', 'NOT SET'), "⚠️  NEEDS CONFIG" if account.get('voice_phone') == 'NOT SET' else "✅ YES"),
        ("Public IP", network.get('public_ip', 'UNKNOWN'), "✅ YES"),
        ("Location (City)", network.get('city', 'UNKNOWN'), "✅ YES"),
        ("Location (Region)", network.get('region', 'UNKNOWN'), "✅ YES"),
        ("ISP/Provider", network.get('isp', 'UNKNOWN'), "✅ YES"),
        ("Timestamp", timestamp.get('timestamp', 'UNKNOWN'), "✅ YES"),
        ("Local IP", network.get('local_ip', 'UNKNOWN'), "✅ YES"),
        ("Hostname", system.get('hostname', 'UNKNOWN'), "✅ YES"),
        ("Operating System", system.get('os', 'UNKNOWN'), "✅ YES"),
    ]
    
    print()
    print(f"  {'Data Point':<25} {'Value':<30} {'Status':<15}")
    print("  " + "-" * 70)
    for name, value, status in capturable:
        print(f"  {name:<25} {str(value)[:30]:<30} {status:<15}")
    print()
    
    # 8. RECOMMENDATIONS
    print("=" * 70)
    print("💡 RECOMMENDATIONS")
    print("=" * 70)
    
    needs_config = []
    if account.get('voice_email') == 'NOT SET':
        needs_config.append('voice_email')
    if account.get('voice_phone') == 'NOT SET':
        needs_config.append('voice_phone')
    
    if needs_config:
        print("  ⚠️  Missing config values:")
        for field in needs_config:
            print(f"     - {field}")
        print()
        print("  Add these to config.json:")
        print('     "voice_email": "user1@gmail.com",')
        print('     "voice_phone": "+13055551234"')
    else:
        print("  ✅ All required config values are set!")
        print("  ✅ All 4 rotation variables can be tracked!")
    
    print()
    print("=" * 70)
    print("Ready to track multi-account rotation!")
    print("=" * 70)

if __name__ == "__main__":
    display_all_data()
