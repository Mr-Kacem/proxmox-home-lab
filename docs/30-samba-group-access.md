# Samba Group-Based Access

## 1. Overview

The Samba share on `fileserver-01` was changed from single-user access to group-based access.

After rebooting the VM, the reserved IP address, data-disk mount, Samba service, and existing shared files were first verified as persistent and working correctly.

---

## 2. Linux Group Permissions

A new Linux group was created:

```text
fileshare
```

The user `hamza` was added to this group.

The shared directory:

```text
/srv/samba-data/shared
```

was then changed to group-based ownership and configured with the setgid bit.

This ensures that new files created inside the shared directory inherit the `fileshare` group automatically.

A test file confirmed the expected ownership:

```text
hamza:fileshare
```

---

## 3. Samba Access Control

The Samba share was updated from a single allowed user to the Linux group:

```ini
valid users = @fileshare
```

A temporary user named `john` was added to the group to verify that a second group member could access and write to the share.

The test succeeded, and the temporary user was removed afterward.

---

## 4. Final Status

The share is no longer tied to one individual user.

Access is now controlled through membership in the Linux `fileshare` group, while new files inherit the correct group automatically.

This provides a cleaner and more scalable permission model for future users.
