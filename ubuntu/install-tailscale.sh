#!/bin/bash

echo "========================================"
echo "Tailscale Installation"
echo "========================================"
read -sp "Enter your Tailscale auth key (or press Enter to skip): " auth_key  < /dev/tty
echo ""  # Newline after hidden input

if [ -n "$auth_key" ]; then
    curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key="$auth_key"
else
    echo "Skipping Tailscale installation."
fi