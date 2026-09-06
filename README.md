# Proxmox Home Lab

A hands-on Linux, virtualization, networking, and self hosting home lab built on repurposed hardware.

This project documents my transition from guided Linux labs to designing, operating, maintaining, and recovering a real **Proxmox VE** environment.

The focus is not simply on deploying services, but on understanding the Linux, networking, storage, virtualization, monitoring, security, backup, and recovery concepts behind them.

> **Status:** 🚧 Active development  
> **Current stage:** Proxmox infrastructure, LFCS multi server lab, Docker services, local and remote HTTPS access, monitoring, automated backups, recovery testing, and maintenance procedures operational.

---

## Project Goals

- Build practical Linux system administration experience
- Prepare for the LFCS certification
- Understand virtualization with Proxmox and KVM
- Practice Linux storage and networking
- Build isolated multi server lab environments
- Deploy and manage containerized services
- Implement monitoring and service alerts
- Build and test backup and recovery procedures
- Automate repeatable administration tasks
- Practice controlled system and container maintenance
- Document technical decisions and troubleshooting with Git

---

## Hardware

| Component | Specification |
| --- | --- |
| CPU | Intel Core i5-4440 |
| Cores / Threads | 4 / 4 |
| RAM | 16 GB DDR3 |
| System SSD | 256 GB |
| Data HDD | 1 TB |
| Backup HDD | 500 GB |
| Network | Gigabit Ethernet |
| Virtualization | Intel VT-x |

The hardware is intentionally modest and was repurposed from an older desktop system.

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
                   ┌─────────────┴─────────────┐
                   │                           │
                                 ▼                                               ▼
             LFCS Lab VMs               docker-prod-01
                   │                           │
         ┌─────────┼─────────┐      ┌──────────┼───────────────┐
         │         │         │      │          │               │
 lfcs-ubuntu-01    │   lfcs-client-01      Uptime Kuma     Nextcloud
                   │                       AdGuard Home
            lfcs-ubuntu-02                 Nginx Proxy Manager
                                           Vaultwarden
                                                │
                                                                                    ▼
                                             Tailscale
                                                │
                                                                                    ▼
                                          Mobile Clients
```

Storage is separated by purpose:

```text
256 GB SSD  → Proxmox VE and selected VM workloads
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

The lab provides a reusable environment for practicing:

- SSH
- users and permissions
- systemd
- networking
- hostname resolution
- storage
- services
- client/server communication
- troubleshooting

Clean Proxmox snapshots provide known starting points before potentially destructive exercises.

---

## Docker Services

A dedicated Ubuntu Server VM named `docker-prod-01` hosts the main container workloads.

| Service | Purpose |
| --- | --- |
| Uptime Kuma | Infrastructure and service monitoring |
| AdGuard Home | DNS filtering |
| Nginx Proxy Manager | Reverse proxy and local HTTPS |
| Vaultwarden | Self hosted password manager |
| Nextcloud | Private cloud and file storage |

Reusable and sanitized Docker configurations are stored under:

```text
docker/
├── adguard home/
├── nextcloud/
├── nginx proxy manager/
├── uptime kuma/
└── vaultwarden/
```

The repository contains deployment configuration and safe example environment files while excluding runtime data, databases, and real secrets.

---

## Local HTTPS

Internal services can be accessed through readable `home.arpa` hostnames.

Nginx Proxy Manager handles reverse proxying and HTTPS using a private homelab Certificate Authority and a wildcard certificate.

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

Private CA keys and sensitive certificate material are not stored in the repository.

---

## Remote Access with Tailscale

Tailscale provides WireGuard based private connectivity to selected services without exposing them directly to the public Internet.

Vaultwarden and Nextcloud are available to authorized mobile clients through **Tailscale Serve** and publicly trusted HTTPS certificates.

```text
Mobile Client
     │
        ▼
  Tailscale
     │
        ▼
Tailscale Serve
     │
     ├── Vaultwarden
     └── Nextcloud
```

The existing LAN access through Nginx Proxy Manager remains available independently.

Remote access has been tested over:

- home Wi-Fi
- mobile data
- Android
- iPhone
- multiple Vaultwarden accounts

No public port forwarding is required.

---

## Monitoring and Alerts

Uptime Kuma monitors the availability of the main homelab services, including:

- Vaultwarden
- Nextcloud
- Nginx Proxy Manager
- AdGuard Home

Push notifications are delivered to a mobile device through **ntfy**.

A real outage and recovery test was performed by intentionally stopping Nextcloud:

```text
Nextcloud stopped
       ↓
Uptime Kuma detects DOWN
       ↓
ntfy notification received
       ↓
Nextcloud restarted
       ↓
Uptime Kuma detects UP
       ↓
recovery notification received
```

This confirms that the monitoring chain detects both service outages and successful recoveries.

---

## Backup and Recovery

The 500 GB HDD is dedicated to local backup storage through `pve-backup`.

The project uses multiple recovery layers.

### Application-Level Backups

Vaultwarden and Nextcloud have dedicated backup procedures including:

- application and database backups
- SHA256 integrity verification
- automated execution with `systemd`
- automated retention
- real restore testing

Vaultwarden and Nextcloud backup jobs use a shared `flock` lock to prevent overlapping backup operations.

Automation files are stored under:

```text
scripts/
systemd/
```

### Full VM Backup

The complete `docker-prod-01` VM is also backed up through Proxmox.

A real restore was performed from a Proxmox VM backup and the restored environment was verified with:

- Docker
- Tailscale
- Vaultwarden
- Nextcloud

A recurring Proxmox backup job provides:

