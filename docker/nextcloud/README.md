# Nextcloud Docker Deployment

This directory contains the Docker Compose configuration used to deploy Nextcloud on `docker-prod-01`.

The deployment consists of:

* Nextcloud Apache;
* MariaDB;
* Redis;
* Nextcloud cron;
* persistent Nextcloud data stored on a dedicated disk;
* a custom Docker image that trusts the local homelab Certificate Authority.

## Files

```text
compose.yaml     Docker Compose configuration
Dockerfile       Builds the custom Nextcloud image
db.env.example   Example database environment variables
.env.example     Example host-specific variables
```

## Configuration

Create the local environment files:

```bash
cp db.env.example db.env
cp .env.example .env
```

Replace all `CHANGE_ME` values in `db.env` with strong passwords.

Adjust `.env` for the local environment:

```bash
DOCKER_HOST_IP=192.168.178.42
NEXTCLOUD_PORT=8080
```

## Local CA Certificate

The Dockerfile expects:

```text
homelab-ca.crt
```

in this directory.

The real homelab CA certificate is intentionally not included in the repository. A local CA certificate must be provided before building the image.

Private CA keys must never be stored in this repository.

## Start the Stack

```bash
docker compose up -d
```

Check the containers with:

```bash
docker compose ps
```

Persistent Nextcloud user data is stored outside the container at:

```text
/srv/data/nextcloud/data
```
