# Self-Hosted AI Package (n8n + AI Docker Stack)

This is my self-hosted AI + automation stack, built entirely with **Docker Compose**.

It’s based on:

* The original [n8n Local AI Starter Kit](https://github.com/n8n-io)
* Extended by [Coleam’s Self-Hosted AI Package](https://github.com/coleam00/local-ai-packaged)
* Further improved here with **additional services, workflows, monitoring, and secure tunnels**

Unlike cloud-based AI platforms, this stack is **100% private and self-hosted**, giving you full control over data, models, and workflows.
Join the community & get the latest workflow bundles:
Skool: https://www.skool.com/n8n-automation-community-2619
Repo: https://github.com/drgsldr691/My_N8N_Stack
---

## ✨ Features

* ✅ **n8n** – Low-code automation with 400+ integrations + AI nodes
* ✅ **Supabase** – Database, auth, storage, APIs, vector support
* ✅ **Ollama** – Run local LLMs (GPU/CPU)
* ✅ **Open WebUI** – Chat with local models + n8n agents
* ✅ **Flowise** – Visual AI pipeline builder
* ✅ **Qdrant** – Vector DB optimized for RAG
* ✅ **Neo4j + Graphiti** – Knowledge graph & visualization
* ✅ **Langfuse** – LLM observability + tracing
* ✅ **SearXNG** – Private metasearch engine
* ✅ **ClickHouse** – Fast analytics
* ✅ **MinIO** – S3-compatible storage
* ✅ **Cloudflared** – Secure remote access tunnels
* ✅ **Portainer, Netdata, Dozzle, Watchtower** – Monitoring, logs, management
* ✅ **WAPP** – Web server/proxy tuned for n8n; combined with Cloudflared it’s reachable anywhere
* ✅ **Prometheus + Grafana** – Metrics collection and dashboards

> **Note:** Any references to **ComfyUI** are intentionally **omitted** until that component is production-ready.

---

## 📦 What’s Included

* `docker-compose.yml` + overrides (private/public profiles)
* `start_services.py` → one command to start/stop all services
* Profiles: `cpu`, `gpu-nvidia`, `gpu-amd`, `none` (external Ollama)
* **Workflows** (examples; newest packs are posted in Skool):

  * Backup Tool → pushes workflows/credentials to GitHub
  * Error Handler → AI-assisted error reporting
  * Agentic RAG → Supabase + Ollama integration
  * System Health → Telegram alerts (Prometheus → Telegram)
  * Workforce Overtime Alerts → SQL → plain-text notifications
  * Receipt Parser (Receipts → Sheets) → strict JSON with safe date defaults

**Latest workflows & community:**
[https://www.skool.com/n8n-automation-community-2619](https://www.skool.com/n8n-automation-community-2619)

---

## 🔧 Prerequisites

* [Docker](https://docs.docker.com/get-docker/)
* Python 3.10+
* Git

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

Stop everything:

```bash
python start_services.py --down
```

---

## 🔑 Environment Setup

* Copy `.env.example` to `.env`
* Replace placeholders (`changeme`, `your-token-here`) with real values
* `.gitignore` prevents committing `.env`
* See `.env.example` for required vars

Minimal keys you’ll likely set:

```ini
# Cloudflared
CLOUDFLARED_TOKEN=your-token-here

# Optional public hostnames
N8N_HOSTNAME=n8n.yourdomain.com
SUPABASE_HOSTNAME=supabase.yourdomain.com
WEBUI_HOSTNAME=webui.yourdomain.com
LANGFUSE_HOSTNAME=langfuse.yourdomain.com
GRAPHITI_HOSTNAME=graphiti.yourdomain.com
GRAFANA_HOSTNAME=grafana.yourdomain.com
PROMETHEUS_HOSTNAME=prometheus.yourdomain.com

# Database / auth
POSTGRES_PASSWORD=changeme-strong
JWT_SECRET=changeme-long-random
SUPABASE_ANON_KEY=changeme
SUPABASE_SERVICE_ROLE_KEY=changeme
```

> **Windows:** Ensure `.env` uses **LF** line endings (see Troubleshooting).

---

## 🌐 Service Access

| Service             | URL                                              | Notes                                 |
| ------------------- | ------------------------------------------------ | ------------------------------------- |
| **n8n**             | [http://localhost:5678](http://localhost:5678)   | Workflow automation                   |
| **Open WebUI**      | [http://localhost:3000](http://localhost:3000)   | Chat with local models                |
| **Supabase Studio** | [http://localhost:54323](http://localhost:54323) | Database UI (Postgres under the hood) |
| **Langfuse**        | [http://localhost:3030](http://localhost:3030)   | LLM observability                     |
| **Portainer**       | [http://localhost:9101](http://localhost:9101)   | Container management                  |
| **Netdata**         | [http://localhost:3100](http://localhost:3100)   | Monitoring                            |
| **Graphiti**        | [http://localhost:8090](http://localhost:8090)   | Graph visualization                   |
| **Neo4j**           | [http://localhost:7474](http://localhost:7474)   | Neo4j browser                         |
| **Qdrant**          | [http://localhost:6333](http://localhost:6333)   | Vector DB API                         |
| **SearXNG**         | [http://localhost:8080](http://localhost:8080)   | Meta search engine                    |
| **MinIO API**       | [http://localhost:9000](http://localhost:9000)   | S3 API                                |
| **MinIO Console**   | [http://localhost:9001](http://localhost:9001)   | UI                                    |
| **Prometheus**      | [http://localhost:9090](http://localhost:9090)   | Metrics                               |
| **Grafana**         | [http://localhost:3001](http://localhost:3001)   | Dashboards (*verify port in compose*) |
| **Dozzle**          | [http://localhost:8888](http://localhost:8888)   | Live container logs                   |

> Ports may differ if you customize `docker-compose.yml`; the compose file is the source of truth.

---

## 🌐 Cloudflared Setup (Dashboard)

This stack uses Cloudflare Tunnels for **secure external access**.

1. Log in → [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Select your domain
3. Go to **Zero Trust → Access → Tunnels**
4. **Create a Tunnel** → choose **Docker** connector → copy token
5. Add **public hostnames**:

| Service        | Subdomain               | URL inside stack                                       |
| -------------- | ----------------------- | ------------------------------------------------------ |
| **n8n**        | n8n.yourdomain.com      | [http://n8n:5678](http://n8n:5678)                     |
| **Supabase**   | supabase.yourdomain.com | [http://supabase-kong:8000](http://supabase-kong:8000) |
| **Open WebUI** | webui.yourdomain.com    | [http://open-webui:3000](http://open-webui:3000)       |
| **Langfuse**   | langfuse.yourdomain.com | [http://langfuse-web:3030](http://langfuse-web:3030)   |
| **Graphiti**   | graphiti.yourdomain.com | [http://graphiti:8090](http://graphiti:8090)           |
| **Grafana**    | grafana.yourdomain.com  | [http://grafana:3000](http://grafana:3000)             |
| **Prometheus** | prom.yourdomain.com     | [http://prometheus:9090](http://prometheus:9090)       |

6. Update `.env` (see example above)
7. Start the stack:

```bash
python start_services.py --profile gpu-nvidia
```

---

## 🔄 Upgrading

```bash
# Stop everything (adjust profile as used)
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

* Open `.env`
* Bottom-right → Change `CRLF` → `LF`
* Save file

Verify with Git:

```bash
git ls-files --eol | findstr ".env"
```

Should show `lf`, not `crlf`.

### 2. Supabase

* **Pooler keeps restarting** → ensure `.env` has `POOLER_DB_POOL_SIZE=5`
* **Analytics container fails** → delete `supabase/docker/volumes/db/data` and restart
* **Password issues** → avoid `@` and special chars in `POSTGRES_PASSWORD`

### 3. SearXNG

If it keeps restarting:

```bash
chmod 755 searxng
```

### 4. Ollama GPU Issues

* **Windows** → enable WSL2 backend in Docker Desktop
* **Linux** → follow Ollama GPU Docker setup

### 5. Containers Not Found

Sometimes Supabase pulls badly. Delete the `supabase/` folder and rerun:

```bash
python start_services.py --profile gpu-nvidia
```

### 6. Prometheus/Grafana show no data

* Check Prometheus **Targets** page (9090) → exporters should be **UP**
* Ensure Grafana datasource points to `http://prometheus:9090`
* Verify job names match container names in your scrape config

---

## 📊 Differences from Cole’s Version

* 🛠️ Extra monitoring: **Portainer, Netdata, Dozzle, Watchtower**
* 🔐 Backup & Error Handling Workflows
* 🌐 Cloudflared Tunnels for secure access
* 🧠 Graphiti + Neo4j integration
* 📂 Synced `.env.example` with safe placeholders
* ⚡ More opinionated defaults for local-first setup

---

## 📜 License & Attribution

This project builds on the work of:

* [n8n Local AI Starter Kit](https://github.com/n8n-io)
* [Self-Hosted AI Package by Coleam](https://github.com/coleam00/local-ai-packaged)

Extended here with **additional services, workflows, monitoring, and improvements**.
Licensed under the **Apache 2.0 License**.

