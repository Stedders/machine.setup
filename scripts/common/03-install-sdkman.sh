#!/usr/bin/env bash
# Install SDKMAN (Java version manager).
# Shell integration is handled by .zshrc — sources sdkman-init.sh automatically.
# After install, open a new shell and run: sdk install java
set -euo pipefail

if [ -d "$HOME/.sdkman" ]; then
    echo "SDKMAN is already installed at ~/.sdkman"
    exit 0
fi

echo "Installing SDKMAN..."
curl -s "https://get.sdkman.io?rcupdate=false" | bash

echo ""
echo "SDKMAN installed to ~/.sdkman"
echo "Open a new shell, then run: sdk install java"
