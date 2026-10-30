<#
  Turns on the automatic update: at 8 AM, 1 PM and 5 PM, Monday to Friday,
  Windows checks whether DASHBOARD DATA_2026.xlsx was saved since the last
  update. If yes (and neither Excel file is open), it runs the full update
  by itself. Nothing runs on Saturday and Sunday.
  Run once:   Setup-AutoRun.ps1
  Turn off:   Setup-AutoRun.ps1 -Remove
#>
param([switch]$Remove)
$name = 'EasyPC Content Dashboard Update'
if ($Remove) {
  Unregister-ScheduledTask -TaskName $name -Confirm:$false -ErrorAction SilentlyContinue
  Write-Host 'Auto-update turned off.'
  return
}
$script = Join-Path $PSScriptRoot 'Update-Dashboard.ps1'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument ('-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $script + '" -IfChanged')
$weekdays = 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
$trigger = @('8:00AM', '1:00PM', '5:00PM') | ForEach-Object { New-ScheduledTaskTrigger -Weekly -DaysOfWeek $weekdays -At $_ }
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 1) -MultipleInstances IgnoreNew
# Runs only while you are logged in: Excel and Claude Code need your session
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Write-Host ('Auto-update is on: "' + $name + '" checks at 8 AM, 1 PM and 5 PM, Monday to Friday.')
