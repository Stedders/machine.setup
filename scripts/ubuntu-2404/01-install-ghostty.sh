#!/usr/bin/env bash
# Install Ghostty terminal emulator via PPA on Ubuntu 24.04.
# https://ghostty.org/docs/install/binary#ubuntu
#
# Run: sudo bash scripts/ubuntu-2404/01-install-ghostty.sh

set -euo pipefail

echo "==> Adding Ghostty PPA..."
sudo add-apt-repository -y ppa:ghostty/release

echo "==> Updating package index..."
sudo apt update

echo "==> Installing Ghostty..."
sudo apt install -y ghostty

echo "==> Verifying installation..."
ghostty --version

echo "Done. Ghostty installed successfully."
