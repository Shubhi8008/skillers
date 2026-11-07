# harvest.ps1 : hourly GitHub + web harvester for the skillers skill library.
# Uses as much of the GitHub API budget as each hour allows:
#   search API (10 calls/min without a token) for rotating queries in queries.txt
#   core API (60 calls/hour without a token) to resolve repos found in curated lists and web pages (sources.txt)
#   raw.githubusercontent.com (not rate limited by the API) for READMEs of new repos
# Optional: set a user environment variable GITHUB_TOKEN (read-only public token) to raise limits to 5,000/hour.
# Outputs: repos.csv (master list), readmes\, log.txt, and "13 Harvest Index.md" in the vault set in ~/.skillers/config.json
param(
  [int]$SearchJobs = 30,
  [int]$CoreBudget = 55,
  [int]$SourcesPerRun = 3,
  [int]$ReadmesPerRun = 25,
  [string]$VaultNote = ""
)
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$csvPath = Join-Path $root "repos.csv"; $statePath = Join-Path $root "state.json"
$queuePath = Join-Path $root "queue.txt"; $logPath = Join-Path $root "log.txt"
$readmeDir = Join-Path $root "readmes"; New-Item -ItemType Directory -Force -Path $readmeDir | Out-Null
$now = (Get-Date).ToString("yyyy-MM-dd HH:mm")
if (-not $VaultNote) {
  $cfgPath = $env:SKILLERS_CONFIG; if (-not $cfgPath) { $cfgPath = Join-Path $HOME ".skillers\config.json" }
  if (Test-Path $cfgPath) { $cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json; if ($cfg.paths.vault) { $VaultNote = Join-Path $cfg.paths.vault "13 Harvest Index.md" } }
  if (-not $VaultNote) { $VaultNote = Join-Path $root "harvest-index.md" }
}
$browserUA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36"
$h = @{ "User-Agent" = "skillers-harvest/1.0"; "Accept" = "application/vnd.github+json" }
$sleepSearch = 6.5
if ($env:GITHUB_TOKEN) { $h["Authorization"] = "Bearer $($env:GITHUB_TOKEN)"; $SearchJobs = 90; $CoreBudget = 800; $sleepSearch = 2.1 }

function Log($m) { $line = "[$now] $m"; Add-Content -Path $logPath -Value $line -Encoding UTF8; Write-Output $line }
function Clean($s) { if ($null -eq $s) { return "" }; return (($s -replace '[\r\n\t]+', ' ') -replace '\|', '/').Trim() }

function Get-Cat([string]$t) {
  $t = $t.ToLower()
  if ($t -match 'skill\.md|agent skill|claude skill|claude-skill|agent-skills|claude code skill|\bskills?\b.*(claude|agent|codex)') { return "skill" }
  if ($t -match '\bmcp\b|model context protocol|mcp-server') { return "mcp" }
  if ($t -match 'scrap|crawl|playwright|puppeteer|browser automation|headless') { return "scraper" }
  if ($t -match '\bclip\b|siglip|embedding|vector|semantic search|retrieval|similarity search') { return "search-embeddings" }
  if ($t -match 'saliency|eye.?track|scanpath|dataset|benchmark') { return "research-dataset" }
  if ($t -match 'design system|design tokens|component library|tokens') { return "design-system" }
  if ($t -match 'canvas|moodboard|whiteboard|gallery|bookmark|inspiration') { return "viewer-inspiration" }
  if ($t -match 'screenshot to code|ui to code|design to code|html|tailwind') { return "design-to-code" }
  if ($t -match '\bux\b|\bui\b|usability|accessib|wireframe|figma|interface') { return "ux-ui" }
  return "other"
}

function Is-Relevant([string]$t) {
  $t = $t.ToLower()
  return ($t -match 'claude|agent skill|skill\.md|\bmcp\b|design|\bux\b|\bui\b|usability|figma|wireframe|moodboard|inspiration|scrap|crawl|playwright|screenshot|\bclip\b|siglip|embedding|image search|visual search|saliency|eye.?track|obsidian|canvas|slop|typograph|accessib')
}

# ---------- load state ----------
$repos = @{}
if (Test-Path $csvPath) { foreach ($r in (Import-Csv $csvPath -Encoding UTF8)) { $repos[$r.full_name.ToLower()] = $r } }
$state = @{ next = 0; srcNext = 0; runs = 0 }
if (Test-Path $statePath) { $s = Get-Content $statePath -Raw | ConvertFrom-Json; $state.next = [int]$s.next; $state.srcNext = [int]$s.srcNext; $state.runs = [int]$s.runs }
$queue = New-Object System.Collections.Generic.List[string]
if (Test-Path $queuePath) { foreach ($l in Get-Content $queuePath) { if ($l.Trim()) { $queue.Add($l.Trim()) } } }
$newThisRun = New-Object System.Collections.Generic.List[string]
$skipped = 0
# drop anything stored earlier that fails the relevance filter
foreach ($k in @($repos.Keys)) { $r = $repos[$k]; if (-not (Is-Relevant ("{0} {1} {2}" -f $r.full_name, $r.description, $r.topics))) { $repos.Remove($k) } }
$beforeCount = $repos.Count

