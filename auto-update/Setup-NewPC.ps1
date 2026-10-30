<#
  Run once on a new PC (right-click > Run with PowerShell, or from the
  "SETUP NEW PC.bat"). It checks everything the auto-update needs, then
  turns on the auto-update (8 AM, 1 PM, 5 PM, weekdays) on this PC.

  The auto-update folder lives in OneDrive, so config.json, upload-token.txt
  and the scripts move with it. What does NOT move: the scheduled task,
  Excel, and the Claude Code login. This script checks those.
#>
$ErrorActionPreference = 'Stop'
$Here = $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding $false
$ok = $true

function Pass([string]$m) { Write-Host ('  [OK]   ' + $m) -ForegroundColor Green }
function Fail([string]$m) { Write-Host ('  [AYUSIN] ' + $m) -ForegroundColor Yellow; $script:ok = $false }

Write-Host ''
Write-Host 'EasyPC Content Dashboard - setup sa bagong PC'
Write-Host ''

# 1. OneDrive
if ($env:OneDriveCommercial -or $env:OneDrive) { Pass ('OneDrive: ' + $(if ($env:OneDriveCommercial) { $env:OneDriveCommercial } else { $env:OneDrive })) }
else { Fail 'Hindi naka-sign in ang OneDrive. Mag-sign in sa EasyPC account at hintaying mag-sync.' }

# 2. Data files (the update script also searches OneDrive if the folder moved)
$config = [IO.File]::ReadAllText((Join-Path $Here 'config.json'), $Utf8) | ConvertFrom-Json
foreach ($f in @($config.dashboardFile, $config.trackerFile)) {
  $p = Join-Path $config.dataFolder $f
  if (Test-Path -LiteralPath $p) { Pass ($f) }
  else { Write-Host ('  [i]    Wala sa ' + $config.dataFolder + ': ' + $f + '. Hahanapin ito ng update sa OneDrive.') }
}

# 3. Excel
try {
  $xl = New-Object -ComObject Excel.Application
  Pass ('Excel ' + $xl.Version)
  $xl.Quit(); [void][Runtime.InteropServices.Marshal]::ReleaseComObject($xl)
} catch { Fail 'Walang desktop Excel. I-install ang Microsoft 365 Excel (hindi pwede ang Excel Online lang).' }

# 4. Claude Code, installed and logged in
$claude = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claude) {
  Fail 'Walang Claude Code. I-install, tapos buksan ang terminal, i-type ang "claude" at mag-login.'
} else {
  Push-Location $env:TEMP
  try { $ans = ('Reply with exactly: READY' | & claude -p --model $config.aiModel --tools '""' --strict-mcp-config --no-session-persistence) -join ' ' } catch { $ans = '' }
  Pop-Location
  if ($ans -match 'READY') { Pass 'Claude Code (naka-login)' }
  else { Fail 'Naka-install ang Claude Code pero hindi sumasagot. Buksan ang terminal, i-type ang "claude" at mag-login.' }
}

# 5. Google Sheet upload
if (Test-Path (Join-Path $Here 'upload-token.txt')) { Pass 'upload-token.txt' }
else { Fail 'Walang upload-token.txt. Hintaying mag-sync ang OneDrive, o kopyahin galing sa lumang PC.' }
if ($config.uploadUrl -match '/exec$') { Pass 'uploadUrl sa config.json' }
else { Fail 'Mali o walang uploadUrl sa config.json (dapat nagtatapos sa /exec).' }

Write-Host ''
if (-not $ok) {
  Write-Host 'Ayusin muna ang mga naka-[AYUSIN], tapos patakbuhin ulit ito. Hindi pa naka-on ang auto-update.' -ForegroundColor Yellow
  return
}

# 6. Turn on the auto-update here
& (Join-Path $Here 'Setup-AutoRun.ps1')
Write-Host ''
Write-Host 'IMPORTANTE: sa LUMANG PC, patakbuhin ang "Setup-AutoRun.ps1 -Remove".' -ForegroundColor Yellow
Write-Host 'Kapag sabay na naka-on sa dalawang PC, pwedeng magka-conflict ang files sa OneDrive.'
