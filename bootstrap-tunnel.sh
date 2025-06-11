#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# Cloudflare Tunnel Bootstrap Script
# Usage: ./bootstrap-tunnel.sh <tunnel_name> <base_domain> <local_port>
# Example: ./bootstrap-tunnel.sh samson thefoldwithin.earth 8000
# ──────────────────────────────────────────────────────────────

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <tunnel_name> <base_domain> <local_port>"
  exit 1
fi

TUNNEL_NAME="$1"
BASE_DOMAIN="$2"
LOCAL_PORT="$3"
USER_HOME=$(eval echo ~"$USER")
CLOUDFLARED_DIR="$USER_HOME/.cloudflared"

# Path to tunnel credentials (auto-created if tunnel exists)
TUNNEL_ID=$(cloudflared tunnel list | grep "$TUNNEL_NAME" | awk '{print $1}')
if [[ -z "$TUNNEL_ID" ]]; then
  echo "❌ Tunnel '$TUNNEL_NAME' not found. Please run: cloudflared tunnel create $TUNNEL_NAME"
  exit 1
fi

CREDENTIALS_FILE="$CLOUDFLARED_DIR/${TUNNEL_ID}.json"
CONFIG_PATH="$CLOUDFLARED_DIR/config.yml"

echo "🧪 Tunnel ID: $TUNNEL_ID"
echo "📜 Writing config to $CONFIG_PATH"

cat > "$CONFIG_PATH" <<EOF
tunnel: $TUNNEL_ID
credentials-file: $CREDENTIALS_FILE

ingress:
  - hostname: $TUNNEL_NAME.$BASE_DOMAIN
    service: http://localhost:$LOCAL_PORT

  - hostname: ssh.$TUNNEL_NAME.$BASE_DOMAIN
    service: ssh://localhost:22

  - hostname: rpc.$TUNNEL_NAME.$BASE_DOMAIN
    service: http://localhost:8545

  - service: http_status:404
EOF

echo "🔁 Creating DNS routes..."
cloudflared tunnel route dns "$TUNNEL_NAME" "$TUNNEL_NAME.$BASE_DOMAIN"
cloudflared tunnel route dns "$TUNNEL_NAME" "ssh.$TUNNEL_NAME.$BASE_DOMAIN"
cloudflared tunnel route dns "$TUNNEL_NAME" "rpc.$TUNNEL_NAME.$BASE_DOMAIN"

echo "🚀 Restarting cloudflared service..."
sudo systemctl restart cloudflared

echo "✅ Tunnel bootstrap complete!"
echo "🌐 Access: https://$TUNNEL_NAME.$BASE_DOMAIN"
echo "🔗 SSH:   ssh.$TUNNEL_NAME.$BASE_DOMAIN"
echo "🔗 RPC:   rpc.$TUNNEL_NAME.$BASE_DOMAIN"
