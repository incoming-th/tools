#!/bin/bash

echo "========================================"
echo "qBittorrent Installation"
echo "========================================"
read -p "Do you want to install qBittorrent? (Y/n): " install_qbit < /dev/tty

if [[ ! "$install_qbit" =~ ^[Nn]$ ]]; then
    sudo apt install qbittorrent -y
else
    echo "Skipping qBittorrent installation."
fi