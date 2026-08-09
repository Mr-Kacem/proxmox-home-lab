# Proxmox VE Storage Configuration

## 1. Overview

After completing the base Proxmox VE installation, the next step was to configure the two additional physical hard drives installed in the server.

The server currently contains:

| Disk       | Planned role                                    |
| ---------- | ----------------------------------------------- |
| 256 GB SSD | Proxmox VE system and selected VM storage       |
| 1 TB HDD   | Main data and additional virtualization storage |
| 500 GB HDD | Local backup storage                            |

The two HDDs had intentionally been disconnected during the initial Proxmox installation to prevent accidentally formatting the wrong disk.

After confirming that Proxmox was installed and working correctly, the server was powered off and the HDDs were reconnected.

This document records their preparation and integration into Proxmox VE.

---

## 2. Storage Goals

The two HDDs have different purposes.

### 1 TB HDD

The 1 TB disk is intended to provide additional general-purpose storage for the homelab.

The Proxmox storage name selected for this disk is:

```text
pve-data
```

Its mount point is:

```text
/mnt/pve-data
```

### 500 GB HDD

The 500 GB disk is intended primarily for local Proxmox backups.

The Proxmox storage name selected for this disk is:

```text
pve-backup
```

Its mount point is:

```text
/mnt/pve-backup
```

Keeping data storage and backup storage on separate physical disks provides a basic level of separation between active workloads and their backups.

However, both disks are still located inside the same physical server, so this is not a complete backup strategy.

---

## 3. Identifying the Physical Disks

Before formatting anything, the available disks were inspected and identified.

This was an important step because Linux device names such as:

```text
/dev/sda
/dev/sdb
/dev/sdc
```

identify block devices, but selecting the wrong device before formatting could destroy data.

The two additional disks were identified as:

```text
/dev/sdc1 → 1 TB HDD
/dev/sdb1 → 500 GB HDD
```

Both disks were verified before being prepared for use.

### Important note about device names

Names such as:

```text
/dev/sdb1
```

and:

```text
/dev/sdc1
```

should not be treated as permanent identifiers.

Linux may assign device letters differently depending on hardware detection and boot order.

For persistent mounting, filesystem UUIDs were therefore used instead of relying on `/dev/sdX` names.

---

# 4. Configuring the 1 TB Data Disk

## 4.1 Filesystem

The 1 TB partition was formatted using the `ext4` filesystem.

The filesystem label assigned to it was:

```text
pve-data
```

After formatting, the partition had:

```text
Device: /dev/sdc1
Filesystem: ext4
Label: pve-data
UUID: 87d628bb-61a0-4419-8962-90d6b820e9a9
```

### Why ext4?

For this first storage configuration, `ext4` provides a simple and well-supported Linux filesystem.

The objective at this stage is to understand:

* disks;
* partitions;
* filesystems;
* mounting;
* persistent mounts;
* Proxmox storage integration;

before introducing more complex storage technologies.

---

## 4.2 Creating the Mount Point

A filesystem must be attached to the Linux directory tree before files can be stored on it.

The mount point selected for the disk was:

```text
/mnt/pve-data
```

Conceptually:

```text
Physical HDD
    │
    ↓
/dev/sdc1
    │
    ↓
ext4 filesystem
    │
    ↓
/mnt/pve-data
```

The directory `/mnt/pve-data` therefore becomes the location through which Linux accesses the filesystem stored on the physical disk.

---

## 4.3 Persistent Mount with `/etc/fstab`

Mounting a filesystem manually works only until the system is rebooted unless persistent mounting is configured.

For this reason, the disk was added to:

```text
/etc/fstab
```

Instead of using:

```text
/dev/sdc1
```

the filesystem UUID was used.

The UUID of `pve-data` is:

```text
87d628bb-61a0-4419-8962-90d6b820e9a9
```

Using the UUID makes the configuration independent of the `/dev/sdX` name assigned during boot.

