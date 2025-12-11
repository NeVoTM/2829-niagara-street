@echo off
REM P-Texting Firefox Launcher
REM This launches P-Texting using Firefox (with limitations)

cd /d "%~dp0"

echo ========================================
echo P-TEXTING - FIREFOX VERSION
echo ========================================
echo.
echo WARNING: Firefox version has limitations:
echo - Launches NEW Firefox instance each time
echo - You MUST log in to Google Voice every session
echo - Use Chrome version for better experience
echo.
echo This version is for backup when Chrome hits daily limit.
echo.
echo ========================================
echo.

REM Check if Firefox is already running with debug mode
echo Checking if Firefox debug mode is running...
powershell -Command "$result = Test-NetConnection -ComputerName 127.0.0.1 -Port 6000 -InformationLevel Quiet -WarningAction SilentlyContinue; if ($result) { Write-Output 'Firefox debug mode detected on port 6000' } else { Write-Output 'Firefox debug mode NOT running'; Write-Output 'Please start Firefox first:'; Write-Output '  1. Double-click Start Firefox for P-Texting shortcut'; Write-Output '  2. Or run start_firefox_debug.bat'; exit 1 }"
if errorlevel 1 (
    echo.
    echo Press any key to exit...
    pause > nul
    exit /b 1
)

echo.
echo Starting P-Texting GUI with Firefox config...
echo.

REM Launch GUI with Firefox config
start "" pythonw.exe "p_texting_gui.py"

echo.
echo P-Texting GUI launched!
echo Remember: Use Firefox in the browser selection.
echo.
echo Press any key to close this window...
pause > nul
