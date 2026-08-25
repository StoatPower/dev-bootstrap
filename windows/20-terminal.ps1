$ErrorActionPreference = "Stop"

$SchemeName = "Ubuntu VS Code"
$FontFace = "JetBrainsMono Nerd Font"

Write-Host "==> Locating Windows Terminal settings"

$possiblePaths = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)

$SettingsPath = $possiblePaths |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

if (-not $SettingsPath) {
    throw "Could not locate Windows Terminal settings.json"
}

Write-Host "Found: $SettingsPath"

# Keep a recoverable copy before changing anything.
$BackupPath = "$SettingsPath.bootstrap-backup"

if (-not (Test-Path $BackupPath)) {
    Copy-Item $SettingsPath $BackupPath
    Write-Host "Backup created: $BackupPath"
}

Write-Host "==> Loading Windows Terminal configuration"

$settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json

# Ensure schemes exists.
if (-not $settings.PSObject.Properties["schemes"]) {
    $settings | Add-Member `
        -MemberType NoteProperty `
        -Name schemes `
        -Value @()
}

$scheme = [PSCustomObject]@{
    name                = $SchemeName
    background          = "#300A24"
    foreground          = "#CCCCCC"
    cursorColor         = "#FFFFFF"
    selectionBackground = "#264F78"

    black         = "#000000"
    red           = "#CD3131"
    green         = "#0DBC79"
    yellow        = "#E5E510"
    blue          = "#2472C8"
    purple        = "#BC3FBC"
    cyan          = "#11A8CD"
    white         = "#E5E5E5"

    brightBlack   = "#666666"
    brightRed     = "#F14C4C"
    brightGreen   = "#23D18B"
    brightYellow  = "#F5F543"
    brightBlue    = "#3B8EEA"
    brightPurple  = "#D670D6"
    brightCyan    = "#29B8DB"
    brightWhite   = "#FFFFFF"
}

Write-Host "==> Configuring color scheme"

$existingScheme = $settings.schemes |
    Where-Object { $_.name -eq $SchemeName } |
    Select-Object -First 1

if ($existingScheme) {
    # Replace the existing managed scheme.
    $settings.schemes = @(
        $settings.schemes | Where-Object { $_.name -ne $SchemeName }
    )
}

$settings.schemes += $scheme

Write-Host "==> Configuring profile defaults"

if (-not $settings.PSObject.Properties["profiles"]) {
    throw "Windows Terminal settings contain no profiles section."
}

if (-not $settings.profiles.PSObject.Properties["defaults"]) {
    $settings.profiles |
        Add-Member -MemberType NoteProperty -Name defaults -Value ([PSCustomObject]@{})
}

$defaults = $settings.profiles.defaults

if ($defaults.PSObject.Properties["colorScheme"]) {
    $defaults.colorScheme = $SchemeName
}
else {
    $defaults |
        Add-Member -MemberType NoteProperty -Name colorScheme -Value $SchemeName
}

$font = [PSCustomObject]@{
    face = $FontFace
}

if ($defaults.PSObject.Properties["font"]) {
    $defaults.font = $font
}
else {
    $defaults |
        Add-Member -MemberType NoteProperty -Name font -Value $font
}

Write-Host "==> Saving Windows Terminal configuration"

$settings |
    ConvertTo-Json -Depth 100 |
    Set-Content $SettingsPath -Encoding utf8

Write-Host
Write-Host "==> Windows Terminal configured successfully"
Write-Host "    Scheme: $SchemeName"
Write-Host "    Font:   $FontFace"
Write-Host
Write-Host "Open a new Windows Terminal tab to apply the changes."