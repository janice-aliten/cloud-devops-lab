# Rollback Plan — cloud-devops-lab

## When to roll back

Roll back when:
- A code change causes /health or /ready to return non-200
- The container enters a restart loop after deployment
- Prometheus scrape failure rate increases after a change
- Smoke test fails after deploying a new image

## Option 1 — Roll back to previous Git commit (local)

```bash
# Check recent commits
git log --oneline -5

# Roll back working directory to the previous commit
git checkout [previous-commit-hash] -- app.py

# Rebuild and restart
docker compose build app
docker compose up -d app

# Validate
bash scripts/smoke-test.sh
```

## Option 2 — Roll back to previous Docker image (ghcr.io)

When a new image has been pushed to ghcr.io and the previous image tag
is known:

```bash
# Edit docker-compose.yml to pin the previous image tag
# Replace: build: .
# With:    image: ghcr.io/janice-aliten/cloud-devops-lab:sha-[previous-sha]

# Pull and restart
docker compose pull app
docker compose up -d app

# Validate
bash scripts/smoke-test.sh
```

## Option 3 — Full stack restart from last known good state

```bash
# Stop everything
docker compose down

# Check out the last known good commit
git log --oneline -10
git checkout [last-good-commit]

# Rebuild from scratch
docker compose up --build

# Validate
bash scripts/smoke-test.sh
```

## Post-rollback validation checklist

```bash
# 1. Container is running and healthy
docker ps | grep devops-lab-app

# 2. Health endpoint responds
curl http://localhost:8000/health

# 3. Full smoke test passes
bash scripts/smoke-test.sh

# 4. Prometheus scrape target is up
curl http://localhost:9090/api/v1/targets | grep '"health":"up"'

# 5. Grafana dashboard is green
# Navigate to http://localhost:3001
```

## In ECS/Fargate (production equivalent)

- Update the ECS service to use the previous task definition revision
- ECS will drain the current task and start the previous image
- Monitor CloudWatch Container Insights for restart count and health
- Validate using ALB target group health checks and CloudWatch metrics
