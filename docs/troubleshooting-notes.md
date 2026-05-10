# Troubleshooting Notes — cloud-devops-lab

## Container state checks

```bash
# All containers and their status
docker ps -a

# Inspect a specific container
docker inspect devops-lab-app

# Check container health state only
docker inspect --format='{{.State.Health.Status}}' devops-lab-app
```

## Log review

```bash
# Last 50 lines from the app
docker logs devops-lab-app --tail 50

# Follow logs in real time
docker logs devops-lab-app -f

# Filter for errors only
docker logs devops-lab-app 2>&1 | grep -i error

# Use the log check script
bash scripts/check-container-logs.sh
```

## Endpoint checks

```bash
# App health — should return {"status":"healthy"}
curl http://localhost:8000/health

# App readiness — should return {"status":"ready"}
curl http://localhost:8000/ready

# Metrics — should return Prometheus text format
curl http://localhost:8000/metrics

# Check HTTP status code only
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health
```

## Port and process checks

```bash
# Check what is listening on the app port
lsof -i :8000

# Or using ss
ss -tlnp | grep 8000

# Check Docker networking
docker network ls
docker network inspect cloud-devops-lab_default
```

## DNS and network reachability

```bash
# Basic DNS
nslookup example.com
dig example.com

# Reach an external endpoint
curl -I http://example.com

# Run the DNS check script
bash scripts/check-dns.sh
```

## Prometheus issues

```bash
# Check Prometheus is up
curl http://localhost:9090/-/ready

# Check scrape targets
curl http://localhost:9090/api/v1/targets

# Check if app metrics are being scraped
curl 'http://localhost:9090/api/v1/query?query=app_requests_total'
```

## Container fails to start

1. Check logs: `docker logs devops-lab-app`
2. Check if port is already in use: `lsof -i :8000`
3. Rebuild the image: `docker compose build --no-cache app`
4. Check the Dockerfile builds locally: `docker build -t test-build .`

## Prometheus shows "unhealthy" for app target

1. Confirm app is running: `docker ps | grep devops-lab-app`
2. Confirm app /metrics is reachable: `curl http://localhost:8000/metrics`
3. Check Prometheus config: `cat monitoring/prometheus.yml`
4. Check that service name in prometheus.yml matches docker-compose.yml

## Grafana dashboard shows "datasource not found"

1. Verify datasource UID in provisioning: `cat monitoring/grafana/provisioning/datasources/prometheus.yml`
2. UID must be `prometheus`
3. Verify dashboard JSON references same UID: `grep uid monitoring/grafana/dashboards/health-dashboard.json`
4. Restart Grafana: `docker compose restart grafana`
