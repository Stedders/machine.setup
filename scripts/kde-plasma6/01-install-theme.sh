#!/bin/bash
# Install Utterly Nord global theme, Tela Circle Nord icons, JetBrainsMono Nerd Font,
# and Klassy window decoration (for macOS-style traffic light buttons).
# Klassy requires sudo (COPR + dnf). Everything else is user-level.

set -euo pipefail

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

echo "=== Installing JetBrainsMono Nerd Font ==="
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
mkdir -p "$FONT_DIR"
NERD_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Downloading JetBrainsMono Nerd Font ${NERD_VERSION}..."
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/JetBrainsMono.zip" -o "$WORK_DIR/JetBrainsMono.zip"
unzip -o "$WORK_DIR/JetBrainsMono.zip" -d "$FONT_DIR" '*.ttf'
fc-cache -f

echo ""
echo "=== Installing Utterly Nord global theme ==="
git clone --depth 1 https://github.com/HimDek/Utterly-Nord-Plasma.git "$WORK_DIR/utterly-nord"

THEME_DIR="$HOME/.local/share/plasma/look-and-feel"
COLOR_DIR="$HOME/.local/share/color-schemes"
mkdir -p "$THEME_DIR" "$COLOR_DIR"

# Install dark and light look-and-feel packages
cp -r "$WORK_DIR/utterly-nord/look-and-feel" "$THEME_DIR/Utterly-Nord"
cp -r "$WORK_DIR/utterly-nord/look-and-feel-light" "$THEME_DIR/Utterly-Nord-Light"

# Install colour schemes
cp "$WORK_DIR/utterly-nord/UtterlyNord.colors" "$COLOR_DIR/"
cp "$WORK_DIR/utterly-nord/UtterlyNordLight.colors" "$COLOR_DIR/"

echo ""
echo "=== Installing Tela Circle Nord icon theme ==="
git clone --depth 1 https://github.com/vinceliuice/Tela-circle-icon-theme.git "$WORK_DIR/tela-circle"
"$WORK_DIR/tela-circle/install.sh" nord

echo ""
echo "=== Installing Klassy window decoration ==="
# Klassy provides macOS-style traffic light buttons, rounded corners, and custom titlebar styling.
# Install from COPR repo for Fedora.
sudo dnf copr enable -y errornointernet/klassy
sudo dnf install -y klassy

echo ""
echo "=== Verifying installation ==="
echo "Themes:"
lookandfeeltool -l 2>/dev/null | grep -i nord || echo "  (check System Settings > Appearance > Global Themes)"
echo ""
echo "Colour schemes:"
ls "$COLOR_DIR" | grep -i nord || echo "  (none found)"
echo ""
echo "Icons:"
ls "$HOME/.local/share/icons/" | grep -i tela || echo "  (none found)"
echo ""
echo "Fonts:"
fc-list | grep -i "JetBrainsMono Nerd" | head -3 && echo "  ..."

echo ""
echo "Done. Run 02-apply-look-and-feel.sh next to apply settings."