This means that even if the disk were detected as another device name in the future, Linux could still identify the correct filesystem.

---

## 4.4 Testing the Configuration

After modifying `/etc/fstab`, the configuration was tested before relying on it.

The mount configuration was checked using:

```bash
mount -a
```

### Why `mount -a`?

`mount -a` attempts to mount the filesystems defined in `/etc/fstab`.

Running it immediately after editing the file is useful because syntax or configuration problems can be discovered before the next reboot.

The mounted filesystem was then checked using tools such as:

```bash
findmnt
```

and:

```bash
df
```

These checks confirmed that the 1 TB filesystem was correctly mounted at:

```text
/mnt/pve-data
```

---

## 4.5 Adding the Disk to Proxmox

Mounting a disk in Linux does not automatically make it a Proxmox storage resource.

There are therefore two separate layers:

```text
Linux
  │
  └── mounts disk at /mnt/pve-data
                  │
                  ↓
              Proxmox VE
                  │
                  └── registers directory as storage
```

The mounted directory was registered in Proxmox with the storage ID:

```text
pve-data
```

The storage was configured to support the required Proxmox content, including:

* Disk image;
* Container;
* ISO image;
* Container template.

This means that the physical 1 TB disk can now be used by Proxmox for several types of virtualization data.

---

# 5. Configuring the 500 GB Backup Disk

After successfully configuring the 1 TB disk, the same basic Linux storage concepts were applied to the 500 GB HDD.

---

## 5.1 Filesystem

The 500 GB partition was formatted using:

```text
ext4
```

with the filesystem label:

```text
pve-backup
```

The resulting filesystem information was:

```text
Device: /dev/sdb1
Filesystem: ext4
Label: pve-backup
UUID: 58657f98-3ec6-42df-aa9b-43ac047627bc
```

---

## 5.2 Creating the Mount Point

The mount point selected for the backup disk was:

```text
/mnt/pve-backup
```

The relationship is therefore:

```text
500 GB HDD
    │
    ↓
/dev/sdb1
    │
    ↓
ext4 filesystem
    │
    ↓
/mnt/pve-backup
```

---

## 5.3 Persistent Mount

The backup filesystem was also added to:

```text
/etc/fstab
```

using its UUID:

```text
58657f98-3ec6-42df-aa9b-43ac047627bc
```

rather than relying permanently on:

```text
/dev/sdb1
```

This allows Linux to identify the correct filesystem independently of the device letter assigned during boot.

---

## 5.4 Adding the Backup Storage to Proxmox

After mounting the filesystem at:

```text
/mnt/pve-backup
```

the directory was registered as a Proxmox storage resource named:

```text
pve-backup
```

Its intended purpose is to store local backups of virtual machines and containers.

The storage architecture is therefore now approximately:

```text
Physical Server
│
├── 256 GB SSD
│   └── Proxmox VE
│
├── 1 TB HDD
│   └── /mnt/pve-data
│       └── Proxmox storage: pve-data
│
└── 500 GB HDD
    └── /mnt/pve-backup
        └── Proxmox storage: pve-backup
```

---

# 6. Understanding the Linux and Proxmox Storage Layers

An important lesson from this configuration was that adding physical storage to Proxmox involves several different layers.

The complete process can be represented as:

```text
Physical disk
      │
      ↓
Partition
      │
      ↓
Filesystem
      │
      ↓
Linux mount point
      │
      ↓
Persistent /etc/fstab entry
      │
      ↓
Proxmox storage definition
```

For example:

```text
1 TB HDD
   ↓
/dev/sdc1
   ↓
ext4
   ↓
/mnt/pve-data
   ↓
/etc/fstab
   ↓
pve-data in Proxmox
```

The Proxmox GUI does not replace the Linux storage layer underneath it.

The physical disk must first be correctly understood and prepared at the operating system level before Proxmox can use the mounted directory as virtualization storage.

---


# 7. Why the Backup Disk Is Separate

