#!/usr/bin/env bash
set -euo pipefail

echo "==> Normalizing SSH permissions"

if [ ! -d "$HOME/.ssh" ]; then
    echo "No ~/.ssh directory found; skipping."
    exit 0
fi

chmod 700 "$HOME/.ssh"

find "$HOME/.ssh" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \;
find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;

[ -f "$HOME/.ssh/config" ] && chmod 600 "$HOME/.ssh/config"
[ -f "$HOME/.ssh/known_hosts" ] && chmod 644 "$HOME/.ssh/known_hosts"

echo "==> SSH permissions normalized"