# 📱 P-Texting - Simple Google Voice Automation

Modern, simple interface for automated Google Voice texting with date filtering.

## 🚀 Quick Start

### Run the Program

**Double-click:** `run_p_texting.bat`

**Or run manually:**
```powershell
python p_texting_gui.py
```

---

## 📋 Interface Guide

### 1. 📸 Image File
- Click "Browse Image" to select your image
- Must be ≤ 1.5 MB
- Supports: PNG, JPG, JPEG, GIF, BMP
- **Optional** - leave blank for text-only

### 2. 📊 Phone Data File  
- Click "Browse CSV" to select your contact list
- Must have columns: `Phone`, `Name`, `Date`
- **Date format:** `YYYY-MM-DD` (e.g., 2025-11-18)
- Supports CSV and Excel files

### 3. 💬 Message Text
- Type your message (include opt-out instructions!)
- Example: "Check out our special! Reply STOP to opt out."

### 4. Buttons
- **🚀 Send Messages** - Start sending to today's contacts
- **💾 Save Config** - Save settings for next time

---

## 📊 Data File Format

Your CSV/Excel must have these columns:

```csv
Phone,Name,Date
3059055068,Eli,2025-11-18
7164211210,Tiffany,2025-11-18
5551234567,John,2025-11-19
```

### Date Column Rules
- **Format:** `YYYY-MM-DD` or `MM/DD/YYYY`  
- **Only sends to contacts with TODAY'S date**
- **Example:** If today is 2025-11-18, only rows with 2025-11-18 get messages

---

## ✨ Features

✅ **Date Filtering** - Automatically sends only to today's contacts  
✅ **Modern Interface** - Clean, simple, beautiful  
✅ **Progress Tracking** - Auto-saves progress  
✅ **Auto-Resume** - Pick up where you left off  
✅ **Rate Limiting** - Respects Google Voice limits  
✅ **MMS Support** - Send images with text  
✅ **Validation** - Checks files and settings before sending  

---

## 📝 Sample Data File

See `test_numbers_with_dates.csv` for an example with proper date formatting.

---

## 🔧 How It Works

1. **You fill in the form** - Image (optional), phone list, message
2. **Click Send Messages** - Program validates everything
3. **Confirms** - Shows what will happen, asks to confirm
4. **Filters by date** - Only loads contacts with today's date
5. **Sends messages** - Opens Chrome, goes to Google Voice, sends
6. **Saves progress** - Tracks what's sent in database
7. **Shows results** - Tells you how many sent/failed

---

## ⚙️ Settings (Auto-Configured)

The program automatically uses these settings (from `config.json`):

- **Browser:** Chrome (Default profile)
- **Batch size:** 7 messages per batch
- **Delay:** 45 seconds between batches
- **Daily limit:** 250 messages
- **Retries:** Up to 3 attempts for failed sends

---

## 📂 Files Created

- `config.json` - Your saved settings
- `progress.db` - Progress tracking database
- `logs/run.log` - Detailed send logs

---

## 🎯 Best Practices

### Before Sending

1. ✅ Test with 2-3 numbers first
2. ✅ Verify dates in your CSV are correct
3. ✅ Check image is < 1.5 MB
4. ✅ Include opt-out instructions in message
5. ✅ Make sure Chrome Default profile is signed into Google Voice

### Daily Workflow

1. **Morning:** Update your CSV with today's date for today's contacts
2. **Open P-Texting** - Load files, write message
3. **Click Send** - Confirm and let it run
4. **Check logs** - Review `logs/run.log` for results

---

## 🔍 Troubleshooting

### "No contacts found for today's date"
- Check your CSV has a `Date` column
- Verify dates are formatted correctly: `YYYY-MM-DD`
- Make sure some rows have today's date

### "Data file not found"
- Use the "Browse CSV" button to select file
- Make sure file exists at that path

### "Image too large"
- Image must be ≤ 1.5 MB
- Use Windows Paint or online tool to resize
- Save as JPEG at lower quality (70-80%)

### "Browser profile not logged in"
- Open Chrome normally
- Go to https://voice.google.com
- Sign in and verify you see Google Voice
- Close Chrome and try again

---

## 🚀 Advanced: Multiple Accounts

To use multiple Google Voice accounts:

1. Create separate Chrome profiles for each account
2. Update `config.json` with different `browser_profile_path` for each
3. Run the GUI, change settings, send
4. Repeat for next account

---

## 📊 Expected Performance

- **Setup time:** 2 minutes
- **Send rate:** ~1 message every 7 seconds
- **Batch of 7:** ~1 minute
- **250 messages:** ~30-40 minutes total

---

## ⚠️ Important Notes

1. **Legal:** Only text people who opted in
2. **Opt-out:** Include "Reply STOP to opt out" in messages
3. **Daily limits:** Respect 250/day limit per account
4. **Date format:** Must use proper date format in CSV
5. **Browser:** Keep Chrome closed while script runs

---

## 📞 Support

- **Logs:** Check `logs/run.log` for detailed errors
- **Database:** `progress.db` tracks all sends
- **Config:** `config.json` has all settings

---

**Version:** 1.0  
**Created:** 2025-11-18  
**Interface:** Modern GUI with gradient design  
**Backend:** Python + Selenium
