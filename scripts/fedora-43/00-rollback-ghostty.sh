#!/usr/bin/env bash
set -euo pipefail

# Rollback: remove Terra repo, Ghostty, and reinstall via COPR

echo "==> Removing Ghostty..."
sudo dnf remove -y ghostty || true

echo "==> Removing Terra repository..."
sudo dnf remove -y terra-release || true
sudo rm -f /etc/yum.repos.d/terra*.repo

echo "==> Adding scottames/ghostty COPR repo..."
. /etc/os-release
curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" \
  | sudo tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo > /dev/null

echo "==> Installing Ghostty via COPR..."
sudo dnf install -y ghostty

echo "==> Verifying..."
ghostty --version

echo "✓ Rollback complete — Ghostty installed from COPR"
