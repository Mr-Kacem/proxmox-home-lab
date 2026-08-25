# Nextcloud Backup and Recovery Automation

## 1. Overview

The Nextcloud deployment was extended with application testing, a verified backup/restore procedure, and automated backup retention.

The existing Nextcloud instance was first confirmed operational after the previous Proxmox snapshot.

---

## 2. Application Validation

The following Nextcloud applications were installed and tested:

* Calendar
* Contacts
* Notes
* Talk

A second user account was created to verify Talk messaging and calls between two independent accounts.

No additional applications such as office suites were added at this stage.

---

## 3. Backup and Restore Test

A complete manual backup was created containing:

* MariaDB database;
* Nextcloud application/configuration data;
* user data stored on the dedicated HDD;
* Docker configuration;
* SHA256 checksums.

Backups are copied to:

```text
/mnt/pve-backup/app-backups/nextcloud/
```

During testing, `mariadb-dump` required the database dump to be created inside the MariaDB container first and then copied to the host.

A complete restore was successfully performed.

The test restored:

```text
MariaDB
+
application/configuration
+
user data
```

A file created after the backup disappeared after restoration, confirming that an actual rollback had occurred.

---

## 4. Backup Automation

The validated manual procedure was converted into an automated Nextcloud backup using:

```text
nextcloud-backup.sh
        ↓
systemd service
        ↓
systemd timer
        ↓
SHA256 verification
```

Vaultwarden and Nextcloud backups now share the lock:

```text
/run/homelab-backup.lock
```

using `flock` to prevent both backup jobs from running simultaneously.

---

## 5. Retention

Automatic Nextcloud backup retention was configured on the Proxmox host.

Retention period:

```text
14 days
```

The cleanup procedure was tested first with a dry run and then with real execution.

Final schedule:

| Time  | Job                   |
| ----- | --------------------- |
| 03:00 | Vaultwarden backup    |
| 03:30 | Vaultwarden retention |
| 04:00 | Nextcloud backup      |
| 04:30 | Nextcloud retention   |

---

## 6. Final State

The following checks were completed successfully:

| Check              | Status   |
| ------------------ | -------- |
| Nextcloud apps     | Verified |
| Manual backup      | Verified |
| SHA256 integrity   | Verified |
| Full restore       | Verified |
| Rollback test      | Verified |
| Automated backup   | Working  |
| Shared backup lock | Working  |
| 14-day retention   | Working  |
| Retention dry run  | Passed   |

Final Proxmox snapshot:

```text
docker-nextcloud-backup-automation
```
