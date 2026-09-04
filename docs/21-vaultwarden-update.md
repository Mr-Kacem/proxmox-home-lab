# Vaultwarden Update Procedure

## 1. Overview

Vaultwarden on `docker-prod-01` was updated from version `1.37.0` to `1.37.2`.

The update was performed with a Proxmox snapshot available as a rollback point before modifying the running deployment.

---

## 2. Pre-Update Protection

Before the update:

- the running Vaultwarden version was verified;
- a Proxmox snapshot of `docker-prod-01` was created.

This provided a recovery point in case the container update caused unexpected problems.

---

## 3. Container Update

The Vaultwarden image tag in:

`docker/vaultwarden/compose.yaml`

was changed from:

`vaultwarden/server:1.37.0`

to:

`vaultwarden/server:1.37.2`

The Docker Compose configuration was verified, the new image was downloaded, and the Vaultwarden container was recreated.

Persistent Vaultwarden data and configuration remained unchanged during the process.

---

## 4. Validation

After the update, the following checks were completed successfully:

- Vaultwarden version `1.37.2` confirmed;
- container status `healthy`;
- web interface accessible;
- Bitwarden mobile application connected and working correctly.

Vaultwarden was therefore successfully updated from `1.37.0` to `1.37.2` and returned to normal operation.
