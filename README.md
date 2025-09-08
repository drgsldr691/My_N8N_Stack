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
- ✅ **WAPP** – Web server that works with n8n out of the box. combined with cloudfare it is accessible from anywhere. 

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
CLOUDFLARED_TOKEN=your-token-here

N8N_HOSTNAME=n8n.yourdomain.com
SUPABASE_HOSTNAME=supabase.yourdomain.com
WEBUI_HOSTNAME=webui.yourdomain.com
LANGFUSE_HOSTNAME=langfuse.yourdomain.com
GRAPHITI_HOSTNAME=graphiti.yourdomain.com
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




