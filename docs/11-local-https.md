# Local HTTPS with Nginx Proxy Manager

## 1. Overview

The existing reverse proxy setup was extended with trusted HTTPS for local services.

The two services now use:

```text
https://kuma.home.arpa
https://adguard.home.arpa
```

through Nginx Proxy Manager.

---

## 2. Local Certificate Authority

A private Certificate Authority named:

```text
Home Lab Root CA
```

was created for the homelab.

A wildcard server certificate was then issued for:

```text
*.home.arpa
```

This allows the same certificate to protect multiple internal services under the `home.arpa` domain.

---

## 3. Reverse Proxy HTTPS

The wildcard certificate was imported into Nginx Proxy Manager and assigned to the existing proxy hosts for:

```text
kuma.home.arpa
adguard.home.arpa
```

`Force SSL` was enabled so HTTP requests are automatically redirected to HTTPS.

Both services remained accessible and operational after the change.

---

## 4. Verification

The certificates were verified directly from the browser.

The checks confirmed:

```text
Subject / SAN:	 *.home.arpa
Issuer:       	 Home Lab Root CA
CA:           	 FALSE
Usage:        	 Server Authentication
```

Both Uptime Kuma and AdGuard Home successfully use the same wildcard certificate.

The final access path is therefore:

```text
Browser
   ↓ HTTPS
Nginx Proxy Manager
   ↓
Uptime Kuma / AdGuard Home
```

---

## 5. Current Status

| Component                          | Status   |
| ---------------------------------- | -------- |
| Local Root CA                      | Working  |
| Wildcard `*.home.arpa` certificate | Working  |
| `kuma.home.arpa` HTTPS             | Verified |
| `adguard.home.arpa` HTTPS          | Verified |
| HTTP → HTTPS redirect              | Verified |
| Browser certificate validation     | Verified |

The local services can now be accessed through readable hostnames using trusted HTTPS instead of direct IP addresses and ports.
A snapshot of the working configuration was taken.
