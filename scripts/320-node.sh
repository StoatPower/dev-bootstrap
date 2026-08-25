#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Node.js"

mise use --global node@lts

echo "==> Verifying Node.js installation"

mise exec -- node --version
mise exec -- npm --version
mise exec -- npx --version

echo "==> Node.js installed successfully"