#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking CUDA prerequisite"

if ! command -v nvcc >/dev/null 2>&1; then
    echo "ERROR: nvcc in not available."
    echo "Run scripts/370-cuda.sh first."
    exit 1
fi

CUDA_MAJOR="$(nvcc --version | sed -n 's/.*release \([0-9]\+\)\..*/\1/p')"

if [ "$CUDA_MAJOR" != "13" ]; then
    echo "ERROR: This script currently expects CUDA 13."
    echo "Detected CUDA major version: ${CUDA_MAJOR:-unknown}"
    exit 1
fi

echo "==> Detecting Ubuntu release"

. /etc/os-release

DISTRO="ubuntu${VERSION_ID//./}"

echo "Detected repository target: $DISTRO"

echo "==> Configuring NVIDIA Ubuntu repository"

KEYRING_DEB="$(mktemp --suffix=.deb)"
trap 'rm -f "$KEYRING_DEB"' EXIT

wget -q \
  "https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/x86_64/cuda-keyring_1.1-1_all.deb" \
  -O "$KEYRING_DEB"

sudo dpkg -i "$KEYRING_DEB"

echo "==> Updating package metadata"

sudo apt-get update

echo "==> Installing cuDNN 9 for CUDA 13"

sudo apt-get install -y cudnn9-cuda-13

echo "==> cuDNN installed"

dpk-query -W \
    -f='${Package} ${Version}\n' \
    'libcudnn9*cuda-13' \
    'cudnn9-cuda-13' \
    2>/dev/null || true