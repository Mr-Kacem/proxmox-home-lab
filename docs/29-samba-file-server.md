# Samba File Server Deployment

## 1. Overview

`fileserver-01` was finalized as a persistent Samba file server with LAN-only access, automatic client mounting, and a cleaned Samba configuration.

Group-based access through the Linux `fileshare` group is documented separately in `30-samba-group-access.md`.

---

## 2. Network Hardening

UFW was enabled on `fileserver-01` with incoming traffic blocked by default.

Only the local network `192.168.178.0/24` is allowed to reach:

```text
22/tcp   → SSH
445/tcp  → SMB
```

After enabling the firewall, both SSH and Samba access were verified from the Ubuntu client.

Active Samba sessions and service logs were also checked with:

```bash
smbstatus
journalctl -u smbd
```

No relevant service errors were found.

---

## 3. Persistent Client Mount

The Ubuntu client was changed from a manual `gio mount` connection to a persistent CIFS mount configured through `/etc/fstab`.

The mount uses:

- a separate `.smbcredentials` file protected with permissions `600`;
- `_netdev`;
- `nofail`;
- `x-systemd.automount`.

After rebooting the client, the share was mounted automatically on first access at:

```text
/mnt/fileserver-shared
```

The mounted directory was also added to Nautilus favorites for easier graphical access.

---

## 4. Samba Cleanup

The Samba configuration was simplified by disabling unused printing and guest-sharing functionality:

```ini
load printers = no
usershare allow guests = no
```

The `[printers]` and `[print$]` shares were removed.

The final configuration was validated with:

```bash
testparm
smbclient
```

Only the intended `[shared]` share and the normal Samba `IPC$` service remained available.

---

## 5. Final State

The final setup now provides:

- authenticated group-based Samba access;
- persistent data storage;
- LAN-only SSH and SMB access;
- automatic CIFS mounting on the Ubuntu client;
- no guest access;
- no unused printer shares.

A final Proxmox snapshot named:

```text
samba-fileserver-final
```

was created after validation.
