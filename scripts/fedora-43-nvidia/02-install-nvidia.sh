#!/bin/bash
# Step 2: Install NVIDIA driver and build dependencies
sudo dnf install gcc kernel-devel-$(uname -r) akmod-nvidia xorg-x11-drv-nvidia-cuda
