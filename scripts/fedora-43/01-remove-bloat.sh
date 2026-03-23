#!/usr/bin/env bash
# Remove unnecessary pre-installed applications from Fedora 43 KDE Plasma 6.
#
# Safe to run on a fresh install. Does NOT remove:
#   - Core KDE/Plasma components (kwin, plasma-desktop, dolphin, etc.)
#   - Konsole (required by plasma-drkonqi crash handler)
#   - keditbookmarks (required by konsole)
#   - Firefox, NetworkManager, systemd, sddm
#
# Run: sudo bash scripts/fedora-43/01-remove-bloat.sh

set -euo pipefail

echo "=== Fedora 43 KDE: Remove bloat ==="
echo ""

# Collect packages that are actually installed before attempting removal
PACKAGES=(
    # Games
    kmahjongg kmines kpat

    # Media / camera
    dragon elisa-player kamoso

    # Paint
    kolourpaint

    # RSS reader
    akregator

    # Remote desktop / screen sharing
    krdc krfb krdp

    # PIM suite (email, calendar, contacts)
    kontact kmail kmail-account-wizard korganizer kaddressbook
    kmouth ktnef akonadi-server kdepim-runtime kdepim-addons
    akonadi-import-wizard

    # LibreOffice (full suite)
    libreoffice-calc libreoffice-writer libreoffice-impress
    libreoffice-draw libreoffice-math libreoffice-core

    # MariaDB (pre-installed but disabled)
    mariadb mariadb-server mariadb-backup

    # Accessibility
    brltty speech-dispatcher braille-printer-app

    # Utilities
    ark kcalc kcharselect kfind kamera khelpcenter

    # Viewers / editors (user has Firefox + Ghostty only)
    okular gwenview kwrite

    # Welcome screen
    plasma-welcome plasma-welcome-fedora

    # VPN plugins (remove all — add back specific ones if needed)
    plasma-nm-l2tp plasma-nm-openconnect plasma-nm-openswan
    plasma-nm-openvpn plasma-nm-pptp plasma-nm-vpnc
)

# Filter to only packages that are actually installed
INSTALLED=()
for pkg in "${PACKAGES[@]}"; do
    if rpm -q "$pkg" &>/dev/null; then
        INSTALLED+=("$pkg")
    fi
done

if [[ ${#INSTALLED[@]} -eq 0 ]]; then
    echo "Nothing to remove — all bloat packages already absent."
    exit 0
fi

echo "The following ${#INSTALLED[@]} packages will be removed:"
echo ""
printf '  %s\n' "${INSTALLED[@]}"
echo ""

# Dry run first — show what dnf would do
echo "=== Dry run (dnf remove --assumeno) ==="
dnf remove --assumeno "${INSTALLED[@]}" 2>&1 || true
echo ""

read -rp "Proceed with removal? [y/N] " confirm
if [[ "${confirm,,}" != "y" ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "=== Removing packages ==="
dnf remove -y "${INSTALLED[@]}"

echo ""
echo "=== Cleaning up unused dependencies ==="
dnf autoremove -y

echo ""
echo "=== Done ==="
echo "Removed ${#INSTALLED[@]} packages. Reboot recommended but not required."
