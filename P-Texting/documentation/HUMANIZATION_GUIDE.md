# P-Texting Humanization Features

## Overview

The P-Texting program has been enhanced with **human-like behavior** to prevent the Google Voice web interface from detecting automation and disabling the send button.

## What Was Changed

### Key Enhancements

1. **Human-like Delays**: Random delays between actions using triangular distribution (more natural than uniform random)

2. **Mouse Wiggle**: Subtle mouse movements to simulate human interaction

3. **Composer Nudge**: Multiple interaction strategies including:
   - Clicking composer area
   - Moving cursor to end of text
   - Adding/removing space character
   - **Pressing '1' then backspace** (your suggestion!) to fool the system
   - Arrow key movements (LEFT then RIGHT)

4. **Button State Verification**: Checks if send button is actually enabled before clicking

5. **Retry Logic**: Up to 3 attempts to activate the send button using different strategies

6. **Debug Screenshots**: Automatically saves screenshots when send button fails to activate

### New Helper Functions (in send_texts.py)

- `human_sleep()` - Random delays with natural timing
- `mouse_wiggle()` - Subtle mouse movements
- `composer_nudge()` - Keyboard interactions to trigger button activation
- `ensure_send_button_active()` - Multi-strategy button activation
- `log_button_state()` - Detailed logging of button state
- `is_send_enabled()` - Checks if button is truly enabled
- `wait_for_attachment_settle()` - Waits for image upload to complete
- `save_debug_screenshot()` - Captures screenshots for failed sends

## Configuration

### Optional Config Keys

You can add these to your `config.json` to customize the humanization behavior. **All are optional** - the code uses sensible defaults if not specified.

```json
{
  "humanize_enabled": true,
  "humanize_micro_delay_min_ms": 120,
  "humanize_micro_delay_max_ms": 480,
  "humanize_post_upload_dwell_min_ms": 900,
  "humanize_post_upload_dwell_max_ms": 1800,
  "humanize_mouse_wiggle": true,
  "humanize_press_one_nudge": true,
  "humanize_arrow_nudge": true,
  "humanize_max_enable_retries": 3
}
```

### Config Explanation

| Key | Default | Description |
|-----|---------|-------------|
| `humanize_enabled` | `true` | Enable/disable all humanization features |
| `humanize_micro_delay_min_ms` | `120` | Minimum delay (ms) between micro-actions |
| `humanize_micro_delay_max_ms` | `480` | Maximum delay (ms) between micro-actions |
| `humanize_post_upload_dwell_min_ms` | `900` | Minimum delay (ms) after image upload |
| `humanize_post_upload_dwell_max_ms` | `1800` | Maximum delay (ms) after image upload |
| `humanize_mouse_wiggle` | `true` | Enable mouse movement simulation |
| `humanize_press_one_nudge` | `true` | Enable the '1' + backspace trick |
| `humanize_arrow_nudge` | `true` | Enable arrow key movements |
| `humanize_max_enable_retries` | `3` | Max attempts to activate send button |

## How It Works

### The Send Button Problem

Google Voice's web interface monitors for automation and disables the send button if it detects:
- Robotic timing (actions happening too fast or too uniformly)
- Lack of mouse movement
- Missing "human" interactions with the text field

### The Solution

After typing the message and attaching any image, the program now:

1. **Performs mouse wiggle** to simulate a human moving their mouse
2. **Performs composer nudge** which includes:
   - Click the text area
   - Move cursor to end
   - Add and remove a space
   - Press '1' then backspace (your brilliant suggestion!)
   - Press LEFT arrow then RIGHT arrow
3. **Clicks neutral area then back** to reset focus
4. **Checks button state** to see if it's enabled
5. **Retries up to 3 times** if button is still disabled
6. **Takes screenshot** if all attempts fail (saved to `logs/screenshots/`)

### Log Output Example

