# Proxmox Homelab Planning

## 1. Project Overview

The goal of this project is to build a small virtualization homelab using Proxmox VE.

The homelab will provide an environment where I can practice Linux system administration, networking, virtualization, storage management, backups, troubleshooting, containers, and self-hosted services.

The project is part of my preparation for the Linux Foundation Certified System Administrator (LFCS) certification and my transition from industrial mechanics toward IT support and Linux system administration.

The repository will document not only the final configuration, but also the decisions, problems, tests, mistakes, and improvements made during the project.

---

## 2. Initial Situation

The physical server was previously running Ubuntu Server 24.04 LTS directly on the hardware.

This first setup was useful for learning the basics of managing a Linux server, including:

* SSH access;
* basic command-line administration;
* disk identification and preparation;
* service management;
* Linux filesystem structure;
* basic networking;
* hardware monitoring.

Running Ubuntu Server directly on the physical hardware was appropriate for learning how to manage a single Linux system.

However, as the homelab grows, I need to create several isolated systems for different exercises and services.

Installing everything directly on one operating system would make the environment increasingly difficult to manage.

For example, different services could:

* depend on different software versions;
* use conflicting ports;
* require different network configurations;
* affect each other during experiments;
* make recovery more difficult if the host system is damaged.

For this reason, the next stage of the homelab is virtualization.

---

## 3. What Problem Virtualization Solves

Instead of using one physical server for one operating system, virtualization allows the hardware resources of the server to be divided between multiple independent virtual machines.

Conceptually:

```text
Physical Server
│
└── Hypervisor
    ├── Linux VM
    ├── Web Server VM
    ├── Docker VM
    ├── Test VM
    └── Other services
```

Each virtual machine can have its own:

* operating system;
* virtual disk;
* virtual network interface;
* CPU allocation;
* RAM allocation;
* services;
* configuration.

This makes experimentation safer.

For example, before performing a potentially destructive Linux exercise, I can create a snapshot of a virtual machine.

If I break the configuration, I can restore the previous state without reinstalling the complete physical server.

Virtualization also makes it possible to build multi-server environments even though I currently have only one dedicated physical server.

---

## 4. Project Requirements

The virtualization platform should allow me to:

* create multiple Linux virtual machines;
* create isolated environments for LFCS exercises;
* practice communication between multiple servers;
* create and restore snapshots;
* experiment without risking the entire physical server;
* manage virtual networking;
* manage different storage devices;
* create backups of virtual machines;
* allocate CPU, RAM, and disk resources;
* run containers in the future;
* manage the infrastructure remotely;
* continue learning Linux while managing the hypervisor.

Because this is a personal learning environment, another important requirement is avoiding unnecessary commercial licensing costs.

---

## 5. Virtualization Platforms Considered

Before selecting Proxmox VE, I considered several possible approaches.

The objective was not simply to find the easiest platform, but to choose one that fits both the hardware available and my Linux learning path.

### 5.1 Ubuntu Server + KVM + libvirt

One possibility was to keep Ubuntu Server installed directly on the physical machine and build the virtualization environment manually using:

* KVM;
* QEMU;
* libvirt;
* `virsh`;
* `virt-install`.

KVM provides hardware virtualization through the Linux kernel, while QEMU runs the virtual machines.

libvirt provides a management layer for virtual machines and related resources.

A simplified architecture would be:

```text
Ubuntu Server
│
├── KVM / QEMU
│
└── libvirt
    ├── virsh
    ├── virt-install
    ├── virtual networks
    └── storage pools
```

### Advantages

This solution would provide direct exposure to Linux virtualization technologies.

It would be especially useful for learning concepts such as:

* KVM;
* QEMU;
* libvirt;
* VM definitions;
* storage pools;
* virtual networks;
* Linux bridges;
* `virsh`;
* `virt-install`.

### Disadvantages

A manually managed KVM/libvirt environment requires more work to integrate and maintain the different components.

Tasks such as:

* virtual machine creation;
* storage management;
* networking;
* snapshots;
* backups;
* monitoring;

would require more manual configuration or additional tools.

This is valuable from a learning perspective, but it would also mean spending a larger part of the homelab project maintaining the virtualization platform itself.

### Decision

KVM and libvirt remain important technologies that I want to study.

However, I decided not to use a manually managed KVM/libvirt host as the main permanent homelab platform.

Instead, KVM/libvirt can be studied separately as part of my Linux virtualization learning path.

---

## 5.2 VMware

VMware is one of the most established virtualization platforms in professional and enterprise environments.

It provides mature tools for:

