#!/bin/bash

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install GUI environment
sudo apt install xfce4 xfce4-goodies -y

# Install xrdp
sudo apt install xrdp -y
echo xfce4-session > ~/.xsession
chmod 600 ~/.xsession
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# Call password change script from GitHub
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/change-password.sh | bash

# Call Tailscale setup script from GitHub
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/setup-tailscale.sh | bash

# Show status of xrdp
sudo systemctl status xrdp

echo "================"
echo "Setup completed."
echo "================"