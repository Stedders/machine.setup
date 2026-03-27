#!/usr/bin/env bash
# Remove unnecessary pre-installed applications from Ubuntu 24.04 GNOME.
#
# Safe to run on a fresh install. Does NOT remove:
#   - Core GNOME/Shell components (gnome-shell, gnome-session, nautilus, etc.)
#   - gnome-terminal (needed as fallback if Ghostty breaks)
#   - Firefox (kept as default browser)
#   - NetworkManager, systemd, gdm3
#   - gnome-control-center, gnome-settings-daemon, gnome-keyring
#
# Run: sudo bash scripts/ubuntu-2404/01-remove-bloat.sh

set -euo pipefail

echo "=== Ubuntu 24.04 GNOME: Remove bloat ==="
echo ""

# --- APT packages ---
APT_PACKAGES=(
    # Games
    aisleriot gnome-mahjongg gnome-mines gnome-sudoku

    # Media
    rhythmbox totem shotwell cheese

    # Office / productivity (use browser-based alternatives)
    libreoffice-calc libreoffice-writer libreoffice-impress
    libreoffice-draw libreoffice-math libreoffice-core
    libreoffice-common

    # Email
    thunderbird

    # Remote desktop
    gnome-remote-desktop remmina

    # Utilities (redundant with dev tools or unused)
    gnome-characters gnome-clocks gnome-font-viewer gnome-logs
    gnome-power-manager gnome-text-editor gnome-user-docs
    simple-scan usb-creator-gtk ubuntu-report yelp
    gnome-initial-setup

    # Accessibility (re-add if needed)
    brltty speech-dispatcher

    # Transmission (torrent client)
    transmission-gtk transmission-common
)

# Filter to only packages that are actually installed
INSTALLED=()
for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -l "$pkg" &>/dev/null && dpkg -s "$pkg" &>/dev/null; then
        INSTALLED+=("$pkg")
    fi
done

echo "--- APT packages ---"
if [[ ${#INSTALLED[@]} -eq 0 ]]; then
    echo "Nothing to remove — all bloat packages already absent."
else
    echo "The following ${#INSTALLED[@]} packages will be removed:"
    echo ""
    printf '  %s\n' "${INSTALLED[@]}"
    echo ""

    # Dry run first
    echo "=== Dry run (apt --simulate remove) ==="
    sudo apt --simulate remove "${INSTALLED[@]}" 2>&1 || true
    echo ""

    read -rp "Proceed with removal? [y/N] " confirm
    if [[ "${confirm,,}" != "y" ]]; then
        echo "Aborted APT removal."
    else
        echo ""
        echo "=== Removing packages ==="
        sudo apt remove -y "${INSTALLED[@]}"

        echo ""
        echo "=== Cleaning up unused dependencies ==="
        sudo apt autoremove -y
    fi
fi

# --- Snap packages ---
echo ""
echo "--- Snap packages ---"

SNAP_REMOVE=(
    # Snap store (use apt or flatpak instead)
    snap-store
    # Firmware updater (fwupd apt package is sufficient)
    firmware-updater
)

for snap in "${SNAP_REMOVE[@]}"; do
    if snap list "$snap" &>/dev/null; then
        echo "Removing snap: $snap"
        read -rp "  Remove $snap? [y/N] " confirm
        if [[ "${confirm,,}" == "y" ]]; then
            sudo snap remove "$snap"
        fi
    else
        echo "  $snap not installed, skipping"
    fi
done

echo ""
echo "=== Done ==="
echo "Reboot recommended but not required."
