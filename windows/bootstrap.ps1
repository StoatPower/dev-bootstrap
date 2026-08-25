$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot

& "$ScriptRoot\10-fonts.ps1"
& "$ScriptRoot\20-terminal.ps1"

Write-Host
Write-Host "==> Windows bootstrap complete"