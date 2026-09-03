# Nextcloud Update Procedure

## 1. Overview

Nextcloud on `docker-prod-01` was updated from version `34.0.2` to `34.0.3`.

Before modifying the running deployment, both application-level and VM-level recovery options were prepared.

---

## 2. Pre-Update Protection

Before the update:

- the currently installed Nextcloud version was verified;
- a complete Nextcloud application backup was created;
- the remote backup copy completed successfully;
- SHA256 integrity verification completed successfully;
- a Proxmox snapshot of `docker-prod-01` was created.

This ensured that both the application data and the complete VM could be recovered if the update failed.

---

## 3. Image Update

The Nextcloud version was updated in:

- `docker/nextcloud/Dockerfile`
- `docker/nextcloud/compose.yaml`

The custom image changed from:

`nextcloud-homelab:34.0.2-apache`

to:

`nextcloud-homelab:34.0.3-apache`

The new Docker image was rebuilt while temporarily keeping the previous image as an additional rollback option.

The `app` and `cron` containers were then recreated using the new image.

---

## 4. Upgrade Verification

After restart, Nextcloud temporarily reported:

`maintenance: true`

`needsDbUpgrade: true`

The required internal upgrade was completed and verified using `occ upgrade`.

The final state was:

`version: 34.0.3`

`maintenance: false`

`needsDbUpgrade: false`

This confirmed that the application and database upgrade completed successfully.

---

## 5. Functional Validation

After the update, the following were tested successfully:

- Nextcloud web interface;
- file and folder access;
- Nextcloud mobile application;
- Uptime Kuma monitoring.

The update from Nextcloud `34.0.2` to `34.0.3` was therefore completed and validated successfully.

---

## 6. Repository Changes

The following deployment files were updated to reflect the new Nextcloud version:

- `docker/nextcloud/Dockerfile`
- `docker/nextcloud/compose.yaml`

No additional configuration files were required for this update.
