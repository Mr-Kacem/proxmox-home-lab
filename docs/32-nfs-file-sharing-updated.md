# NFS File Sharing on fileserver-01

## 1. Overview

`fileserver-01` provides an NFSv4.2 export in addition to the existing Samba service.

The NFS data is stored on the dedicated 100 GB data disk rather than on the VM system disk.

---

## 2. NFS Server Configuration

The NFS export is located at:

```text
/srv/samba-data/nfs-lab
```

and is restricted to the local network:

```text
192.168.178.0/24
```

UFW allows NFS traffic on:

```text
2049/tcp
```

only from the LAN.

The export configuration was applied through `/etc/exports` and verified with a successful read/write test from `lfcs-client-01`.

---

## 3. Storage Layout Correction

The first NFS directory was accidentally created on the VM system disk.

This was detected with:

```bash
findmnt -T /srv/nfs/lab
```

The export was then moved to:

```text
/srv/samba-data/nfs-lab
```

which resides on the dedicated 100 GB data disk.

The client was remounted and read/write access was verified again successfully.

---

## 4. On-Demand Mount with autofs

`autofs` was configured on `lfcs-client-01` so the NFS share is mounted only when needed.

The client accesses the export through:

```text
/mnt/nfs/nfs-lab
```

After correcting the parent mount point, simply accessing this path automatically activates the NFSv4.2 mount.

Write access through the automatic mount was also verified successfully.

The configuration uses:

```text
timeout=60
```

so the mount can be released after inactivity and recreated automatically on the next access.

---

## 5. Final Status

`fileserver-01` now provides:

- Samba file sharing;
- NFSv4.2 file sharing;
- data stored on the dedicated 100 GB disk;
- LAN-only NFS access.

`lfcs-client-01` accesses the NFS export through an on-demand `autofs` mount instead of requiring a permanent manual mount.
