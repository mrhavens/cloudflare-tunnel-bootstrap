#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ─────────────────────────────────────────────────────────────
# SSH Server Bootstrap Script for Remote Access via Tunnel
# ─────────────────────────────────────────────────────────────

echo "🔐 Installing OpenSSH server..."

sudo apt update
sudo apt install -y openssh-server

echo "🛠 Configuring SSH..."

# Ensure sshd_config exists
SSHD_CONFIG="/etc/ssh/sshd_config"

# Enable password and public key auth
sudo sed -i 's/#*PasswordAuthentication .*/PasswordAuthentication yes/' "$SSHD_CONFIG"
sudo sed -i 's/#*PermitRootLogin .*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
sudo sed -i 's/#*PubkeyAuthentication .*/PubkeyAuthentication yes/' "$SSHD_CONFIG"

# Optional: restrict to certain users (e.g., "mrhavens")
# echo "AllowUsers mrhavens" | sudo tee -a "$SSHD_CONFIG"

echo "🔁 Restarting SSH service..."
sudo systemctl restart ssh
sudo systemctl enable ssh

echo "✅ SSH server is installed and listening on port 22"
echo "🌐 You may now access this machine via your tunnel:"
echo "    ssh user@ssh.samson.thefoldwithin.earth"
