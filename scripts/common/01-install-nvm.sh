#!/usr/bin/env bash
# Install nvm (Node Version Manager).
# Installs to XDG_CONFIG_HOME/nvm (~/.config/nvm).
# Shell integration is handled by .zshrc — sources $NVM_DIR/nvm.sh automatically.
# After install, open a new shell and run: nvm install --lts
set -euo pipefail

NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"

if [ -d "$NVM_DIR" ]; then
    echo "nvm is already installed at $NVM_DIR"
    exit 0
fi

echo "Installing nvm..."
export NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | PROFILE=/dev/null bash

echo ""
echo "nvm installed to $NVM_DIR"
echo "Open a new shell, then run: nvm install --lts"
