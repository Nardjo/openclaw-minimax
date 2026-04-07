# Commandes Post-Déploiement Coolify

## 🚀 Une Commande pour Tout Configurer

Dans le terminal Coolify, exécutez simplement :

```bash
bash post-deploy.sh
```

---

## 🔧 Commandes Individuelles (Si besoin de contrôle)

### Étape 1 : Ajouter les Bots Telegram

**Bot General :**
```bash
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account general --token "$TELEGRAM_BOT_TOKEN_GENERAL"
```

**Bot Tech :**
```bash
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account tech --token "$TELEGRAM_BOT_TOKEN_TECH"
```

**Bot Commercial :**
```bash
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --account commercial --token "$TELEGRAM_BOT_TOKEN_COMMERCIAL"
```

### Étape 2 : Configurer l'Admin (Optionnel mais recommandé)

```bash
# General
docker compose exec openclaw-gateway node dist/index.js config set \
  --path channels.telegram.accounts.general.allowFrom \
  --value '["'$TELEGRAM_ADMIN_USER_ID'"]'

# Tech
docker compose exec openclaw-gateway node dist/index.js config set \
  --path channels.telegram.accounts.tech.allowFrom \
  --value '["'$TELEGRAM_ADMIN_USER_ID'"]'

# Commercial
docker compose exec openclaw-gateway node dist/index.js config set \
  --path channels.telegram.accounts.commercial.allowFrom \
  --value '["'$TELEGRAM_ADMIN_USER_ID'"]'
```

### Étape 3 : Redémarrer

```bash
docker compose restart
```

### Étape 4 : Vérifier

```bash
docker compose exec openclaw-gateway node dist/index.js channels list
```

---

## 🧪 Test

Envoyez **"Bonjour"** à chaque bot sur Telegram :

- **General** → Répond et lance le bootstrap
- **Tech** → Vous demande sa personnalité
- **Commercial** → Se configure via conversation

---

## 🆘 Dépannage

**Erreur "command not found" :**
- Vérifiez que vous êtes dans le bon répertoire
- Essayez : `cd /path/to/your/project`

**Erreur "No such container" :**
- Le container n'est pas encore démarré
- Attendez 30s après le déploiement

**Erreur "token invalide" :**
- Vérifiez que les variables d'env sont bien définies dans Coolify
- Redéployez si vous avez modifié les env vars

---

## 📚 Commandes Utiles

**Voir les logs :**
```bash
docker compose logs -f
```

**Vérifier le statut :**
```bash
docker compose ps
```

**Redémarrer complètement :**
```bash
docker compose down && docker compose up -d
```

**Backup des données :**
```bash
docker compose exec openclaw-gateway tar czf - /home/node/.openclaw > backup-$(date +%Y%m%d).tar.gz
```
