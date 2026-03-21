#!/bin/bash
# Step 3: Build the NVIDIA kernel module and verify
sudo akmods --force
echo "Checking module version..."
modinfo -F version nvidia
echo ""
echo "If a version number was printed above, you can proceed to step 4."
echo "If not, wait a few minutes and run this script again."