* virtual machines;
* networking;
* storage;
* centralized administration;
* enterprise infrastructure.

Learning VMware technologies could therefore be useful professionally.

However, for this specific homelab, VMware was not selected because the current project is intended to remain based primarily on open-source Linux technologies and should not depend on commercial licensing.

This does not mean VMware is technically inferior.

It simply does not match the current requirements of this personal Linux-focused homelab as well as Proxmox VE.

---

## 5.3 Microsoft Hyper-V

Microsoft Hyper-V is another widely used virtualization solution.

It integrates naturally with Windows and Windows Server environments and can also run Linux virtual machines.

Hyper-V would be particularly interesting for a homelab focused on:

* Windows Server;
* Active Directory;
* Microsoft infrastructure;
* Windows administration.

My current learning path, however, is focused primarily on Linux system administration.

For this reason, using a Linux-based virtualization platform provides more opportunities to continue working directly with Linux technologies.

Hyper-V may still be useful later when expanding the homelab toward Microsoft infrastructure.

---

## 5.4 XCP-ng

XCP-ng is another open-source virtualization platform and represents a valid alternative to Proxmox VE.

It is based on the Xen virtualization ecosystem and can provide centralized management of virtual machines and infrastructure.

It was considered because it also offers an open-source approach suitable for homelabs and professional virtualization environments.

However, Proxmox VE is based on technologies that align more directly with my current Linux learning path, particularly:

* Debian;
* KVM;
* QEMU;
* LXC;
* Linux networking;
* Linux storage.

For this reason, Proxmox VE was considered a better match for the current project.

---

## 6. Why Proxmox VE Was Selected

Proxmox VE was selected as the main virtualization platform for the homelab.

The decision was based on several factors.

### Linux-Based Platform

Proxmox VE is based on Debian Linux.

This is important because managing the hypervisor still provides exposure to a real Linux environment.

I can therefore continue practicing concepts such as:

* Linux commands;
* filesystems;
* services;
* networking;
* storage;
* SSH;
* logs;
* permissions.

The virtualization platform does not replace Linux learning.

It becomes another Linux system that must be understood and administered.

---

### KVM Virtualization

Proxmox VE uses KVM/QEMU for virtual machines.

This means that choosing Proxmox does not mean avoiding Linux virtualization technologies.

A simplified architecture is:

```text
Physical Hardware
│
└── Proxmox VE
    │
    ├── KVM / QEMU
    │   ├── VM 1
    │   ├── VM 2
    │   └── VM 3
    │
    └── LXC
        ├── Container 1
        └── Container 2
```

Proxmox provides its own management tools around these technologies instead of using libvirt as its main management layer.

This distinction is important.

The comparison is therefore not simply:

```text
Proxmox vs KVM
```

because Proxmox itself uses KVM.

A more accurate comparison is:

```text
KVM/QEMU managed manually through tools such as libvirt
                         vs
KVM/QEMU managed through the integrated Proxmox platform
```

---

### Integrated Management

One of the main reasons for selecting Proxmox is that several infrastructure components are managed through one platform.

This includes:

* virtual machines;
* containers;
* storage;
* virtual networking;
* snapshots;
* backups;
* resource allocation;
* monitoring.

With a manually built KVM/libvirt host, many of these functions would require separate configuration and management.

Proxmox reduces the amount of integration work without completely hiding the underlying Linux concepts.

This allows me to spend more time building and administering the systems running inside the homelab.

---

### Web Interface and Command Line

Proxmox provides a web interface for infrastructure management.

This is useful for visualizing:

* virtual machines;
* CPU and memory usage;
* storage;
* network interfaces;
* snapshots;
* backups.

However, the system can also be administered from the Linux command line.

The objective of using the web interface is therefore not to avoid the command line.

The web interface provides centralized infrastructure management, while the command line remains important for understanding and troubleshooting the system.

---

### Open-Source Approach

Another important factor is that Proxmox VE is open source.

For a personal learning environment, this makes it possible to build a complete virtualization platform without requiring a commercial hypervisor license.

Commercial subscriptions and enterprise support are available, but they are not required for building this homelab.

This fits the goal of creating a low-cost learning environment based primarily on Linux and open-source technologies.

---

### Virtual Machines and Containers

Proxmox supports both:

* KVM virtual machines;
* LXC containers.

This will allow the homelab to be expanded gradually.

Initially, I will concentrate mainly on virtual machines because they provide stronger isolation and are easier to understand while learning operating system administration.

Containers will be introduced later, after the Linux and networking foundations are stronger.

---

### Snapshots and Recovery

