#!/usr/bin/env bash
# Install nvm (Node Version Manager).
# Shell integration is handled by .zshrc — sources $NVM_DIR/nvm.sh automatically.
# After install, open a new shell and run: nvm install --lts
set -euo pipefail

if [ -d "$HOME/.nvm" ]; then
    echo "nvm is already installed at ~/.nvm"
    exit 0
fi

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | PROFILE=/dev/null bash

echo ""
echo "nvm installed to ~/.nvm"
echo "Open a new shell, then run: nvm install --lts"
