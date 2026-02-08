#!/bin/bash

echo "========================================"
echo "qBittorrent Installation"
echo "========================================"
read -p "Do you want to install qBittorrent? (Y/n): " install_qbit < /dev/tty

if [[ ! "$install_qbit" =~ ^[Nn]$ ]]; then
    sudo apt install qbittorrent -y
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/qbittorrent.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=qbittorrent
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=qBittorrent
Comment=Start qBittorrent on login
EOF
else
    echo "Skipping qBittorrent installation."
fi