@echo off
rem Runs the skillers harvester every hour while you are logged in. Double-click to install.
schtasks /Create /SC HOURLY /TN "Skillers Harvest" /TR "powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%~dp0harvest.ps1\"" /F
schtasks /Query /TN "Skillers Harvest"
echo.
echo To stop it later: schtasks /Delete /TN "Skillers Harvest" /F
pause
