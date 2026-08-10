# Proxmox Home Lab

A hands-on Linux and virtualization home lab built on repurposed hardware.

This project documents my transition from guided Linux study environments to managing a real **Proxmox VE** server, with a focus on system administration, storage, networking, virtualization, backups, and troubleshooting.

The goal is not only to build a working home server, but to understand and document the decisions and Linux concepts behind each configuration.

> **Status:** 🚧 Work in progress 
> **Current stage:** Proxmox VE installed and additional storage configured

---

## Project Goals

The main objectives of this home lab are:

* Build practical Linux administration experience outside guided labs
* Learn how a virtualization host is installed and managed
* Understand Linux disks, filesystems, mount points, UUIDs, and `/etc/fstab`
* Create and manage virtual machines and containers
* Practice Linux networking in a controlled environment
* Build reusable environments for LFCS exercises
* Learn backup and recovery concepts
* Practice troubleshooting
* Document the complete learning process with Git and GitHub

This repository is intentionally built step by step.

The focus is not simply on getting services running, but on understanding **why each configuration is necessary and how the underlying Linux components work**.

---

## Hardware

The server is built from an older desktop PC that has been repurposed as a dedicated home lab machine.

| Component | Specification |
| --- | --- |
| CPU | Intel Core i5-4440 |
| Cores / Threads | 4 / 4 |
| Clock | 3.1 GHz – 3.3 GHz |
| RAM | 16 GB DDR3 |
| System SSD | 256 GB |
| Data HDD | 1 TB |
| Backup HDD | 500 GB |
| Network | Gigabit Ethernet |
| Virtualization | Intel VT-x enabled |

Despite its age, the hardware provides enough resources for a small virtualization environment with lightweight Linux virtual machines and containers.

---

## Software

### Proxmox Virtual Environment

**Proxmox VE** provides the virtualization platform for the home lab.

It supports:

* KVM virtual machines
* LXC containers
* Virtual networking
* Multiple storage configurations
* Snapshots
* Backups

Proxmox VE is based on Debian Linux, making the host itself useful for gaining additional exposure to Linux system administration.

---

## Storage Layout

The server currently uses three physical drives with separate purposes.

### 256 GB SSD — System

Used for:

* Proxmox VE operating system
* Proxmox installation
* Virtualization-related system storage

### 1 TB HDD — Data

Configured as additional persistent storage.

Intended for:

* Virtual machine data
* Container data
* Future services
* General home lab storage

### 500 GB HDD — Backup

Configured separately as dedicated backup storage.

Keeping backup storage separate from the main data disk is intentional and will allow backup and recovery procedures to be tested independently.

---

## Linux Storage Configuration

The two additional HDDs were prepared manually from the Linux shell.

The process included:

* Identifying the correct block devices
* Verifying that the disks contained no required data
* Creating ext4 filesystems
* Creating dedicated mount points
* Retrieving filesystem UUIDs
* Configuring persistent mounts in `/etc/fstab`
* Testing the configuration before rebooting
* Adding the mounted directories to Proxmox as storage

Filesystem UUIDs are used instead of relying only on device names such as `/dev/sdb`.

The configuration follows this basic relationship:

```text
Physical disk
    ↓
Filesystem
    ↓
UUID
    ↓
/etc/fstab
    ↓
Mount point
    ↓
Proxmox storage
```

This part of the project provided practical experience with Linux storage concepts that are also relevant to LFCS preparation.

---

## Current Architecture

```text
                    Home Network
                         │
                  Gigabit Ethernet
                         │
                         ▼
                ┌─────────────────┐
                │   Proxmox VE    │
                │                 │
                │ Intel i5-4440   │
                │ 16 GB RAM       │
                └────────┬────────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
     256 GB SSD       1 TB HDD       500 GB HDD
     Proxmox OS       Data Storage   Backup Storage
          │
          ▼
     Future VMs
     and Containers
```

The architecture will evolve as virtual machines, containers, networks, and services are added.

---

## Documentation

The project is documented progressively rather than reconstructed after completion.

Current documentation:

```text
docs/
├── 01-planning.md
├── 02-installation-log.md
└── 03-storage-configuration.md
```

### `01-planning.md`

Documents the decisions made before installation, including:

* Hardware evaluation
* Storage planning
* Hypervisor choice
* Intended purpose of the server
* Initial architecture

### `02-installation-log.md`

Documents the Proxmox VE installation process, including:

