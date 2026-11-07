# Copy the skillers skills into a Claude Code skills folder and create a config if missing.
# Usage: powershell -ExecutionPolicy Bypass -File scripts\install.ps1 [-Scope user|project]
param([ValidateSet("user", "project")][string]$Scope = "user")
$here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$target = if ($Scope -eq "project") { Join-Path (Get-Location) ".claude\skills" } else { Join-Path $HOME ".claude\skills" }
New-Item -ItemType Directory -Force -Path $target | Out-Null
foreach ($d in Get-ChildItem (Join-Path $here "skills") -Directory) {
  $dest = Join-Path $target $d.Name
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse $d.FullName $dest; "installed $($d.Name)"
}
$cfgDir = Join-Path $HOME ".skillers"; New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$cfg = Join-Path $cfgDir "config.json"
if (-not (Test-Path $cfg)) { Copy-Item (Join-Path $here "config\skillers.config.example.json") $cfg; "created $cfg (run the skillers-setup skill to tailor it)" }
