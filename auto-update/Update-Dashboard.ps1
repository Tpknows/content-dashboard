<#
  EASYPC CONTENT DASHBOARD - ONE-STEP UPDATE
  ------------------------------------------
  Source of truth: DASHBOARD DATA_2026.xlsx (sheet FB DATA). That is the only
  file anyone edits. This script then:
    1. reads every video in FB DATA (saved values)
    2. updates VIDEO LOG in the Content Team Tracker, matched by VIDEO LINK
       (adds new videos, refreshes numbers, repairs rows whose paste shifted).
       Only videos from startDate in config.json onward are touched; older
       rows stay exactly as they are.
    3. fills blank PILLAR / CATEGORY / HOOK TEXT / HOOK TYPE with Claude
       (caption only; AI-filled cells are shaded yellow so they can be checked)
    4. saves the tracker (a backup copy is kept first)
    5. pushes the tracker to the Google Sheet through the Tracker Upload
       Apps Script (only when uploadUrl is set in config.json)

  Usage
    UPDATE DASHBOARD.bat                      normal run
    Update-Dashboard.ps1 -DryRun              show what would change, write nothing
    Update-Dashboard.ps1 -NoAI -NoUpload      skip tagging / skip the Google push
    Update-Dashboard.ps1 -IfChanged           used by the scheduled task: runs only
                                              when DASHBOARD DATA was saved since the
                                              last run and neither file is open
#>
param(
  [switch]$DryRun,
  [switch]$NoAI,
  [switch]$NoUpload,
  [switch]$IfChanged
)

$ErrorActionPreference = 'Stop'
$Here = $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding $false
$OutputEncoding = $Utf8
[Console]::OutputEncoding = $Utf8

$LogDir = Join-Path $Here 'logs'
New-Item -ItemType Directory -Force $LogDir | Out-Null
$LogFile = Join-Path $LogDir ('update-' + (Get-Date -Format 'yyyy-MM-dd') + '.log')

function Log([string]$msg) {
  $line = (Get-Date -Format 'HH:mm:ss') + '  ' + $msg
  Write-Host $line
  [IO.File]::AppendAllText($LogFile, $line + "`r`n", $Utf8)
}

# ---------------------------------------------------------------- config
$ConfigPath = Join-Path $Here 'config.json'
$Config = [IO.File]::ReadAllText($ConfigPath, $Utf8) | ConvertFrom-Json
$StatePath = Join-Path $Here 'state.json'

# Finds a data file: config folder first, then anywhere under OneDrive (the
# folder can move). When it is found somewhere new, config.json is updated.
function Find-DataFile([string]$name) {
  $p = Join-Path $Config.dataFolder $name
  if (Test-Path -LiteralPath $p) { return $p }
  $roots = @($env:OneDriveCommercial, $env:OneDrive) | Where-Object { $_ } | Select-Object -Unique
  foreach ($root in $roots) {
    $hit = Get-ChildItem -LiteralPath $root -Recurse -File -Filter $name -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '\\backups\\' } |
      Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($hit) {
      Log ("Found " + $name + " in a new folder: " + $hit.DirectoryName)
      $Config.dataFolder = $hit.DirectoryName
      [IO.File]::WriteAllText($ConfigPath, ($Config | ConvertTo-Json -Depth 5), $Utf8)
      return $hit.FullName
    }
  }
  throw ("Hindi mahanap ang " + $name + ". I-check ang dataFolder sa config.json.")
}

function Test-Open([string]$path) {
  $lock = Join-Path (Split-Path $path) ('~$' + (Split-Path $path -Leaf))
  return (Test-Path -LiteralPath $lock)
}

$DashPath = Find-DataFile $Config.dashboardFile
$TrackPath = Find-DataFile $Config.trackerFile

