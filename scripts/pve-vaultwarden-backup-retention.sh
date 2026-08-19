#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="/mnt/pve-backup/app-backups/vaultwarden"

find "$BACKUP_DIR" \
  -maxdepth 1 \
  -type f \
  -name 'vaultwarden-20*.tar.gz' \
  -mmin +20160 \
  -print \
  -delete
