# Proxmox Storage Health Monitoring

## 1. Overview

The Proxmox host storage was reviewed and an automated health check was added for the three physical disks.

The objective is to detect storage capacity problems or SMART health failures and send an alert through ntfy without requiring manual checks.

---

## 2. Storage and SMART Validation

The current disk layout was verified:

```text
sda → Proxmox system / LVM
sdb → /mnt/pve-backup
sdc → /mnt/pve-data
```

Disk usage was checked and no capacity problems were found.

SMART health was then verified for all three disks. Each disk reported `PASSED`, with no reallocated, pending, or uncorrectable sectors detected.

A SMART short self-test was also executed on every disk and completed without errors.

---

## 3. Automated Health Check

A monitoring script was created at:

```text
/usr/local/sbin/home-lab-storage-check.sh
```

The script checks:

- filesystem usage for `/`, `/mnt/pve-backup`, and `/mnt/pve-data`;
- an alert threshold of 85% filesystem usage;
- SMART health for `/dev/sda`, `/dev/sdb`, and `/dev/sdc`;
- ntfy notification delivery when an abnormal condition is detected.

A manual execution returned exit code `0` and generated no alert, which was the expected result with all checks passing.

---

## 4. systemd Automation

The script is executed through:

```text
home-lab-storage-check.service
home-lab-storage-check.timer
```

The timer runs daily at:

```text
18:00
```

and uses:

```text
Persistent=true
```

so a missed check can run after the next server startup if the Proxmox host was powered off at the scheduled time.

---

## 5. Final Status

| Check | Status |
|---|---|
| Disk layout | Verified |
| Filesystem capacity | Normal |
| SMART health | Passed |
| SMART short self-tests | Passed |
| Manual script test | Passed |
| ntfy alert path | Configured |
| Daily systemd timer | Active |
| Missed-run recovery | Enabled |

The Proxmox host now performs automatic storage capacity and disk health checks and can report detected problems through ntfy.
