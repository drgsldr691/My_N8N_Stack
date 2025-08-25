🚀 Self-Hosted AI Package (My n8n + AI Docker Stack)

This is my self-hosted AI + automation stack, built entirely with Docker Compose.

It’s based on:

The original n8n Local AI Starter Kit

Extended by Coleam’s Self-Hosted AI Package

Further improved here with additional services, workflows, monitoring, and self-healing tools

Unlike cloud-based AI platforms, this stack is 100% private and self-hosted, giving me full control over my data and models.

✨ Features

✅ n8n – Low-code automation platform with 400+ integrations + AI nodes
✅ Supabase – Database, auth, APIs, storage, vector support
✅ Ollama – Run local LLMs on GPU or CPU
✅ Open WebUI – Chat interface for local models + n8n agents
✅ Flowise – Visual AI pipeline builder
✅ Qdrant – Vector database optimized for embeddings and RAG
✅ Neo4j + Graphiti – Graph database + visualization
✅ Langfuse – LLM observability and tracing
✅ SearXNG – Self-hosted metasearch engine for live queries
✅ Clickhouse – Analytics + fast queries
✅ Minio – S3-compatible object storage
✅ Cloudflared – Secure tunnels without exposing ports
✅ Portainer, Netdata, Dozzle, Watchtower – Monitoring, logging, management

📦 What’s Included

docker-compose.yml + override files for flexible deployment

start_services.py script with multiple profiles

Profiles: cpu, gpu-nvidia, gpu-amd, none (external Ollama)

Backup workflow → commits n8n workflows + credentials to a private GitHub repo

Error handling workflow → AI-assisted error notifications via Gmail + Telegram

.env.example → template for environment variables (no secrets)

🔧 Prerequisites

Docker

Python 3.10+

Git

⚡ Quick Start

Clone the repo:

git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME


Copy .env.example → .env and fill in your secrets:

cp .env.example .env


Start the stack:

▶️ Nvidia GPU
python start_services.py --profile gpu-nvidia

▶️ AMD GPU (Linux only)
python start_services.py --profile gpu-amd

▶️ CPU only
python start_services.py --profile cpu

▶️ External Ollama (Mac / Apple Silicon)

Run Ollama natively, then start the stack without it:

python start_services.py --profile none


Set OLLAMA_HOST=host.docker.internal:11434 in the n8n container config.

🔑 Environment Setup

Copy .env.example to .env.

Replace placeholders (changeme, your-token-here) with your real secrets.

.gitignore protects .env automatically — never commit secrets.

See .env.example for a full reference of required variables.

🌐 Service Access

Once running, services are available at:

Service	URL	Notes
n8n	http://localhost:5678
	Workflow automation
Open WebUI	http://localhost:3000
	Chat with local models
Supabase Studio	http://localhost:54323
	Database UI
Langfuse	http://localhost:3030
	LLM observability
Portainer	http://localhost:9443
	Container management
Netdata	http://localhost:19999
	Monitoring dashboard
Graphiti	http://localhost:7474
	Graph visualization (Neo4j)
Qdrant	http://localhost:6333
	Vector database API
SearXNG	http://localhost:8080
	Meta search engine
🛠️ Workflows

This stack comes with extra n8n workflows:

Main Assistant – Central AI agent (Ollama + Postgres memory).

Calendar Agent – Manage events (Google Calendar).

Contact Agent – Manage contacts (Google Contacts).

Email Agent – Send, search, draft, and label emails.

Error Handler – AI-analyzed error reporting via Gmail/Telegram.

Backup Tool – Daily commits of workflows/credentials to a private GitHub repo.

🔐 Security

Always use a private repo if committing config.

All secrets stay in .env (never push them).

Cloudflared secures external access via tunnels.

🌐 Cloudflared Setup (Using the Dashboard)

This stack uses Cloudflare Tunnels to securely expose services like n8n, Supabase, or Open WebUI — without opening ports.

1. Log into Cloudflare Dashboard

Go to dash.cloudflare.com

Select your domain (must already be on Cloudflare DNS).

Navigate to Zero Trust → Access → Tunnels.

2. Create a Tunnel

Click Create a Tunnel

Name it n8n-stack (or similar).

Choose Docker as the connector type.

Copy the token shown (you’ll use it in .env).

3. Configure Public Hostnames

Add entries for each service you want exposed:

Service	Subdomain	URL inside stack
n8n	n8n.yourdomain.com	http://n8n:5678
Supabase	supabase.yourdomain.com	http://supabase-kong:8000
Open WebUI	webui.yourdomain.com	http://open-webui:3000
Langfuse	langfuse.yourdomain.com	http://langfuse-web:3030
Graphiti	graphiti.yourdomain.com	http://graphiti:7474

Cloudflare will automatically create DNS records for these subdomains.

4. Update .env

Paste your token:

CLOUDFLARED_TOKEN=your-cloudflared-token-here


And set hostnames to match your DNS:

N8N_HOSTNAME=n8n.yourdomain.com
SUPABASE_HOSTNAME=supabase.yourdomain.com
WEBUI_HOSTNAME=webui.yourdomain.com
LANGFUSE_HOSTNAME=langfuse.yourdomain.com
GRAPHITI_HOSTNAME=graphiti.yourdomain.com

5. Start the Stack
python start_services.py --profile gpu-nvidia


The Cloudflared container will connect automatically, and your services will be available at your custom subdomains.

🔄 Upgrading

To update containers (n8n, Supabase, Ollama, etc.):

# Stop running services
docker compose -p localai -f docker-compose.yml --profile <your-profile> down

# Pull latest versions
docker compose -p localai -f docker-compose.yml --profile <your-profile> pull

# Restart with your chosen profile
python start_services.py --profile <your-profile>


Replace <your-profile> with one of: cpu, gpu-nvidia, gpu-amd, none.

⚠️ Note: start_services.py restarts services but does not upgrade containers — you must pull explicitly.

🛠️ Troubleshooting
Supabase Issues

Pooler keeps restarting → Add POOLER_DB_POOL_SIZE=5 to .env.

Analytics container fails after password change → Delete supabase/docker/volumes/db/data and restart.

Service unavailable → Avoid @ and special chars in POSTGRES_PASSWORD.

SearXNG

If searxng keeps restarting:

chmod 755 searxng


This ensures permissions for uwsgi.ini.

Ollama GPU Issues

Windows → Enable WSL2 backend in Docker Desktop.

Linux → Follow Ollama GPU Docker setup docs
.

General

Containers not found → Sometimes a bad pull corrupts Supabase. Delete the supabase/ folder and rerun start_services.py.

Port conflicts → Ensure nothing else is using the mapped ports (5432, 5678, 3000, etc.).

🔄 Differences from Cole’s Version

This project extends Coleam’s Self-Hosted AI Package with:

🛠️ Extra monitoring & management: Portainer, Netdata, Dozzle, Watchtower

🔐 Backup & Error Handling Workflows: daily GitHub commits + AI-powered error alerts

🌐 Cloudflared tunnels: secure remote access without opening ports

📊 Graphiti integration with Neo4j for graph visualization

📂 Improved .env.example — always synced with .env, safe placeholders

⚡ More opinionated defaults for easier local-first setup

📜 License & Attribution

This project builds on the work of:

The n8n Local AI Starter Kit
 by the n8n team

The Self-Hosted AI Package
 by Coleam

I’ve extended it with additional services, monitoring, workflows, and improvements.

Licensed under the Apache 2.0 License.