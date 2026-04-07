#!/bin/bash
# post-deploy.sh - Script de post-déploiement pour Coolify
# À exécuter dans le terminal Coolify après le premier déploiement

set -e

echo "🔧 Configuration des Bots Telegram..."
echo ""

# 1. Ajouter les bots
echo "1️⃣ Ajout du bot General..."
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account general --token "$TELEGRAM_BOT_TOKEN_GENERAL"

echo ""
echo "2️⃣ Ajout du bot Tech..."
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account tech --token "$TELEGRAM_BOT_TOKEN_TECH"

echo ""
echo "3️⃣ Ajout du bot Commercial..."
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account commercial --token "$TELEGRAM_BOT_TOKEN_COMMERCIAL"

echo ""
echo "4️⃣ Configuration de l'admin..."
if [ -n "$TELEGRAM_ADMIN_USER_ID" ]; then
    docker compose exec openclaw-gateway node dist/index.js config set \
      --path channels.telegram.accounts.general.allowFrom \
      --value "[\"$TELEGRAM_ADMIN_USER_ID\"]"
    
    docker compose exec openclaw-gateway node dist/index.js config set \
      --path channels.telegram.accounts.tech.allowFrom \
      --value "[\"$TELEGRAM_ADMIN_USER_ID\"]"
    
    docker compose exec openclaw-gateway node dist/index.js config set \
      --path channels.telegram.accounts.commercial.allowFrom \
      --value "[\"$TELEGRAM_ADMIN_USER_ID\"]"
fi

echo ""
echo "5️⃣ Redémarrage..."
docker compose restart

echo ""
echo "✅ Configuration terminée !"
echo ""
echo "🤖 Bots configurés :"
docker compose exec openclaw-gateway node dist/index.js channels list
echo ""
echo "📝 Prochaine étape : Envoyez 'Bonjour' à vos bots sur Telegram !"
