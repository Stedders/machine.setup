#!/usr/bin/env bash
# Install C/C++ build tools and .NET SDK not available via Homebrew on Fedora.
# gcc and make are typically pre-installed; this adds g++, cmake, and dotnet.
# Note: Homebrew dotnet is broken on Fedora 43 (executable stack restriction).
set -euo pipefail

PACKAGES=(gcc-c++ cmake dotnet-sdk-10.0)

echo "Installing dev toolchain: ${PACKAGES[*]}"
echo ""

sudo dnf install -y "${PACKAGES[@]}"

echo ""
echo "Installed versions:"
g++ --version | head -1
cmake --version | head -1
dotnet --version
