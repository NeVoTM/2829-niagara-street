@echo off
echo ========================================
echo Starting Opera Browser (Debug Mode)
echo Account: account4
echo Port: 9225
echo ========================================
echo.

REM Create profile directory
if not exist "C:\temp\opera_debug_profile" mkdir "C:\temp\opera_debug_profile"

REM Start Opera with remote debugging on port 9225
start "" "C:\Users\%USERNAME%\AppData\Local\Programs\Opera\opera.exe" --remote-debugging-port=9225 --user-data-dir="C:\temp\opera_debug_profile" --no-first-run --no-default-browser-check

echo.
echo Opera started with remote debugging on port 9225
echo.
echo INSTRUCTIONS:
echo 1. Log in to Google Voice with account4
echo 2. Keep this Opera window open
echo 3. Run P-Texting (Opera) to send messages
echo.
pause