function Upsert($it, [string]$src) {
  $key = $it.full_name.ToLower()
  $topics = ""; if ($it.topics) { $topics = ($it.topics -join " ") }
  if (-not (Is-Relevant ("{0} {1} {2}" -f $it.full_name, $it.description, $topics))) { $script:skipped++; return }
  $lic = ""; if ($it.license) { $lic = $it.license.spdx_id }
  $cat = Get-Cat ("{0} {1} {2}" -f $it.full_name, $it.description, $topics)
  if ($repos.ContainsKey($key)) {
    $r = $repos[$key]; $r.stars = [string]$it.stargazers_count; $r.forks = [string]$it.forks_count
    $r.pushed = ([string]$it.pushed_at).Substring(0, [Math]::Min(10, ([string]$it.pushed_at).Length)); $r.last_seen = $now
  } else {
    $repos[$key] = [pscustomobject]@{
      full_name = $it.full_name; stars = [string]$it.stargazers_count; forks = [string]$it.forks_count
      pushed = ([string]$it.pushed_at).Substring(0, [Math]::Min(10, ([string]$it.pushed_at).Length))
      language = [string]$it.language; license = [string]$lic; topics = (Clean $topics); description = (Clean $it.description)
      category = $cat; url = $it.html_url; first_seen = $now; last_seen = $now; source = $src
    }
    $script:newThisRun.Add($key)
  }
}

# ---------- rate limits (this call is free) ----------
try { $rl = (Invoke-WebRequest -Uri "https://api.github.com/rate_limit" -Headers $h -UseBasicParsing).Content | ConvertFrom-Json
  $coreLeft = [int]$rl.resources.core.remaining; $searchLeft = [int]$rl.resources.search.remaining
  Log "limits: core $coreLeft, search $searchLeft per minute window"
} catch { $coreLeft = $CoreBudget; $searchLeft = 10; Log "rate_limit check failed: $($_.Exception.Message)" }

# ---------- 1. rotating search jobs ----------
$Q = @(Get-Content (Join-Path $root "queries.txt") | Where-Object { $_.Trim() -and -not $_.Trim().StartsWith("#") })
$total = $Q.Count * 6; $done = 0
$retried = @{}
for ($j = 0; $j -lt $SearchJobs; $j++) {
  $idx = ($state.next + $j) % $total
  $q = $Q[$idx % $Q.Count]; $rest = [Math]::Floor($idx / $Q.Count)
  $page = ($rest % 3) + 1; $sort = "stars"; if (([Math]::Floor($rest / 3) % 2) -eq 1) { $sort = "updated" }
  $u = "https://api.github.com/search/repositories?q=$([uri]::EscapeDataString($q))&sort=$sort&order=desc&per_page=50&page=$page"
  try {
    $res = Invoke-WebRequest -Uri $u -Headers $h -UseBasicParsing
    $data = $res.Content | ConvertFrom-Json
    foreach ($it in $data.items) { Upsert $it ("search:" + $q) }
    $done++
  } catch {
    $msg = $_.Exception.Message
    $code = 0; if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
    if ($code -eq 403 -or $code -eq 429) {
      # wait for the search window to reset, then retry this job once
      $wait = 61
      try { $rl2 = (Invoke-WebRequest -Uri "https://api.github.com/rate_limit" -Headers $h -UseBasicParsing).Content | ConvertFrom-Json
        $wait = [Math]::Max(5, [int]$rl2.resources.search.reset - [int][DateTimeOffset]::UtcNow.ToUnixTimeSeconds() + 2) } catch { }
      Log "search limit after $done jobs, waiting $wait s"
      Start-Sleep -Seconds ([Math]::Min($wait, 90))
      if (-not $retried[$j]) { $retried[$j] = 1; $j--; continue }
      continue
    }
    Log "search fail '$q' p$page (code $code): $($msg.Substring(0, [Math]::Min(200, $msg.Length)))"
  }
  Start-Sleep -Seconds $sleepSearch
}
$state.next = ($state.next + $SearchJobs) % $total
Log "search jobs done: $done"

# ---------- 2. mine curated lists and web pages for repo links ----------
$S = @(Get-Content (Join-Path $root "sources.txt") | Where-Object { $_.Trim() -and -not $_.Trim().StartsWith("#") })
$skipOwners = 'topics|features|sponsors|orgs|about|marketplace|login|settings|collections|apps|site|pricing|security|enterprise|search|explore|trending|readme|contact|customer-stories|team|join|notifications|issues|pulls'
for ($k = 0; $k -lt [Math]::Min($SourcesPerRun, $S.Count); $k++) {
  $src = $S[($state.srcNext + $k) % $S.Count]
  try {
    $c = (Invoke-WebRequest -Uri $src -UseBasicParsing -UserAgent $browserUA -TimeoutSec 25).Content
    $found = 0
    foreach ($m in [regex]::Matches($c, 'github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)')) {
      $o = $m.Groups[1].Value; $n = ($m.Groups[2].Value -replace '\.git$', '' -replace '[.)]+$', '')
      if ($o -match "^($skipOwners)$" -or -not $n) { continue }
      $key = "$o/$n".ToLower()
      if (-not $repos.ContainsKey($key) -and -not $queue.Contains($key)) { $queue.Add($key); $found++ }
    }
    Log "source $src : $found new links queued"
  } catch { Log "source fail $src : $($_.Exception.Message)" }
  Start-Sleep -Seconds 2
}
$state.srcNext = ($state.srcNext + $SourcesPerRun) % [Math]::Max(1, $S.Count)

