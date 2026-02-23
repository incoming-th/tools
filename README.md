# Tools

Collection of scripts for automation of common tasks.

Most of the scripts will require elevated privileges or sudo access. **Always** review the codes before running them.

## Ubuntu

### Setup GUI

Install a GUI environment on a fresh Ubuntu installation.

```bash
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/install-gui.sh | bash
```

### Change Password

Change the password of the default user on an Ubuntu server.

```bash
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/change-password.sh | bash
```

### qBittorrent Installation

Install qBittorrent on an Ubuntu server.

```bash
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/install-qbitorrent.sh | bash
```

### Samba Installation

Install Samba on an Ubuntu server (Tailscale supported).

```bash
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/install-samba.sh | bash
```

If Windows complains about existing login, run:

```bash
net use * /delete
```

### Tailscale Installation

Install Tailscale on an Ubuntu server.

```bash
curl -sSL https://raw.githubusercontent.com/incoming-th/tools/main/ubuntu/install-tailscale.sh | bash
```