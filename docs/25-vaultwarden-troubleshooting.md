# Vaultwarden Troubleshooting Exercise

## 1. Overview

A controlled failure was introduced by stopping the Vaultwarden container on `docker-prod-01`.

The objective was to practice identifying where a service failure occurs instead of immediately restarting components.

---

## 2. Symptoms

After stopping Vaultwarden:

- the browser returned `502 Bad Gateway`;
- Uptime Kuma reported `ECONNREFUSED` for `192.168.178.42:8081`.

These symptoms indicated that:

- Nginx Proxy Manager was still reachable;
- `docker-prod-01` was still reachable;
- the Vaultwarden backend was no longer listening on port `8081`.

---

## 3. Diagnosis

Container state was checked with:

```bash
docker compose ps
docker compose ps -a
```

`docker compose ps -a` showed Vaultwarden as:

```text
Exited (0)
```

This confirmed that the container had stopped cleanly rather than crashed.

The service was then restarted and verified as healthy.

Finally, the backend was tested directly:

```bash
curl -I http://127.0.0.1:8081
```

Result:

```text
HTTP/1.1 200 OK
```

This confirmed that Vaultwarden was again reachable independently of the reverse proxy.

---

## 4. Troubleshooting Logic

```text
502 Bad Gateway
→ reverse proxy reachable
→ backend unavailable

ECONNREFUSED
→ host reachable
→ no service listening on the target port

docker compose ps -a
→ also shows stopped or exited containers
```

The exercise reinforced a layered troubleshooting approach: verify the proxy, host, container state, listening service, and backend response separately.
