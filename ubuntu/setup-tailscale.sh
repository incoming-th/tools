#!/bin/bash

echo "========================================"
echo "Tailscale Setup"
echo "========================================"
read -p "Enter your Tailscale auth key (or press Enter to skip): " auth_key  < /dev/tty

if [ -n "$auth_key" ]; then
    curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key="$auth_key"
else
    echo "Skipping Tailscale installation."
fi