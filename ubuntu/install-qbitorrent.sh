#!/bin/bash

set -e

echo "========================================"
echo "qBittorrent Installation"
echo "========================================"

read -p "Do you want to install qBittorrent? (Y/n): " install_qbit < /dev/tty
install_qbit="${install_qbit:-Y}"
install_qbit="${install_qbit^^}"

if [[ "$install_qbit" == 'Y' ]]; then
    sudo apt update
    sudo apt install -y qbittorrent
else
    echo "Skipping qBittorrent installation."
fi

echo "========================================"
echo "End of qBittorrent Installation"
echo "========================================"