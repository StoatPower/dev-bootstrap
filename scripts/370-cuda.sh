#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking for NVIDIA GPU support"

# CUDA setup is optional. Machines without NVIDIA GPU support should
# simply skip this step.
if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo "==> NVIDIA GPU support not detected; skipping CUDA"
    exit 0
fi

if ~ nvidia-smi >/dev/null 2>&1; then
    echo "ERROR: nvidia-smi exists, but the NVIDIA GPU is not accessible."
    echo "Check the Windows NVIDIA driver and WSL GPU support."
    exit 1
fi

echo "==> NVIDIA GPU detected"

# This script is specifically for WSL. The NVIDIA display driver belongs
# on Windows and must NOT be installed inside the WSL distribution.
if ! grep -qiE '(microsoft|wsl)' /proc/version; then
    echo "ERROR: NVIDIA GPU detected, but this does not appear to be WSL."
    echo "CUDA installation outside WSL requires a different setup path."
    exit 1
fi

echo "==> Configuring NVIDIA CUDA repository for WSL"

KEYRING_DEB="$(mktemp --suffix=.deb)"
trap 'rm -f "$KEYRING_DEB"' EXIT

wget -q \
    https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb \
    -O "$KEYRING_DEB"

sudo dpkg -i "$KEYRING_DEB"

echo "==> Updating package metadata"

sudo apt-get update

echo "==> Installing CUDA Toolkit"

sudo apt-get install -y cuda-toolkit

echo "==> CUDA Toolkit installed"
echo
echo "NVIDIA driver:"
nvidia-smi

echo "==> Configuring CUDA environment"

ENV_DIR="$HOME/.config/dev-bootstrap/env"
mkdir -p "$ENV_DIR"

cat > "$ENV_DIR/cuda.sh" <<'EOF'
# Managed by dev-bootstrap/scripts/370-cuda.sh

export CUDA_HOME="/usr/local/cuda"
export PATH="$CUDA_HOME/bin:$PATH"

if [ -d "$CUDA_HOME/lib64" ]; then
    export LD_LIBRARY_PATH="$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi
EOF

# Apply the environment to this script as well as future shells.
source "$ENV_DIR/cuda.sh"

echo
echo "CUDA compiler:"
nvcc --version