One of the main requirements of the project is the ability to experiment safely.

For example:

```text
Clean Linux VM
      │
      ├── Create snapshot
      │
      ↓
Perform exercise
      │
      ├── Configuration works → keep changes
      │
      └── System breaks → restore snapshot
```

This is particularly useful for LFCS exercises where system configuration may intentionally be modified or broken.

---

## 7. Why Proxmox Instead of KVM/libvirt for the Main Homelab

The decision between Proxmox and a manually managed KVM/libvirt environment is not based on one being better than the other.

They serve slightly different learning objectives.

### KVM + libvirt

Better suited for learning the individual components of Linux virtualization in greater detail.

For example:

```text
KVM
QEMU
libvirt
virsh
virt-install
storage pools
virtual networks
XML VM definitions
```

### Proxmox VE

Better suited for building and operating a complete permanent homelab infrastructure where virtualization, storage, networking, snapshots, and backups need to work together.

For this project, the main objective is:

```text
Build a complete homelab
        ↓
Create Linux servers
        ↓
Practice administration
        ↓
Practice networking
        ↓
Add services
        ↓
Test backup and recovery
```

For this reason, Proxmox VE was selected as the main platform.

KVM and libvirt will still be studied separately so that the underlying virtualization concepts are not ignored.

---

## 8. Hardware Inventory

The current dedicated server has the following hardware:

| Component               | Specification             |
| ----------------------- | ------------------------- |
| CPU                     | Intel Core i5-4440        |
| CPU cores               | 4 cores / 4 threads       |
| Clock speed             | approximately 3.1–3.3 GHz |
| Hardware virtualization | Intel VT-x enabled        |
| Memory                  | 16 GB DDR3 RAM            |
| System disk             | 256 GB SSD                |
| Main storage            | 1 TB HDD                  |
| Backup disk             | 500 GB HDD                |
| Network                 | Gigabit Ethernet          |

This is older consumer hardware, but it is sufficient for a small learning environment if resources are managed carefully.

---

## 9. Initial Storage Plan

The current storage devices have the following planned roles:

| Disk       | Planned role                                |
| ---------- | ------------------------------------------- |
| 256 GB SSD | Proxmox VE and selected VM disks            |
| 1 TB HDD   | Main data storage and additional VM storage |
| 500 GB HDD | Local backup destination                    |

This configuration is currently a plan and may change after learning more about Proxmox storage.

Before making the final decision, I need to understand:

* how Proxmox organizes storage;
* which filesystem or storage type should be used;
* where VM disks should be stored;
* which workloads benefit most from the SSD;
* how much space the Proxmox installation requires;
* how backup retention should be configured.

The SSD should provide better performance for workloads requiring frequent disk access.

The mechanical HDDs provide more capacity but lower performance.

---

## 10. Backup Considerations

The 500 GB HDD is planned as the first local backup destination.

This provides protection against problems such as:

* accidental deletion of a VM;
* configuration mistakes;
* corrupted virtual disks;
* failed experiments.

However, the backup disk is installed inside the same physical server.

For this reason, it does not protect against:

* complete server failure;
* power damage;
* theft;
* physical damage;
* failure affecting multiple disks.

Therefore, the internal 500 GB disk should be considered one layer of the backup strategy, not the final backup solution.

An external or remote backup solution may be added later.

---

## 11. Initial Homelab Architecture

The first version of the homelab should remain simple.

A possible architecture is:

```text
Home Network
     │
     │ Gigabit Ethernet
     │
┌────▼───────────────────────┐
│        Proxmox Host        │
│                            │
│  ┌─────────────────────┐   │
│  │ Linux / LFCS VM     │   │
│  └─────────────────────┘   │
│                            │
│  ┌─────────────────────┐   │
│  │ Test VM             │   │
│  └─────────────────────┘   │
│                            │
│  Future:                   │
│  Docker / services / VPN   │
│                            │
└────────────────────────────┘
             │
             │
       500 GB Backup HDD
```

The objective is not to deploy many services immediately.

The platform should first be understood and tested.

---

## 12. Planned Learning Progression

The homelab should grow gradually.

### Phase 1 — Proxmox Foundation

* install Proxmox VE;
* understand the management interface;
* configure hostname and network settings;
* understand the default storage configuration;
* verify SSH access;
* understand basic Proxmox administration.

### Phase 2 — First Virtual Machines

* create a Linux VM;
* allocate CPU and RAM;
* configure virtual disks;
* understand virtual network interfaces;
* test connectivity;
* practice VM lifecycle management.

### Phase 3 — Snapshots and Recovery

