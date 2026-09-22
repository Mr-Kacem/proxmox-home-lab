# Proxmox VM Backup and Recovery

## 1. Overview

The Proxmox backup strategy was validated with real restore tests for both main service VMs:

- `docker-prod-01`
- `fileserver-01`

The objective was to verify that backups stored on `pve-backup` are not only created successfully, but can actually restore complete working virtual machines.

---

## 2. docker-prod-01 Recovery Test

A full Proxmox backup of `docker-prod-01` was restored and tested separately from the original VM.

The restored system was verified with:

- Docker;
- Tailscale;
- Vaultwarden;
- Nextcloud.

The test confirmed that the complete Docker service environment can be recovered from a Proxmox VM backup.

---

## 3. fileserver-01 Recovery Test

A full manual backup of `fileserver-01` was created using:

```text
Mode:        snapshot
Compression: zstd
Storage:     pve-backup
```

The backup archive was verified as present and recognized by Proxmox.

It was then restored as a temporary VM with the network disconnected to avoid IP or MAC conflicts with the original server.

The restored VM was checked for:

- successful Ubuntu boot;
- persistent Samba data-disk mount;
- existing shared files;
- active `smbd` service.

All checks passed.

The temporary restored VM was deleted after validation, confirming that the original backup remained available and usable.

---

## 4. Automated Backup Job

The existing weekly Proxmox backup job was extended to include both service VMs:

```text
docker-prod-01
fileserver-01
```

Current policy:

```text
Schedule:    Saturday 15:00
Storage:     pve-backup
Mode:        snapshot
Compression: zstd
Retention:   keep last 4 backups
```

Missed-job handling remains enabled so a scheduled backup can run later if the Proxmox host was powered off.

---

## 5. Final Status

| Check | Status |
|---|---|
| `docker-prod-01` restore | Verified |
| `fileserver-01` backup | Verified |
| `fileserver-01` restore | Verified |
| Samba data after restore | Verified |
| Temporary restore cleanup | Completed |
| Weekly backup job | Updated |
| Retention | 4 backups |

The VM backup workflow is now validated for both main service VMs through real restore testing.
