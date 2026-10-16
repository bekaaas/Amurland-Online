@echo off
setlocal
cd /d "%~dp0"

echo [AMURLAND] Checking Node.js...
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is not installed. Install Node.js 20+ first.
  pause
  exit /b 1
)

echo [AMURLAND] Releasing ports 5173 and 3001...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5173" ^| findstr "LISTENING"') do taskkill /F /PID %%a >nul 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":3001" ^| findstr "LISTENING"') do taskkill /F /PID %%a >nul 2>nul

if not exist node_modules (
  echo [AMURLAND] Installing dependencies...
  call npm.cmd install
  if errorlevel 1 goto :error
)

echo [AMURLAND] Starting frontend and backend...
call npm.cmd run dev
exit /b %errorlevel%

:error
echo.
echo AMURLAND failed to start.
pause
exit /b 1
