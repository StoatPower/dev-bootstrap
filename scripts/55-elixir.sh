#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Elixir"

mise use --global elixir@latest

echo "==> Installing Hex"

mise exec -- mix local.hex --force

echo "==> Installing Rebar3"

mise exec -- mix local.rebar --force

echo "==> Verifying Elixir installation"

mise exec -- elixir --version
mise exec -- mix --version
mise exec -- iex --version

echo "==> Elixir installed successfully"