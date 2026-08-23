# Proxmox Home Lab

A hands on Linux, virtualization, and self hosting home lab built on repurposed hardware.

This project documents my transition from guided Linux labs to designing and managing a real **Proxmox VE** environment.

The focus is not only on deploying services, but on understanding the Linux, networking, storage, virtualization, and recovery concepts behind them.

> **Status:** 🚧 Active development
> **Current stage:** Proxmox host, LFCS multi server lab, Docker services, monitoring, local HTTPS, and backup automation operational

---

## Goals

* Build practical Linux system administration experience
* Prepare for the LFCS certification
* Understand virtualization with Proxmox and KVM
* Practice Linux storage and networking
* Build isolated multi server lab environments
* Deploy and manage containerized services
* Implement snapshots, backups, and restore procedures
* Automate repeatable administration tasks
* Document technical decisions and troubleshooting with Git

---

## Hardware

| Component       | Specification      |
| --------------- | ------------------ |
| CPU             | Intel Core i5 4440 |
| Cores / Threads | 4 / 4              |
| RAM             | 16 GB DDR3         |
| System SSD      | 256 GB             |
| Data HDD        | 1 TB               |
| Backup HDD      | 500 GB             |
| Network         | Gigabit Ethernet   |
| Virtualization  | Intel VT x         |

The hardware is intentionally modest and repurposed from an older desktop system.

---

## Current Architecture

```text
                         Home Network
                              │
                              ▼
                       ┌─────────────┐
                       │ Proxmox VE  │
                       └──────┬──────┘
                              │
                ┌─────────────┴──────────────┐
                │                            │
                ▼                            ▼
          LFCS Lab VMs                docker-prod-01
                │                            │
      ┌─────────┼─────────┐        ┌─────────┼───────────────┐
      │         │         │        │         │               │
 Ubuntu-01  Ubuntu-02   Client   Uptime   AdGuard        Nextcloud
                                 Kuma      Home
                                            │
                                            ├── Nginx Proxy Manager
                                            └── Vaultwarden
```

Storage is separated between:

```text
256 GB SSD  → Proxmox and selected VM workloads
1 TB HDD    → VM and persistent service data
500 GB HDD  → local backup storage
```

---

## LFCS Lab

A three-machine Ubuntu Server environment is available for Linux administration exercises:

```text
lfcs-ubuntu-01
lfcs-ubuntu-02
lfcs-client-01
```

The lab supports practice with:

* SSH
* users and permissions
* systemd
* networking
* hostname resolution
* storage
* services
* troubleshooting
* client/server communication

Clean Proxmox snapshots provide reusable starting points for exercises.

---

## Docker Services

A dedicated Ubuntu VM named `docker-prod-01` hosts the current container workloads.

| Service             | Purpose                               |
| ------------------- | ------------------------------------- |
| Uptime Kuma         | Infrastructure and service monitoring |
| AdGuard Home        | DNS filtering                         |
| Nginx Proxy Manager | Reverse proxy                         |
| Vaultwarden         | Self-hosted password manager          |
| Nextcloud           | Private cloud and file storage        |

Public, reusable Docker configurations are stored under:

```text
docker/
├── adguard-home/
├── nextcloud/
├── nginx-proxy-manager/
├── uptime-kuma/
└── vaultwarden/
```

Each service directory contains the relevant Docker Compose configuration and example environment files without production secrets.

---

## Local HTTPS

Internal services are accessed through readable `home.arpa` hostnames.

Nginx Proxy Manager handles reverse proxying and HTTPS.

A private homelab Certificate Authority and wildcard certificate are used for trusted local TLS connections.

Example:

```text
Browser
   │
   │ HTTPS
   ▼
Nginx Proxy Manager
   │
   ├── Uptime Kuma
   ├── AdGuard Home
   ├── Vaultwarden
   └── Nextcloud
```

Private CA keys and sensitive certificate material are not stored in this repository.

---

## Backup and Recovery

The 500 GB HDD is dedicated to local backups.

The project currently includes:

* persistent Proxmox backup storage
* VM snapshots
* restore testing
* Vaultwarden application backups
* SHA256 integrity verification
* automated backup execution with `systemd`
* automated backup retention

Automation files are available under:

```text
scripts/
systemd/
```

The local backup disk protects against several logical failures, but it is not considered a complete off site backup strategy.

---

## Repository Structure

```text
.
├── docker/      # Reusable Docker configurations
├── docs/        # Project documentation
├── scripts/     # Administration and backup scripts
├── systemd/     # systemd services and timers
└── README.md
```

### Documentation

```text
docs/
├── 01-planning.md
├── 02-installation-log.md
├── 03-storage-configuration.md
├── 04-host-validation.md
├── 05-first-vm-lfcs.md
├── 06-lfcs-lab-expansion.md
├── 07-lfcs-lab-validation.md
├── 08-docker-prod-uptime-kuma.md
├── 09-adguard-home.md
├── 10-nginx-proxy-manager.md
├── 11-local-https.md
├── 12-vaultwarden.md
├── 13-vaultwarden-backup-automation.md
└── 14-nextcloud.md
```

The documentation is written progressively while the infrastructure is built rather than reconstructed afterward.

---

## Skills Practiced

This project currently includes hands on work with:

* Linux administration
* Proxmox VE
* KVM virtualization
* Linux bridges
* virtual machines
* block devices and filesystems
* UUIDs and `/etc/fstab`
* persistent mounts
* SSH
* Docker
* Docker Compose
* DNS
* reverse proxies
* HTTP/HTTPS
* TLS certificates
* monitoring
* snapshots
* backups and restores
* Bash scripting
* systemd services and timers
* Git and technical documentation

---

## Roadmap

### Completed

* [x] Install and validate Proxmox VE
* [x] Configure persistent storage
* [x] Configure dedicated backup storage
* [x] Build LFCS multi server lab
* [x] Configure stable VM networking
* [x] Test snapshots
* [x] Deploy dedicated Docker host
* [x] Deploy Uptime Kuma
* [x] Deploy AdGuard Home
* [x] Deploy Nginx Proxy Manager
* [x] Configure local HTTPS
* [x] Deploy Vaultwarden
* [x] Automate Vaultwarden backups
* [x] Deploy Nextcloud
* [x] Test persistent Nextcloud storage

### Future

* [ ] Expand backup strategy beyond the physical server
* [ ] Continue LFCS exercises
* [ ] Improve monitoring
* [ ] Explore centralized logging
* [ ] Introduce Ansible
* [ ] Explore isolated networks / VLANs
* [ ] Study KVM and libvirt independently from Proxmox

---

## Why I Built This Project

My professional background is in industrial mechanics, and I am transitioning toward IT infrastructure and Linux system administration.

After learning Linux fundamentals through structured labs, I wanted an environment where I had to make real decisions about:

```text
hardware
storage
networking
virtualization
services
security
backup
recovery
```

The objective is to be able to explain and troubleshoot every major component rather than simply deploy software.

This repository records that progression.

---

## Author

**Hamza Kacem**

Currently focused on Linux system administration, LFCS preparation, networking, virtualization, and home lab infrastructure.

