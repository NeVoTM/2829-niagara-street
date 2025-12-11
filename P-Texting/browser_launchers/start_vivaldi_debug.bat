@echo off
echo ========================================
echo Starting Vivaldi Browser (Debug Mode)
echo Account: account5
echo Port: 9226
echo ========================================
echo.

REM Create profile directory
if not exist "C:\temp\vivaldi_debug_profile" mkdir "C:\temp\vivaldi_debug_profile"

REM Start Vivaldi with remote debugging on port 9226
start "" "C:\Users\%USERNAME%\AppData\Local\Vivaldi\Application\vivaldi.exe" --remote-debugging-port=9226 --user-data-dir="C:\temp\vivaldi_debug_profile" --no-first-run --no-default-browser-check

echo.
echo Vivaldi started with remote debugging on port 9226
echo.
echo INSTRUCTIONS:
echo 1. Log in to Google Voice with account5
echo 2. Keep this Vivaldi window open
echo 3. Run P-Texting (Vivaldi) to send messages
echo.
pause
