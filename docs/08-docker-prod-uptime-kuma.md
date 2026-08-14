# Docker Host and Uptime Kuma

## 1. Overview

A dedicated VM named `docker-prod-01` was prepared as the main Docker host for self-hosted services.

The first deployed service is Uptime Kuma, used to monitor the availability of the homelab infrastructure.

---

## 2. Docker Host

`docker-prod-01` was configured with:

| Resource    | Configuration       |
| ----------- | ------------------- |
| CPU         | 2 vCPU              |
| RAM         | 4 GiB               |
| OS          | Ubuntu Server 26.04 |
| System disk | 40 GiB on SSD       |
| Data disk   | 200 GiB on HDD      |

The base system was updated and configured with:

* OpenSSH Server;
* QEMU Guest Agent;
* Docker Engine;
* Docker Compose.

Docker was installed from the official Docker repository.

The installation was verified successfully with:

```bash
docker run hello-world
```

---

## 3. Dedicated Data Disk

The additional 200 GiB virtual disk was prepared with an `ext4` filesystem and mounted at:

```text
/srv/data
```

The mount was added to `/etc/fstab` so that it remains available after reboot.

This separates:

```text
OS / Docker configuration → SSD
Persistent service data   → HDD
```

---

## 4. Uptime Kuma

The Docker Compose project was created under:

```text
/opt/docker/uptime-kuma/
```

with:

```text
compose.yaml
```

Uptime Kuma was deployed successfully using Docker Compose.

The deployment uses its embedded MariaDB database.

---

## 5. Initial Monitoring

The first monitors configured in Uptime Kuma were:

* Proxmox host via ping;
* Proxmox Web UI via HTTPS;
* `docker-prod-01`;
* FRITZ!Box at `192.168.178.1`.

All configured monitors were working correctly.

---

## 6. Startup and Persistence Test

`docker-prod-01` was configured to start automatically with the Proxmox host.

A complete reboot test was performed to verify the startup chain:

```text
Proxmox
   ↓
docker-prod-01
   ↓
Docker
   ↓
Uptime Kuma
   ↓
Monitoring operational
```

After reboot, the VM and Uptime Kuma returned online successfully.

This confirmed that the monitoring service does not require manual intervention after a normal host restart.

---

## 7. Snapshots

The VM now has two relevant snapshots:

```text
clean-install
docker-uptime-kuma
```

`clean-install` represents the initial clean system state.

`docker-uptime-kuma` represents the state after Docker and the first monitoring service were configured and verified.

---

## 8. Current Status

| Component                | Status               |
| ------------------------ | -------------------- |
| `docker-prod-01`         | Operational          |
| Dedicated data disk      | Mounted persistently |
| Docker Engine            | Working              |
| Docker Compose           | Working              |
| Uptime Kuma              | Running              |
| Infrastructure monitors  | Working              |
| Automatic VM startup     | Enabled              |
| Reboot persistence test  | Passed               |
| Post-deployment snapshot | Created              |

The first persistent Docker workload of the homelab is now operational.

