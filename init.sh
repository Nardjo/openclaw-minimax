#!/bin/sh
# init.sh - Configure OpenClaw at startup for Coolify
# This script runs inside the container to set up MiniMax and Telegram bots

set -e

echo "🔧 Initializing OpenClaw..."

# Check required env vars
if [ -z "$MINIMAX_API_KEY" ]; then
    echo "❌ MINIMAX_API_KEY not set!"
    exit 1
fi

if [ -z "$OPENCLAW_GATEWAY_TOKEN" ]; then
    echo "❌ OPENCLAW_GATEWAY_TOKEN not set!"
    exit 1
fi

# Generate openclaw.json with proper config
cat > /home/node/.openclaw/openclaw.json << EOF
{
  "channels": {
    "telegram": {
      "enabled": true,
      "accounts": {},
      "dmPolicy": "allowlist",
      "allowFrom": []
    }
  },
  "models": {
    "mode": "replace",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimax.io/v1",
        "apiKey": "$MINIMAX_API_KEY",
        "api": "openai-completions",
        "models": [
          {
            "id": "MiniMax-M2.7",
            "name": "MiniMax-M2.7",
            "input": ["text"],
            "cost": {
              "input": 0.2,
              "output": 1.0
            }
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.7"
      }
    }
  }
}
EOF

echo "✅ MiniMax configured"

# Add Telegram bots if tokens are provided
for var in $(env | grep '^TELEGRAM_BOT_TOKEN_' | cut -d= -f1); do
    bot_name=$(echo "$var" | sed 's/TELEGRAM_BOT_TOKEN_//')
    token=$(eval echo "\$$var")
    
    if [ -n "$token" ] && [ "$token" != "token_${bot_name,,}" ] && [ "$token" != "token_bot_${bot_name,,}" ]; then
        echo "🤖 Adding Telegram bot: $bot_name"
        node dist/index.js channels add --channel telegram --account "$(echo "$bot_name" | tr '[:upper:]' '[:lower:]')" --token "$token" 2>/dev/null || true
    fi
done

# Setup admin allowlist if provided
if [ -n "$TELEGRAM_ADMIN_USER_ID" ]; then
    echo "👤 Setting up admin allowlist: $TELEGRAM_ADMIN_USER_ID"
    # This will be configured per-bot by the CLI above
fi

echo "🚀 Starting OpenClaw Gateway..."
exec node dist/index.js gateway --bind loopback --port 18789 --allow-unconfigured
