#!/usr/bin/env bash
# Install JetBrains Toolbox.
# Downloads the latest release via the JetBrains API, extracts to /tmp,
# and runs the binary which self-installs to ~/.local/share/JetBrains/Toolbox/.
# Desktop entry is created automatically on first launch.
set -euo pipefail

INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"

if [ -d "$INSTALL_DIR" ]; then
    echo "JetBrains Toolbox is already installed at $INSTALL_DIR"
    exit 0
fi

echo "Fetching latest JetBrains Toolbox download URL..."
DOWNLOAD_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | jq -r '.TBA[0].downloads.linux.link')

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
    echo "Error: could not fetch download URL from JetBrains API"
    exit 1
fi

TMPDIR=$(mktemp -d)
TARBALL="$TMPDIR/jetbrains-toolbox.tar.gz"

echo "Downloading $DOWNLOAD_URL..."
curl -fSL -o "$TARBALL" "$DOWNLOAD_URL"

echo "Extracting..."
tar -xzf "$TARBALL" -C "$TMPDIR"

echo "Launching JetBrains Toolbox (self-installs to $INSTALL_DIR)..."
"$TMPDIR"/jetbrains-toolbox-*/bin/jetbrains-toolbox

rm -rf "$TMPDIR"

echo ""
echo "JetBrains Toolbox installed. Use it to install your IDEs."
