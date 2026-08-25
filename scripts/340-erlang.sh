#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Erlang build dependencies"

sudo apt-get install -y \
  libwxgtk3.2-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libpng-dev \
  libssh-dev \
  unixodbc-dev \
  xsltproc \
  fop

echo "==> Installing Erlang"

mise use --global erlang@latest

echo "==> Verifying Erlang installation"

mise exec -- erl -eval 'halt().' -noshell

echo "==> Erlang installed successfully"