@echo off
echo ========================================
echo Starting Microsoft Edge (Debug Mode)
echo Account: account2
echo Port: 9223
echo ========================================
echo.

REM Create profile directory
if not exist "C:\temp\edge_debug_profile" mkdir "C:\temp\edge_debug_profile"

REM Start Edge with remote debugging on port 9223
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --remote-debugging-port=9223 --user-data-dir="C:\temp\edge_debug_profile" --no-first-run --no-default-browser-check --new-window

echo.
echo Edge started with remote debugging on port 9223
echo.
echo INSTRUCTIONS:
echo 1. Log in to Google Voice with account2
echo 2. Keep this Edge window open
echo 3. Run P-Texting (Edge) to send messages
echo.
pause
