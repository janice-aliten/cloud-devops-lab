#!/usr/bin/env bash
# smoke-test.sh — post-startup validation for the cloud-devops-lab stack
# Run after: docker compose up --build
# Usage: bash scripts/smoke-test.sh

set -euo pipefail

APP_HOST="${APP_HOST:-localhost}"
APP_PORT="${APP_PORT:-8000}"
PROMETHEUS_PORT="${PROMETHEUS_PORT:-9090}"
PASS=0
FAIL=0

green() { echo -e "\033[0;32m[PASS]\033[0m $1"; }
red()   { echo -e "\033[0;31m[FAIL]\033[0m $1"; }
info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }

check_endpoint() {
  local label="$1"
  local url="$2"
  local expected="$3"

  response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" || echo "000")

  if [ "$response" = "$expected" ]; then
    green "$label — HTTP $response"
    PASS=$((PASS + 1))
  else
    red "$label — expected HTTP $expected, got HTTP $response"
    FAIL=$((FAIL + 1))
  fi
}

check_body_contains() {
  local label="$1"
  local url="$2"
  local pattern="$3"

  body=$(curl -s --max-time 5 "$url" || echo "")

  if echo "$body" | grep -q "$pattern"; then
    green "$label — found '$pattern' in response"
    PASS=$((PASS + 1))
  else
    red "$label — '$pattern' not found in response body"
    FAIL=$((FAIL + 1))
  fi
}

check_container() {
  local label="$1"
  local name="$2"

  state=$(docker inspect --format='{{.State.Status}}' "$name" 2>/dev/null || echo "missing")

  if [ "$state" = "running" ]; then
    green "$label — container state: $state"
    PASS=$((PASS + 1))
  else
    red "$label — container state: $state"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
info "=== cloud-devops-lab smoke test ==="
echo ""

# Container state checks
check_container "App container"        "devops-lab-app"
check_container "Prometheus container" "devops-lab-prometheus"
check_container "Grafana container"    "devops-lab-grafana"

# App endpoint checks
check_endpoint "App /health"  "http://$APP_HOST:$APP_PORT/health" "200"
check_endpoint "App /ready"   "http://$APP_HOST:$APP_PORT/ready"  "200"
check_endpoint "App /metrics" "http://$APP_HOST:$APP_PORT/metrics" "200"

# Metrics content checks
check_body_contains "Metrics: request count" \
  "http://$APP_HOST:$APP_PORT/metrics" "app_requests_total"
check_body_contains "Metrics: uptime" \
  "http://$APP_HOST:$APP_PORT/metrics" "app_uptime_seconds"

# Prometheus reachability
check_endpoint "Prometheus UI" "http://$APP_HOST:$PROMETHEUS_PORT/-/ready" "200"

echo ""
info "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  red "Smoke test FAILED — check logs with: docker compose logs"
  exit 1
else
  green "All checks passed"
  exit 0
fi
