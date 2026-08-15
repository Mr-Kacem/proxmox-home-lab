# AdGuard Home Deployment

## 1. Overview

AdGuard Home was deployed on the existing Docker host:

```text
docker-prod-01 → 192.168.178.42
```

The objective was to test network-wide DNS filtering without immediately changing the DNS configuration of the entire home network.

The FRITZ!Box global DNS configuration was therefore left unchanged.

---

## 2. DNS Configuration

AdGuard Home was configured as a DNS resolver with:

```text
Upstream DNS → Quad9 via DNS-over-HTTPS
```

The first test was intentionally limited to one client:

```text
pluto → 192.168.178.22
```

Only this computer was configured temporarily to use:

```text
192.168.178.42
```

as its DNS server.

This isolated the test from the rest of the network.

---

## 3. Verification

DNS resolution through AdGuard Home was successfully confirmed.

During the test:

```text
DNS queries:     134
Blocked queries: 7
```

Web browsing continued to work correctly while filtering was active.

A reboot test also confirmed that:

```text
docker-prod-01
      ↓
Docker
      ↓
AdGuard Home
```

returned online automatically.

---

## 4. Final Network State

After testing, `pluto` was returned to the normal automatic DNS configuration provided by the FRITZ!Box.

This ensures that the PC does not depend on `docker-prod-01` being available.

The home network therefore remains unchanged globally, while AdGuard Home is installed and ready for future use.

---

## 5. Current Status

| Component                          | Status    |
| ---------------------------------- | --------- |
| AdGuard Home                       | Running   |
| DNS resolution                     | Verified  |
| DNS filtering                      | Verified  |
| Quad9 DoH upstream                 | Working   |
| Restart persistence                | Verified  |
| Global FRITZ!Box DNS               | Unchanged |
| Test client returned to normal DNS | Completed |

A new Proxmox snapshot has been taken to preserve the Docker host with both Uptime Kuma and AdGuard Home configured and tested.

