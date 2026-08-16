# Nginx Proxy Manager Deployment

## 1. Overview

Nginx Proxy Manager was added to `docker-prod-01` to introduce centralized reverse proxy management for the homelab.

Before deployment, the existing AdGuard Home configuration had to be adjusted to avoid a port conflict.

---

## 2. Freeing Port 80

AdGuard Home was previously exposing its Web UI on host port `80`.

Because Nginx Proxy Manager needs ports `80` and `443` for HTTP/HTTPS traffic, the AdGuard Home mapping was changed to:

```text
8080:80
```

AdGuard Home therefore remains accessible through port `8080`, while port `80` is available for the reverse proxy.

The configuration change was applied successfully and AdGuard Home remained operational.

---

## 3. Nginx Proxy Manager

Nginx Proxy Manager was deployed with Docker Compose on the existing Docker host.

The relevant exposed ports are:

| Port  | Purpose                            |
| ----- | ---------------------------------- |
| `80`  | HTTP proxy traffic                 |
| `81`  | Nginx Proxy Manager administration |
| `443` | HTTPS proxy traffic                |

Before deployment, the required ports were checked for conflicts.

The containers started successfully and the administration interface was reachable.

---

## 4. Verification

After configuration, the reverse proxy setup was tested successfully.

The resulting traffic flow is now:

```text
Client
  ↓
Nginx Proxy Manager
  ↓
Selected internal service
```

AdGuard Home and Uptime Kuma remained operational after the change.

| Check                       | Result    |
| --------------------------- | --------- |
| AdGuard Web UI on `8080`    | OK        |
| Port `80` available for NPM | OK        |
| Nginx Proxy Manager         | Running   |
| Admin interface             | Reachable |
| Reverse proxy test          | Working   |
| Existing Docker services    | Working   |

---

## 5. Snapshot

A new Proxmox snapshot of `docker-prod-01` was created successfully to preserve the verified state with:

```text
Uptime Kuma
AdGuard Home
Nginx Proxy Manager
```
