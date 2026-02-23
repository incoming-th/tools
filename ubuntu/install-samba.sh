#!/bin/bash

set -e

SMB_CONF="/etc/samba/smb.conf"
TMP_CONF="$(mktemp)"
CURRENT_USER="${SUDO_USER:-$USER}"
USER_HOME="$(getent passwd "$CURRENT_USER" | awk -F: '{print $6}')"
TAILSCALE_CONFIG=""

echo "========================================"
echo "Samba Installation"
echo "========================================"
read -p "Samba username (default: samba): " smb_username < /dev/tty
smb_username="${smb_username:-samba}"
# Ask for password
while true; do
    read -rsp "Samba password (cannot be empty): " smb_password < /dev/tty
    echo # Newline after hidden input

    # Trim whitespace
    smb_password="${smb_password#"${smb_password%%[![:space:]]*}"}"
    smb_password="${smb_password%"${smb_password##*[![:space:]]}"}"

    [[ -n "$smb_password" ]] && break

    echo "[ERROR] Password cannot be empty."
done
# Ask for folder
while true; do
    read -p "Enter folder to share (leave empty to keep current setting): " share_folder < /dev/tty

    # Trim whitespace
    share_folder="${share_folder#"${share_folder%%[![:space:]]*}"}"
    share_folder="${share_folder%"${share_folder##*[![:space:]]}"}"

    # If empty try to reuse existing share
    if [[ -z "$share_folder" ]]; then
        if sudo test -f "$SMB_CONF"; then
            share_folder="$(sudo awk -F'=' '/^\s*path\s*=/{print $2; exit}' "$SMB_CONF")"
        fi

        if [[ -z "$share_folder" ]]; then
            echo "[ERROR] No existing Samba share folder found."
            continue
        fi

        break
    fi

    # Remove leading slashes (force relative path)
    share_folder="${share_folder##/}"

    # Reject dangerous patterns
    if [[ "$share_folder" == *"~"* || "$share_folder" == *".."* || "$share_folder" == "." ]]; then
        echo "[ERROR] '~', '..', and '.' are not allowed"
        continue
    fi

    # Allow only safe characters
    if [[ ! "$share_folder" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        echo "[ERROR] Only letters, numbers, / _ - are allowed"
        continue
    fi

    # Create folder (safe if exists)
    share_folder="$USER_HOME/$share_folder"
    mkdir -p "$share_folder"
    sudo chown -R "$CURRENT_USER":"$CURRENT_USER" "$share_folder"
    chmod 755 "$share_folder"

    break
done
# Ask for Tailscale
read -p "Allow only for Tailscale network? (Y/n): " enable_tailscale < /dev/tty
enable_tailscale="${enable_tailscale:-Y}"
enable_tailscale="${enable_tailscale^^}"

# Install Samba if not available
if ! command -v smbd >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y samba
fi

# Create Samba user if not available
if ! id "$smb_username" >/dev/null 2>&1; then
    sudo useradd -M -s /usr/sbin/nologin "$smb_username"
fi

# Set Samba password (always update)
printf '%s\n%s\n' "$smb_password" "$smb_password" | sudo smbpasswd -s -a "$smb_username"
sudo smbpasswd -e "$smb_username"

# Build optional Tailscale restriction
if [[ "$enable_tailscale" == "Y" ]]; then
    TAILSCALE_CONFIG="bind interfaces only = no
   hosts allow = 100.64.0.0/10 127.0.0.1
   hosts deny = 0.0.0.0/0"
fi

# Generate Samba config
# https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#HOSTSALLOW
NEW_SMB_CONF=$(cat <<EOF
[global]
   workgroup = WORKGROUP
   server string = Samba Server
   security = user
   map to guest = bad user
   $TAILSCALE_CONFIG

[$smb_username]
   path = $share_folder
   browseable = yes
   writable = yes
   read only = no
   valid users = $smb_username
   force user = $CURRENT_USER
   force group = $CURRENT_USER
   create mask = 0755
   directory mask = 0755
EOF
)

# Write config in temp file
echo "$NEW_SMB_CONF" > "$TMP_CONF"

# Validate temp config
if ! sudo testparm -s "$TMP_CONF" >/dev/null 2>&1; then
    echo "[ERROR] Invalid Samba configuration."
    exit 1
fi

# Move the temp config to be used
sudo mv "$TMP_CONF" "$SMB_CONF"

# Restart Samba
sudo systemctl restart smbd
sudo systemctl enable smbd

# Cleanup temp files
trap 'sudo rm -f "$TMP_CONF"' EXIT

echo "========================================"
echo "End of Samba Installation"
echo "========================================"