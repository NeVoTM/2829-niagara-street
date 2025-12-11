@echo off
setlocal

set CHROME_EXE="C:\Program Files\Google\Chrome\Application\chrome.exe"
set DEBUG_PORT=9222
set USER_PROFILE_DIR=C:\temp\chrome_debug_profile
set DEFAULT_PROFILE=%USER_PROFILE_DIR%\Default

echo Closing all Chrome windows...
taskkill /F /IM chrome.exe /T >nul 2>&1
for /l %%i in (1,1,5) do (
  timeout /t 1 /nobreak >nul
  tasklist | find /i "chrome.exe" >nul || goto :after_kill
)
:after_kill

if not exist "%DEFAULT_PROFILE%" (
  echo Creating debug Chrome profile at "%DEFAULT_PROFILE%" ...
  mkdir "%DEFAULT_PROFILE%" >nul 2>&1
)

echo Starting Chrome with remote debugging on port %DEBUG_PORT% and dedicated profile...
echo Opening Google Voice automatically...
start "" %CHROME_EXE% --remote-debugging-port=%DEBUG_PORT% --user-data-dir=%USER_PROFILE_DIR% --no-first-run --no-default-browser-check "https://voice.google.com/messages"

REM Give Chrome time to start listening
powershell -NoProfile -Command "Start-Sleep -Seconds 3; try { $r=Invoke-WebRequest -Uri 'http://127.0.0.1:%DEBUG_PORT%/json/version' -UseBasicParsing -TimeoutSec 2; if($r.StatusCode -eq 200){Write-Output 'OK: DevTools is listening on 127.0.0.1:%DEBUG_PORT%'} else {Write-Output 'WARN: DevTools not ready yet'} } catch { Write-Output 'WARN: DevTools not ready yet' }"

echo.
echo SUCCESS! Chrome is running with:
echo - Remote debugging on port %DEBUG_PORT%
echo - Google Voice automatically opened
echo.
echo Next steps:
echo 1. Log in to Google Voice (if not already logged in)
echo 2. In P-Texting GUI, select Chrome and click "Send Messages"
echo Keep this window open - Chrome will stay running!
echo.
echo Press Ctrl+C to stop when done.
echo.
:wait
timeout /t 999 /nobreak >nul
goto wait
