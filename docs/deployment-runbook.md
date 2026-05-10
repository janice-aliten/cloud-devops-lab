# Deployment Runbook — cloud-devops-lab

## Prerequisites

- Docker Desktop or Docker Engine installed and running
- Docker Compose available (`docker compose version`)
- Git installed
- Ports 8000, 9090, and 3001 free on localhost

## Step 1 — Clone the repository

```bash
git clone https://github.com/janice-aliten/cloud-devops-lab.git
cd cloud-devops-lab
```

## Step 2 — Configure environment

```bash
cp .env.example .env
# Edit .env if you want to change ports or Grafana credentials
# Default credentials: lab-admin / local-lab-password
```

## Step 3 — Build and start the stack

```bash
docker compose up --build
```

Expected: three containers start — app, prometheus, grafana.
Wait for the app healthcheck to pass (up to 30 seconds).

## Step 4 — Validate the stack is running

```bash
bash scripts/smoke-test.sh
```

Expected: all checks pass with HTTP 200 responses.

Manual spot checks:

```bash
# App health
curl http://localhost:8000/health

# App readiness
curl http://localhost:8000/ready

# Prometheus metrics
curl http://localhost:8000/metrics | grep app_

# Container state
docker ps
```

## Step 5 — Access monitoring

| Service | URL | Credentials |
|---|---|---|
| App | http://localhost:8000/health | None |
| Prometheus | http://localhost:9090 | None |
| Grafana | http://localhost:3001 | lab-admin / local-lab-password |

Grafana dashboard auto-loads on startup. Navigate to Dashboards →
cloud-devops-lab — Service Health.

## Step 6 — Review logs

```bash
# All services
docker compose logs

# App only
docker logs devops-lab-app --tail 20

# Prometheus only
docker logs devops-lab-prometheus --tail 20

# Or use the script
bash scripts/check-container-logs.sh
```

## Shutdown

```bash
docker compose down
```

To remove volumes as well:

```bash
docker compose down -v
```
