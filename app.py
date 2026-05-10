"""
cloud-devops-lab — health and metrics service

Exposes three endpoints:
  /health   — liveness check (is the process running?)
  /ready    — readiness check (is the service ready to serve traffic?)
  /metrics  — Prometheus scrape endpoint (request count, uptime)

This is a sanitized lab service. It does not contain trading logic,
exchange credentials, employer code, or production data.
"""

import time
from fastapi import FastAPI, Response
from prometheus_client import (
    Counter,
    Gauge,
    generate_latest,
    CONTENT_TYPE_LATEST,
)

app = FastAPI(title="cloud-devops-lab health service")

# Track when the application started
START_TIME = time.time()

# Prometheus metrics
REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total number of requests received",
    ["method", "endpoint", "status"],
)

UPTIME_GAUGE = Gauge(
    "app_uptime_seconds",
    "Number of seconds the application has been running",
)


@app.get("/health")
def health():
    """Liveness check — confirms the process is running."""
    REQUEST_COUNT.labels(method="GET", endpoint="/health", status="200").inc()
    return {"status": "healthy", "service": "cloud-devops-lab"}


@app.get("/ready")
def ready():
    """Readiness check — confirms the service is ready to serve traffic."""
    REQUEST_COUNT.labels(method="GET", endpoint="/ready", status="200").inc()
    return {"status": "ready", "service": "cloud-devops-lab"}


@app.get("/metrics")
def metrics():
    """Prometheus scrape endpoint — exposes request count and uptime."""
    # Update uptime gauge on every scrape
    UPTIME_GAUGE.set(time.time() - START_TIME)
    REQUEST_COUNT.labels(method="GET", endpoint="/metrics", status="200").inc()
    return Response(
        content=generate_latest(),
        media_type=CONTENT_TYPE_LATEST,
    )
