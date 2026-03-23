#!/usr/bin/env bash
# Add Homebrew zsh to /etc/shells and set it as default shell

set -euo pipefail

ZSH_PATH="/home/linuxbrew/.linuxbrew/bin/zsh"

if [[ ! -x "$ZSH_PATH" ]]; then
  echo "Error: $ZSH_PATH not found or not executable"
  exit 1
fi

# Add to /etc/shells if not already there
if ! grep -qF "$ZSH_PATH" /etc/shells; then
  echo "Adding $ZSH_PATH to /etc/shells..."
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
else
  echo "$ZSH_PATH already in /etc/shells"
fi

# Change default shell
echo "Changing default shell to $ZSH_PATH..."
sudo chsh -s "$ZSH_PATH" "$USER"

echo "Done. Log out and back in for the change to take effect."
