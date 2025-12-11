# P-Texting - Quick Start (Updated with Humanization)

## ✅ What's New

Your P-Texting program has been **enhanced with human-like behavior** to prevent Google Voice from detecting automation and disabling the send button!

### Key Features Added:

1. **🎯 Pressing '1' then backspace** - Your suggestion! Fools the system into thinking a real person is typing
2. **🖱️ Mouse movements** - Simulates natural mouse behavior
3. **⌨️ Arrow key nudges** - LEFT/RIGHT arrow movements
4. **🔄 Multiple retry attempts** - Up to 3 tries to activate the send button
5. **📸 Debug screenshots** - Automatically captures screenshots when sends fail
6. **⏱️ Human-like timing** - Random delays that mimic real human behavior
7. **🔍 Button state verification** - Checks if send button is actually enabled before clicking

## 🚀 Quick Test (3 Steps)

### Step 1: Start Chrome with Remote Debugging

```powershell
# Press Win+R, then paste this:
chrome.exe --remote-debugging-port=9222
```

### Step 2: Open Google Voice

In the Chrome window that just opened:
1. Go to: https://voice.google.com/messages
2. Log in if needed
3. **Leave this window open!**

### Step 3: Run the Program

```powershell
# Navigate to the folder
cd "C:\Users\17274\ME\2829-Niagara-Street\P-Texting"

# Run the test first (optional but recommended)
python test_humanization.py

# Send messages
python send_texts_date_filter.py
```

## 📋 What Will Happen

The program will:

1. ✅ Connect to your open Chrome browser
2. ✅ Filter contacts from CSV to only send to today's date (2025-11-19)
3. ✅ For each contact:
   - Enter phone number
   - Attach image (if configured)
   - Type message
   - **Perform human-like interactions** (mouse wiggle, '1' trick, arrow keys)
   - **Verify send button is enabled**
   - **Click send**
4. ✅ Save progress to database
5. ✅ Generate report when done

## 🔍 Monitoring

### Watch in Real-Time

- **Chrome window**: You'll see messages being sent in real-time
- **Console**: Shows progress and status updates
- **Logs**: `logs/run.log` has detailed information

### Check Status

```powershell
# View current message status
python -c "import sqlite3; conn = sqlite3.connect('progress.db'); cursor = conn.cursor(); cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status'); print('\n'.join([f'{row[0]}: {row[1]}' for row in cursor.fetchall()]))"
```

### View Logs

```powershell
# See last 50 lines of log
Get-Content logs/run.log -Tail 50
```

## ✅ Success Indicators

Look for these in the logs:

```
============================================================
ACTIVATING SEND BUTTON (HUMAN-LIKE BEHAVIOR)
============================================================
Pressing '1' then backspace (anti-automation trick)...
✓ Send button is ENABLED!
============================================================
SENDING MESSAGE
============================================================
✓ Send button clicked!
✓✓✓ SENT to +13059055068 (Eli)
```

## ⚠️ If Send Button Still Gets Disabled

### Quick Fixes

1. **Increase delays in config.json:**

```json
{
  "humanize_micro_delay_min_ms": 200,
  "humanize_micro_delay_max_ms": 800,
  "humanize_max_enable_retries": 5
}
```

2. **Check the screenshot** in `logs/screenshots/` to see what went wrong

3. **Try text-only first** - remove or comment out `image_path` in config.json

4. **Try with saved contact** - add the phone number to your Google Contacts first

### Reset and Try Again

```powershell
# Reset failed messages to pending
python -c "import sqlite3; conn = sqlite3.connect('progress.db'); conn.execute('UPDATE messages SET status=\"pending\", attempts=0 WHERE status=\"failed\"'); conn.commit()"

# Run again
python send_texts_date_filter.py
```

## 📊 Your Test Data

Current test file: `test_numbers_with_dates.csv`

```csv
Phone,Name,Date
13059055068,Eli,2025-11-19           ✅ Will send today
17164211210,Tiffany,2025-11-19      ✅ Will send today
15551234567,Test User 1,2025-11-19  ✅ Will send today
15559876543,Test User 2,2025-11-20  ❌ Won't send (tomorrow's date)
```

**3 messages will be sent today**

## 📁 Files Created/Modified

- ✅ `send_texts.py` - **Updated with humanization**
- ✅ `send_texts_backup.py` - **Backup of original**
- ✅ `test_humanization.py` - **Test script**
- ✅ `HUMANIZATION_GUIDE.md` - **Full documentation**
- ✅ `QUICK_START.md` - **This file**
- ✅ `logs/screenshots/` - **Debug screenshots folder**

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| "Could not connect to Chrome DevTools" | Make sure Chrome was started with `--remote-debugging-port=9222` |
| "Send button remained disabled" | Check `logs/screenshots/` and increase delays in config |
| "No contacts found for today" | Check Date column in CSV matches today: 2025-11-19 |
| Image too large error | Use smaller image (< 1.5MB) or increase size limit in code |
| Messages still failing | Try text-only first (remove image_path from config) |

## 📚 More Info

- **Full Guide**: See `HUMANIZATION_GUIDE.md`
- **Original README**: See `README.md`

## 🎯 Next Steps

1. **Test with your data**: Update `test_numbers_with_dates.csv` with real numbers and today's date
2. **Try text-only first**: Remove `image_path` from config.json for initial test
3. **Monitor the first send**: Watch Chrome window and logs carefully
4. **Check screenshots**: If it fails, look at `logs/screenshots/` to see what happened
5. **Adjust timing**: If needed, increase delays in config.json

## 💡 Tips

- **Start small**: Test with 2-3 numbers first
- **Watch the browser**: Keep Chrome window visible to see what's happening
- **Check logs frequently**: `logs/run.log` tells you everything
- **Be patient**: The humanization adds delays, but that's intentional!
- **Save contacts**: Import your CSV to Google Contacts first for better reliability

---

**Ready to send?** Just run: `python send_texts_date_filter.py`

**Need help?** Check the logs first, then look at screenshots in `logs/screenshots/`
