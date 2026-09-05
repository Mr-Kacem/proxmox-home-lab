# Docker Service Maintenance

## 1. Overview

A maintenance check was performed on the main Docker services running on `docker-prod-01`.

The objective was to verify the installed versions and update only services that actually required maintenance.

---

## 2. Version Check

### Nginx Proxy Manager

Installed version:

`2.15.1`

The service was already current, so no changes were required.

### AdGuard Home

The deployment uses:

`adguard/adguardhome:latest`

The running container reported:

`v0.107.78`

AdGuard Home was already up to date.

### Uptime Kuma

The installed version was:

`2.5.0`

A newer release from the same major version was available.

Before updating, a Proxmox snapshot of `docker-prod-01` was created as a rollback point.

Uptime Kuma was then updated with:

`docker compose pull`

followed by:

`docker compose up -d`

---

## 3. Validation

After the update, the Uptime Kuma container was verified successfully and returned:

`healthy`

No configuration changes were required for Nginx Proxy Manager or AdGuard Home.

This maintenance cycle therefore updated only the service that required it while leaving already current services unchanged.
