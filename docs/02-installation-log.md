# Proxmox VE Installation Log

## 1. Overview

This document records the installation of Proxmox VE on the physical server used for my homelab.

The planning, virtualization platform comparison, hardware inventory, and reasons for selecting Proxmox VE are documented separately in:

```text
docs/01-planning.md
```

This document focuses on the actual installation process, the decisions made during installation, and the first post-installation checks.

The installation was completed successfully without major errors or troubleshooting.

---

## 2. Installation Date

Proxmox VE was installed on:

```text
8 August 2026
```

---

## 3. Hardware Used

The physical server used for the installation has:

| Component      | Specification       |
| -------------- | ------------------- |
| CPU            | Intel Core i5-4440  |
| CPU cores      | 4 cores / 4 threads |
| RAM            | 16 GB DDR3          |
| System disk    | 256 GB SSD          |
| Main storage   | 1 TB HDD            |
| Backup disk    | 500 GB HDD          |
| Network        | Gigabit Ethernet    |
| Virtualization | Intel VT-x enabled  |

The 256 GB SSD was selected as the system disk for Proxmox VE.

---

## 4. Disk Preparation Before Installation

Before starting the installation, the additional storage disks were physically disconnected from the server.

Only the SSD intended for the Proxmox installation remained connected.

The purpose of this decision was simple:

```text
Prevent accidental installation or formatting of the wrong disk.
```

The disconnected drives were:

* 1 TB HDD;
* 500 GB HDD.

These disks already had planned roles in the homelab and were not required during the initial Proxmox installation.

This reduced the risk of selecting the wrong target disk during installation.

The additional disks were reconnected only after the Proxmox installation and initial configuration had been completed successfully.

---

## 5. Proxmox VE Installation Media

The Proxmox VE ISO image was downloaded from the official Proxmox website.

A bootable USB drive was then prepared using the downloaded ISO.

### ISO information

```text
ISO version: Proxmox VE 9.2 ISO Installer
Source: Official Proxmox website
```

### ISO Integrity Verification

Before using an operating system image, verifying its checksum is useful because it confirms that the downloaded file matches the file published by the vendor.

A SHA256 checksum can be calculated with:

```bash
sha256sum <proxmox-iso-file>
```

The calculated value should match the SHA256 value published by Proxmox.


### Bootable USB

The ISO was written to a USB drive and used as the installation media.

```text
USB creation method/tool: 4GB USB
```

The USB drive was then connected to the physical server.

---

## 6. Booting the Installer

The server was powered on and the motherboard boot menu was used to start the system from the Proxmox installation USB.

The important objective at this stage was to boot from:

```text
USB installation media
```

instead of the existing system disk.

The Proxmox VE graphical installer started successfully.

No boot-related errors were encountered.

---

## 7. Target Disk Selection

During installation, the 256 GB SSD was selected as the installation target.

```text
Target disk: 256 GB SSD
```

Because the other physical drives had already been disconnected, there was no possibility of accidentally selecting the planned data or backup disks.

The SSD was selected because it provides significantly better disk performance than the mechanical HDDs and is therefore suitable for:

* the Proxmox operating system;
* system files;
* frequently accessed virtualization data;
* selected VM disks.

The other drives will be configured separately after the base Proxmox installation.

---

## 8. Location and System Settings

The installer requested the regional configuration, including:

* country;
* timezone;
* keyboard layout.

The appropriate settings for the server location in Germany were selected.

These settings are important because they affect system time, logs, scheduled tasks, and keyboard input.

---

## 9. Administrative Account

During installation, a password was configured for the Proxmox administrative account.

Proxmox uses the Linux:

```text
root
```

account for the initial system administration.

This was important to understand because the login username is not a newly created personal username.

The initial administrative login therefore uses:

```text
Username: root
```

Passwords are not documented in this repository.

---

## 10. Management Network Configuration

Proxmox requires a management network configuration during installation.

The server had previously used the static IPv4 address:

```text
192.168.178.35
```

on the home network.

This address was already associated with the server in the router configuration.

For this reason, the same address was reused for the Proxmox management interface:

```text
Management IPv4: 192.168.178.35
```

Using a static management address is important because the hypervisor should always be reachable at a predictable address.

For example, a dynamically changing address would make administration unnecessarily difficult.

The Proxmox web interface can therefore be reached using:

```text
https://192.168.178.35:8006
```

Port `8006` is used by the Proxmox VE web management interface.

---

## 11. Hostname and FQDN

The Proxmox installer requires a fully qualified domain name (FQDN), not only a simple hostname.

A name using the local `home.arpa` domain was discussed during installation.

`home.arpa` is intended for naming systems inside private residential networks rather than representing a public Internet domain.

The structure is:

```text
hostname.home.arpa
```

The exact hostname configured during installation should be recorded here:

