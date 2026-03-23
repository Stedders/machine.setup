#!/usr/bin/env bash
# Install Google Cloud SDK to ~/.local/share/google-cloud-sdk.
# PATH is handled by .zshenv, completions by .zshrc.
# After install, open a new shell and run: gcloud init
set -euo pipefail

INSTALL_DIR="$HOME/.local/share/google-cloud-sdk"

if [ -d "$INSTALL_DIR" ]; then
    echo "Google Cloud SDK is already installed at $INSTALL_DIR"
    exit 0
fi

echo "Installing Google Cloud SDK..."
mkdir -p "$HOME/.local/share"
curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir="$HOME/.local/share"

echo ""
echo "Google Cloud SDK installed to $INSTALL_DIR"
echo "Open a new shell, then run: gcloud init"