- scheduled full VM backups
- Zstandard compression
- retention
- missed-job handling

The backup procedure is therefore not only configured but proven through an actual recovery test.

The internal backup HDD remains a local recovery layer and is not considered a complete off site backup strategy.

---

## Automatic Security Updates

Ubuntu security maintenance on `docker-prod-01` uses the native `unattended-upgrades` mechanism.

The existing APT timers and configuration were inspected and verified.

The current policy automatically handles supported Ubuntu security updates while broader package updates remain under manual control.

Automatic rebooting is explicitly disabled:

```text
Unattended Upgrade::Automatic Reboot "false";
```

This prevents an unattended update from unexpectedly restarting the Docker host and interrupting its services.

Example APT configuration is stored separately in the repository.

---

## Controlled Service Maintenance

Container updates are performed deliberately instead of automatically updating every service.

The general maintenance workflow is:

```text
check current version
        ↓
verify backup / create snapshot
        ↓
update image
        ↓
recreate container
        ↓
verify application state
        ↓
test service functionality
```

This procedure has been used for:

- Nextcloud
- Vaultwarden
- Uptime Kuma

Nginx Proxy Manager and AdGuard Home were also checked during maintenance and left unchanged when no update was required.

This approach avoids unnecessary changes while keeping recovery options available before maintenance.

---

## Repository Structure

```text
.
├── docker/            # Reusable Docker deployment configurations
├── docker-prod-01/    # Host level configuration examples for the Docker VM
├── docs/              # Project documentation
├── pve/               # Sanitized Proxmox configuration examples
├── scripts/           # Backup and retention scripts
├── systemd/           # systemd services and timers
└── README.md
```

### Docker Host Configuration

Host-level Ubuntu configuration that does not belong to an individual container is kept separately.

Example:

```text
docker-prod-01/
└── apt/
    ├── 20auto-upgrades.example
    └── 50unattended-upgrades.example
```

### Proxmox Configuration Examples

The `pve/` directory contains sanitized examples of relevant Proxmox and Linux host configuration:

```text
pve/
├── fstab.example
├── interfaces.example
├── jobs.cfg.example
└── storage.cfg.example
```

These files demonstrate the actual configuration approach without unnecessarily publishing installation specific identifiers.

---

## Documentation

The project is documented progressively while the infrastructure is built, tested, maintained, and recovered.

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
├── 14-nextcloud.md
├── 15-nextcloud-backup-automation.md
├── 16-tailscale-remote-access.md
├── 17-vm-backup-recovery.md
├── 18-automatic-security-updates.md
├── 19-monitoring-alerts.md
├── 20-nextcloud-update.md
├── 21-vaultwarden-update.md
└── 22-docker-service-maintenance.md
```

The documentation records planning, implementation, validation, troubleshooting, recovery, and maintenance instead of reconstructing the project after completion.

---

## Skills Practiced

This project currently includes hands-on work with:

- Linux administration
- Proxmox VE
- KVM virtualization
- virtual machines
- Linux bridges
- block devices and filesystems
- UUIDs and `/etc/fstab`
- persistent mounts
- SSH
- Docker
- Docker Compose
- DNS
- reverse proxies
- HTTP/HTTPS
- TLS certificates
- private Certificate Authorities
- Tailscale
- monitoring and alerting
- snapshots
- application backups
- full VM backups
- backup restoration
- SHA256 integrity verification
- Bash scripting
- `flock`
- systemd services and timers
- APT unattended security updates
- controlled container maintenance
- Git and technical documentation

---

## Security and Repository Policy

Real secrets and runtime data are intentionally excluded from the repository.

Public examples are used instead of publishing:

- passwords
- real `.env` files
- private keys
- databases
- Docker runtime data
- backup archives
- private CA keys
- Tailscale authentication keys
- private notification topics

Files such as `.env.example` and sanitized `.example` configurations document how services are configured without exposing credentials or sensitive runtime information.

---

## Roadmap

### Completed

- [x] Install and validate Proxmox VE
- [x] Configure persistent data storage
- [x] Configure dedicated backup storage
- [x] Build a three-machine LFCS lab
- [x] Configure stable VM networking
- [x] Test Proxmox snapshots
- [x] Deploy a dedicated Docker host
- [x] Deploy Uptime Kuma
- [x] Deploy AdGuard Home
- [x] Deploy Nginx Proxy Manager
- [x] Configure trusted local HTTPS
- [x] Deploy Vaultwarden
- [x] Deploy Nextcloud
- [x] Automate Vaultwarden backups
- [x] Automate Nextcloud backups
- [x] Perform real application restore tests
- [x] Configure secure Tailscale remote access
- [x] Validate remote access from multiple mobile devices
- [x] Configure monitoring alerts with ntfy
- [x] Configure automatic Ubuntu security updates
- [x] Configure scheduled full VM backups
- [x] Perform a complete VM restore test
- [x] Establish controlled container update procedures

### Future

- [ ] Continue LFCS exercises
- [ ] Expand backups beyond the physical server
- [ ] Introduce centralized logging
- [ ] Introduce Ansible
- [ ] Explore isolated networks and VLANs
- [ ] Study KVM and libvirt independently from Proxmox
- [ ] Expand monitoring beyond basic availability checks

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
monitoring
backup
recovery
maintenance
```

The objective is not simply to make services work.

I want to understand how they are built, how to verify them, how to troubleshoot them when they fail, and how to recover them when something goes wrong.

This repository records that progression.

---

## Author

**Hamza Kacem**

Currently focused on Linux system administration, LFCS preparation, networking, virtualization, and home lab infrastructure.
