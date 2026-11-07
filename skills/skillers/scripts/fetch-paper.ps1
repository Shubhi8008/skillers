# fetch-paper.ps1 : download an OPEN ACCESS paper by arXiv id, DOI or title.
# Sources: arXiv and OpenAlex open access locations only. No Sci-Hub or other shadow libraries.
# Usage:
#   powershell -ExecutionPolicy Bypass -File fetch-paper.ps1 -Query "2404.12500" -OutDir "D:\papers"
#   powershell -ExecutionPolicy Bypass -File fetch-paper.ps1 -Query "10.1145/3411764.3445762"
#   powershell -ExecutionPolicy Bypass -File fetch-paper.ps1 -Query "Rico mobile app dataset data-driven design"
param(
  [Parameter(Mandatory = $true)][string]$Query,
  [Parameter(Mandatory = $true)][string]$OutDir
)
$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Safe-Name([string]$s) { ($s -replace '[^\w\- ]', '' -replace '\s+', '_').Substring(0, [Math]::Min(80, ($s -replace '[^\w\- ]', '' -replace '\s+', '_').Length)) }

function Save-Pdf([string]$url, [string]$name) {
  $out = Join-Path $OutDir ($name + ".pdf")
  if (Test-Path $out) { Write-Output "EXISTS $out"; return }
  Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -Headers @{ "User-Agent" = "skillers-research-fetch/1.0" }
  $head = [System.IO.File]::ReadAllBytes($out)[0..3]
  if ([System.Text.Encoding]::ASCII.GetString($head) -ne "%PDF") { Remove-Item $out -ErrorAction SilentlyContinue; Write-Output "NOT_PDF $url"; return }
  Write-Output "OK $out"
}

# 1. arXiv id
if ($Query -match '^\d{4}\.\d{4,5}(v\d+)?$') {
  Save-Pdf ("https://arxiv.org/pdf/" + $Query) ("arXiv_" + $Query); exit
}

# 2. DOI or title via OpenAlex
# select= keeps abstract_inverted_index out; its case-clashing keys break PowerShell 5 JSON parsing
$sel = "select=display_name,publication_year,doi,best_oa_location,locations,ids"
if ($Query -match '^10\.\d{4,}/') {
  $w = Invoke-RestMethod -Uri ("https://api.openalex.org/works/doi:" + $Query + "?" + $sel)
} else {
  $r = Invoke-RestMethod -Uri ("https://api.openalex.org/works?per_page=1&" + $sel + "&search=" + [uri]::EscapeDataString($Query))
  $w = $null
  if ($r.results) { $w = $r.results[0] }
}
if (-not $w) { Write-Output "NOT_FOUND $Query"; exit }

$title = $w.display_name
$year = $w.publication_year
$pdf = $w.best_oa_location.pdf_url
if (-not $pdf) { foreach ($loc in $w.locations) { if ($loc.is_oa -and $loc.pdf_url) { $pdf = $loc.pdf_url; break } } }

# arXiv fallback from OpenAlex ids
if (-not $pdf -and $w.ids.arxiv) { $pdf = ($w.ids.arxiv -replace 'abs', 'pdf') }

if ($pdf) {
  Save-Pdf $pdf ("{0}_{1}" -f $year, (Safe-Name $title))
} else {
  Write-Output ("NO_OPEN_PDF {0} ({1}) DOI {2} : buy, use a library, or check the author's page" -f $title, $year, $w.doi)
}