* Installation process
* Initial Proxmox configuration
* Network configuration
* First access to the Proxmox management interface
* Initial verification

### `03-storage-configuration.md`

Documents the post-installation storage configuration.

It covers the preparation and integration of the two additional HDDs:

* 1 TB data disk
* 500 GB backup disk
* ext4 filesystem creation
* Mount point creation
* Filesystem UUID identification
* Persistent configuration with `/etc/fstab`
* Mount verification
* Proxmox storage integration
* `pve-data`
* `pve-backup`

Separating storage configuration from the installation log keeps each document focused and makes individual procedures easier to understand and reproduce.

Additional documentation will be added as the lab develops.

---

## Skills Practiced

So far, this project has provided hands-on practice with:

* Linux block device identification
* Filesystem creation
* ext4 filesystems
* Mount points
* Filesystem UUIDs
* Persistent mounts with `/etc/fstab`
* Linux CLI administration
* Proxmox VE installation and basic administration
* Proxmox storage configuration
* Basic server networking
* Configuration verification
* Troubleshooting
* Technical documentation with Git

Future stages will introduce hands-on work with virtual machines, containers, dedicated lab networking, backups, recovery, and self-hosted services.

---

## Roadmap

### Completed

* [x] Evaluate available server hardware
* [x] Plan storage layout
* [x] Install Proxmox VE
* [x] Configure basic Proxmox networking
* [x] Prepare the 1 TB data disk
* [x] Configure persistent mounts
* [x] Prepare the 500 GB backup disk
* [x] Add additional storage to Proxmox

### Next Steps

* [ ] Create the first Linux virtual machine
* [ ] Configure VM templates
* [ ] Practice SSH administration
* [ ] Build a small multi-server Linux lab
* [ ] Configure dedicated lab networking
* [ ] Practice snapshots and backups
* [ ] Test VM recovery
* [ ] Create reusable LFCS practice environments
* [ ] Introduce LXC containers

### Later

* [ ] Deploy self-hosted services
* [ ] Improve the backup strategy
* [ ] Add monitoring
* [ ] Experiment with Docker
* [ ] Deploy Nextcloud
* [ ] Integrate WireGuard VPN
* [ ] Explore centralized logging
* [ ] Introduce Ansible
* [ ] Explore isolated lab networks or VLANs

The roadmap may change as the lab develops and new concepts are learned.

---

## Planned Lab Environment

One of the next goals is to build a multi-server environment that can be used for Linux administration exercises.

For example:

```text
              Proxmox VE
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
      web        app       data
    Linux VM   Linux VM   Linux VM
```

These systems will provide an isolated environment for practicing tasks such as:

* SSH
* Users and groups
* Services
* systemd
* Storage
* Networking
* Firewalls
* Web servers
* File sharing
* Troubleshooting

Experiments can therefore be performed inside the virtual environment without unnecessarily modifying the Proxmox host itself.

---

## Backup Strategy

The 500 GB HDD is kept separate from the primary data disk and is dedicated to backups.

Future work will include:

* VM backups
* Backup scheduling
* Restore testing
* Snapshot vs. backup comparison
* Recovery procedures

Backup configuration will be documented once these procedures are implemented and tested.

---

## Why I Built This Project

My professional background is in industrial mechanics, and I am currently transitioning toward IT infrastructure and Linux system administration.

After studying Linux fundamentals and working through LFCS preparation labs, I wanted an environment where I could make real infrastructure decisions instead of only following predefined exercises.

Repurposing existing hardware into a Proxmox server gives me a platform where I can:

1. learn a concept,
2. implement it,
3. break it,
4. troubleshoot it,
5. rebuild it,
6. document what happened.

This repository records that process.

The objective is not to present a perfectly finished infrastructure, but to document my progression from Linux fundamentals toward practical system administration.

---

## Repository Philosophy

Configurations in this repository should be explainable.

I intentionally avoid adding scripts, automation, or infrastructure components that I cannot yet understand and troubleshoot manually.

Automation will be introduced progressively after the underlying manual administration process is understood.

This repository is therefore both a technical project and a record of my learning process.

---

## Disclaimer

This repository documents a personal learning environment.

Configurations are designed for a private home lab and should not automatically be considered production-ready.

---

## Author

**Hamza Kacem**

Industrial Mechanic transitioning into IT infrastructure and Linux system administration.

Currently focused on:

* Linux
* LFCS
* System Administration
* Networking
* Proxmox
* Home Lab Infrastructure
