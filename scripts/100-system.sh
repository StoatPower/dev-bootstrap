#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating Ubuntu package metadata"
sudo apt-get update

echo "==> Installing core system and build packages"

# Network, source control, and native build tools
sudo apt-get install -y \
  ca-certificates \
  curl \
  wget \
  git \
  build-essential \
  autoconf \
  automake \
  libtool \
  pkg-config \
  cmake \
  ninja-build \
  patch \

echo "==> Installing archive and compression tools"

sudo apt-get install -y \
  unzip \
  zip \
  xz-utils \
  bzip2

echo "==> Installing common development libraries"

sudo apt-get install -y \
  libssl-dev \
  libncurses-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libffi-dev \
  liblzma-dev \
  libgdbm-dev \
  libdb-dev \
  uuid-dev

echo "==> System foundation installed"