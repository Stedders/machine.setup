#!/usr/bin/env bash
# Install rustup (Rust toolchain manager).
# Adds ~/.cargo/bin to PATH — handled by .zshenv automatically.
set -euo pipefail

if command -v rustup &>/dev/null; then
    echo "rustup is already installed: $(rustup --version)"
    exit 0
fi

echo "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

echo ""
echo "Rust installed. Open a new shell to use rustc, cargo, rustup."
