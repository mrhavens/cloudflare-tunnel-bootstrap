#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ─────────────────────────────────────────────────────────────
# 🌐 Cloudflare Tunnel Binary Installer
# Installs the latest cloudflared (Linux x86_64)
# Cleans up any legacy APT sources
# ─────────────────────────────────────────────────────────────

CLOUDFLARED_BIN="/usr/local/bin/cloudflared"
RELEASE_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"

echo "🧹 Cleaning up legacy Cloudflare APT sources (if any)..."
LEGACY_LIST="/etc/apt/sources.list.d/cloudflared.list"
if [[ -f "$LEGACY_LIST" ]]; then
    echo "⚠️  Found legacy APT source: $LEGACY_LIST"
    sudo rm -f "$LEGACY_LIST"
    sudo apt update
    echo "✅ Removed deprecated source and updated package list."
fi

echo "🔍 Checking for existing cloudflared installation..."
if command -v cloudflared >/dev/null 2>&1; then
    echo "✅ cloudflared already installed at: $(which cloudflared)"
    echo "🔁 To reinstall, run: sudo rm $(which cloudflared) && ./install-cloudflared.sh"
    exit 0
fi

echo "⬇️  Downloading latest cloudflared binary..."
wget -q --show-progress "$RELEASE_URL" -O cloudflared

echo "🔐 Making binary executable..."
chmod +x cloudflared

echo "🚚 Moving to /usr/local/bin (requires sudo)..."
sudo mv cloudflared "$CLOUDFLARED_BIN"

echo "✅ cloudflared installed at $CLOUDFLARED_BIN"
cloudflared --version
