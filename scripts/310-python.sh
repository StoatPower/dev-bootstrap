#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Python"

mise use --global python@latest

echo "==> Verifying Python installation"

mise exec -- python --version
mise exec -- python -m pip --version

echo "==> Python installed successfully"

echo "==> Installing uv"

mise use --global uv@latest

echo "==> Verifying uv installation"

mise exec -- uv --version

echo "==> uv installed successfully"