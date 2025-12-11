@echo off
echo ========================================
echo Starting Brave Browser (Debug Mode)
echo Account: account3
echo Port: 9224
echo ========================================
echo.

REM Create profile directory
if not exist "C:\temp\brave_debug_profile" mkdir "C:\temp\brave_debug_profile"

REM Start Brave with remote debugging on port 9224
start "" "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" --remote-debugging-port=9224 --user-data-dir="C:\temp\brave_debug_profile" --no-first-run --no-default-browser-check

echo.
echo Brave started with remote debugging on port 9224
echo.
echo INSTRUCTIONS:
echo 1. Log in to Google Voice with account3
echo 2. Keep this Brave window open
echo 3. Run P-Texting (Brave) to send messages
echo.
pause
