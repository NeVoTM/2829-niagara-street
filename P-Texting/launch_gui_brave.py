#!/usr/bin/env python3
"""
Launch P-Texting GUI for Brave Browser
"""

import sys
import os
from pathlib import Path

# Get paths
script_dir = Path(__file__).parent.absolute()
gui_script = script_dir / "browser_specific" / "p_texting_brave.py"

if not gui_script.exists():
    print(f"Error: {gui_script} not found!")
    sys.exit(1)

# Change to P-Texting directory so relative paths work
os.chdir(script_dir)

# Execute the GUI script with proper encoding
exec(open(gui_script, encoding='utf-8').read())
