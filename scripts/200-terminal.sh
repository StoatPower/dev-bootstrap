#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing terminal and command-line tools"

sudo apt-get install -y \
    tmux \
    ripgrep \
    fd-find \
    fzf \
    jq \
    tree \
    htop \
    btop \
    bat \
    ncdu \
    p7zip-full \
    rsync \
    shellcheck \
    less \
    man-db

echo "==> Creating Ubuntu compatibility aliases"

mkdir -p "${HOME}/.local/bin"

# Ubuntu names these executables differently because of package-name
# conflicts inherited from Debian.
if command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
fi

if command -v batcat >/dev/null 2>&1; then
  ln -sf "$(command -v batcat)" "${HOME}/.local/bin/bat"
fi

echo "==> Terminal tools installed"