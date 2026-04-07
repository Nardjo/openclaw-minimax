# OpenClaw Multi-Agent - MiniMax Edition

Agents IA personnels via Telegram, propulsés par **MiniMax-M2.7**. Un seul Gateway, plusieurs bots, chacun avec sa propre personnalité et mémoire.

## 🎯 Objectif

Déployer facilement sur **Coolify** (ou Docker) avec :
- **Modèle AI** : MiniMax-M2.7 (via Coding Plan)
- **Multi-agents** : Autant de bots Telegram que nécessaire
- **Configuration zéro** : Les agents se configurent en conversation

## 🚀 Déploiement Rapide sur Coolify

### 1. Préparer les Secrets

```bash
# Clonez ce repo
git clone <votre-repo>
cd openclaw

# Copiez et éditez le .env
cp .env.example .env
```

Remplissez le `.env` :
```env
OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
MINIMAX_API_KEY=sk-cp-...  # Depuis https://platform.minimax.io/
TELEGRAM_BOT_TOKEN_GENERAL=123456:ABC...
TELEGRAM_BOT_TOKEN_TECH=123456:DEF...
TELEGRAM_BOT_TOKEN_COMMERCIAL=123456:GHI...
TELEGRAM_ADMIN_USER_ID=12345678  # Votre ID Telegram
```

### 2. Push sur GitHub

```bash
git add .
git commit -m "MiniMax multi-agent ready"
git push origin main
```

### 3. Déployer sur Coolify

1. **Coolify Dashboard** → Create New Resource
2. **Source** : GitHub → Sélectionnez ce repo
3. **Type** : Docker Compose (détecté automatiquement)
4. **Environment Variables** : Coolify importera votre `.env` ou vous pouvez les ajouter manuellement
5. **Deploy**

### 4. Configurer les Bots (Une fois déployé)

Connectez-vous au container et ajoutez les bots Telegram :

```bash
# Via Coolify Terminal ou SSH
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram \
  --account general \
  --token $TELEGRAM_BOT_TOKEN_GENERAL

# Répétez pour chaque bot...
```

Ou utilisez la commande interactive :
```bash
docker compose exec openclaw-gateway sh
node dist/index.js channels add --channel telegram --account <nom> --token <token>
```

### 5. Tester

Envoyez **"Bonjour"** à vos bots Telegram !
- L'agent va vous demander qui il est
- Décrivez sa personnalité
- Il écrit automatiquement son `SOUL.md`
- Commencez à discuter avec MiniMax-M2.7 !

## 📁 Structure du Projet

```
openclaw/
├── docker-compose.yaml      # Configuration Docker
├── .env.example            # Template des variables
├── config/
│   └── openclaw.json       # Config par défaut (MiniMax)
├── init.sh                 # Script d'initialisation (optionnel)
└── README.md               # Ce fichier
```

## 🔧 Configuration

### Variables d'Environnement Requises

| Variable | Source | Description |
|----------|--------|-------------|
| `OPENCLAW_GATEWAY_TOKEN` | `openssl rand -hex 32` | Token de sécurité interne |
| `MINIMAX_API_KEY` | [platform.minimax.io](https://platform.minimax.io/) | Clé API MiniMax Token Plan |
| `TELEGRAM_BOT_TOKEN_*` | @BotFather | Tokens des bots Telegram |
| `TELEGRAM_ADMIN_USER_ID` | @userinfobot | Votre ID Telegram (optionnel) |

### Ajouter un Nouvel Agent

1. **Créez un bot** via @BotFather sur Telegram
2. **Ajoutez la variable** dans Coolify : `TELEGRAM_BOT_TOKEN_NEWAGENT=token`
3. **Redéployez** le service
4. **Ajoutez le channel** via CLI :
   ```bash
   docker compose exec openclaw-gateway node dist/index.js channels add \
     --channel telegram --account newagent --token <token>
   ```
5. **Parlez au bot** pour le configurer !

## 🧠 Comment ça Marche

1. **Démarrage** : OpenClaw lit `config/openclaw.json` avec MiniMax préconfiguré
2. **Connexion** : Les bots Telegram se connectent via les tokens
3. **Conversation** : Chaque agent maintient son propre contexte
4. **Mémoire** : Sauvegardée dans le volume `workspaces`
5. **Persistance** : Les volumes Docker sont persistants entre redémarrages

## 🛠️ Commandes Utiles

```bash
# Voir les logs
docker compose logs -f

# Liste des channels configurés
docker compose exec openclaw-gateway node dist/index.js channels list

# Redémarrer
docker compose restart

# Backup
docker compose exec openclaw-gateway tar czf - /home/node/.openclaw > backup.tar.gz
```

## 🔒 Sécurité

- **Ne commitez jamais** votre `.env` avec les vraies clés
- **`.env.example`** est safe à commit (valeurs placeholder)
- **MINIMAX_API_KEY** reste dans les variables d'environnement Coolify
- **Volumes** : Les données sont persistées mais non versionnées

## 📚 Documentation

- [OpenClaw Docs](https://docs.openclaw.ai)
- [MiniMax Platform](https://platform.minimax.io/)
- [Coolify Docs](https://coolify.io/docs)

## 🐛 Dépannage

**Les bots ne répondent pas :**
1. Vérifiez les logs : `docker compose logs`
2. Vérifiez les tokens Telegram dans Coolify
3. Assurez-vous que les channels sont ajoutés : `docker compose exec openclaw-gateway node dist/index.js channels list`

**Erreur "No API key found" :**
- La clé MiniMax doit être configurée. Vérifiez que `MINIMAX_API_KEY` est bien dans les env vars.

**Conflit Telegram (409) :**
- Un autre process utilise les bots. Redémarrez le container : `docker compose restart`

---

**✨ Vos agents MiniMax sont prêts !**
