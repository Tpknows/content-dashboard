@echo off
rem Double-click once on a new PC: checks the setup and turns on the auto-update
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup-NewPC.ps1"
echo.
pause
