#!/usr/bin/env python3
"""
Launch P-Texting GUI with Firefox browser preset
"""
import sys
import os
import shutil
from pathlib import Path

# Set browser environment variable before importing GUI
os.environ['PTEXTING_BROWSER'] = 'firefox'

# Copy browser-specific config if it exists
config_firefox = Path('configs/config_firefox.json')
config_main = Path('config.json')
if config_firefox.exists():
    shutil.copy(config_firefox, config_main)
    print(f"Loaded Firefox config: {config_firefox}")

# Import and run GUI
from p_texting_gui import main
main()
