@echo off
rem Double-click: updates the tracker and the Google Sheet from DASHBOARD DATA_2026
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Update-Dashboard.ps1"
echo.
pause