The 500 GB HDD was assigned specifically to backup storage instead of using the same filesystem as the main data disk.

This provides separation between:

```text
active data
```

and:

```text
backup data
```

For example, a future VM could reside on the SSD or 1 TB storage while its Proxmox backup is stored on the 500 GB disk.

However, this has an important limitation.

All three disks are located inside the same physical server.

Therefore, this configuration can help against some problems such as:

* accidentally deleting a VM;
* damaging a VM configuration;
* corrupting a virtual disk;
* needing to restore a previous backup.

It does not protect against:

* theft of the complete server;
* fire;
* major electrical damage;
* catastrophic hardware failure affecting the system;
* physical destruction of the server.

For this reason, `pve-backup` should be considered the first local backup layer rather than the final backup strategy.

---

# 8. Final Storage Layout

At the end of the configuration, the server storage layout is:

| Physical disk | Filesystem             | Mount point       | Proxmox role                     |
| ------------- | ---------------------- | ----------------- | -------------------------------- |
| 256 GB SSD    | Proxmox system storage | Proxmox system    | Hypervisor + selected VM storage |
| 1 TB HDD      | ext4                   | `/mnt/pve-data`   | `pve-data`                       |
| 500 GB HDD    | ext4                   | `/mnt/pve-backup` | `pve-backup`                     |

The two additional filesystems use persistent UUID-based mounts through `/etc/fstab`

---

# 9. Verification

The important checks performed during the configuration included:

```text
1 TB disk identified             → OK
1 TB filesystem created          → OK
pve-data label                   → OK
/mnt/pve-data mount              → OK
Persistent fstab entry           → OK
mount -a test                    → OK
findmnt / df verification        → OK
pve-data registered in Proxmox   → OK

500 GB disk identified           → OK
500 GB filesystem created        → OK
pve-backup label                 → OK
/mnt/pve-backup mount            → OK
Persistent fstab entry           → OK
mount -a test                    → OK
findmnt / df verification        → OK
pve-backup registered in Proxmox → OK
```

No significant problems were encountered during the storage configuration.

---

# 10. Lessons Learned

## A disk is not immediately usable storage

A physical HDD must pass through several layers before applications can use it:

```text
disk → partition → filesystem → mount → application/storage configuration
```

This distinction is fundamental to Linux storage administration.

---

## A mount point is only a directory

A path such as:

```text
/mnt/pve-data
```

does not itself represent a disk.

It is a directory where Linux attaches the filesystem stored on the disk.

---

## `/etc/fstab` makes mounts persistent

A manually mounted filesystem does not automatically remain mounted after reboot.

The `/etc/fstab` configuration tells Linux which filesystems should be mounted persistently.

---

## UUIDs are preferable to `/dev/sdX` for persistent mounts

Device names can change.

Filesystem UUIDs provide a more reliable way to identify the correct filesystem during boot.

---

## Linux storage and Proxmox storage are related but different

Mounting `/mnt/pve-data` makes the storage available to Linux.

Registering `pve-data` makes that mounted storage available for Proxmox virtualization purposes.

Both steps are necessary.

---

## Verification matters

After editing a critical file such as:

```text
/etc/fstab
```

the configuration should be tested rather than assuming that it is correct.

Commands such as:

```bash
mount -a
findmnt
df
```

help verify that the configuration behaves as expected before the system is rebooted.

---

# 11. Current Status

The storage preparation phase is now complete.

The Proxmox server has:

```text
Proxmox system storage
+
1 TB pve-data storage
+
500 GB pve-backup storage
```

The next stage of the homelab can therefore move from physical storage preparation toward using the virtualization platform itself.

Future work will include:

* understanding the existing Proxmox network bridge;
* preparing installation media for a guest operating system;
* creating the first Linux virtual machine;
* assigning appropriate CPU, RAM, disk, and networking resources;
* verifying VM network connectivity;
* testing snapshots;
* creating the first real Proxmox backup;
* performing a backup restore test.

