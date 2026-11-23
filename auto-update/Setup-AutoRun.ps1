<#
  Turns on the automatic update: every 5 minutes (and at login), Windows
  checks whether DASHBOARD DATA_2026.xlsx was saved since the last update.
  If yes (and neither Excel file is open), it runs the full update by itself.
  No change = it stops right away, so the frequent check costs nothing.
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
# conhost --headless: no window at all (-WindowStyle Hidden alone still flashes one every check)
$action = New-ScheduledTaskAction -Execute 'conhost.exe' -Argument ('--headless powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $script + '" -IfChanged')
# No RepetitionDuration = repeats every 5 minutes for as long as the task exists
$trigger = @(
  (New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5)),
  (New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME)
)
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 1) -MultipleInstances IgnoreNew
# Runs only while you are logged in: Excel and Claude Code need your session
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Write-Host ('Auto-update is on: "' + $name + '" checks every 5 minutes for a new save of DASHBOARD DATA.')
