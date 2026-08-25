#!/usr/bin/env bash
set -euo pipefail

echo "==> Configure Git"

git config --global init.defaultBranch main
git config --global fetch.prune true
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.fileMode false
git config --global gpg.program gpg
git config --global commit.gpgsign true
git config --global tag.gpgsign true

echo "==> Git configured"