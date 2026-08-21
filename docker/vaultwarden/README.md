# Vaultwarden Docker Deployment

This directory contains the Docker Compose configuration used to deploy Vaultwarden on `docker-prod-01`.

## Files

```text
compose.yaml    Docker Compose configuration
.env.example    Example environment configuration
```

## Configuration

Create the local environment file:

```bash
cp .env.example .env
```

Adjust the values if required:

```bash
DOCKER_HOST_IP=192.168.178.42
VAULTWARDEN_PORT=8081
VAULTWARDEN_DOMAIN=https://vaultwarden.home.arpa
```

## Persistent Data

Vaultwarden stores its persistent application data in:

```text
./data
```

which is mounted inside the container as:

```text
/data
```

The `data/` directory contains runtime data such as the Vaultwarden database.

## Start the Service

```bash
docker compose up -d
```

Verify the container:

```bash
docker compose ps
```

Vaultwarden is exposed locally through the configured host IP and port and is accessed through the homelab reverse proxy at:

```text
https://vaultwarden.home.arpa
```

New account registration is disabled through:

```text
SIGNUPS_ALLOWED=false
```
