#!/usr/bin/env python3
"""
Launch P-Texting GUI with Edge browser preset
"""
import sys
import os
import shutil
from pathlib import Path

# Set browser environment variable before importing GUI
os.environ['PTEXTING_BROWSER'] = 'edge'

# Copy browser-specific config if it exists
config_edge = Path('configs/config_edge.json')
config_main = Path('config.json')
if config_edge.exists():
    shutil.copy(config_edge, config_main)
    print(f"Loaded Edge config: {config_edge}")

# Import and run GUI
from p_texting_gui import main
main()
