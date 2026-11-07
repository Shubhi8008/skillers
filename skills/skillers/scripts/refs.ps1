# refs.ps1 : helper for skillers references mode. Runs on the user's Windows machine.
# Modes:
#   -Mode awwwards -Query "portfolio"            -> JSON of Awwwards site cards (category slug)
#   -Mode godly                                  -> JSON of Godly / recent.design items (latest)
#   -Mode og -Urls "u1,u2"                       -> JSON of og:image + title for any page URLs
#   -Mode thumbs -In refs.json -OutDir folder    -> downloads each item's img to folder as <id>.<ext>
# Output JSON items: { id, source, title, page, img }
param(
  [Parameter(Mandatory = $true)][ValidateSet("awwwards", "godly", "og", "thumbs")][string]$Mode,
  [string]$Query = "",
  [string]$Urls = "",
  [string]$In = "",
  [string]$OutDir = "",
  [string]$Out = "",
  [int]$Max = 24
)
$ErrorActionPreference = "Continue"
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Get-Html([string]$u) { (Invoke-WebRequest -Uri $u -UseBasicParsing -UserAgent $ua -TimeoutSec 20).Content }
function Emit($items) {
  $json = ConvertTo-Json -InputObject @($items | Select-Object -First $Max) -Depth 3
  if ($Out) { [IO.File]::WriteAllText($Out, $json, (New-Object Text.UTF8Encoding($false))); "WROTE $Out ($(@($items).Count) found)" } else { $json }
}

switch ($Mode) {
  "awwwards" {
    $slug = ($Query.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
    $u = if ($slug) { "https://www.awwwards.com/websites/$slug/" } else { "https://www.awwwards.com/websites/" }
    $h = Get-Html $u
    $items = @(); $seen = @{}; $i = 0
    foreach ($m in [regex]::Matches($h, '(?s)href="(/sites/[^"]+)".{0,1500}?(https://assets\.awwwards\.com/awards/media/cache/thumb_440_330/submissions/[^"''\s]+\.(?:jpg|png|webp))')) {
      $page = "https://www.awwwards.com" + $m.Groups[1].Value
      if ($seen[$page]) { continue }; $seen[$page] = 1; $i++
      $title = ($m.Groups[1].Value -replace '^/sites/', '' -replace '-', ' ')
      $items += [pscustomobject]@{ id = "aw$i"; source = "Awwwards"; title = $title; page = $page; img = $m.Groups[2].Value }
    }
    Emit $items
  }
  "godly" {
    $h = Get-Html "https://godly.website/"
    $items = @(); $seen = @{}; $i = 0
    foreach ($m in [regex]::Matches($h, 'https://cdn\.recent\.design/items/([a-z0-9]+)/0/image/[a-f0-9]+/720\.webp')) {
      if ($seen[$m.Groups[1].Value]) { continue }; $seen[$m.Groups[1].Value] = 1; $i++
      $items += [pscustomobject]@{ id = "gd$i"; source = "Godly"; title = $m.Groups[1].Value; page = "https://godly.website/"; img = $m.Value }
    }
    Emit $items
  }
  "og" {
    $items = @(); $i = 0
    foreach ($u in ($Urls -split ',')) {
      $u = $u.Trim(); if (-not $u) { continue }; $i++
      try {
        $h = Get-Html $u
        $img = [regex]::Match($h, '(?i)<meta[^>]+property="og:image"[^>]+content="([^"]+)"').Groups[1].Value
        if (-not $img) { $img = [regex]::Match($h, '(?i)<meta[^>]+content="([^"]+)"[^>]+property="og:image"').Groups[1].Value }
        $t = [regex]::Match($h, '(?is)<title>(.*?)</title>').Groups[1].Value.Trim()
        $items += [pscustomobject]@{ id = "og$i"; source = ([uri]$u).Host; title = $t; page = $u; img = $img }
      } catch { $items += [pscustomobject]@{ id = "og$i"; source = "error"; title = $_.Exception.Message; page = $u; img = "" } }
      Start-Sleep -Milliseconds 800
    }
    Emit $items
  }
  "thumbs" {
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $list = Get-Content $In -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($r in $list) {
      if (-not $r.img) { continue }
      $f = Join-Path $OutDir ("{0}.img" -f $r.id)
      if (Test-Path $f) { continue }
      try { Invoke-WebRequest -Uri $r.img -OutFile $f -UseBasicParsing -UserAgent $ua -TimeoutSec 20; "OK $($r.id)" } catch { "FAIL $($r.id)" }
      Start-Sleep -Milliseconds 300
    }
  }
}
