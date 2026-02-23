#!/bin/bash

set -e

echo "========================================"
echo "Password Change"
echo "========================================"

read -p "Do you want to change the Ubuntu user password? (Y/n): " change_pwd < /dev/tty
change_pwd="${change_pwd:-Y}"
change_pwd="${change_pwd^^}"

if [[ "$change_pwd" == 'Y' ]]; then
    sudo passwd ubuntu < /dev/tty
else
    echo "Skipping password change."
fi

echo "========================================"
echo "End Of Password Change"
echo "========================================"