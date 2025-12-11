# Browser-Specific Shortcuts

## Desktop Shortcuts

Each browser has its own dedicated shortcut that launches the GUI pre-configured for that browser:

- **P-Texting (Chrome).lnk** → Opens GUI with "Chrome" in title, Chrome pre-selected
- **P-Texting (Edge).lnk** → Opens GUI with "Edge" in title, Edge pre-selected  
- **P-Texting (Firefox).lnk** → Opens GUI with "Firefox" in title, Firefox pre-selected

## How It Works

Each shortcut launches a browser-specific Python script:
- `launch_gui_chrome.py` - Sets Chrome as preset browser
- `launch_gui_edge.py` - Sets Edge as preset browser
- `launch_gui_firefox.py` - Sets Firefox as preset browser

These launchers set an environment variable (`PTEXTING_BROWSER`) before opening the GUI, which:
1. Updates the window title: **"P-Texting (Chrome)"** or **"P-Texting (Edge)"**, etc.
2. Updates the header: **"📱 P-Texting (Chrome) • Google Voice Date-Filtered Texting"**
3. Pre-selects the correct browser radio button

## Visual Indicators

When you open a browser-specific shortcut, you'll see:
- **Window Title Bar**: Shows browser name (e.g., "P-Texting (Edge)")
- **Header**: Shows browser name (e.g., "📱 P-Texting (Edge) • ...")
- **Browser Radio Button**: Automatically pre-selected to the correct browser

This makes it immediately clear which browser the GUI is configured for!

## Data File Selection

When using the GUI:
- ✅ Select **CSV file** (e.g., `test_numbers_with_dates.csv`)
- ❌ Do NOT select the database file (`progress_shared.db`)

The GUI automatically uses `progress_shared.db` (combined database) to track sent/pending/failed messages across all browsers.
