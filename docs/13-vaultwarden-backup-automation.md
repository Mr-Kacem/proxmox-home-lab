# Vaultwarden Backup Automation

## 1. Overview

After verifying a manual Vaultwarden backup and restore, the backup procedure was automated.

The objective was to move from:

```text
manual backup
    ↓
manual verification
```

to a repeatable scheduled process with automatic retention.

---

## 2. Backup Content

The backup protects the Vaultwarden deployment, including:

```text
compose.yaml
data/
```

The persistent data contains the SQLite database and Vaultwarden application data required for recovery.

Backups are stored separately from the Docker VM on the Proxmox backup disk.

---

## 3. Automation

The previously tested backup procedure was converted into an automated process using:

```text
backup script
    ↓
systemd service
    ↓
systemd timer
    ↓
backup retention
```

This removes the need to manually start each backup while keeping the same recovery principle already tested with the manual procedure.

---

## 4. Verification

The automated backup workflow was tested after configuration.

The complete Vaultwarden backup strategy has now been validated through:

* successful backup creation;
* SHA256 integrity verification;
* real restore test;
* automated execution;
* backup retention;
* Proxmox recovery snapshot.

The earlier restore test confirmed that the backup contains sufficient data to recover the Vaultwarden deployment.

---

## 5. Current Status

| Component                             | Status     |
| ------------------------------------- | ---------- |
| Manual backup                         | Verified   |
| SHA256 integrity check                | Verified   |
| Real restore                          | Verified   |
| Automated backup                      | Working    |
| systemd scheduling                    | Working    |
| Retention                             | Configured |
| Proxmox snapshot `docker-vaultwarden` | Created    |

Vaultwarden now has both a tested recovery procedure and an automated backup process.
