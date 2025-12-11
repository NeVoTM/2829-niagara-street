# P-TEXTING - SEPARATE BROWSER VERSIONS

## Overview
P-Texting now has **two completely separate programs** - one for Chrome and one for Firefox. Each has its own GUI, config file, database, and sending script.

## 🎯 WHICH VERSION TO USE?

### ✅ **CHROME VERSION - PRIMARY** (Recommended)
- **Shortcut**: "P-Texting (Chrome)" on Desktop
- **GUI**: `p_texting_chrome.py`
- **Send Script**: `send_texts_date_filter.py`
- **Config**: `config_chrome.json`
- **Database**: `progress_chrome.db`
- **Advantages**:
  - ✅ Connects to existing Chrome window
  - ✅ Stays logged in to Google Voice
  - ✅ Best user experience
  - ✅ No repeated logins required
- **Use this for**: Your primary texting (first 250 messages/day)

### ⚠️ **FIREFOX VERSION - BACKUP** (Limited)
- **Shortcut**: "P-Texting (Firefox)" on Desktop
- **GUI**: `p_texting_firefox.py`
- **Send Script**: `send_texts_date_filter_firefox.py`
- **Config**: `config_firefox.json`
- **Database**: `progress_firefox.db`
- **Limitations**:
  - ⚠️ Launches NEW Firefox instance each time
  - ⚠️ Must log in to Google Voice every session
  - ⚠️ Cannot connect to existing Firefox
  - ⚠️ Poor user experience
- **Use this for**: Backup when Chrome hits 250 message daily limit

---

## 🚀 QUICK START

### Chrome Version (Primary)
1. **Start Chrome Debug Mode**:
   - Double-click "Start Chrome for P-Texting" on Desktop
   - OR run `start_chrome_debug.bat`
   - Chrome will open with Google Voice
   - Log in if needed (stays logged in!)

2. **Launch P-Texting Chrome**:
   - Double-click "P-Texting (Chrome)" on Desktop
   - OR run `p_texting_chrome.py`

3. **Configure and Send**:
   - Select CSV file
   - Enter message text
   - Optional: Add image, salutation
   - Click "Save Config"
   - Click "SEND MESSAGES"

### Firefox Version (Backup)
1. **Launch P-Texting Firefox**:
   - Double-click "P-Texting (Firefox)" on Desktop
   - OR run `p_texting_firefox.py`
   - Read the warning about limitations

2. **Configure and Send**:
   - Select CSV file
   - Enter message text
   - Optional: Add image, salutation
   - Click "Save Config"
   - Click "SEND MESSAGES"
   - **IMPORTANT**: A NEW Firefox window will open - LOG IN immediately!

---

## 📂 FILE STRUCTURE

### Chrome Version Files
```
p_texting_chrome.py              # Chrome-specific GUI
send_texts_date_filter.py        # Chrome sending script
config_chrome.json               # Chrome configuration
progress_chrome.db               # Chrome database
logs/run_chrome.log              # Chrome logs
start_chrome_debug.bat           # Start Chrome with debugging
Desktop: "P-Texting (Chrome).lnk"
Desktop: "Start Chrome for P-Texting.lnk"
```

### Firefox Version Files
```
p_texting_firefox.py             # Firefox-specific GUI
send_texts_date_filter_firefox.py # Firefox sending script
config_firefox.json              # Firefox configuration
progress_firefox.db              # Firefox database
logs/run_firefox.log             # Firefox logs
start_firefox_debug.bat          # Start Firefox with debugging (not needed)
Desktop: "P-Texting (Firefox).lnk"
```

### Shared Files (Used by Both)
```
send_texts.py                    # Core automation logic
generate_report.py               # Report generation
test_numbers_with_dates.csv      # Your contacts
```

---

## 🔄 WORKFLOW: 500 MESSAGES/DAY (Both Browsers)

To send 500 messages in one day, use both browsers:

### Morning: Chrome (250 messages)
1. Start Chrome debug mode
2. Launch P-Texting (Chrome)
3. Configure with your CSV file
4. Send first 250 messages
5. Generate report

### Afternoon: Firefox (250 messages)
1. Launch P-Texting (Firefox)
2. Configure with same CSV file (different account label!)
3. Click "SEND MESSAGES"
4. **IMMEDIATELY** log in to new Firefox window
5. Send next 250 messages
6. Generate report

