#!/bin/bash

echo "========================================"
echo "Tailscale Installation"
echo "========================================"
read -sp "Enter your Tailscale auth key (or press Enter to skip): " auth_key  < /dev/tty
echo ""  # Newline after hidden input
read -p "Enable Tailscale SSH (you will lose SSH access if you do)? (y/N): " enable_ssh < /dev/tty
read -p "Advertise this machine as an exit node? (y/N): " enable_exit < /dev/tty

TS_FLAGS=""

if [[ "$enable_ssh" =~ ^[Yy]$ ]]; then
    TS_FLAGS="$TS_FLAGS --ssh --accept-risk=lose-ssh"
fi

if [[ "$enable_exit" =~ ^[Yy]$ ]]; then
    TS_FLAGS="$TS_FLAGS --advertise-exit-node"

    if [ -d /etc/sysctl.d ]; then
        SYSCTL_FILE="/etc/sysctl.d/99-tailscale.conf"
    else
        SYSCTL_FILE="/etc/sysctl.conf"
    fi

    sudo touch "$SYSCTL_FILE"

    grep -q '^net.ipv4.ip_forward *= *1' "$SYSCTL_FILE" || \
        echo 'net.ipv4.ip_forward = 1' | sudo tee -a "$SYSCTL_FILE"

    grep -q '^net.ipv6.conf.all.forwarding *= *1' "$SYSCTL_FILE" || \
        echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a "$SYSCTL_FILE"

    sudo sysctl -p "$SYSCTL_FILE"
fi

# Auth key provided: initial login
if [ -n "$auth_key" ]; then
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up --auth-key="$auth_key" $TS_FLAGS

# No auth key: update existing config
else
    if [ -z "$TS_FLAGS" ]; then
        echo "Skipping Tailscale installation."
    else
        sudo tailscale set $TS_FLAGS
    fi
fi