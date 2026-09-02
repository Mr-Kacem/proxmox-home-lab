# Monitoring and Push Alerts

## 1. Overview

Uptime Kuma was extended from basic availability monitoring to active push notifications.

The following homelab services are now monitored:

- Vaultwarden
- Nextcloud
- Nginx Proxy Manager
- AdGuard Home

Whenever a monitored service becomes unavailable or returns online, Uptime Kuma can notify the administrator directly on a mobile device.

---

## 2. Service Monitoring

Vaultwarden, Nginx Proxy Manager, and AdGuard Home were monitored directly through their internal HTTP endpoints.

Nextcloud initially appeared as `DOWN` because its normal URL redirects to HTTPS.

Instead, its internal status endpoint was used:

```text
http://<DOCKER_HOST_IP>:8082/status.php
```

This endpoint returns the application status directly and is therefore better suited for availability monitoring.

---

## 3. Push Notifications with ntfy

ntfy was selected as the notification channel for the Android device.

A dedicated private topic was created and connected to Uptime Kuma.

The real topic name is intentionally not documented in this repository.

Notification flow:

```text
Service
   ↓
Uptime Kuma
   ↓
ntfy
   ↓
Android device
```

A test notification confirmed that the integration was working correctly.

---

## 4. Failure and Recovery Test

A real failure test was performed with Nextcloud.

The container was intentionally stopped:

```text
Nextcloud stopped
        ↓
Uptime Kuma detected DOWN
        ↓
ntfy notification received
```

After restarting the container:

```text
Nextcloud started
        ↓
Uptime Kuma detected UP
        ↓
recovery notification received
```

This confirmed that the monitoring system detects both service failures and recoveries.

---

## 5. Final Status

| Check | Status |
|---|---|
| Vaultwarden monitoring | Working |
| Nextcloud monitoring | Working |
| Nginx Proxy Manager monitoring | Working |
| AdGuard Home monitoring | Working |
| ntfy integration | Working |
| DOWN notification | Verified |
| UP notification | Verified |

The homelab can now report service outages and recoveries automatically instead of relying only on manual checks.
