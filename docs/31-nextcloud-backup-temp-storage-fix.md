# Nextcloud Backup Temporary Storage Fix

## 1. Overview

A Nextcloud maintenance mode incident was traced to the backup process filling the VM root filesystem.

The main Nextcloud data disk was healthy and had free space. The problem was caused by large temporary backup files being written to `/tmp`, which resides on the smaller root filesystem.

---

## 2. Root Cause

The root filesystem reached 100% usage while inode usage remained normal.

The main temporary files found in `/tmp` were:

```text
app.tar.gz
data.tar.gz
db.sql
```

Together they used approximately 1.7 GB.

Nextcloud data itself was correctly mounted on:

```text
/srv/data/nextcloud/data
```

so the persistent data disk was not the source of the problem.

After confirming that no backup was active, the abandoned temporary files were removed.

Nextcloud still reported:

```text
maintenance: true
needsDbUpgrade: false
```

Maintenance mode was then disabled manually without performing a database upgrade.

---

## 3. Backup Script Improvement

The backup script:

```text
/usr/local/sbin/nextcloud-backup.sh
```

was updated to use dedicated temporary storage on the larger data disk:

```text
/srv/data/nextcloud-backup-tmp
```

instead of `/tmp`.

Cleanup logic was also strengthened so that, if the backup fails:

- the previous service state is restored;
- temporary backup files are removed.

The script syntax was verified with:

```bash
bash -n /usr/local/sbin/nextcloud-backup.sh
```

---

## 4. Validation

A complete backup was executed manually through the real systemd service:

```text
nextcloud-backup.service
```

The workflow completed successfully, including:

- application archive;
- user-data archive;
- database dump;
- stack archive;
- SHA256 verification;
- remote copy to the Proxmox backup storage;
- restoration of the original container state.

After the test:

- `/tmp` remained free;
- Nextcloud returned to normal operation;
- maintenance mode was disabled;
- the scheduled `nextcloud-backup.timer` remained active.

---

## 5. Result

The backup process no longer depends on the limited root filesystem for large temporary archives.

Temporary backup data is now created on the dedicated data disk and cleaned up reliably if the backup exits unexpectedly.
