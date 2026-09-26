# NFS File Sharing on fileserver-01

## 1. Overview

`fileserver-01` was extended with an NFSv4.2 export in addition to the existing Samba service.

The objective was to reuse the existing file server and dedicated 100 GB data disk instead of creating a separate VM.

---

## 2. NFS Server Configuration

`nfs-kernel-server` was installed and enabled on `fileserver-01`.

A new export directory was created at:

```text
/srv/samba-data/nfs-lab
```

This keeps the NFS data on the existing 100 GB data disk rather than on the VM system disk.

The export was added to `/etc/exports` and restricted to the local network:

```text
192.168.178.0/24
```

The firewall was updated to allow NFS traffic on:

```text
2049/tcp
```

only from the LAN.

---

## 3. Client Validation

The NFS client tools were installed on `lfcs-client-01`.

The export was mounted manually and verified with:

```bash
findmnt -T /srv/nfs/lab
```

The first check revealed that the export directory was located on the system disk.

The directory was then recreated under:

```text
/srv/samba-data/nfs-lab
```

and the export configuration was updated.

After remounting, read/write access from the client worked correctly.

Files created through NFS were stored with the expected ownership:

```text
hamza:fileshare
```

---

## 4. Final Status

`fileserver-01` now provides two local-network file-sharing services:

- Samba
- NFSv4.2

Both use the dedicated 100 GB data disk.

A final Proxmox snapshot was prepared with the configuration name:

```text
nfs-configured
```
