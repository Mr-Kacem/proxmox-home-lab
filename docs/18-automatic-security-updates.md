# Automatic Security Updates on docker-prod-01

## 1. Overview

Automatic Ubuntu security updates were reviewed and configured on `docker-prod-01`.

Ubuntu already had `unattended-upgrades` installed, so no custom scripts or systemd services were required.

The objective was to keep the Docker host patched automatically while preventing unexpected reboots that could interrupt Vaultwarden, Nextcloud, and the other hosted services.

---

## 2. Existing Ubuntu Update Mechanism

The existing APT timers were verified:

```text
apt-daily.timer
apt-daily-upgrade.timer
```

These timers allow Ubuntu to periodically refresh package information and execute unattended upgrades.

The configuration in:

```text
/etc/apt/apt.conf.d/20auto-upgrades
```

confirmed that automatic package-list updates and unattended upgrades were enabled.

---

## 3. Update Policy

The configuration in:

```text
/etc/apt/apt.conf.d/50unattended-upgrades
```

was reviewed.

Automatic installation is primarily limited to supported Ubuntu security updates.

The following repositories are not automatically enabled for unattended installation:

```text
-updates
-proposed
-backports
```

This keeps automatic maintenance focused on security patches instead of performing broader package upgrades without manual review.

---

## 4. Automatic Reboot Disabled

The following setting was configured:

```text
Unattended-Upgrade::Automatic-Reboot "false";
```

This prevents `docker-prod-01` from rebooting automatically after an unattended update.

If a package update requires a reboot, the restart can therefore be performed manually at an appropriate time after checking the running services.

---

## 5. Final State

| Check | Status |
|---|---|
| `unattended-upgrades` installed | Verified |
| APT automatic-update timers | Verified |
| Automatic package-list refresh | Enabled |
| Automatic security updates | Enabled |
| General Ubuntu updates | Manual |
| Proposed / backports | Manual |
| Automatic reboot | Disabled |

`docker-prod-01` now receives Ubuntu security updates automatically while service-impacting reboots remain under manual control.

This configuration applies to the Ubuntu guest itself and does not replace separate maintenance procedures for the Proxmox host or third-party software repositories.
