# P-Texting - Google Voice Automation

Automated texting tool for Google Voice with date filtering and progress tracking.

## Quick Start Guide

### Step 1: Start Chrome with Remote Debugging

**IMPORTANT:** Chrome must be started with remote debugging enabled for the automation to work.

**Option A - Using Run Dialog (Easiest):**
1. Press `Win + R` to open Run dialog
2. Type: `chrome.exe --remote-debugging-port=9222`
3. Press Enter

**Option B - Create a Desktop Shortcut:**
1. Right-click on Desktop → New → Shortcut
2. Enter target: `"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222`
3. Name it "Chrome (Debug Mode)"
4. Double-click this shortcut to start Chrome

### Step 2: Find Your Chrome Profile Path

1. In Chrome, type in the address bar: `chrome://version`
2. Look for the line that says **"Profile Path"**
3. Copy the entire path (e.g., `C:\Users\YourName\AppData\Local\Google\Chrome\User Data\Default`)

### Step 3: Prepare Google Voice

1. In the Chrome window you just opened, navigate to: `https://voice.google.com/messages`
2. Log in to your Google account if needed
3. Make sure you can see your Google Voice messages
4. **Keep this Chrome window open**

### Step 4: Run P-Texting

1. Double-click the **P-Texting** shortcut on your desktop
2. The GUI window will open
3. **Paste your Chrome Profile Path** into the first field (the one you copied in Step 2)
4. Select your phone data CSV file (must have `Phone`, `Name`, and `Date` columns)
5. Type your message text
6. (Optional) Attach an image if needed
7. Click **"Send Messages"**

### Step 5: Watch Progress

- The automation will:
  - Connect to your open Chrome window
  - Use the Google Voice tab
  - Automatically send messages to contacts with today's date
  - Show progress in both the GUI and Google Voice window
- The Chrome window will **stay open** so you can see the messages being sent in real-time
- A timestamped results file will be saved in the `reports` folder

## Data File Format

Your CSV file must have these columns:
- `Phone`: Phone number (any format, will be normalized)
- `Name`: Contact name
- `Date`: Date in format `YYYY-MM-DD` (e.g., `2025-11-19`)

**Only contacts with today's date will receive messages.**

Example (`test_numbers_with_dates.csv`):
```csv
Phone,Name,Date
15551234567,John Doe,2025-11-19
15559876543,Jane Smith,2025-11-19
15551111111,Bob Jones,2025-11-20
```

## Configuration

Settings are saved to `config.json` and include:
- Chrome profile path
- Batch size (default: 7 messages per batch)
- Daily limit (default: 250 messages)
- Delays between messages and batches
- Max retries for failed messages

## Reports

After each run, a timestamped report is created in the `reports` folder:
- Filename format: `results_YYYY-MM-DD_HH-MM-SS.txt`
- Contains: sent count, failed count, pending count, and error details

## Troubleshooting

### "Could not connect to Chrome DevTools"
- Make sure you started Chrome with `--remote-debugging-port=9222`
- Close all Chrome windows and start again with the debug flag

### "Profile path not found"
- Double-check you copied the correct path from `chrome://version`
- Make sure the path ends with `Default`, `Profile 1`, etc.

### Messages not sending
- Verify you're logged into Google Voice in the Chrome window
- Check that your CSV has contacts with today's date
- Look at the logs in `logs/run.log` for detailed error messages

### "No contacts found for today's date"
- Your CSV file's `Date` column must match today's date exactly
- Format must be: `YYYY-MM-DD`

## Support

For issues or questions:
1. Check `logs/run.log` for detailed error messages
2. Check the timestamped report in the `reports` folder
3. Verify all steps in the Quick Start Guide

## Tips

- Keep the Chrome window visible while sending so you can see progress
- The GUI updates every 2 seconds with sent/failed counts
- You can stop the process anytime by closing the GUI (progress is saved)
- Messages are sent in batches with delays to avoid rate limits
