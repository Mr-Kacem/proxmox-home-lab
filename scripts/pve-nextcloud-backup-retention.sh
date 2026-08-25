#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="/mnt/pve-backup/app-backups/nextcloud"

find "$BACKUP_DIR" \
  -mindepth 1 \
  -maxdepth 1 \
  -type d \
  -name '20??-??-??_??-??-??' \
  -mmin +20160 \
  -print \
  -exec rm -rf -- {} +
