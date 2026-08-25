#!/usr/bin/env bash

set -euo pipefail
umask 077

APP_DIR="/opt/docker/nextcloud"
DATA_PARENT="/srv/data/nextcloud"

REMOTE_USER="vaultbackup"
REMOTE_HOST="192.168.178.35"
REMOTE_BASE="/mnt/pve-backup/app-backups/nextcloud"

SSH_KEY="/home/hamza/.ssh/vaultbackup_ed25519"
KNOWN_HOSTS="/home/hamza/.ssh/known_hosts"

TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
REMOTE_DIR="${REMOTE_BASE}/${TIMESTAMP}"

DB_DUMP_CONTAINER="/tmp/nextcloud-db.sql"
LOCAL_DB_DUMP="/tmp/nextcloud-${TIMESTAMP}-db.sql"

MAINTENANCE_ON=0
CRON_STOPPED=0

restore_service_state() {
    if [[ "$MAINTENANCE_ON" -eq 1 ]]; then
        docker compose -f "$APP_DIR/compose.yaml" exec -T -u www-data app \
            php occ maintenance:mode --off || true
    fi

    if [[ "$CRON_STOPPED" -eq 1 ]]; then
        docker compose -f "$APP_DIR/compose.yaml" start cron || true
    fi
}

trap restore_service_state EXIT

echo "Checking backup destination..."
ssh \
  -i "$SSH_KEY" \
  -o UserKnownHostsFile="$KNOWN_HOSTS" \
  -o StrictHostKeyChecking=yes \
  "${REMOTE_USER}@${REMOTE_HOST}" \
  "mkdir -p '$REMOTE_DIR'"

echo "Enabling Nextcloud maintenance mode..."
MAINTENANCE_ON=1
docker compose -f "$APP_DIR/compose.yaml" exec -T -u www-data app \
  php occ maintenance:mode --on

echo "Stopping Nextcloud cron..."
CRON_STOPPED=1
docker compose -f "$APP_DIR/compose.yaml" stop cron

echo "Creating MariaDB dump..."
docker compose -f "$APP_DIR/compose.yaml" exec -T db sh -c \
  'rm -f /tmp/nextcloud-db.sql && timeout -k 2 60 mariadb-dump --single-transaction --quick --skip-lock-tables --default-character-set=utf8mb4 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" > /tmp/nextcloud-db.sql'

echo "Copying database dump out of the container..."
docker compose -f "$APP_DIR/compose.yaml" cp \
  db:"$DB_DUMP_CONTAINER" \
  "$LOCAL_DB_DUMP"

if [[ ! -s "$LOCAL_DB_DUMP" ]]; then
    echo "ERROR: database dump is empty."
    exit 1
fi

echo "Creating app archive..."
tar -czpf "/tmp/nextcloud-${TIMESTAMP}-app.tar.gz" \
  -C "$APP_DIR" app

echo "Creating data archive..."
tar -czpf "/tmp/nextcloud-${TIMESTAMP}-data.tar.gz" \
  -C "$DATA_PARENT" data

echo "Creating stack archive..."
tar -czpf "/tmp/nextcloud-${TIMESTAMP}-stack.tar.gz" \
  -C "$APP_DIR" \
  compose.yaml db.env Dockerfile homelab-ca.crt

echo "Calculating checksums..."
cd /tmp

sha256sum \
  "nextcloud-${TIMESTAMP}-app.tar.gz" \
  "nextcloud-${TIMESTAMP}-data.tar.gz" \
  "nextcloud-${TIMESTAMP}-db.sql" \
  "nextcloud-${TIMESTAMP}-stack.tar.gz" \
  > "nextcloud-${TIMESTAMP}-SHA256SUMS"

echo "Copying backup to Proxmox..."
scp \
  -i "$SSH_KEY" \
  -o UserKnownHostsFile="$KNOWN_HOSTS" \
  -o StrictHostKeyChecking=yes \
  /tmp/nextcloud-"${TIMESTAMP}"-* \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

echo "Verifying remote checksums..."
ssh \
  -i "$SSH_KEY" \
  -o UserKnownHostsFile="$KNOWN_HOSTS" \
  -o StrictHostKeyChecking=yes \
  "${REMOTE_USER}@${REMOTE_HOST}" \
  "cd '$REMOTE_DIR' && sha256sum -c 'nextcloud-${TIMESTAMP}-SHA256SUMS'"

echo "Removing database dump from container..."
docker compose -f "$APP_DIR/compose.yaml" exec -T db \
  rm -f "$DB_DUMP_CONTAINER"

echo "Disabling Nextcloud maintenance mode..."
docker compose -f "$APP_DIR/compose.yaml" exec -T -u www-data app \
  php occ maintenance:mode --off
MAINTENANCE_ON=0

echo "Starting Nextcloud cron..."
docker compose -f "$APP_DIR/compose.yaml" up -d cron
CRON_STOPPED=0

echo "Removing local temporary backup files..."
rm -f \
  "/tmp/nextcloud-${TIMESTAMP}-app.tar.gz" \
  "/tmp/nextcloud-${TIMESTAMP}-data.tar.gz" \
  "/tmp/nextcloud-${TIMESTAMP}-db.sql" \
  "/tmp/nextcloud-${TIMESTAMP}-stack.tar.gz" \
  "/tmp/nextcloud-${TIMESTAMP}-SHA256SUMS"

echo "Nextcloud backup completed successfully: $TIMESTAMP"
