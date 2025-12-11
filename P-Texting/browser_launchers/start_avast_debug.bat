@echo off
echo ========================================
echo Starting Avast Secure Browser (Debug Mode)
echo Account: account6
echo Port: 9227
echo ========================================
echo.

REM Create profile directory
if not exist "C:\temp\avast_debug_profile" mkdir "C:\temp\avast_debug_profile"

REM Start Avast Secure Browser with remote debugging on port 9227
start "" "C:\Program Files\AVAST Software\Browser\Application\AvastBrowser.exe" --remote-debugging-port=9227 --user-data-dir="C:\temp\avast_debug_profile" --no-first-run --no-default-browser-check

echo.
echo Avast Secure Browser started with remote debugging on port 9227
echo.
echo INSTRUCTIONS:
echo 1. Log in to Google Voice with account6
echo 2. Keep this Avast browser window open
echo 3. Run P-Texting (Avast) to send messages
echo.
pause
