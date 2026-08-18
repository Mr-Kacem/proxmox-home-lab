# Vaultwarden Deployment

## 1. Overview

Vaultwarden was deployed on the existing Docker host:

```text
docker-prod-01 → 192.168.178.42
```

The container runs through Docker Compose and exposes the service internally on:

```text
192.168.178.42:8081 → 80/tcp
```

Container health was verified successfully.

---

## 2. Reverse Proxy

A new proxy host was added to Nginx Proxy Manager:

```text
https://vaultwarden.home.arpa
```

The existing homelab wildcard certificate was reused and HTTPS access was verified successfully.

The resulting path is:

```text
Browser
   ↓ HTTPS
Nginx Proxy Manager
   ↓
Vaultwarden
```

---

## 3. Functional Verification

The Vaultwarden web interface was tested and the initial account setup completed successfully.

The service was then checked from both the user side and the Docker host.

Verification included:

* successful web access;
* login and password storage tests;
* container health status;
* data persistence checks;
* checksum comparison during integrity verification.

After the final checks, the Vaultwarden container returned to:

```text
healthy
```

---

## 4. Snapshot

After confirming the working configuration, a Proxmox snapshot was created to preserve the current state of `docker-prod-01`.

This provides a recovery point after the completed Vaultwarden deployment.

---

## 5. Current Status

| Component               | Status   |
| ----------------------- | -------- |
| Vaultwarden container   | Healthy  |
| Persistent data         | Verified |
| `vaultwarden.home.arpa` | Working  |
| HTTPS                   | Verified |
| Account/login test      | Passed   |
| Integrity checks        | Passed   |
| Proxmox snapshot        | Created  |

Vaultwarden is now operational as the first password-management service hosted in the homelab.

