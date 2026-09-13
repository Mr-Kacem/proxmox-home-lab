# Proxmox Journal Persistence Check

## 1. Overview

The Proxmox host logging configuration was reviewed to verify journal persistence and disk usage.

No configuration changes were required.

---

## 2. Journal Usage

Current `systemd-journald` disk usage was checked and found to be approximately:

```text
64 MB
```

This showed no abnormal log growth or storage concern.

---

## 3. Persistence Verification

`/etc/systemd/journald.conf` was reviewed and no relevant custom limits or overrides were present.

Previous boot history was checked with:

```bash
journalctl --list-boots
```

Multiple earlier boots were available, confirming that journal logs persist across reboots.

The relevant journal locations are:

```text
/var/log/journal  → persistent logs stored on disk
/run/log/journal  → temporary runtime logs
```

The Proxmox host is using persistent journal storage correctly.

---

## 4. Result

The current journald configuration is healthy:

- log usage is small;
- previous boot logs are retained;
- persistent journal storage is working;
- no additional size limits or configuration changes are currently necessary.

The default journald configuration was therefore left unchanged.
