# Samba File Server Deployment

## 1. Overview

A new Ubuntu Server VM named `fileserver-01` was prepared as a basic Samba file server.

The VM was configured with `qemu-guest-agent` and a reserved LAN address:

```text
192.168.178.49
```

A second 100 GB virtual disk on `pve-data` was added specifically for shared file storage, keeping the operating system and file-server data separated.

---

## 2. Data Disk

The new virtual disk was prepared with:

- GPT partition table;
- one partition: `/dev/sdb1`;
- `ext4` filesystem;
- filesystem label: `samba-data`.

It was mounted at:

```text
/srv/samba-data
```

and added to `/etc/fstab` by UUID so the mount persists across reboots.

The Samba share directory was created at:

```text
/srv/samba-data/shared
```

with Linux permissions set to `770`.

---

## 3. Samba Configuration

Samba was installed and `smbd` was verified as active and listening on TCP port `445`.

The local Linux user `hamza` was added to Samba authentication with `smbpasswd`.

A share named:

```text
[shared]
```

was configured in `/etc/samba/smb.conf` with authenticated read/write access restricted to the intended user.

The configuration was validated with:

```bash
testparm
```

and applied by reloading `smbd`.

---

## 4. Validation

The share was tested locally with `smbclient`, confirming:

- authentication;
- directory access;
- file read/write operations.

Access from an Ubuntu desktop client was also verified over the network.

Nautilus initially did not complete the SMB connection correctly, while command-line access worked. The client side was isolated as the problem and the share was mounted manually with `gio mount`.

After authentication, Nautilus recognized the share correctly.

The final path is:

```text
Ubuntu client
    ↓
SMB
    ↓
Samba on fileserver-01
    ↓
/srv/samba-data/shared
    ↓
100 GB ext4 data disk
```

---

## 5. Final Status

| Check | Status |
|---|---|
| `fileserver-01` VM | Operational |
| Data disk | Mounted persistently |
| Samba service | Active |
| TCP 445 | Listening |
| Samba authentication | Verified |
| Read/write access | Verified |
| `smbclient` access | Verified |
| Nautilus access | Verified |

`fileserver-01` is now operational as a basic authenticated Samba file server.