**IMPORTANT**: Use different account labels (e.g., `account1` for Chrome, `account2` for Firefox) so the databases don't conflict!

---

## ⚙️ CONFIGURATION

### Chrome Config (`config_chrome.json`)
```json
{
  "browser": "chrome",
  "database_path": "progress_chrome.db",
  "log_path": ".\\logs\\run_chrome.log",
  "account_label": "account1",
  "remote_debugging_port": 9222
}
```

### Firefox Config (`config_firefox.json`)
```json
{
  "browser": "firefox",
  "database_path": "progress_firefox.db",
  "log_path": ".\\logs\\run_firefox.log",
  "account_label": "account2",
  "remote_debugging_port": 6000
}
```

**Note**: All other settings (CSV file, message text, image, etc.) are configured via the GUI and saved to the respective config file.

---

## 🐛 TROUBLESHOOTING

### Chrome Issues

**"Could not connect to Chrome remote debugging"**
- Start Chrome debug mode first: Double-click "Start Chrome for P-Texting"
- Make sure Chrome is running on port 9222
- Check that Chrome window is still open

**"Send button stays disabled"**
- This is the "Send to" button issue (should be fixed)
- Check logs/run_chrome.log for details

### Firefox Issues

**"Firefox will launch a new instance"**
- This is expected behavior (technical limitation)
- You MUST log in to Google Voice each time
- Consider using Chrome version instead

**"Firefox didn't open"**
- Check that geckodriver is installed
- Firefox version doesn't need "Start Firefox Debug" batch file
- Firefox launches automatically when you click "SEND MESSAGES"

---

## 📊 REPORTS

Each version has its own reporting:

### Chrome Reports
```bash
# Generate report for Chrome sends
Click "Open Report" in Chrome GUI
# OR manually:
python generate_report.py config_chrome.json
```

### Firefox Reports
```bash
# Generate report for Firefox sends
Click "Open Report" in Firefox GUI
# OR manually:
python generate_report.py config_firefox.json
```

Reports are generated in CSV format, compatible with Google Sheets.

---

## 🔧 TECHNICAL DETAILS

### Why Separate Programs?

Chrome and Firefox have fundamentally different architectures:

**Chrome**:
- Supports `debuggerAddress` option
- Can connect to existing browser instance
- Stays logged in between sessions
- Perfect UX

**Firefox**:
- Does NOT support `debuggerAddress`
- Cannot connect to existing instance
- Must launch new instance each time
- Poor UX but functional

Rather than trying to make one program handle both (with complex if/else logic), we created two separate, focused programs that each do one thing well.

### Port Assignments
- **Chrome**: Port 9222 (CDP - Chrome DevTools Protocol)
- **Firefox**: Port 6000 (CDP - experimental/incomplete)

### Database Separation
Each browser has its own database to prevent conflicts:
- `progress_chrome.db` - Tracks Chrome sends
- `progress_firefox.db` - Tracks Firefox sends

This allows you to send to the same contacts via both browsers without "already sent" conflicts.

---

## 🎓 FUTURE: COMBINING VERSIONS

Once both versions are working perfectly, you could create a unified launcher that:
1. Detects which browser is available
2. Switches between them automatically
3. Tracks daily limits across both

But for now, keeping them separate makes development and testing easier!

---

## 📞 SUPPORT

If you have issues:

1. **Chrome Version Issues**: Check `logs/run_chrome.log`
2. **Firefox Version Issues**: Check `logs/run_firefox.log`
3. **GUI Issues**: Refer to original `README.md`
4. **Send Button Issues**: Check SESSION_HANDOFF files for "Send to" button details

---

## ✅ QUICK REFERENCE

| Feature | Chrome Version | Firefox Version |
|---------|---------------|-----------------|
| Shortcut | "P-Texting (Chrome)" | "P-Texting (Firefox)" |
| GUI Script | `p_texting_chrome.py` | `p_texting_firefox.py` |
| Send Script | `send_texts_date_filter.py` | `send_texts_date_filter_firefox.py` |
| Config File | `config_chrome.json` | `config_firefox.json` |
| Database | `progress_chrome.db` | `progress_firefox.db` |
| Port | 9222 | 6000 |
| Stays Logged In | ✅ Yes | ❌ No |
| Best For | Primary use | Backup only |
| Login Required | Once | Every session |

---

**RECOMMENDATION**: Start with Chrome version. Only use Firefox version when you hit Chrome's 250 message daily limit.