```
============================================================
ACTIVATING SEND BUTTON (HUMAN-LIKE BEHAVIOR)
============================================================
Performing composer nudge to activate send button...
Pressing '1' then backspace (anti-automation trick)...
Composer nudge complete
Attempt 1/3 to activate send button...
Send button state: disabled=False, aria-disabled=None, classes='...' , text='Send'
✓ Send button is ENABLED!

============================================================
SENDING MESSAGE
============================================================
Clicking send button...
✓ Send button clicked!
✓✓✓ SENT to +13059055068 (Eli)
```

## Testing

### Test Without Date Filtering

```powershell
python send_texts_date_filter.py
```

This uses your existing `test_numbers_with_dates.csv` and only sends to contacts with today's date.

### Test Scenarios

1. **Text only** (remove or leave image_path empty in config.json)
2. **Text + small image** (< 500KB)
3. **Text + larger image** (~ 1.5MB)
4. **Known contact** (number already in your Google Contacts)
5. **Unknown number** (not in contacts)

### Checking Logs

- Main log: `logs/run.log`
- Screenshots (if send fails): `logs/screenshots/failed_YYYYMMDD_HHMMSS_PHONENUMBER.png`

### What to Look For

✅ **Success indicators:**
- "✓ Send button is ENABLED!" in logs
- "✓✓✓ SENT to +PHONE (NAME)" in logs
- Message appears in Google Voice web interface
- No screenshot created

❌ **Failure indicators:**
- "❌ Failed to activate send button after N attempts" in logs
- Screenshot created in logs/screenshots/
- Message status = "failed" in progress.db

## Troubleshooting

### Send Button Still Disabled

**Try these solutions:**

1. **Increase retry attempts:**
   ```json
   "humanize_max_enable_retries": 5
   ```

2. **Increase delays:**
   ```json
   "humanize_micro_delay_min_ms": 200,
   "humanize_micro_delay_max_ms": 800
   ```

3. **Check screenshot** in `logs/screenshots/` to see what the UI looks like when it fails

4. **Test manually** - open Google Voice in the same Chrome profile and try sending manually to see if there's a different issue

### Image Upload Issues

- Try smaller images (< 500KB)
- Increase post-upload dwell time:
  ```json
  "humanize_post_upload_dwell_min_ms": 2000,
  "humanize_post_upload_dwell_max_ms": 3000
  ```

### Timeout Errors

- Increase the WebDriverWait timeout in code (currently 30 seconds)
- Check internet connection speed

## Rollback Instructions

If you need to revert to the old version:

```powershell
# Backup current version
Copy-Item send_texts.py -Destination send_texts_humanized.py

# Restore old version
Copy-Item send_texts_backup.py -Destination send_texts.py
```

## Database Reset

If you want to reset and try sending again:

```powershell
# Delete the database to start fresh
Remove-Item progress.db

# Or just update specific records to pending
python -c "import sqlite3; conn = sqlite3.connect('progress.db'); conn.execute('UPDATE messages SET status=\"pending\", attempts=0 WHERE status=\"failed\"'); conn.commit()"
```

## Advanced: Monitor Database

Check current status:

```powershell
python -c "import sqlite3; conn = sqlite3.connect('progress.db'); cursor = conn.cursor(); cursor.execute('SELECT status, COUNT(*) FROM messages GROUP BY status'); print('\n'.join([f'{row[0]}: {row[1]}' for row in cursor.fetchall()]))"
```

## Next Steps

If the humanization still doesn't fully solve the send button issue:

1. **Try smaller batch sizes** - reduce from 7 to 3-4 messages per batch
2. **Save contacts in Google Contacts** - import your CSV to Google Contacts first
3. **Manual hybrid approach** - have the script pause and prompt you to manually click send when it detects a disabled button
4. **Alternative providers** - consider Twilio/MessageBird for critical messages (paid options)

## Questions?

Check the logs first! The enhanced logging will tell you:
- Exactly when the button was checked
- What state it was in (disabled/enabled)
- Which activation strategies were attempted
- Whether they succeeded

If you see consistent failures, share the screenshot from `logs/screenshots/` and the relevant log lines from `logs/run.log`.
