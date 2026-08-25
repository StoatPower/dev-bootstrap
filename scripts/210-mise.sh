#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing mise"

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
else
  echo "mise is already installed"
fi

echo "==> Configuring mise"

# Ensure ~/.local/bin exists and is on PATH
mkdir -p "$HOME/.local/bin"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
  cat <<'EOF' >> "$HOME/.bashrc"

# Local user binaries
export PATH="$HOME/.local/bin:$PATH"
EOF
fi

# Enable mise
if ! grep -q 'mise activate bash' "$HOME/.bashrc"; then
  cat <<'EOF' >> "$HOME/.bashrc"

# mise
eval "$("$HOME/.local/bin/mise" activate bash)"
EOF
fi

# Activate for this script
export PATH="$HOME/.local/bin:$PATH"
eval "$("$HOME/.local/bin/mise" activate bash)"

echo "==> Verifying mise installation"

mise --version

echo "==> mise configured successfully"