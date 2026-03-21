#!/bin/bash
# Step 4: Remove nomodeset from boot params and configure NVIDIA for Wayland
sudo grubby --update-kernel=ALL --remove-args="nomodeset vga=791"
echo 'options nvidia_drm modeset=1 fbdev=1' | sudo tee /etc/modprobe.d/nvidia.conf
sudo dracut --force
echo ""
echo "Done. Reboot when ready: sudo reboot"
