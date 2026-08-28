# Tailscale Remote Access

## 1. Overview

Tailscale was introduced to provide secure mobile access to Vaultwarden and Nextcloud without exposing either service directly to the Internet.

The change was initially required because Bitwarden Android did not trust the private homelab CA as expected, even though the certificate itself was valid.

Tailscale provides:

* WireGuard-based private connectivity;
* MagicDNS;
* publicly trusted HTTPS certificates;
* access from Wi-Fi and mobile networks;
* no public port forwarding.

---

## 2. Tailscale Setup

Tailscale was installed on:

```text
docker-prod-01
Samsung Android device
```

Both devices were joined to the same Tailnet and connectivity was verified.

MagicDNS and Tailscale HTTPS certificates were enabled.

---

## 3. Vaultwarden

Vaultwarden keeps its existing LAN binding:

```text
192.168.178.42:8081
```

and now also listens locally on:

```text
127.0.0.1:8081
```

This provides two independent paths:

```text
LAN
 ↓
Nginx Proxy Manager
 ↓
vaultwarden.home.arpa
 ↓
Vaultwarden
```

and:

```text
Tailscale
 ↓
HTTPS / Tailscale Serve
 ↓
127.0.0.1:8081
 ↓
Vaultwarden
```

Bitwarden Android was configured with the Tailscale HTTPS endpoint and successfully tested over both Wi-Fi and mobile data.

---

## 4. Nextcloud

After the Samsung was returned to DHCP, `nextcloud.home.arpa` was no longer resolved because the phone was no longer using AdGuard Home.

Nextcloud was therefore also made available through Tailscale.

A second binding was added:

```text
192.168.178.42:8082 → existing LAN access
127.0.0.1:8082      → Tailscale Serve
```

The Tailscale hostname was added to Nextcloud's trusted domains.

Tailscale Serve exposes Nextcloud through a separate HTTPS port:

```text
Tailscale HTTPS :8443
        ↓
127.0.0.1:8082
        ↓
Nextcloud
```

Browser access and the Nextcloud Android application were both successfully tested.

---

## 5. Troubleshooting

Two issues were encountered.

### Docker permissions

`docker compose` initially failed with:

```text
permission denied while trying to connect to the Docker API
```

The configuration was successfully applied using the required privileges.

### Tailscale hostname

The Tailscale hostname initially appeared unreachable.

Connectivity through the Tailscale IP confirmed that the VPN itself was working.

The cause was a hostname typo. After correcting it, HTTPS worked normally.

---

## 6. Mobile Network Cleanup

The Samsung previously used a manually configured IPv4 address and AdGuard DNS.

A DHCP reservation was configured on the FRITZ!Box instead:

```text
Samsung → 192.168.178.24
```

The phone was returned to DHCP and continued receiving the reserved address.

AdGuard Home is intentionally not distributed as the global LAN DNS because `docker-prod-01` does not need to remain powered on continuously.

IPv6 connectivity was also verified successfully.

---

## 7. Final Architecture

```text
Vaultwarden
Tailscale HTTPS
      ↓
Tailscale Serve
      ↓
127.0.0.1:8081
      ↓
Vaultwarden
```

```text
Nextcloud
Tailscale HTTPS :8443
      ↓
Tailscale Serve
      ↓
127.0.0.1:8082
      ↓
Nextcloud
```

Both services are now accessible from the Android device inside or outside the home network without buying a public domain or exposing the services directly to the Internet.

After rebooting and confirming that both services were working correctly through Tailscale, a Proxmox snapshot was created to preserve the validated state.
