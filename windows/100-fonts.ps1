$ErrorActionPreference = "Stop"

$FontPackageId = "DEVCOM.JetBrainsMonoNerdFont"

Write-Host "==> Checking JetBrainsMono Nerd Font"

$installed = winget list --id $FontPackageId --exact 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "JetBrainsMono Nerd Font is already installed."
}
else {
    Write-Host "==> Installing JetBrainsMono Nerd Font"

    winget install `
        --id $FontPackageId `
        --exact `
        --accept-package-agreements `
        --accept-source-agreements
}

Write-Host "==> Font setup complete"