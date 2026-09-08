#!/usr/bin/env bash

set -u

NTFY_URL="https://ntfy.sh/CHANGE_ME"
HOST="$(hostname)"
LIMIT=85

send_alert() {
    curl -fsS \
        -H "Title: Home Lab Storage Alert" \
        -H "Priority: high" \
        -d "$1" \
        "$NTFY_URL" >/dev/null || true
}

# Check filesystem usage
for MOUNT in / /mnt/pve-backup /mnt/pve-data; do
    USAGE=$(df -P "$MOUNT" | awk 'NR==2 {gsub("%","",$5); print $5}')

    if (( USAGE >= LIMIT )); then
        send_alert "$HOST: filesystem $MOUNT is ${USAGE}% full."
    fi
done

# Check SMART health
for DISK in /dev/sda /dev/sdb /dev/sdc; do
    if ! smartctl -H "$DISK" | grep -q "PASSED"; then
        send_alert "$HOST: SMART health check FAILED for $DISK."
    fi
done
