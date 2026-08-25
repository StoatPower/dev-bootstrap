#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing GNU Fortran"

sudo apt-get install -y gfortran

echo "==> Verifying GNU Fortran installation"

mise exec -- gfortran --version

echo "==> GNU Fortran installed successfully"