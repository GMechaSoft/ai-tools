$source = Join-Path (Split-Path $PSScriptRoot -Parent) "agents"
$target = Join-Path $HOME ".config/opencode/agents"
$backup = "$target-old"

if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
if (Test-Path $target) { Rename-Item $target $backup }

New-Item -ItemType Junction -Path $target -Target $source -Force | Out-Null
Write-Host "Linked $source -> $target"

if (Test-Path $backup) {
  Get-ChildItem $backup | Copy-Item -Destination $target -Recurse -Force
  Remove-Item $backup -Recurse -Force
}
