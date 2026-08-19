#!/usr/bin/env bash

set -euo pipefail
umask 077

APP_DIR="/opt/docker/vaultwarden"
REMOTE_USER="vaultbackup"
REMOTE_HOST="192.168.178.35"
REMOTE_DIR="/mnt/pve-backup/app-backups/vaultwarden"

SSH_KEY="/home/hamza/.ssh/vaultbackup_ed25519"
KNOWN_HOSTS="/home/hamza/.ssh/known_hosts"

TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_NAME="vaultwarden-${TIMESTAMP}.tar.gz"
LOCAL_BACKUP="/tmp/${BACKUP_NAME}"

VAULTWARDEN_STOPPED=0

restart_vaultwarden() {
    if [[ "$VAULTWARDEN_STOPPED" -eq 1 ]]; then
        docker compose -f "$APP_DIR/compose.yaml" start
    fi
}

trap restart_vaultwarden EXIT

echo "Stopping Vaultwarden..."
VAULTWARDEN_STOPPED=1
docker compose -f "$APP_DIR/compose.yaml" stop

echo "Creating backup..."
tar -czpf "$LOCAL_BACKUP" -C /opt/docker vaultwarden

echo "Starting Vaultwarden..."
docker compose -f "$APP_DIR/compose.yaml" start
VAULTWARDEN_STOPPED=0

echo "Calculating local checksum..."
LOCAL_SHA="$(sha256sum "$LOCAL_BACKUP" | awk '{print $1}')"

echo "Copying backup to Proxmox..."
scp \
  -i "$SSH_KEY" \
  -o UserKnownHostsFile="$KNOWN_HOSTS" \
  -o StrictHostKeyChecking=yes \
  "$LOCAL_BACKUP" \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${BACKUP_NAME}"

echo "Calculating remote checksum..."
REMOTE_SHA="$(
  ssh \
    -i "$SSH_KEY" \
    -o UserKnownHostsFile="$KNOWN_HOSTS" \
    -o StrictHostKeyChecking=yes \
    "${REMOTE_USER}@${REMOTE_HOST}" \
    "sha256sum ${REMOTE_DIR}/${BACKUP_NAME}" |
  awk '{print $1}'
)"

if [[ "$LOCAL_SHA" != "$REMOTE_SHA" ]]; then
    echo "ERROR: checksum mismatch."
    exit 1
fi

echo "Checksum verified: $LOCAL_SHA"

rm -f "$LOCAL_BACKUP"

echo "Backup completed successfully: $BACKUP_NAME"
