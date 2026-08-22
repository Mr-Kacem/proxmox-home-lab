# Nginx Proxy Manager Docker Deployment

This directory contains the Docker Compose configuration used to deploy Nginx Proxy Manager on `docker-prod-01`.

## Files

```text
compose.yaml    Docker Compose configuration
.env.example    Example host and port configuration
```

## Configuration

Create the local environment file:

```bash
cp .env.example .env
```

Example values:

```bash
NPM_HOST_IP=192.168.178.42
NPM_HTTP_PORT=80
NPM_HTTPS_PORT=443
NPM_ADMIN_PORT=81
```

The real `.env` file should remain local and should not be committed.

## Persistent Data

Nginx Proxy Manager stores runtime data in:

```text
./data
./letsencrypt
```

These directories contain generated configuration, database data, certificates, and keys.

## Start the Service

```bash
docker compose up -d
```

Verify the container:

```bash
docker compose ps
```

The administration interface is available on the configured host IP and admin port.
