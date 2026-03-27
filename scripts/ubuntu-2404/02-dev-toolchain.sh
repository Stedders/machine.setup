#!/usr/bin/env bash
# Install C/C++ build tools and .NET SDK on Ubuntu 24.04.
# Ubuntu's build-essential meta-package covers gcc, g++, and make.
# cmake and dotnet are added separately.
#
# Run: sudo bash scripts/ubuntu-2404/02-dev-toolchain.sh

set -euo pipefail

PACKAGES=(build-essential cmake dotnet-sdk-9.0)

echo "Installing dev toolchain: ${PACKAGES[*]}"
echo ""

sudo apt update
sudo apt install -y "${PACKAGES[@]}"

echo ""
echo "Installed versions:"
gcc --version | head -1
g++ --version | head -1
cmake --version | head -1
dotnet --version