* create snapshots;
* intentionally modify or break a test VM;
* restore the previous state;
* understand when snapshots should and should not be used.

### Phase 4 — Storage and Backups

* configure the available physical disks;
* understand Proxmox storage types;
* configure the backup disk;
* create VM backups;
* perform a restore test.

A backup should not be considered reliable until a restore has been tested.

### Phase 5 — Linux Multi-Server Lab

Create multiple Linux systems for LFCS exercises.

For example:

```text
main-server
web
app
data
```

This will allow practice with:

* SSH;
* hostname resolution;
* networking;
* services;
* file transfer;
* permissions;
* storage;
* troubleshooting.

### Phase 6 — Containers and Self-Hosted Services

Only after the virtualization and Linux foundations are stable, the homelab may be expanded with technologies such as:

* Docker;
* Docker Compose;
* Portainer;
* Uptime Kuma;
* reverse proxy;
* Nextcloud;
* WireGuard;
* DNS filtering.

Security monitoring tools such as Wazuh may be introduced later after gaining stronger knowledge of Linux logs, networking, authentication, permissions, and system security.

---

## 13. Hardware Limitations

The server has enough resources for a small homelab, but the hardware has clear limitations.

### CPU

The Intel Core i5-4440 provides:

```text
4 cores
4 threads
```

This is sufficient for multiple small Linux virtual machines, but it is not suitable for running many CPU-intensive workloads at the same time.

CPU resources should therefore be allocated conservatively.

---

### Memory

The system currently has:

```text
16 GB RAM
```

Proxmox itself requires memory, and every running virtual machine also consumes RAM.

For this reason, the first Linux VMs should use relatively small allocations where possible.

For example:

```text
1 GB RAM
2 GB RAM
```

depending on the purpose of the machine.

Resources should be increased only when there is a technical reason to do so.

---

### Storage

The server contains one SSD and two mechanical HDDs.

The SSD provides better performance but has lower capacity.

The HDDs provide more capacity but have slower random disk access.

This means that VM placement should eventually consider both:

```text
capacity
and
performance
```

rather than simply storing everything on the largest disk.

---

### No Hardware Redundancy

The server does not currently provide enterprise features such as:

* redundant power supplies;
* redundant network interfaces;
* hardware RAID;
* high availability;
* multiple Proxmox nodes.

This is acceptable because the objective is learning rather than production availability.

Understanding these limitations is also part of the project.

---

## 14. Security Principles

The initial Proxmox management interface should only be accessible from the local network.

It should not be exposed directly to the public Internet.

If remote access is required later, a VPN solution should be used instead of directly exposing the Proxmox management interface.

The GitHub repository must never contain sensitive information such as:

* passwords;
* private SSH keys;
* API tokens;
* authentication cookies;
* backup encryption keys;
* secrets;
* credentials;
* private `.env` files.

Configuration files must be reviewed before they are committed to the repository.

---

## 15. Documentation Strategy

The project documentation is divided into different files according to purpose.

```text
docs/
├── 01-planning.md
└── 02-installation-log.md
```

### `01-planning.md`

This document explains:

* why the homelab is being built;
* why virtualization is required;
* which platforms were considered;
* why Proxmox VE was selected;
* available hardware;
* planned storage usage;
* project limitations;
* future learning direction.

### `02-installation-log.md`

The installation log will document what was actually done.

This will include:

* Proxmox ISO download;
* ISO checksum verification;
* bootable USB creation;
* BIOS/UEFI settings where relevant;
* installation choices;
* network configuration;
* storage configuration;
* problems encountered;
* troubleshooting;
* verification steps.

The objective is to document important technical decisions and verification steps rather than every mouse click.

---

## 16. Success Criteria

The first stage of the project will be considered successful when:

* Proxmox VE is installed successfully;
* the management interface is reachable from the local network;
* SSH administration works;
* the physical storage devices are correctly identified;
* the storage roles are understood and configured;
* at least one Linux virtual machine can be created;
* the VM has network connectivity;
* snapshots can be created and restored;
* backups can be created;
* at least one backup restore has been tested;
* the configuration and important decisions are documented in GitHub.

---

## 17. Open Decisions

The following decisions still need to be made during the installation and configuration process:

* Proxmox hostname;
* static management IP address;
* DNS configuration;
* SSD partitioning;
* Proxmox storage layout;
* VM disk location;
* backup retention policy;
* VM naming convention;
* resource allocation rules;
* network bridge configuration;
* future backup outside the physical server.

These decisions will not be made only because a default option exists.

Where possible, each choice will be documented together with the reason behind it.

