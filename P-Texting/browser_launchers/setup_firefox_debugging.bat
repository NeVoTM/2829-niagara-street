@echo off
REM Enable Firefox Remote Debugging Settings
REM This script enables the required Firefox preferences for remote debugging

echo ========================================
echo Firefox Remote Debugging Setup
echo ========================================
echo.
echo This will enable remote debugging in Firefox.
echo.
echo INSTRUCTIONS:
echo 1. Close ALL Firefox windows completely
echo 2. Press any key to continue...
pause > nul
echo.
echo Opening Firefox with required debugging flags...
echo.

REM Start Firefox with all required flags for remote debugging
start firefox.exe --start-debugger-server 6000 --marionette --remote-debugging-port 6000

echo.
echo Firefox is starting with remote debugging enabled.
echo.
echo NEXT STEPS:
echo 1. In Firefox, type in the address bar: about:config
echo 2. Click "Accept the Risk and Continue"
echo 3. Search for: devtools.debugger.remote-enabled
echo 4. Click the toggle button to set it to TRUE
echo 5. Search for: devtools.chrome.enabled  
echo 6. Click the toggle button to set it to TRUE
echo 7. Navigate to: https://voice.google.com/messages
echo 8. Log in to Google Voice
echo 9. Go back to P-Texting GUI and click Send Messages
echo.
echo Press any key to close this window...
pause > nul
