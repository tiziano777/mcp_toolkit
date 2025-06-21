#!/usr/bin/env bash
set -euo pipefail

#----------------------------------------------------------------#
# Script: install_qdrant.sh
# Descrizione: Scarica ed esegue Qdrant (Docker) e MCP Server Qdrant 
#              poi avvia il server MCP via uvx (se disponibile) o Docker.
#----------------------------------------------------------------#

log() {
  echo -e "[INFO] $*"
}

# --- 1️⃣ Avvio Qdrant via Docker --- 

log "Pull dell'immagine Docker Qdrant..."
docker pull qdrant/qdrant:latest

log "Avvio container Docker Qdrant (background)..."
docker run -d --name qdrant \
  -p 6333:6333 -p 6334:6334 \
  -v "/home/tiziano/progetti/mcp_toolkit/volumes/qdrant:/qdrant/storage:z" \
  qdrant/qdrant:latest


# --- 2️⃣ Avvio Redis (Servizio Locale) ---
log "Avvio del servizio Redis locale..."
# Check if Redis is already active to avoid errors if it's already running
if systemctl is-active --quiet redis-server; then
  log "Servizio Redis è già attivo."
else
  # Using 'sudo' here because starting/stopping system services usually requires root privileges.
  # You might be prompted for your password.
  sudo systemctl start redis-server
  log "Servizio Redis avviato."
fi


log "Tutti i servizi (Qdrant, Redis) sono avviati."