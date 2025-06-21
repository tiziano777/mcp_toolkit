#!/usr/bin/env bash
set -euo pipefail

#----------------------------------------------------------------#
# Script: uninstall_qdrant.sh
# Description: Stops and removes the Qdrant Docker container and Redis local service.
#----------------------------------------------------------------#

log() {
  echo -e "[INFO] $*"
}

# --- 1️⃣ Stop and Remove Qdrant Docker Container --- 

log "Stopping Qdrant Docker container..."
if docker ps -a --format "{{.Names}}" | grep -q "qdrant"; then
  docker stop qdrant
  log "Qdrant container stopped."
else
  log "Qdrant container 'qdrant' not found or already stopped."
fi

log "Removing Qdrant Docker container..."
if docker ps -a --format "{{.Names}}" | grep -q "qdrant"; then
  docker rm qdrant
  log "Qdrant container removed."
else
  log "Qdrant container 'qdrant' not found or already removed."
fi

log "Qdrant cleanup complete."

# Note: This script does NOT remove the persistent volume data
# at /home/tiziano/progetti/mcp_toolkit/volumes/qdrant.
# You'll need to manually delete that directory if you want to remove all data.


# --- 2️⃣ Stop Redis (Servizio Locale) ---
log "Arresto del servizio Redis locale..."
# Check if Redis is active before trying to stop it
if systemctl is-active --quiet redis-server; then
  # Using 'sudo' here for stopping the system service
  sudo systemctl stop redis-server
  log "Servizio Redis arrestato."
else
  log "Servizio Redis non attivo o già arrestato."
fi

log "Tutti i servizi (Qdrant, Redis) sono stati gestiti."