if ($IfChanged) {
  $last = $null
  if (Test-Path $StatePath) { $last = ([IO.File]::ReadAllText($StatePath, $Utf8) | ConvertFrom-Json).dashboardWriteTime }
  $now = (Get-Item -LiteralPath $DashPath).LastWriteTimeUtc.ToString('o')
  if ($last -eq $now) { exit 0 }
  if (Test-Open $DashPath) { exit 0 }   # still being edited; next run will pick it up
  if (Test-Open $TrackPath) { Log 'Skipped: bukas ang tracker sa Excel.'; exit 0 }
}

if (Test-Open $TrackPath) { throw 'Bukas ang tracker sa Excel. Isara mo muna, tapos ulitin.' }
if (Test-Open $DashPath) { Log 'Paalala: bukas ang DASHBOARD DATA. Yung huling na-save na version ang babasahin.' }

Log ('==== Update start' + $(if ($DryRun) { ' (DRY RUN)' } else { '' }))
Log ('Dashboard: ' + $DashPath)
Log ('Tracker:   ' + $TrackPath)

# ---------------------------------------------------------------- helpers
function Is-XlError($v) { return ($v -is [int]) -and ($v -le -2146826200) }
function Clean($v) {
  if ($null -eq $v) { return '' }
  if (Is-XlError $v) { return '' }
  return [string]$v
}
function Norm-Link($l) { return ((Clean $l).Trim() -replace '[?#].*$', '' -replace '/+$', '').ToLower() }
function Title-Key($t) { $s = ((Clean $t).ToLower() -replace '\s+', ' ').Trim(); if ($s.Length -gt 30) { $s = $s.Substring(0, 30) }; return $s }
function Num($v) { if ($null -eq $v -or (Is-XlError $v) -or "$v" -eq '') { return $null }; try { return [double]$v } catch { return $null } }
# Cell writes go through reflection: PowerShell's own COM binding rejects
# strings that were stored in arrays ("Specified cast is not valid") or
# silently drops them. Text Excel would read as a formula gets an apostrophe.
function Set-XlProp($ws, [int]$r, [int]$c, [string]$prop, $v) {
  if ($null -ne $v) { $v = $v.PSObject.BaseObject }
  if ($prop -eq 'Value2' -and $v -is [string] -and $v -match '^[=+\-@]') { $v = "'" + $v }
  $cell = $ws.Cells.Item($r, $c)
  [void]$cell.GetType().InvokeMember($prop, [Reflection.BindingFlags]::SetProperty, $null, $cell, [object[]]@(, $v))
}
function Col-Letter([int]$n) { $s = ''; while ($n -gt 0) { $m = ($n - 1) % 26; $s = [char](65 + $m) + $s; $n = [int](($n - $m - 1) / 26) }; return $s }

function Header-Map($values, [int]$row) {
  $map = @{}
  for ($c = 1; $c -le $values.GetLength(1); $c++) {
    $h = (Clean $values[$row, $c]).Trim().ToUpper()
    if ($h -and -not $map.ContainsKey($h)) { $map[$h] = $c }
  }
  return $map
}
function Need-Col($map, [string]$name, [string]$where) {
  if (-not $map.ContainsKey($name)) { throw ('Walang column na "' + $name + '" sa ' + $where + '.') }
  return $map[$name]
}

# Range.Value2 as a 1-based [rows, cols] array even for a single cell
function Get-Block($range) {
  $v = $range.Value2
  if ($v -is [array]) { return ,$v }
  $a = [Array]::CreateInstance([object], @(1, 1), @(1, 1)); $a[1, 1] = $v; return ,$a
}
function New-Column([int]$n) { return ,([Array]::CreateInstance([object], @($n, 1), @(1, 1))) }

$excluded = @{}; foreach ($x in $Config.excludeCreators) { $excluded[$x.ToUpper()] = $true }

