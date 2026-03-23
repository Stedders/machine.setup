#!/usr/bin/env bash
# Install C/C++ build tools not already present on Fedora.
# gcc and make are typically pre-installed; this adds g++ and cmake.
set -euo pipefail

PACKAGES=(gcc-c++ cmake)

echo "Installing C/C++ build tools: ${PACKAGES[*]}"
echo ""

sudo dnf install -y "${PACKAGES[@]}"

echo ""
echo "Installed versions:"
g++ --version | head -1
cmake --version | head -1
