#!/bin/bash

echo "========================================"
echo "Password Change"
echo "========================================"
read -p "Do you want to change the Ubuntu user password? (Y/n): " change_pwd < /dev/tty

if [[ ! "$change_pwd" =~ ^[Nn]$ ]]; then
    sudo passwd ubuntu < /dev/tty
else
    echo "Skipping password change."
fi