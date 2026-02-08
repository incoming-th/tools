#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install xfce4 xfce4-goodies -y
sudo apt install xrdp -y

echo xfce4-session > ~/.xsession
chmod 600 ~/.xsession

sudo systemctl enable xrdp
sudo systemctl restart xrdp

# Ask about password change (default Yes)
read -p "Do you want to change the Ubuntu user password? (Y/n): " change_pwd < /dev/tty

if [[ ! "$change_pwd" =~ ^[Nn]$ ]]; then
    echo "Enter new password for user 'ubuntu':"
    sudo passwd ubuntu < /dev/tty
else
    echo "Skipping password change."
fi

sudo systemctl status xrdp

echo "================"
echo "Setup completed."
echo "================"