# ---------- 3. spend core budget resolving the queue ----------
$budget = [Math]::Min($CoreBudget, $coreLeft - 3); $used = 0
while ($queue.Count -gt 0 -and $used -lt $budget) {
  $key = $queue[0]; $queue.RemoveAt(0); $used++
  try { $it = (Invoke-WebRequest -Uri "https://api.github.com/repos/$key" -Headers $h -UseBasicParsing).Content | ConvertFrom-Json
    if ($it.full_name) { Upsert $it "list" }
  } catch { if ($_.Exception.Message -match '403|429') { $queue.Insert(0, $key); Log "core limit hit"; break } }
}
Log "core calls used: $used, queue left: $($queue.Count)"

# ---------- 4. READMEs for the best new repos (raw, not API limited) ----------
$top = $newThisRun | ForEach-Object { $repos[$_] } | Sort-Object { [int]$_.stars } -Descending | Select-Object -First $ReadmesPerRun
foreach ($r in $top) {
  $f = Join-Path $readmeDir (($r.full_name -replace '/', '_') + ".md")
  if (Test-Path $f) { continue }
  foreach ($n in @("README.md", "readme.md", "Readme.md")) {
    try { Invoke-WebRequest -Uri "https://raw.githubusercontent.com/$($r.full_name)/HEAD/$n" -OutFile $f -UseBasicParsing -UserAgent $browserUA -TimeoutSec 20; break } catch { }
  }
}

# ---------- 5. save ----------
$all = $repos.Values | Sort-Object { [int]$_.stars } -Descending
$all | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
$queue | Set-Content -Path $queuePath -Encoding UTF8
$state.runs++; ($state | ConvertTo-Json) | Set-Content -Path $statePath -Encoding UTF8
Log "run $($state.runs): $($repos.Count) repos total, $($repos.Count - $beforeCount) new, $skipped off-topic skipped"

# ---------- 6. vault index note ----------
$cats = "skill", "mcp", "scraper", "search-embeddings", "viewer-inspiration", "design-system", "design-to-code", "ux-ui", "research-dataset", "other"
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("---"); [void]$sb.AppendLine("title: Harvest index"); [void]$sb.AppendLine("updated: $now"); [void]$sb.AppendLine("tags: [repos, harvest]"); [void]$sb.AppendLine("---"); [void]$sb.AppendLine("")
[void]$sb.AppendLine("# Harvest index"); [void]$sb.AppendLine("")
[void]$sb.AppendLine("Back to [[Welcome]] | Scope [[00 Scope Lock]] | Hand picked list [[10 Repo Index]]"); [void]$sb.AppendLine("")
[void]$sb.AppendLine("Auto generated every hour by ``tools/harvest/harvest.ps1``. Full data: ``repos.csv``. Runs so far: $($state.runs). Repos: $($repos.Count). New this run: $($newThisRun.Count). Queue: $($queue.Count)."); [void]$sb.AppendLine("")
[void]$sb.AppendLine("## Count by category"); [void]$sb.AppendLine("| Category | Repos |"); [void]$sb.AppendLine("|---|---|")
foreach ($c in $cats) { [void]$sb.AppendLine("| $c | $(@($all | Where-Object { $_.category -eq $c }).Count) |") }
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## New this run (top 30 by stars)"); [void]$sb.AppendLine("| Repo | Stars | Category | What it does |"); [void]$sb.AppendLine("|---|---|---|---|")
foreach ($r in ($newThisRun | ForEach-Object { $repos[$_] } | Sort-Object { [int]$_.stars } -Descending | Select-Object -First 30)) {
  $d = $r.description; if ($d.Length -gt 110) { $d = $d.Substring(0, 110) }
  [void]$sb.AppendLine("| [$($r.full_name)]($($r.url)) | $($r.stars) | $($r.category) | $d |")
}
foreach ($c in $cats) {
  if ($c -eq "other") { continue }
  [void]$sb.AppendLine(""); [void]$sb.AppendLine("## Top 15: $c"); [void]$sb.AppendLine("| Repo | Stars | Updated | What it does |"); [void]$sb.AppendLine("|---|---|---|---|")
  foreach ($r in ($all | Where-Object { $_.category -eq $c } | Select-Object -First 15)) {
    $d = $r.description; if ($d.Length -gt 110) { $d = $d.Substring(0, 110) }
    [void]$sb.AppendLine("| [$($r.full_name)]($($r.url)) | $($r.stars) | $($r.pushed) | $d |")
  }
}
[IO.File]::WriteAllText($VaultNote, $sb.ToString(), (New-Object Text.UTF8Encoding($false)))
Log "vault note written"