```text
FQDN: pve.home.arpa
```


It can later be verified with:

```bash
hostname
```

and:

```bash
hostname --fqdn
```

---

## 12. Installation

After reviewing the selected configuration, the Proxmox VE installation was started.

The installer:

* partitioned the selected SSD;
* installed the Proxmox VE system;
* configured the management network;
* configured the administrative account;
* installed the bootloader;
* prepared the system for the first boot.

The installation completed successfully.

No installation errors were encountered.

This is important to document as well: an installation log does not need artificial troubleshooting sections when no troubleshooting was necessary.

---

## 13. First Reboot

After the installation was completed, the system requested a reboot.

The reboot was performed.

After restarting, the server successfully booted from the SSD into Proxmox VE.

The USB installation media was no longer required.

The server remained reachable through the configured network connection after reboot.

This confirmed that the basic network configuration survived the restart correctly.

---

## 14. First Proxmox Login

After the server restarted, the Proxmox VE web interface was accessed from another computer on the same local network.

The management interface was opened using:

```text
https://192.168.178.35:8006
```

The initial login used the administrative Linux account:

```text
root
```

After authentication, the Proxmox VE management interface loaded successfully.

This confirmed that:

* Proxmox was running;
* the management IP was reachable;
* the web management service was running;
* authentication worked;
* communication between the management computer and the Proxmox server worked.

---

## 15. Initial Post-Installation Configuration

After the first successful login, the initial Proxmox configuration and package state were reviewed.

System updates were applied as part of the first post-installation configuration.

After the update process, the system indicated that a reboot was required.

The reboot was performed.

After restarting, the Proxmox server automatically became reachable again without requiring the network configuration to be entered again.

This provided an additional verification that the management network configuration was persistent and working correctly.

---

## 16. Reconnecting the Additional Storage

Once Proxmox had been installed, updated, rebooted, and verified as working correctly, the server was shut down.

The previously disconnected storage devices could then be physically reconnected:

```text
1 TB HDD
500 GB HDD
```

The server was kept powered off while reconnecting the drives.

These disks were intentionally not configured immediately.

Their purpose will first be verified before creating storage configurations in Proxmox.

The planned roles are currently:

| Disk       | Planned role                      |
| ---------- | --------------------------------- |
| 256 GB SSD | Proxmox VE + selected VM storage  |
| 1 TB HDD   | Main data / additional VM storage |
| 500 GB HDD | Local backup storage              |

These roles may still be adjusted after examining the available Proxmox storage options.

---

## 17. Installation Result

At the end of the installation process:

* Proxmox VE was installed successfully on the 256 GB SSD;
* the system booted correctly from the SSD;
* the management network was working;
* the static IP address `192.168.178.35` was reachable;
* the Proxmox web interface was accessible;
* login with the `root` administrative account worked;
* system updates were completed;
* the required reboot completed successfully;
* the server returned online after reboot;
* the additional HDDs could be reconnected safely.

No major installation problems were encountered.

---

## 18. What Was Verified

The installation was not considered complete simply because the installer reported success.

The following basic checks were also performed:

```text
Proxmox boots from SSD              → OK
Management network                 → OK
Static IP 192.168.178.35           → OK
Web interface on port 8006         → OK
Administrative login               → OK
System reboot                      → OK
Network connectivity after reboot  → OK
```

These checks confirmed that the base hypervisor installation was operational.

---

## 19. Lessons Learned

The installation introduced several important concepts.

### A hypervisor needs a stable management address

A server management interface should use a predictable IP address.

This is why the existing static address:

```text
192.168.178.35
```

was reused.

### FQDN is different from a simple hostname

Proxmox requests a fully qualified domain name during installation.

This introduced the distinction between:

```text
hostname
```

and:

```text
hostname.domain
```

and the use of `home.arpa` for local residential network naming.

### Removing unnecessary disks reduces risk

Disconnecting the two HDDs before installation prevented accidental formatting or selection of the wrong installation target.

This was a simple precaution with a clear purpose.

### Installation success is not enough

After installation, the system was also tested by:

* accessing the web interface;
* logging in;
* updating the system;
* rebooting;
* verifying that connectivity returned.

These verification steps confirm that the installed system actually works.

---

## 20. Next Steps

The base installation is now complete.

The next phase of the project is not to immediately deploy applications.

The next tasks are to understand and configure the Proxmox foundation correctly:

1. verify the two reconnected HDDs;
2. identify each disk from Proxmox/Linux;
3. understand the current Proxmox storage configuration;
4. decide the final role of each disk;
5. configure backup storage;
6. understand the default Linux bridge;
7. create the first Linux virtual machine;
8. test networking;
9. test snapshots;
10. create and restore the first backup.

Only after these foundations are understood will additional services and containers be introduced.

