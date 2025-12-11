# QUICK START - P-TEXTING SEPARATE VERSIONS

## 🎯 TWO PROGRAMS - PICK ONE!

You now have **two separate P-Texting programs**:

### 🔵 **CHROME** (Use this first!)
- Best experience
- Stays logged in
- Use for your first 250 messages/day

### 🟠 **FIREFOX** (Backup only)
- Must log in every time
- Use when Chrome hits 250 limit
- Gets you another 250 messages/day

---

## 🚀 START WITH CHROME

### Step 1: Start Chrome Debug Mode
**Desktop shortcut:** `Start Chrome for P-Texting`

OR double-click: `start_chrome_debug.bat` in P-Texting folder

**What happens:**
- Chrome opens with Google Voice
- Command window stays open (don't close it!)
- Log in to Google Voice if needed
- **You stay logged in** - only need to do this once!

### Step 2: Launch Chrome P-Texting
**Desktop shortcut:** `P-Texting (Chrome)`

OR double-click: `p_texting_chrome.py` in P-Texting folder

### Step 3: Configure
1. Click **"Browse"** next to CSV file → Select your contacts
2. Type your message in the **Message Text** box
3. (Optional) Add image
4. (Optional) Add salutation like `Attn: {name},`
5. Click **"Save Config"**

### Step 4: Send Messages
1. Click **"SEND MESSAGES"**
2. Watch the console window for progress
3. Chrome window stays open - don't close it!
4. Messages send automatically

### Step 5: Check Results
Click **"Open Report"** to see what was sent

---

## 🟠 USING FIREFOX (When Chrome Limit Hit)

### Step 1: Launch Firefox P-Texting
**Desktop shortcut:** `P-Texting (Firefox)`

OR double-click: `p_texting_firefox.py` in P-Texting folder

**You'll see a warning** - that's normal!

### Step 2: Configure
Same as Chrome - select CSV, type message, etc.

### Step 3: Send Messages
1. Click **"SEND MESSAGES"**
2. Read the popup warning
3. Click **"Yes"**
4. **NEW Firefox window opens** - DO NOT CLOSE IT!
5. **LOG IN to Google Voice immediately!**
6. Automation will start once you're logged in
7. Watch console window for progress

### Step 4: Next Time
You'll have to log in AGAIN next time you use Firefox 😞

---

## 📊 SENDING 500 MESSAGES IN ONE DAY

### Morning: Chrome (250 messages)
1. Start Chrome debug
2. Launch P-Texting (Chrome)
3. Send to first 250 contacts
4. Generate report

### Afternoon: Firefox (250 messages)
1. Launch P-Texting (Firefox)
2. Use **SAME CSV file**
3. Change **Account Label** to `account2`
4. Send to next 250 contacts
5. Log in when Firefox opens
6. Generate report

**Total: 500 messages sent!** 🎉

---

## 🖥️ YOUR DESKTOP SHORTCUTS

After setup, you'll see:

```
P-Texting (Chrome) ← Your main tool
P-Texting (Firefox) ← Backup tool
Start Chrome for P-Texting ← Start this before Chrome version
Start Firefox for P-Texting ← Not needed (auto-starts)
P-Texting ← Old version (still works but use new ones)
```

---

## ❓ TROUBLESHOOTING

### Chrome: "Could not connect to remote debugging"
**Fix:** Start Chrome debug mode first!
1. Double-click `Start Chrome for P-Texting`
2. Wait for Chrome to open
3. Then launch P-Texting (Chrome)

### Firefox: "Must log in every time"
**This is normal!** Firefox technical limitation.
- Can't be fixed
- Use Chrome as primary
- Use Firefox as backup only

### Can't find my CSV file
**Location:** Usually in Documents or P-Texting folder
- Look for `test_numbers_with_dates.csv`
- Must have columns: `Name`, `Phone`, `Date`

### Messages not sending
**Check:**
1. Chrome/Firefox is actually open
2. Google Voice is loaded
3. You're logged in
4. CSV file has today's date in `Date` column
5. Check logs folder for errors

---

## 📁 WHERE ARE MY FILES?

### Configs
- `config_chrome.json` - Chrome settings
- `config_firefox.json` - Firefox settings

### Databases
- `progress_chrome.db` - Chrome send tracking
- `progress_firefox.db` - Firefox send tracking

### Logs
- `logs/run_chrome.log` - Chrome activity log
- `logs/run_firefox.log` - Firefox activity log

### Reports
- `reports/results_TIMESTAMP.csv` - Generated reports
- `exports/results_TIMESTAMP.csv` - Exported results

---

## 💡 PRO TIPS

### Tip 1: Use Different Account Labels
- Chrome: `account1`
- Firefox: `account2`

This prevents database conflicts when using both!

### Tip 2: Keep Chrome Debug Running
Once you start Chrome debug mode, you can:
- Close P-Texting GUI
- Send more messages later
- Chrome stays open and logged in! ✅

### Tip 3: Test with Small Batch First
Before sending to 250 contacts:
- Create a test CSV with 2-3 contacts
- Include yourself!
- Test that messages actually send
- Then use your full contact list

### Tip 4: Check Reports Often
Click "Open Report" after each batch to see:
- How many sent successfully
- Any errors
- Which contacts are pending

---

## 🎓 NEXT STEPS

Once you're comfortable with Chrome version:
1. Test sending to yourself
2. Send to a small group (5-10)
3. Scale up to your full list
4. Only try Firefox when needed

---

## 📞 NEED HELP?

1. **Chrome issues**: Check `logs/run_chrome.log`
2. **Firefox issues**: Check `logs/run_firefox.log`
3. **Full docs**: Read `README_SEPARATE_VERSIONS.md`
4. **Technical details**: Read `CHANGES_NOV23_2025.md`

---

**Remember: Start with Chrome! Only use Firefox as backup.**

Good luck! 🚀
