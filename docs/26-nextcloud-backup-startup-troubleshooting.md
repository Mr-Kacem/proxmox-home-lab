# Nextcloud Backup Startup Troubleshooting

## 1. Overview

A failed automatic Nextcloud backup was investigated using system and container logs.

The objective was to identify the real cause of the failure and make the existing backup automation more reliable after host startup.

---

## 2. Log Analysis

Two different log sources were used:

```text
journalctl          → systemd and system-level events
docker compose logs → application and container events
```

Older Vaultwarden warnings were also reviewed and identified as expired session/token messages rather than current service failures.

A system error check revealed:

```text
Failed to start nextcloud-backup.service
```

The service log showed the actual cause:

```text
SQLSTATE[HY000] [2002] Connection refused
```

The backup had started shortly after boot while Docker was already running, but MariaDB and Nextcloud were not yet ready to accept connections.

---

## 3. Backup Script Improvement

`/usr/local/sbin/nextcloud-backup.sh` was updated to wait for Nextcloud to become available before starting the backup.

The new logic retries periodically for a limited time instead of failing immediately during service startup.

The script syntax was verified with:

```bash
bash -n /usr/local/sbin/nextcloud-backup.sh
```

No syntax errors were reported.

---

## 4. Validation

Nextcloud was first confirmed operational:

```text
maintenance: false
needsDbUpgrade: false
```

The real systemd backup service was then started manually and completed with:

```text
status=0/SUCCESS
Nextcloud backup completed successfully
```

The complete workflow was verified, including:

- MariaDB dump;
- application and user data backup;
- checksum verification;
- remote backup copy;
- restoration of the original container state.

---

## 5. Result

The automatic backup no longer assumes that application containers are ready immediately after boot.

This troubleshooting exercise reinforced a practical workflow:

```text
detect system error
      ↓
inspect service logs
      ↓
identify root cause
      ↓
modify automation
      ↓
validate the real systemd service
```

The issue was corrected at its source instead of being handled with a manual restart workaround.
