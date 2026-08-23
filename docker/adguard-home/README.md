# AdGuard Home Docker Deployment

This directory contains the Docker Compose configuration used to deploy AdGuard Home on `docker-prod-01`.

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
ADGUARD_HOST_IP=192.168.178.42
ADGUARD_SETUP_PORT=3000
ADGUARD_WEB_PORT=8080
```

The real `.env` file should remain local.

## Persistent Data

AdGuard Home stores its runtime configuration and data in:

```text
./conf
./work
```

These directories should remain local and should not be committed to Git because they may contain generated data and environment-specific configuration.

## Start the Service

```bash
docker compose up -d
```

Verify the container:

```bash
docker compose ps
```

AdGuard Home provides DNS filtering on port `53` and its web interface through the configured web port.
