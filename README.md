# 🚀 Self-Hosted AI Package (n8n + AI Docker Stack)

This is my self-hosted AI + automation stack, built entirely with **Docker Compose**.

It’s based on:

- The original [n8n Local AI Starter Kit](https://github.com/n8n-io)
- Extended by [Coleam’s Self-Hosted AI Package](https://github.com/coleam00/local-ai-packaged)
- Further improved here with **additional services, workflows, monitoring, and secure tunnels**

Unlike cloud-based AI platforms, this stack is **100% private and self-hosted**, giving you full control over data, models, and workflows.

---

## ✨ Features

- ✅ **n8n** – Low-code automation with 400+ integrations + AI nodes  
- ✅ **Supabase** – Database, auth, storage, APIs, vector support  
- ✅ **Ollama** – Run local LLMs (GPU/CPU)  
- ✅ **Open WebUI** – Chat with local models + n8n agents  
- ✅ **Flowise** – Visual AI pipeline builder  
- ✅ **Qdrant** – Vector DB optimized for RAG  
- ✅ **Neo4j + Graphiti** – Knowledge graph & visualization  
- ✅ **Langfuse** – LLM observability + tracing  
- ✅ **SearXNG** – Private metasearch engine  
- ✅ **ClickHouse** – Fast analytics  
- ✅ **Minio** – S3-compatible storage  
- ✅ **Cloudflared** – Secure remote access tunnels  
- ✅ **Portainer, Netdata, Dozzle, Watchtower** – Monitoring, logs, management  

---

## 📦 What’s Included

- `docker-compose.yml` + overrides (private/public profiles)  
- `start_services.py` → one command to start/stop all services  
- Profiles: `cpu`, `gpu-nvidia`, `gpu-amd`, `none` (external Ollama)  
- **Workflows**:  
  - Backup Tool → pushes workflows/credentials to GitHub  
  - Error Handler → AI-assisted error reporting  
  - Agentic RAG → Supabase + Ollama integration  

---

## 🔧 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)  
- Python 3.10+  
- Git  

---

## ⚡ Quick Start

Clone the repo:

```bash
git clone https://github.com/drgsldr691/My_N8N_Stack.git
cd My_N8N_Stack
```

Copy `.env.example` → `.env` and fill in your secrets:

```bash
cp .env.example .env
```

Start the stack (choose one):

```bash
# ▶️ Nvidia GPU
python start_services.py --profile gpu-nvidia
```

```bash
# ▶️ AMD GPU (Linux only)
python start_services.py --profile gpu-amd
```

```bash
# ▶️ CPU only
python start_services.py --profile cpu
```

```bash
# ▶️ External Ollama (Mac / Apple Silicon)
python start_services.py --profile none
```

---

## 🔑 Environment Setup

- Copy `.env.example` to `.env`  
- Replace placeholders (`changeme`, `your-token-here`) with real values  
- `.gitignore` prevents committing `.env`  
- See `.env.example` for required vars  

---

## 🌐 Service Access

| Service        | URL                       | Notes                          |
|----------------|---------------------------|--------------------------------|
| n8n            | http://localhost:5678     | Workflow automation            |
| Open WebUI     | http://localhost:3000     | Chat with local models         |
| Supabase       | http://localhost:54323    | Database UI (Studio)           |
| Langfuse       | http://localhost:3030     | LLM observability              |
| Portainer      | http://localhost:9101     | Container management           |
| Netdata        | http://localhost:3100     | Monitoring                     |
| Graphiti       | http://localhost:8090     | Graph visualization            |
| Neo4j          | http://localhost:7474     | Neo4j browser                  |
| Qdrant         | http://localhost:6333     | Vector DB API                  |
| SearXNG        | http://localhost:8080     | Meta search engine             |

---

## 🌐 Cloudflared Setup (Dashboard)

This stack uses Cloudflare Tunnels for **secure external access**.

1. Log in → [Cloudflare Dashboard](https://dash.cloudflare.com)  
2. Select your domain  
3. Go to **Zero Trust → Access → Tunnels**  
4. **Create a Tunnel** → choose **Docker** connector → copy token  
5. Add **public hostnames**:

| Service     | Subdomain               | URL inside stack       |
|-------------|--------------------------|------------------------|
| n8n         | n8n.yourdomain.com      | http://n8n:5678        |
| Supabase    | supabase.yourdomain.com | http://supabase-kong:8000 |
| Open WebUI  | webui.yourdomain.com    | http://open-webui:3000 |
| Langfuse    | langfuse.yourdomain.com | http://langfuse-web:3030 |
| Graphiti    | graphiti.yourdomain.com | http://graphiti:7474   |

6. Update `.env`:

```ini
##############################################
# Core / Networking
##############################################
# Cloudflare Tunnel (Zero Trust → Access → Tunnels → Docker token)
CLOUDFLARED_TOKEN=your-token-here

# Public hostnames you’ll create in Cloudflare → map to internal services
N8N_HOSTNAME=n8n.yourdomain.com
WEBUI_HOSTNAME=webui.yourdomain.com
LANGFUSE_HOSTNAME=langfuse.yourdomain.com
GRAPHITI_HOSTNAME=graphiti.yourdomain.com
GRAFANA_HOSTNAME=grafana.yourdomain.com
SEARXNG_HOSTNAME=search.yourdomain.com
# (Optional) Supabase if you expose it
SUPABASE_HOSTNAME=supabase.yourdomain.com

# Canonical external URLs (used by apps behind Cloudflare)
WEBHOOK_URL=https://n8n.yourdomain.com        # n8n webhook base
LANGFUSE_PUBLIC_URL=https://langfuse.yourdomain.com
MINIO_EXTERNAL_ENDPOINT=https://minio.yourdomain.com
GRAFANA_URL=https://grafana.yourdomain.com

##############################################
# n8n
##############################################
# IMPORTANT: generate strong secrets (32+ chars)
N8N_ENCRYPTION_KEY=changeme_super_secret_key
N8N_USER_MANAGEMENT_JWT_SECRET=changeme_jwt_secret
N8N_SECURE_COOKIE=false          # true if you terminate HTTPS at the app (not just CF)
N8N_PROTOCOL=https               # http for purely local dev

##############################################
# Postgres (shared by n8n/Langfuse/exporters)
##############################################
POSTGRES_VERSION=15
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_DB=postgres
POSTGRES_PASSWORD=changeme_pg

##############################################
# Redis / Valkey
##############################################
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=LOCALONLYREDIS
# Langfuse expects this name:
REDIS_AUTH=${REDIS_PASSWORD}

##############################################
# Neo4j (Graph DB)
##############################################
NEO4J_USER=neo4j
NEO4J_PASSWORD=changeme_neo4j

##############################################
# Graphiti (talks to Neo4j + LLMs)
##############################################
# For local LLMs via Ollama’s OpenAI-compatible endpoint
OPENAI_API_KEY=ollama                # placeholder; not used by Ollama but some libs require it
OPENAI_BASE_URL=http://ollama:11434/v1
OPENAI_MODEL=qwen2.5:14b-instruct
OPENAI_SMALL_MODEL=llama3.2:3b
OPENAI_EMBEDDING_MODEL=nomic-embed-text

##############################################
# Ollama (models pulled by init containers)
##############################################
# No secrets typically needed; models are configured in compose
# Example: qwen2.5:7b-instruct-q4_K_M, nomic-embed-text

##############################################
# Qdrant (Vector DB)
##############################################
# Using defaults in compose; add auth vars here if you enable them

##############################################
# ClickHouse (Langfuse analytics store)
##############################################
CLICKHOUSE_USER=clickhouse
CLICKHOUSE_PASSWORD=changeme_clickhouse
CLICKHOUSE_URL=http://clickhouse:8123
CLICKHOUSE_MIGRATION_URL=clickhouse://clickhouse:9000
CLICKHOUSE_CLUSTER_ENABLED=false

##############################################
# MinIO (S3-compatible storage for Langfuse events/media)
##############################################
MINIO_ROOT_USER=minio
MINIO_ROOT_PASSWORD=changeme_minio
LANGFUSE_S3_EVENT_UPLOAD_BUCKET=langfuse
LANGFUSE_S3_EVENT_UPLOAD_REGION=auto
LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID=minio
LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD}
LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT=http://minio:9100
LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE=true
LANGFUSE_S3_EVENT_UPLOAD_PREFIX=events/

LANGFUSE_S3_MEDIA_UPLOAD_BUCKET=langfuse
LANGFUSE_S3_MEDIA_UPLOAD_REGION=auto
LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID=minio
LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD}
LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT=http://minio:9100
LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE=true
LANGFUSE_S3_MEDIA_UPLOAD_PREFIX=media/

# Optional batch export
LANGFUSE_S3_BATCH_EXPORT_ENABLED=false
LANGFUSE_S3_BATCH_EXPORT_BUCKET=langfuse
LANGFUSE_S3_BATCH_EXPORT_PREFIX=exports/
LANGFUSE_S3_BATCH_EXPORT_REGION=auto
LANGFUSE_S3_BATCH_EXPORT_ENDPOINT=http://minio:9100
LANGFUSE_S3_BATCH_EXPORT_EXTERNAL_ENDPOINT=${MINIO_EXTERNAL_ENDPOINT}
LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID=minio
LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY=${MINIO_ROOT_PASSWORD}
LANGFUSE_S3_BATCH_EXPORT_FORCE_PATH_STYLE=true

##############################################
# Langfuse (app + worker)
##############################################
LANGFUSE_SALT=changeme_langfuse_salt
ENCRYPTION_KEY=changeme_langfuse_enc_key
TELEMETRY_ENABLED=true
NEXTAUTH_SECRET=changeme_nextauth

# (Optional) bootstrap values for first-run automation
LANGFUSE_INIT_ORG_ID=
LANGFUSE_INIT_ORG_NAME=
LANGFUSE_INIT_PROJECT_ID=
LANGFUSE_INIT_PROJECT_NAME=
LANGFUSE_INIT_PROJECT_PUBLIC_KEY=
LANGFUSE_INIT_PROJECT_SECRET_KEY=
LANGFUSE_INIT_USER_EMAIL=
LANGFUSE_INIT_USER_NAME=
LANGFUSE_INIT_USER_PASSWORD=

# Performance tuning (leave blank to use defaults)
LANGFUSE_INGESTION_QUEUE_DELAY_MS=
LANGFUSE_INGESTION_CLICKHOUSE_WRITE_INTERVAL_MS=

##############################################
# Grafana
##############################################
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=changeme_grafana
GF_SECURITY_ALLOW_EMBEDDING=true
GF_AUTH_ANONYMOUS_ENABLED=true
GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer
GF_SERVER_DOMAIN=${GRAFANA_HOSTNAME}
GF_SERVER_ROOT_URL=https://${GRAFANA_HOSTNAME}
GF_SERVER_SERVE_FROM_SUB_PATH=false
GF_SECURITY_COOKIE_SECURE=true
GF_SECURITY_COOKIE_SAMESITE=none

##############################################
# SearXNG
##############################################
SEARXNG_UWSGI_WORKERS=4
SEARXNG_UWSGI_THREADS=4
SEARXNG_BASE_URL=https://${SEARXNG_HOSTNAME}/

##############################################
# Flowise
##############################################
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=changeme_flowise

##############################################
# Open WebUI
##############################################
# (Typically no secrets required for local use)

##############################################
# Apache/PHP dashboard (WAPP)
##############################################
# Example: used by www/grafana_proxy.php (server-side env)
GRAFANA_SA_TOKEN=changeme_service_account_token

##############################################
# Prometheus / Exporters
##############################################
# Postgres exporter composes a DSN from these:
# DATA_SOURCE_NAME="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"

```

7. Start the stack:

```bash
python start_services.py --profile gpu-nvidia
```

---

## 🔄 Upgrading

```bash
# Stop everything
docker compose -p localai -f docker-compose.yml --profile gpu-nvidia down

# Pull latest images
docker compose -p localai -f docker-compose.yml --profile gpu-nvidia pull

# Restart
python start_services.py --profile gpu-nvidia
```

---

## 🛠️ Troubleshooting

### 1. Line Ending Issues (CRLF → LF)
On **Windows**, `.env` may revert to CRLF and break Supabase Pooler.  

Fix in VS Code:
- Open `.env`  
- Bottom-right → Change `CRLF` → `LF`  
- Save file  

Verify with Git:
```bash
git ls-files --eol | findstr ".env"
```
Should show `lf`, not `crlf`.

---

### 2. Supabase
- **Pooler keeps restarting** → ensure `.env` has `POOLER_DB_POOL_SIZE=5`  
- **Analytics container fails** → delete `supabase/docker/volumes/db/data` and restart  
- **Password issues** → avoid `@` and special chars in `POSTGRES_PASSWORD`  

---

### 3. SearXNG
If it keeps restarting:
```bash
chmod 755 searxng
```

---

### 4. Ollama GPU Issues
- **Windows** → enable WSL2 backend in Docker Desktop  
- **Linux** → follow Ollama GPU Docker setup  

---

### 5. Containers Not Found
Sometimes Supabase pulls badly. Delete the `supabase/` folder and rerun:

```bash
python start_services.py --profile gpu-nvidia
```

---

## 📊 Differences from Cole’s Version

- 🛠️ Extra monitoring: **Portainer, Netdata, Dozzle, Watchtower**  
- 🔐 Backup & Error Handling Workflows  
- 🌐 Cloudflared Tunnels for secure access  
- 📊 Graphiti + Neo4j integration  
- 📂 Synced `.env.example` with safe placeholders  
- ⚡ More opinionated defaults for local-first setup  

---

## 📜 License & Attribution

This project builds on the work of:

- [n8n Local AI Starter Kit](https://github.com/n8n-io)  
- [Self-Hosted AI Package by Coleam](https://github.com/coleam00/local-ai-packaged)  

Extended here with **additional services, workflows, monitoring, and improvements**.  
Licensed under the **Apache 2.0 License**.



