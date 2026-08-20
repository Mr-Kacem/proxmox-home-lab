# Nextcloud Deployment and Validation

## 1. Overview

Nextcloud was deployed on the existing Docker host `docker-prod-01`.

The service uses the dedicated data storage already attached to the VM and is accessed through the existing local reverse proxy and HTTPS infrastructure.

---

## 2. Persistent Storage

Nextcloud data is stored on the dedicated 200 GiB virtual data disk rather than on the VM system disk.

The usable capacity is approximately:

```text
196 GiB
```

This storage can be expanded later if required by enlarging the virtual disk and subsequently extending the filesystem inside the VM.

---

## 3. Functional Test

The installation was tested through the Nextcloud web interface.

Verification included:

* successful login;
* file upload;
* storage persistence;
* video playback directly from Nextcloud.

A larger media file was intentionally used as a practical test instead of relying only on the container status.

---

## 4. Reboot Persistence Test

`docker-prod-01` was rebooted after the initial deployment.

After startup:

```text
docker-prod-01
      ↓
Docker
      ↓
Nextcloud
      ↓
existing data still available
      ↓
video playback successful
```

This confirmed that both the service and its persistent data survive a normal VM reboot.

---

## 5. Nextcloud Maintenance

The Nextcloud administration overview was reviewed after deployment.

Recommended maintenance operations, including the available expensive migrations, were executed.

These migrations are maintenance tasks required after particular application/database changes; they are not operations that must be repeated at every server startup.

Remaining administration warnings were reviewed separately from the basic functionality test.

---

## 6. Current Status

| Check                | Status    |
| -------------------- | --------- |
| Nextcloud deployment | Working   |
| Web access           | Working   |
| Persistent storage   | Verified  |
| File upload          | Verified  |
| Video playback       | Verified  |
| VM reboot recovery   | Verified  |
| Expensive migrations | Completed |

Nextcloud is now operational as a persistent self-hosted cloud service in the homelab.

A snapshot was also taken.
