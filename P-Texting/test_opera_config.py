#!/usr/bin/env python3
"""Test Opera config loading"""

import sys
from pathlib import Path

print("=" * 60)
print("Testing Opera Config Loading")
print("=" * 60)

# Test 1: Check config file exists
config_path = Path("configs/config_opera.json")
print(f"\n1. Config file path: {config_path.absolute()}")
print(f"   Exists: {config_path.exists()}")

if not config_path.exists():
    print("\n❌ Config file not found!")
    input("Press Enter to exit...")
    sys.exit(1)

# Test 2: Try to load config
try:
    sys.path.insert(0, 'junk')
    from send_texts import Config
    
    print(f"\n2. Loading config from: {config_path}")
    config = Config(str(config_path))
    print(f"   ✅ Config loaded successfully!")
    print(f"   Browser: {config['browser']}")
    print(f"   Port: {config['remote_debugging_port']}")
    print(f"   Account: {config['account_label']}")
    
except Exception as e:
    print(f"\n❌ Error loading config: {e}")
    import traceback
    traceback.print_exc()
    input("Press Enter to exit...")
    sys.exit(1)

print("\n✅ All tests passed!")
input("Press Enter to exit...")
