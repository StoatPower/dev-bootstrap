#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Julia"

mise use --global julia@latest

echo "==> Verifying Julia installation"

mise exec -- julia --version

echo "==> Julia installed successfully"