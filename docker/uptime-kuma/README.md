# Uptime Kuma Docker Deployment

This directory contains the Docker Compose configuration used to deploy Uptime Kuma on `docker-prod-01`.

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
UPTIME_KUMA_HOST_IP=192.168.178.42
UPTIME_KUMA_PORT=3001
```

The real `.env` file should remain local.

## Persistent Data

Uptime Kuma stores its runtime data in:

```text
./data
```

This directory contains the application database, configuration, uploads, screenshots, and other generated data and should not be committed to Git.

## Start the Service

```bash
docker compose up -d
```

Verify the container:

```bash
docker compose ps
```

Uptime Kuma is exposed through the configured host IP and port and is used to monitor the availability of homelab services and infrastructure.

