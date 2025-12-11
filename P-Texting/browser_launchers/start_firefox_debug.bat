@echo off
REM Start Firefox with remote debugging enabled
REM This allows P-Texting to connect to Firefox for automation

echo ========================================
echo Starting Firefox for P-Texting
echo ========================================
echo Port: 6000 (Firefox CDP)
echo.
echo Opening Firefox with Google Voice...
echo.

REM Start Firefox with Selenium-compatible remote debugging AND open Google Voice
echo Starting Firefox in debug mode...
echo.
echo IMPORTANT: Keep this window open! Closing it will close Firefox.
echo.
echo Firefox will open - manually navigate to Google Voice.
echo Go to: https://voice.google.com/messages
echo Log in if needed, then use P-Texting GUI.
echo.
echo Press Ctrl+C to stop Firefox when done.
echo.
echo ========================================
echo.

REM Run Firefox and keep cmd window open
start "" "C:\Program Files\Mozilla Firefox\firefox.exe" --marionette --remote-debugging-port=6000

echo.
echo Firefox is starting...
timeout /t 3 /nobreak >nul
echo.
echo Firefox should now be running. This window will stay open.
echo.
echo To close Firefox, close the Firefox window (not this one).
echo.
:loop
timeout /t 60 /nobreak >nul
echo Firefox still running... (checked at %time%)
goto loop
