#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Rust"

# Install the latest stable Rust toolchain.
mise use --global rust@stable

echo "==> Verifying Rust installation"

mise exec -- rustc --version
mise exec -- cargo --version
mise exec -- rustfmt --version
mise exec -- cargo clippy --version

echo "==> Rust installed successfully"