# Incident Response Example — Container Restart Loop

## Incident summary

| Field | Detail |
|---|---|
| Scenario | Application container enters a restart loop |
| Severity | High — service unavailable, Prometheus scrape failing |
| Environment | Local lab (maps to: production ECS/Fargate container service) |
| Duration | 12 minutes from detection to resolution |

---

## Detection

Grafana dashboard shows App Status panel switching from green (UP) to
red (DOWN). Prometheus alert `AppDown` fires. Smoke test returns failures
on /health and /ready.

```bash
bash scripts/smoke-test.sh
# [FAIL] App /health — expected HTTP 200, got HTTP 000
# [FAIL] App /ready  — expected HTTP 200, got HTTP 000
```

---

## Impact assessment

- /health and /ready endpoints unreachable
- Prometheus cannot scrape /metrics — target marked down
- Grafana dashboard panels show no data
- CI build-and-push would still succeed (image build is separate from runtime)

---

## Triage

```bash
# Check container state
docker ps -a | grep devops-lab-app
# STATUS: Restarting (1) 8 seconds ago

# Check restart count
docker inspect --format='{{.RestartCount}}' devops-lab-app
# 7

# Review recent logs
docker logs devops-lab-app --tail 30
# ERROR: Address already in use: port 8000
# ERROR: [Errno 98] Address already in use
```

---

## Root cause

A previous instance of the app container did not release port 8000 on
exit. The new container starts, attempts to bind port 8000, fails
immediately, and is restarted by Docker's restart policy. Each restart
fails for the same reason, producing a restart loop.

This pattern occurs in ECS/Fargate when a task exits uncleanly and the
container port is not released before the replacement task starts.

---

## Remediation

```bash
# Step 1 — Stop the restart loop
docker compose stop app

# Step 2 — Check what is holding port 8000
lsof -i :8000
# or
ss -tlnp | grep 8000

# Step 3 — Kill the process holding the port if it is a stale container
docker ps -a | grep 8000
docker rm -f [stale-container-id]

# Step 4 — Restart cleanly
docker compose up -d app

# Step 5 — Confirm container is running and stable
docker ps | grep devops-lab-app
# STATUS: Up 30 seconds (healthy)
```

---

## Validation

```bash
# Confirm health endpoint responds
curl http://localhost:8000/health
# {"status":"healthy","service":"cloud-devops-lab"}

# Run full smoke test
bash scripts/smoke-test.sh
# [PASS] All checks passed

# Confirm Prometheus scrape target is back up
curl http://localhost:9090/api/v1/targets | grep health
# "health": "up"

# Confirm Grafana dashboard is green
# Navigate to http://localhost:3000 — App Status panel should show UP
```

---

## Prevention

- Add Docker healthcheck with `start_period` long enough for the app to
  start (already implemented in docker-compose.yml — `start_period: 5s`)
- Use `restart: unless-stopped` rather than `always` to allow manual
  stops without triggering a restart loop (already implemented)
- In ECS/Fargate: set deregistration delay and connection draining so
  the old task releases resources before the new one starts
- Monitor `RestartCount` via Prometheus or CloudWatch and alert when
  it exceeds a threshold
