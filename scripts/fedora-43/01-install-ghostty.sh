#!/usr/bin/env bash
set -euo pipefail

# Install Ghostty terminal emulator via scottames/ghostty COPR
# https://ghostty.org/docs/install/binary#fedora

. /etc/os-release

echo "==> Adding scottames/ghostty COPR repo..."
curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" \
  | sudo tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo > /dev/null

echo "==> Installing Ghostty..."
sudo dnf install -y ghostty

echo "==> Verifying installation..."
ghostty --version

echo "✓ Ghostty installed successfully"
