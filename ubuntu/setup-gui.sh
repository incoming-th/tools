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

# Prompt for password change
echo "========================================"
read -p "Do you want to change the Ubuntu user password? (Y/n): " change_pwd < /dev/tty

if [[ ! "$change_pwd" =~ ^[Nn]$ ]]; then
    sudo passwd ubuntu < /dev/tty
else
    echo "Skipping password change."
fi
echo "========================================"

# Show status of xrdp
sudo systemctl status xrdp

echo "================"
echo "Setup completed."
echo "================"