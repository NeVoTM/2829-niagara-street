# Firefox Remote Debugging Setup

## The Problem
Firefox requires two settings to be enabled before it can accept remote debugging connections from Selenium/Python.

## One-Time Setup (Do This Once)

### Step 1: Close All Firefox Windows
Make sure Firefox is completely closed.

### Step 2: Run the Debug Script
Double-click: `start_firefox_debug.bat`

OR run from command line:
```
firefox.exe --start-debugger-server 6000
```

### Step 3: Enable Remote Debugging in Firefox

1. In Firefox, type in the address bar: `about:config`
2. Click **"Accept the Risk and Continue"**
3. In the search box, type: `devtools.debugger.remote-enabled`
4. Click the **toggle button** on the right to set it to **TRUE** (it will turn blue)
5. In the search box, type: `devtools.chrome.enabled`
6. Click the **toggle button** on the right to set it to **TRUE** (it will turn blue)

**These settings persist!** You only need to do this once.

### Step 4: Navigate to Google Voice
1. Go to: https://voice.google.com/messages
2. Log in to your Google Voice account
3. Leave Firefox window open

### Step 5: Use P-Texting
1. Open P-Texting GUI
2. Select **Firefox** radio button
3. Click **Save**
4. Click **Send Messages**

## Every Time After Setup
Once you've done the one-time setup above, you only need to:

1. Run `start_firefox_debug.bat` 
2. Navigate to Google Voice (if not already logged in)
3. Use P-Texting GUI normally

## Verification
You can verify the settings are enabled by:
1. Type `about:config` in Firefox
2. Search for `devtools.debugger.remote-enabled` - should be TRUE
3. Search for `devtools.chrome.enabled` - should be TRUE

## Troubleshooting

### Error: "Could not run chrome debugger!"
**Solution:** Follow Step 3 above to enable the two required settings.

### Error: "Port 6000 not listening"
**Solution:** Make sure Firefox was started with `--start-debugger-server 6000` flag.

### Firefox won't connect
**Solution:** 
1. Close all Firefox windows
2. Run `start_firefox_debug.bat` again
3. Verify the two settings in about:config are TRUE

## Technical Details
- Firefox uses port **6000** for remote debugging (Chrome uses 9222)
- The flag `--start-debugger-server 6000` enables the debugger on that port
- The two config settings allow external tools (like Selenium) to connect
- These settings are safe and only allow connections from localhost (127.0.0.1)