# ---------------------------------------------------------------- Excel
$xl = $null; $dashWb = $null; $trackWb = $null
try {
  $xl = New-Object -ComObject Excel.Application
  $xl.Visible = $false; $xl.DisplayAlerts = $false; $xl.AskToUpdateLinks = $false; $xl.ScreenUpdating = $false

  # ---- 1. read FB DATA
  $dashWb = $xl.Workbooks.Open($DashPath, 0, $true)
  $fbWs = $dashWb.Worksheets.Item('FB DATA')
  $ur = $fbWs.UsedRange
  $fbVals = Get-Block $fbWs.Range($fbWs.Cells(1, 1), $fbWs.Cells($ur.Row + $ur.Rows.Count - 1, $ur.Column + $ur.Columns.Count - 1))
  $fh = Header-Map $fbVals 1
  $c = @{}
  foreach ($k in 'POST ID', 'DATE', 'POSTED BY', 'VIDEO TITLE', 'VIDEO LINK', 'VIEWS', 'THRU PLAYS', 'AVG WATCH TIME', 'HOOK RATE', 'HOLD RATE', 'AUTHENTIC', 'AI', 'ORGANIC VIEWS') {
    $c[$k] = Need-Col $fh $k 'FB DATA'
  }
  $fb = [ordered]@{}; $fbByTitle = @{}
  for ($r = 2; $r -le $fbVals.GetLength(0); $r++) {
    $id = Clean $fbVals[$r, $c['POST ID']]
    $link = Norm-Link $fbVals[$r, $c['VIDEO LINK']]
    if (-not $id -or $id -eq '0' -or -not $link) { continue }
    $creatorRaw = $fbVals[$r, $c['POSTED BY']]
    $rec = [pscustomobject]@{
      Link = $link; LinkRaw = (Clean $fbVals[$r, $c['VIDEO LINK']]).Trim()
      Date = Num $fbVals[$r, $c['DATE']]
      Creator = (Clean $creatorRaw).Trim(); CreatorErr = (Is-XlError $creatorRaw)
      Title = Clean $fbVals[$r, $c['VIDEO TITLE']]
      Views = Num $fbVals[$r, $c['VIEWS']]; Organic = Num $fbVals[$r, $c['ORGANIC VIEWS']]
      Thru = Num $fbVals[$r, $c['THRU PLAYS']]; Avg = Num $fbVals[$r, $c['AVG WATCH TIME']]
      Hook = Num $fbVals[$r, $c['HOOK RATE']]; Hold = Num $fbVals[$r, $c['HOLD RATE']]
      Authentic = (Clean $fbVals[$r, $c['AUTHENTIC']]).Trim(); AI = (Clean $fbVals[$r, $c['AI']]).Trim()
    }
    $fb[$link] = $rec
    $tk = Title-Key $rec.Title
    if ($tk) { if ($fbByTitle.ContainsKey($tk)) { $fbByTitle[$tk] = '' } else { $fbByTitle[$tk] = $link } }  # '' = title not unique
  }
  $dashWb.Close($false); $dashWb = $null
  Log ('FB DATA: ' + $fb.Count + ' videos')

  # ---- 2. read VIDEO LOG
  $trackWb = $xl.Workbooks.Open($TrackPath, 0, $false)
  if ($trackWb.ReadOnly) { throw 'Read-only ang tracker (baka bukas sa ibang PC o nagsi-sync pa ang OneDrive). Subukan ulit mamaya.' }
  $ws = $trackWb.Worksheets.Item('VIDEO LOG')
  $HDR = 4; $FIRST = 5
  $hv = Get-Block $ws.Range($ws.Cells($HDR, 1), $ws.Cells($HDR, 40))
  $th = Header-Map $hv 1
  $t = @{}
  foreach ($k in 'DATE POSTED', 'CREATOR', 'VIDEO TITLE', 'CONTENT TYPE', 'PILLAR', 'CATEGORY', 'HOOK TEXT', 'HOOK TYPE', 'AI INTEGRATED?', 'AUTHENTIC?', 'VIEWS', 'ORGANIC VIEWS', 'THRUPLAYS', 'AVG WATCH TIME (S)', 'VIDEO LINK', 'HOOK RATE', 'HOLD RATE %') {
    $t[$k] = Need-Col $th $k 'VIDEO LOG'
  }
  $lastCol = ($th.Values | Measure-Object -Maximum).Maximum
  $xlUp = -4162
  $last = $FIRST - 1
  foreach ($k in 'DATE POSTED', 'VIDEO TITLE', 'VIDEO LINK') {
    $lr = $ws.Cells($ws.Rows.Count, $t[$k]).End($xlUp).Row
    if ($lr -gt $last) { $last = $lr }
  }
  $n = $last - $FIRST + 1
  $tv = Get-Block $ws.Range($ws.Cells($FIRST, 1), $ws.Cells($last, $lastCol))

  # Formula columns, taken from the first data row as R1C1 so they fit any row
  $tmpl = @{}
  for ($col = 1; $col -le $lastCol; $col++) {
    $cell = $ws.Cells($FIRST, $col)
    if ($cell.HasFormula) { $tmpl[$col] = $cell.FormulaR1C1 }
  }

  # ---- 3. scope: only videos from startDate onward. Older rows are never touched.
  $cutoff = ([DateTime]::ParseExact($Config.startDate, 'yyyy-MM-dd', $null)).ToOADate()
  $fbIn = @{}; $fbInByTitle = @{}
  foreach ($rec in $fb.Values) {
    if ($null -eq $rec.Date -or [double]$rec.Date -lt $cutoff) { continue }
    $fbIn[$rec.Link] = $rec
    $tk = Title-Key $rec.Title
    if ($tk) { if ($fbInByTitle.ContainsKey($tk)) { $fbInByTitle[$tk] = '' } else { $fbInByTitle[$tk] = $rec.Link } }
  }
  $scopeRows = New-Object System.Collections.ArrayList
  for ($i = 1; $i -le $n; $i++) {
    $d = Num $tv[$i, $t['DATE POSTED']]
    $link = Norm-Link $tv[$i, $t['VIDEO LINK']]
    if (($null -ne $d -and $d -ge $cutoff) -or ($link -and $fbIn.ContainsKey($link))) { [void]$scopeRows.Add($i) }
  }

  # ---- 4. decide which FB video each in-scope row belongs to.
  # Tags were typed while looking at the title, so when a row's title clearly
  # names a different video than its link (a shifted paste), the row follows
  # the title. Otherwise it follows the link.
  $owner = @{}; $claimed = @{}; $deferred = New-Object System.Collections.ArrayList
  $orphans = 0; $moved = New-Object System.Collections.ArrayList; $dupes = New-Object System.Collections.ArrayList
  foreach ($i in $scopeRows) {
    $link = Norm-Link $tv[$i, $t['VIDEO LINK']]
    $tk = Title-Key $tv[$i, $t['VIDEO TITLE']]
    $byTitle = $null; if ($tk -and $fbInByTitle.ContainsKey($tk) -and $fbInByTitle[$tk]) { $byTitle = $fbInByTitle[$tk] }
    $hasLink = [bool]($link -and $fbIn.ContainsKey($link))
    if ($hasLink -and (-not $byTitle -or $byTitle -eq $link) -and -not $claimed.ContainsKey($link)) {
      $owner[$i] = $link; $claimed[$link] = $i
    } elseif (-not $hasLink -and -not $byTitle) {
      $orphans++
    } else {
      [void]$deferred.Add(@($i, $link, $byTitle, $hasLink))
    }
  }
  foreach ($d in $deferred) {
    $i = $d[0]; $link = $d[1]; $byTitle = $d[2]; $hasLink = $d[3]
    if ($byTitle -and -not $claimed.ContainsKey($byTitle)) {
      $owner[$i] = $byTitle; $claimed[$byTitle] = $i
      if ($byTitle -ne $link) { [void]$moved.Add($FIRST + $i - 1) }
    } elseif ($hasLink -and -not $claimed.ContainsKey($link)) {
      $owner[$i] = $link; $claimed[$link] = $i
      [void]$moved.Add($FIRST + $i - 1)
    } else {
      [void]$dupes.Add($FIRST + $i - 1)
    }
  }

  # New videos join only once POSTED BY is filled in DASHBOARD DATA
  $waiting = @($fbIn.Values | Where-Object { -not $claimed.ContainsKey($_.Link) -and -not $_.Creator -and -not $_.CreatorErr })
  $newVids = @($fbIn.Values | Where-Object {
      -not $claimed.ContainsKey($_.Link) -and $_.Creator -and -not $_.CreatorErr -and -not $excluded.ContainsKey($_.Creator.ToUpper())
    } | Sort-Object Date)

  Log ('Scope: ' + $Config.startDate + ' pataas. FB DATA: ' + $fbIn.Count + ' videos; VIDEO LOG: ' + $scopeRows.Count + ' rows (matched ' + $owner.Count + ', wala sa FB DATA ' + $orphans + '); bago: ' + $newVids.Count)
  if ($waiting.Count) { Log ('Hindi muna isinama (walang POSTED BY sa DASHBOARD DATA): ' + $waiting.Count + ' video') }
  if ($moved.Count) { Log ('Shifted rows na inayos (magkaiba ang video sa title/date/link): ' + ($moved -join ', ')) }
  if ($dupes.Count) { Log ('Paalala, duplicate rows (hindi ginalaw, i-check mo): ' + ($dupes -join ', ')) }
  foreach ($v in $newVids) {
    $tt = ($v.Title -replace '\s+', ' ').Trim(); if ($tt.Length -gt 60) { $tt = $tt.Substring(0, 60) }
    Log ('  + new: ' + [DateTime]::FromOADate([double]$v.Date).ToString('MMM d') + ' | ' + $v.Creator + ' | ' + $tt)
  }

  # ---- 5. new contents, kept in memory per column (block index = sheet row - FIRST + 1)
  $total = $n + $newVids.Count
  $rowRec = @{}
  foreach ($k in $owner.Keys) { $rowRec[$k] = $fbIn[$owner[$k]] }
  for ($j = 0; $j -lt $newVids.Count; $j++) { $rowRec[$n + 1 + $j] = $newVids[$j] }

  $cols = @{}
  foreach ($k in $t.Keys) {
    $col = $t[$k]; $arr = New-Column $total
    for ($i = 1; $i -le $n; $i++) { $arr[$i, 1] = $tv[$i, $col] }
    $cols[$k] = $arr
  }
  foreach ($i in $rowRec.Keys) {
    $v = $rowRec[$i]
    $cols['DATE POSTED'][$i, 1] = $v.Date
    if ($v.Creator -and -not $v.CreatorErr) { $cols['CREATOR'][$i, 1] = $v.Creator }
    $cols['VIDEO TITLE'][$i, 1] = $v.Title
    if (-not (Clean $cols['CONTENT TYPE'][$i, 1])) { $cols['CONTENT TYPE'][$i, 1] = 'Reel' }
    if ($v.AI -and -not (Clean $cols['AI INTEGRATED?'][$i, 1])) { $cols['AI INTEGRATED?'][$i, 1] = $v.AI }
    if ($v.Authentic -and -not (Clean $cols['AUTHENTIC?'][$i, 1])) { $cols['AUTHENTIC?'][$i, 1] = $v.Authentic }
    $cols['VIEWS'][$i, 1] = $v.Views
    $cols['ORGANIC VIEWS'][$i, 1] = $v.Organic
    $cols['THRUPLAYS'][$i, 1] = $v.Thru
    $cols['AVG WATCH TIME (S)'][$i, 1] = $v.Avg
    $cols['VIDEO LINK'][$i, 1] = $v.LinkRaw
    $cols['HOOK RATE'][$i, 1] = $v.Hook
    $cols['HOLD RATE %'][$i, 1] = $v.Hold
  }
  $written = @('DATE POSTED', 'CREATOR', 'VIDEO TITLE', 'CONTENT TYPE', 'AI INTEGRATED?', 'AUTHENTIC?', 'VIEWS', 'ORGANIC VIEWS', 'THRUPLAYS', 'AVG WATCH TIME (S)', 'VIDEO LINK', 'HOOK RATE', 'HOLD RATE %')

  # ---- 6. rows that still need tags (in scope only)
  $tagFields = [ordered]@{ 'PILLAR' = 'pillar'; 'CATEGORY' = 'category'; 'HOOK TYPE' = 'hookType'; 'HOOK TEXT' = 'hookText' }
  $todo = New-Object System.Collections.ArrayList   # block indexes
  $needById = @{}
  foreach ($i in ($rowRec.Keys | Sort-Object)) {
    $need = @(); foreach ($f in $tagFields.Keys) { if (-not (Clean $cols[$f][$i, 1]).Trim()) { $need += $tagFields[$f] } }
    if ($need.Count -and (Clean $cols['VIDEO TITLE'][$i, 1]).Trim()) { [void]$todo.Add([int]$i); $needById[[int]$i] = $need }
  }
  Log ('Kailangan ng tags: ' + $todo.Count + ' rows')

  if ($DryRun) { Log '==== DRY RUN tapos. Walang binago.'; return }

  # ---- 7. write VIDEO LOG, cell by cell, only the in-scope rows
  $bak = Join-Path (Join-Path $Here 'backups') ('Tracker - ' + (Get-Date -Format 'yyyy-MM-dd HHmmss') + '.xlsx')
  New-Item -ItemType Directory -Force (Split-Path $bak) | Out-Null
  Copy-Item -LiteralPath $TrackPath $bak
  Get-ChildItem (Split-Path $bak) -Filter 'Tracker - *.xlsx' | Sort-Object Name -Descending | Select-Object -Skip ([int]$Config.keepBackups) | Remove-Item -Force
  Log ('Backup: ' + $bak)

  foreach ($i in ($rowRec.Keys | Sort-Object)) {
    $r = $FIRST + $i - 1
    if ($i -gt $n) {
      # New row: borrow the first data row's formatting (no clipboard used)
      $ws.Rows($FIRST).Copy($ws.Rows($r)) | Out-Null
      $ws.Rows($r).ClearContents() | Out-Null
    }
    foreach ($k in $written) { Set-XlProp $ws $r $t[$k] 'Value2' $cols[$k][$i, 1] }
    foreach ($col in $tmpl.Keys) { Set-XlProp $ws $r $col 'FormulaR1C1' $tmpl[$col] }
  }
  $trackWb.Save()
  Log ('VIDEO LOG saved: ' + $owner.Count + ' na-refresh, ' + $newVids.Count + ' bago')

  function Sheet-Row([int]$i) { return $FIRST + $i - 1 }


  # ---- 8. AI tags
  if (-not $NoAI -and $Config.aiTagging -and $todo.Count) {
    $allowed = @{
      pillar   = @($Config.pillars)
      category = @($Config.categories)
      hookType = @($Config.hookTypes)
    }
    # Examples: the team's own fully tagged rows, newest first
    $ex = New-Object System.Collections.ArrayList
    for ($i = $n; $i -ge 1 -and $ex.Count -lt 60; $i--) {
      $p = Clean $cols['PILLAR'][$i, 1]; $cat = Clean $cols['CATEGORY'][$i, 1]; $ht = Clean $cols['HOOK TYPE'][$i, 1]; $tx = Clean $cols['HOOK TEXT'][$i, 1]
      if ($p -and $cat -and $ht) {
        $cap = ((Clean $cols['VIDEO TITLE'][$i, 1]) -replace '\s+', ' ').Trim(); if ($cap.Length -gt 180) { $cap = $cap.Substring(0, 180) }
        [void]$ex.Add('- caption: "' + $cap + '" -> pillar: ' + $p + ' | category: ' + $cat + ' | hookType: ' + $ht + $(if ($tx) { ' | hookText: "' + (($tx -replace '\s+', ' ').Trim()) + '"' } else { '' }))
      }
    }
    $template = [IO.File]::ReadAllText((Join-Path $Here 'tag-prompt.md'), $Utf8)
    $template = $template.Replace('{{PILLARS}}', ($allowed.pillar -join ', ')).Replace('{{CATEGORIES}}', ($allowed.category -join ', ')).Replace('{{HOOKTYPES}}', ($allowed.hookType -join ', ')).Replace('{{EXAMPLES}}', ($ex -join "`n"))

    $yellow = 255 + 244 * 256 + 204 * 65536   # #FFF4CC
    $tagLog = Join-Path $LogDir 'ai-tags.csv'
    if (-not (Test-Path $tagLog)) { [IO.File]::WriteAllText($tagLog, "date,row,link,field,value`r`n", $Utf8) }
    $size = [int]$Config.aiBatchSize; $filled = 0; $failed = 0
    $normAlnum = { param($s) (([string]$s).ToLower() -replace '[^\p{L}\p{N}]+', '') }
    # Returns the caption's own text for the hook the AI picked (letters and
    # digits must match in order), or $null when the caption doesn't hold it.
    # The AI's copy is never written, so its typos or lost characters can't leak in.
    $captionSpan = {
      param([string]$caption, [string]$hook)
      $want = & $normAlnum $hook
      if ($want.Length -lt 4) { return $null }
      $chars = New-Object System.Text.StringBuilder; $pos = New-Object System.Collections.Generic.List[int]
      for ($k = 0; $k -lt $caption.Length; $k++) {
        $ch = [string]$caption[$k]
        if ($ch -match '[\p{L}\p{N}]') { [void]$chars.Append($ch.ToLower()); $pos.Add($k) }
      }
      $at = $chars.ToString().IndexOf($want)
      if ($at -lt 0) { return $null }
      $from = $pos[$at]; $to = $pos[$at + $want.Length - 1]
      # keep closing punctuation (?, !, .) that directly follows the hook
      while ($to + 1 -lt $caption.Length -and '?!.'.Contains([string]$caption[$to + 1])) { $to++ }
      return $caption.Substring($from, $to - $from + 1).Trim()
    }
    $runDir = Join-Path $env:TEMP 'easypc-dashboard-ai'
    New-Item -ItemType Directory -Force $runDir | Out-Null
    $inFile = Join-Path $runDir 'prompt.txt'; $outFile = Join-Path $runDir 'answer.txt'; $cmdFile = Join-Path $runDir 'ask.cmd'
    # Prompt and answer pass through files, so curly quotes, the peso sign and emoji stay intact
    [IO.File]::WriteAllText($cmdFile, ('@claude -p --model ' + $Config.aiModel + ' --tools "" --strict-mcp-config --no-session-persistence < "' + $inFile + '" > "' + $outFile + '" 2>nul'), [Text.Encoding]::ASCII)

    for ($b = 0; $b -lt $todo.Count; $b += $size) {
      $batch = @($todo.GetRange($b, [Math]::Min($size, $todo.Count - $b)))
      $items = @(); foreach ($x in $batch) { $items += [ordered]@{ id = $x; caption = (Clean $cols['VIDEO TITLE'][$x, 1]); need = @($needById[$x]) } }
      $prompt = $template.Replace('{{VIDEOS}}', (ConvertTo-Json -InputObject $items -Depth 4 -Compress))
      Log ('AI tagging ' + ($b + 1) + '-' + ($b + $batch.Count) + ' of ' + $todo.Count + ' ...')
      $out = $null
      [IO.File]::WriteAllText($inFile, $prompt, $Utf8)
      if (Test-Path $outFile) { Remove-Item $outFile -Force }
      Push-Location $runDir
      try {
        & cmd.exe /c $cmdFile
        if (Test-Path $outFile) { $out = [IO.File]::ReadAllText($outFile, $Utf8) }
      } catch { Log ('  Claude error: ' + $_) } finally { Pop-Location }
      $s = if ($out) { $out.IndexOf('[') } else { -1 }; $e = if ($out) { $out.LastIndexOf(']') } else { -1 }
      if ($s -lt 0 -or $e -le $s) { Log '  Walang valid na sagot sa batch na ito; lalaktawan.'; $failed += $batch.Count; continue }
      try { $res = $out.Substring($s, $e - $s + 1) | ConvertFrom-Json } catch { Log '  Hindi ma-parse ang sagot; lalaktawan.'; $failed += $batch.Count; continue }

      foreach ($r in $res) {
        $i = [int]$r.id
        if ($batch -notcontains $i) { continue }
        $need = $needById[$i]
        $sheetRow = Sheet-Row $i
        $caption = Clean $cols['VIDEO TITLE'][$i, 1]
        foreach ($f in $tagFields.Keys) {
          $key = $tagFields[$f]
          if ($need -notcontains $key) { continue }
          $val = [string]$r.$key; if (-not $val) { continue }
          $val = $val.Trim()
          if ($allowed.ContainsKey($key)) {
            $match = $allowed[$key] | Where-Object { $_.ToLower() -eq $val.ToLower() } | Select-Object -First 1
            if (-not $match) { continue }
            $val = $match
          } else {
            # Hook text must really be in the caption, never invented
            $val = & $captionSpan $caption $val
            if (-not $val) { continue }
          }
          $cell = $ws.Cells($sheetRow, $t[$f])
          if ((Clean $cell.Value2).Trim()) { continue }
          Set-XlProp $ws $sheetRow $t[$f] 'Value2' $val
          $cell.Interior.Color = $yellow
          $filled++
          $csvVal = '"' + ($val -replace '"', '""' -replace '\r?\n', ' ') + '"'
          [IO.File]::AppendAllText($tagLog, ((Get-Date -Format 'yyyy-MM-dd HH:mm') + ',' + $sheetRow + ',' + (Clean $cols['VIDEO LINK'][$i, 1]) + ',' + $key + ',' + $csvVal + "`r`n"), $Utf8)
        }
      }
      $trackWb.Save()
    }
    Log ('AI tags na nailagay: ' + $filled + ' cells (naka-yellow). Hindi natapos: ' + $failed + ' rows.')
  }

  $trackWb.Save()
  $trackWb.Close($true); $trackWb = $null
}
finally {
  if ($dashWb) { try { $dashWb.Close($false) } catch {} }
  if ($trackWb) { try { $trackWb.Close($false) } catch {} }
  if ($xl) { try { $xl.Quit() } catch {}; [void][Runtime.InteropServices.Marshal]::ReleaseComObject($xl) }
  [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}

if ($DryRun) { exit 0 }

# ---------------------------------------------------------------- 8. Google Sheet
if (-not $NoUpload -and $Config.uploadUrl) {
  $tokenFile = Join-Path $Here 'upload-token.txt'
  if (-not (Test-Path $tokenFile)) { throw 'Walang upload-token.txt. Tingnan ang SETUP sa README.' }
  $token = ([IO.File]::ReadAllText($tokenFile, $Utf8)).Trim()
  $body = @{ token = $token; fileName = (Split-Path $TrackPath -Leaf); data = [Convert]::ToBase64String([IO.File]::ReadAllBytes($TrackPath)) } | ConvertTo-Json -Compress
  Log 'Pushing tracker sa Google Sheet ...'
  $resp = Invoke-RestMethod -Method Post -Uri $Config.uploadUrl -Body ([Text.Encoding]::UTF8.GetBytes($body)) -ContentType 'application/json; charset=utf-8' -TimeoutSec 300
  if ($resp.status -ne 'ok') { throw ('Google Sheet upload failed: ' + $resp.message) }
  Log ('Google Sheet updated: ' + ($resp.sheets -join ', '))
  if ($resp.errors) { foreach ($er in $resp.errors) { Log ('  May problema: ' + $er) } }
} elseif (-not $NoUpload) {
  Log 'Google Sheet: hindi pa naka-setup (walang uploadUrl sa config.json), kaya nilaktawan.'
}

$state = @{ dashboardWriteTime = (Get-Item -LiteralPath $DashPath).LastWriteTimeUtc.ToString('o'); lastRun = (Get-Date).ToString('o') }
[IO.File]::WriteAllText($StatePath, ($state | ConvertTo-Json), $Utf8)
Log '==== Tapos.'
