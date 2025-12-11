#!/usr/bin/env python3
"""
Launch P-Texting GUI with Chrome browser preset
"""
import sys
import os
import shutil
from pathlib import Path

# Set browser environment variable before importing GUI
os.environ['PTEXTING_BROWSER'] = 'chrome'

# Copy browser-specific config if it exists
config_chrome = Path('configs/config_chrome.json')
config_main = Path('config.json')
if config_chrome.exists():
    shutil.copy(config_chrome, config_main)
    print(f"Loaded Chrome config: {config_chrome}")

# Import and run GUI
from p_texting_gui import main
main()
