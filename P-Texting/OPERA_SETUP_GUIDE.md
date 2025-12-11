# Opera Browser Setup Guide

## Overview
Opera is now set up for P-Texting with:
- Port: **9225**
- Account: **account4**
- Profile: `C:\temp\opera_debug_profile`
- Database: `progress_opera.db`

## Files Created/Fixed

### 1. GUI Launcher
**File:** `launch_gui_opera.py`
- Launches the Opera-specific GUI
- Located in main directory for easy access

### 2. Browser Launcher
**File:** `browser_launchers/start_opera_debug.bat`
- Starts Opera with remote debugging on port 9225
- Creates separate profile in `C:\temp\opera_debug_profile`

### 3. Config File
**File:** `configs/config_opera.json`
- Opera-specific configuration
- Port: 9225
- Account: account4

### 4. GUI Application
**File:** `browser_specific/p_texting_opera.py`
- Full Tkinter GUI for Opera
- Includes Start Opera Debug button

### 5. Sending Script
**File:** `browser_specific/send_texts_date_filter_opera.py`
- Opera-specific message sending script
- Connects to Opera on port 9225

## How To Use Opera

### Method 1: Use GUI (Recommended)

1. **Launch GUI:**
   ```bash
   python launch_gui_opera.py
   ```

2. **Start Opera Browser:**
   - Click "🚀 Start Opera Debug" button in GUI
   - Opera will open in a new window
   - A console window will show the status

3. **Log Into Google Voice:**
   - Go to https://voice.google.com in Opera
   - Log in with account4 credentials
   - Keep this Opera window open

4. **Configure Message:**
   - In the GUI, select your CSV file
   - Enter your message
   - Set salutation (if desired)
   - Select image (if desired)

5. **Send Messages:**
   - Click "✉️ SEND MESSAGES" button
   - A new console window will show progress
   - Opera stays open and logged in!

### Method 2: Manual Launch

1. **Start Opera Debug Mode:**
   ```bash
   browser_launchers\start_opera_debug.bat
   ```

2. **Log Into Google Voice:**
   - Opera opens automatically
   - Go to https://voice.google.com
   - Log in with account4

3. **Run Sending Script:**
   ```bash
   python browser_specific\send_texts_date_filter_opera.py
   ```

## Advantages of Opera

✅ **Stays Logged In** - Like Chrome, Opera keeps your Google Voice session
✅ **Separate Profile** - Won't interfere with your regular Opera browsing
✅ **VPN Friendly** - Great for rotation (account4 = VPN location 4)
✅ **Fast** - Chromium-based, same speed as Chrome
✅ **Different Fingerprint** - Appears as different browser to Google

## Testing Opera

### Quick Test (5 messages)

1. **Prepare test data:**
   - Use `test_data_enhanced.csv` (5 test records)
   - Or create small test CSV

2. **Start Opera:**
   ```bash
   browser_launchers\start_opera_debug.bat
   ```

3. **Log into Google Voice** in Opera

4. **Run GUI:**
   ```bash
   python launch_gui_opera.py
   ```

5. **Configure for test:**
   - CSV: Select test file
   - Message: "Test message from Opera"
   - Batch size: 5
   - Daily limit: 5

6. **Send test messages:**
   - Click "SEND MESSAGES"
   - Watch console for progress

7. **Verify:**
   ```bash
   python check_database_status.py
   ```
   Check that `progress_opera.db` shows sent messages

### Extract Account Info

Once logged into Google Voice in Opera:

```bash
python utilities\extract_voice_account_info.py --port 9225 --browser chrome
```

Note: Use `--browser chrome` even for Opera (Opera uses Chrome driver)

This will extract:
- Email address (account4's email)
- Phone number (account4's Google Voice number)

Then update `configs/config_opera.json`:
```json
{
  "voice_email": "account4@example.com",
  "voice_phone": "+1234567890"
}
```

## Troubleshooting

### Opera Won't Start
**Problem:** Clicking "Start Opera Debug" does nothing

**Solutions:**
1. Check if Opera is installed:
   ```bash
   Test-Path "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
   ```
2. If not installed, install Opera from https://www.opera.com
3. Verify path in `start_opera_debug.bat` matches your Opera installation

### Can't Connect to Opera
**Problem:** "Port 9225 not listening" error

**Solutions:**
1. Make sure Opera is running with debug mode:
   ```bash
   browser_launchers\start_opera_debug.bat
   ```
2. Check if port is in use:
   ```powershell
   netstat -ano | findstr :9225
   ```
3. If port is busy, kill the process or change port

### Google Voice Not Working
**Problem:** Can't log into Google Voice

**Solutions:**
1. Clear Opera profile:
   ```bash
   Remove-Item -Recurse -Force C:\temp\opera_debug_profile
   ```
2. Start Opera debug again
3. Log in fresh

### Messages Not Sending
**Problem:** Script runs but messages don't send

**Solutions:**
1. Check if Google Voice tab is open in Opera
2. Check logs:
   ```bash
   Get-Content logs\run_opera.log -Tail 50
   ```
3. Verify account4 isn't at daily limit
4. Check `progress_opera.db` status

## Port Assignments

| Browser | Port | Account | Status |
|---------|------|---------|--------|
| Chrome | 9222 | account1 | ✅ Working |
| Edge | 9223 | account2/3 | ✅ Working |
| Firefox | 9224 | (varies) | ⚠️ Requires re-login |
| Opera | 9225 | account4 | ✅ Ready to test |

## Rotation Strategy with Opera

### Daily Rotation Example:
```
Morning (8am-12pm):  Chrome   account1  port 9222  250 messages
Afternoon (12pm-4pm): Edge     account2  port 9223  250 messages  
Evening (4pm-8pm):    Firefox  account3  port 9224  250 messages
Night (8pm-12am):     Opera    account4  port 9225  250 messages

Total: 1,000 messages/day across 4 browsers
```

### Benefits:
- **4 different browser fingerprints**
- **4 different IP addresses** (use different VPN for each)
- **4 different Google Voice accounts**
- **Natural distribution** across time

## Next Steps

1. ✅ Opera GUI created and working
2. ✅ Start Opera Debug button functional
3. ⏳ **Test Opera with 5 messages**
4. ⏳ Extract account info (email/phone)
5. ⏳ Update config with voice_email and voice_phone
6. ⏳ Run database migration for tracking fields
7. ⏳ Test full rotation (Chrome → Edge → Firefox → Opera)

## Files Reference

**Main Directory:**
- `launch_gui_opera.py` - Start here

**Browser Launchers:**
- `browser_launchers/start_opera_debug.bat`

**Configs:**
- `configs/config_opera.json`

**Browser-Specific:**
- `browser_specific/p_texting_opera.py` (GUI)
- `browser_specific/send_texts_date_filter_opera.py` (Sender)

**Database:**
- `progress_opera.db` (Opera's database)

**Logs:**
- `logs/run_opera.log`

---

**Opera is ready! Start with a small test batch to verify everything works.**
