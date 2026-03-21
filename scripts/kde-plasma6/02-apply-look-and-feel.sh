#!/bin/bash
# Apply Utterly Nord theme, Tela Circle Nord icons, JetBrainsMono Nerd Font,
# Klassy window decoration with macOS-style buttons, and Konsole transparency.
# Uses KDE CLI tools — no sudo needed.

set -euo pipefail

echo "=== Applying Utterly Nord Dark global theme ==="
lookandfeeltool -a Utterly-Nord

echo ""
echo "=== Applying colour scheme ==="
plasma-apply-colorscheme UtterlyNord

echo ""
echo "=== Applying Tela Circle Nord icon theme ==="
ICON_THEME=$(ls "$HOME/.local/share/icons/" | grep -i "tela-circle.*nord" | head -1)
if [ -z "$ICON_THEME" ]; then
    echo "Error: Tela Circle Nord icon theme not found. Run 01-install-theme.sh first."
    exit 1
fi
kwriteconfig6 --file kdeglobals --group Icons --key Theme "$ICON_THEME"

echo ""
echo "=== Applying JetBrainsMono Nerd Font ==="
kwriteconfig6 --file kdeglobals --group General --key font "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "JetBrainsMono Nerd Font,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key menuFont "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key fixed "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

echo ""
echo "=== Applying Klassy window decoration ==="
# Set Klassy as the window decoration
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.klassy"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "Klassy"
# macOS-style traffic light buttons: close (left), minimise, maximise — on the left side
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "XIA"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight ""

echo ""
echo "=== Enabling blur and transparency desktop effects ==="
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig6 --file kwinrc --group Plugins --key contrastEnabled true
kwriteconfig6 --file kwinrc --group Plugins --key translucencyEnabled true

echo ""
echo "=== Configuring Konsole transparency ==="
KONSOLE_PROFILE_DIR="$HOME/.local/share/konsole"
mkdir -p "$KONSOLE_PROFILE_DIR"
# Create a Nord-transparent profile if one doesn't exist
PROFILE_FILE="$KONSOLE_PROFILE_DIR/Nord-Transparent.profile"
if [ ! -f "$PROFILE_FILE" ]; then
    cat > "$PROFILE_FILE" <<'PROFILE'
[Appearance]
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[General]
Command=/bin/bash
Name=Nord Transparent
Parent=FALLBACK/

[Scrolling]
HistoryMode=2

[Terminal Features]
BlinkingCursorEnabled=true
PROFILE
fi

# Set as default profile
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile "Nord-Transparent.profile"

echo ""
echo "=== Reloading KWin ==="
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

echo ""
echo "=== Verifying ==="
echo "Colour scheme: $(kreadconfig6 --file kdeglobals --group General --key ColorScheme)"
echo "Icon theme: $(kreadconfig6 --file kdeglobals --group Icons --key Theme)"
echo "UI font: $(kreadconfig6 --file kdeglobals --group General --key font)"
echo "Window decoration: $(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key library)"
echo "Buttons left: $(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft)"
echo "Blur enabled: $(kreadconfig6 --file kwinrc --group Plugins --key blurEnabled)"

echo ""
echo "Done. You may need to log out and back in for all changes to take full effect."
echo ""
echo "Manual steps remaining:"
echo "  1. Klassy button style: System Settings > Colours & Themes > Window Decorations"
echo "     > Klassy > Configure > set button icon style to 'Traffic Lights'"
echo "  2. Konsole transparency: Open Konsole > Settings > Edit Profile > Appearance"
echo "     > Edit colour scheme > set Background transparency slider"
echo "  3. Floating panel: Right-click panel > Enter Edit Mode > More Options > Floating"
echo "  4. Day/night switching: System Settings > Appearance > Quick Settings"
