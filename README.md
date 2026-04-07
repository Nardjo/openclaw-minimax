# OpenClaw — Multi-Agent Telegram Gateway

Agents IA personnels via Telegram, tous dans un seul Gateway avec multi-agent routing. Chaque bot a son propre workspace et sa propre memoire. Propulse par [OpenClaw](https://openclaw.ai/).

## Architecture

```
Telegram
  ├── @Raccoon33Bot       → agent "general"
  ├── @Raccoon33DevBot    → agent "tech"
  └── @Raccoon33SocialBot → agent "social"
         │
         ▼
   Single Gateway (port 18789)
   Multi-agent routing via bindings
```

Un seul process Gateway route les messages vers le bon agent selon le bot Telegram utilise.
Chaque agent a son propre `SOUL.md`, `AGENTS.md` et `MEMORY.md` — isole par defaut.

## Prerequisites

- Docker + Docker Compose
- Tailscale account + auth key
- 3 bot tokens Telegram (via [@BotFather](https://t.me/BotFather))
- Anthropic API key

## Setup

### 1. Clone et configuration

```bash
git clone git@github.com:Nardjo/openclaw.git
cd openclaw
cp .env.example .env
```

### 2. Creer les bots Telegram

Via [@BotFather](https://t.me/BotFather), creer 3 bots :
1. Un bot "General" → `TELEGRAM_BOT_TOKEN_GENERAL`
2. Un bot "Tech" → `TELEGRAM_BOT_TOKEN_TECH`
3. Un bot "Social" → `TELEGRAM_BOT_TOKEN_SOCIAL`

### 3. Configurer `.env`

```bash
# Generer le gateway token
openssl rand -hex 32  # → OPENCLAW_GATEWAY_TOKEN
```

Remplir toutes les variables dans `.env`.

### 4. Lancer

```bash
docker compose up -d
```

### 5. Utiliser

Envoyer un message a chaque bot dans Telegram. Chaque conversation est isolee avec sa propre memoire.

## Agents

| Agent | Bot Telegram | Workspace | Description |
|-------|-------------|-----------|-------------|
| general | @Raccoon33Bot | `workspace/general/` | Assistant polyvalent |
| tech | @Raccoon33DevBot | `workspace/tech/` | Dev / code / architecture |
| social | @Raccoon33SocialBot | `workspace/social/` | Social media / contenu |

## Ajouter un agent

1. Creer un bot via @BotFather
2. Ajouter `TELEGRAM_BOT_TOKEN_<NAME>` dans `.env`
3. Creer `workspace/<name>/SOUL.md`
4. Ajouter l'agent dans `config/openclaw.json` : agents.list, bindings, et channels.telegram.accounts

## Structure

```
openclaw/
├── docker-compose.yaml
├── serve.json
├── .env.example
├── config/
│   └── openclaw.json          # Config unifiee multi-agent
└── workspace/
    ├── general/SOUL.md
    ├── tech/SOUL.md
    └── social/SOUL.md
```

## 🚀 Déploiement Coolify (Nouveau)

Pour un déploiement simple sur Coolify avec **un seul fichier**:

### Fichiers nécessaires

```
.
├── docker-compose.yaml    # Service unique avec volumes
└── .env                   # Vos tokens (à créer depuis .env.example)
```

### Déploiement

1. **Créez le `.env`** depuis le template:
   ```bash
   cp .env.example .env
   # Éditez avec vos tokens
   ```

2. **Poussez sur GitHub**:
   ```bash
   git add docker-compose.yaml .env.example README.md
   git commit -m "Coolify ready"
   git push origin main
   ```

3. **Dans Coolify**:
   - New Service → GitHub Repository
   - Sélectionnez ce repo
   - Coolify détecte automatiquement le docker-compose.yaml
   - Remplissez les variables d'environnement dans l'UI
   - Déployez

### Configuration Coolify

Variables requises dans l'interface Coolify:

| Variable | Description | Exemple |
|----------|-------------|---------|
| `OPENCLAW_GATEWAY_TOKEN` | Token sécurisé | `openssl rand -hex 32` |
| `OPENROUTER_API_KEY` | Clé API OpenRouter | `sk-or-v1-...` |
| `TELEGRAM_BOT_TOKEN_*` | Tokens des bots | `123456:ABC...` |

### Ajouter un agent

1. Créez un bot via @BotFather
2. Ajoutez dans Coolify: `TELEGRAM_BOT_TOKEN_NOUVEAUNOM=token`
3. Redéployez

L'agent démarre vide et se configure via conversation avec vous!

### Persistance Coolify

Les volumes nommés (`config`, `workspaces`) sont persistants.
Pour sauvegarder:
```bash
docker exec <container> tar czf - /home/node/.openclaw > backup.tar.gz
```
