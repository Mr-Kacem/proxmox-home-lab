# Proxmox VM Backup and Recovery

## 1. Overview

A complete Proxmox backup and recovery procedure was tested for `docker-prod-01`.

Unlike the existing application-level backups, this backup protects the entire virtual machine.

The backup is stored on:

```text
pve-backup
```

---

## 2. Restore Test

A manual VM backup was created and a real restore was performed.

The original VM was powered off before testing the restored copy.

The restore was also successfully tested without assigning a new `Unique` identity.

After restoration, the following components were verified:

* Docker;
* Tailscale;
* Bitwarden / Vaultwarden access;
* Nextcloud.

All services returned operational on the restored VM.

This confirmed that the backup can be used to recover the complete `docker-prod-01` environment after VM loss.

---

## 3. Automated Backup

A scheduled weekly Proxmox backup job was configured for the VM.

`Repeat missed` is enabled so a missed scheduled backup can run later when the Proxmox server becomes available again.

This is useful because the homelab server is not required to remain powered on continuously.

Backup retention is also configured directly in the Proxmox backup job.

---

## 4. Final Status

| Check                    | Status     |
| ------------------------ | ---------- |
| Manual full VM backup    | Passed     |
| Real VM restore          | Passed     |
| Restore without `Unique` | Passed     |
| Docker verification      | Passed     |
| Tailscale verification   | Passed     |
| Vaultwarden verification | Passed     |
| Nextcloud verification   | Passed     |
| Weekly automated backup  | Configured |
| Missed-job handling      | Enabled    |
| Backup retention         | Configured |

The VM backup is therefore not only configured but has been proven recoverable through an actual restore test.
