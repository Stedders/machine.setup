#!/bin/bash
# Enable NumLock on the SDDM login screen.
# Writes an SDDM config drop-in so numpad is active at the greeter.

set -euo pipefail

CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="$CONF_DIR/numlock.conf"

echo "Creating $CONF_FILE to enable NumLock on login..."

sudo mkdir -p "$CONF_DIR"
sudo tee "$CONF_FILE" > /dev/null <<'EOF'
[General]
Numlock=on
EOF

echo "Done. NumLock will be enabled on the next login screen."
