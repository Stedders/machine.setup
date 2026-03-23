#!/usr/bin/env bash
# Install Steam and gaming dependencies on Fedora.
# Includes 32-bit compatibility libraries, Vulkan, Proton tools, and gaming utilities.
# Requires RPM Fusion nonfree repo (enabled by default on Fedora KDE spins).
set -euo pipefail

# Ensure RPM Fusion nonfree is enabled
if ! dnf repolist --enabled 2>/dev/null | grep -q rpmfusion-nonfree; then
    echo "Enabling RPM Fusion nonfree repo..."
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
fi

# 32-bit compatibility libraries (required by many Steam/Proton games)
COMPAT_LIBS=(
    glibc.i686
    libstdc++.i686
    libgcc.i686
    zlib-ng-compat.i686
    mesa-libGL.i686
    mesa-libGLU.i686
    mesa-vulkan-drivers.i686
    libX11.i686
    libXcursor.i686
    libXrandr.i686
    libXinerama.i686
    libXi.i686
    libXtst.i686
)

# NVIDIA 32-bit Vulkan support (for Proton/DXVK)
NVIDIA_LIBS=(
    xorg-x11-drv-nvidia-libs.i686
)

# Vulkan packages
VULKAN_PKGS=(
    mesa-vulkan-drivers
    vulkan-tools
)

# Gaming tools
GAMING_TOOLS=(
    steam
    protontricks
    winetricks
    gamemode
    mangohud
    gamescope
)

ALL_PACKAGES=("${COMPAT_LIBS[@]}" "${NVIDIA_LIBS[@]}" "${VULKAN_PKGS[@]}" "${GAMING_TOOLS[@]}")

echo "Installing Steam and gaming dependencies (${#ALL_PACKAGES[@]} packages)..."
echo ""

sudo dnf install -y "${ALL_PACKAGES[@]}"

echo ""
echo "Installed:"
echo "  - Steam"
echo "  - 32-bit compatibility libraries"
echo "  - NVIDIA 32-bit Vulkan support"
echo "  - protontricks / winetricks (fix games needing .NET, VC++, DirectX)"
echo "  - gamemode (CPU/scheduler optimiser — add 'gamemoderun %command%' to launch options)"
echo "  - mangohud (FPS overlay — add 'mangohud %command%' to launch options)"
echo "  - gamescope (Valve compositor for upscaling/frame limiting)"
echo ""
echo "Launch Steam from the application menu or run: steam"
