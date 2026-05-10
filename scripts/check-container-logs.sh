#!/usr/bin/env bash
# check-container-logs.sh — review recent container logs and flag errors
# Usage: bash scripts/check-container-logs.sh
#        bash scripts/check-container-logs.sh --lines 50

set -euo pipefail

LINES="${LINES:-20}"
green() { echo -e "\033[0;32m[OK]\033[0m $1"; }
red()   { echo -e "\033[0;31m[ERROR]\033[0m $1"; }
warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }
info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }

CONTAINERS=("devops-lab-app" "devops-lab-prometheus" "devops-lab-grafana")

echo ""
info "=== Container log review (last $LINES lines each) ==="

for container in "${CONTAINERS[@]}"; do
  echo ""
  info "--- $container ---"

  state=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null || echo "not found")

  if [ "$state" != "running" ]; then
    red "$container is not running (state: $state)"
    continue
  fi

  # Print recent logs
  docker logs --tail "$LINES" "$container" 2>&1 | while IFS= read -r line; do
    if echo "$line" | grep -qiE "error|exception|fatal|panic|crash"; then
      red "$line"
    elif echo "$line" | grep -qiE "warn|warning"; then
      warn "$line"
    else
      echo "  $line"
    fi
  done

  green "$container log review complete"
done

echo ""
info "=== Sample log demo (samples/sanitized-app.log) ==="
echo ""

SAMPLE_LOG="$(dirname "$0")/../samples/sanitized-app.log"

if [ -f "$SAMPLE_LOG" ]; then
  grep -iE "error|warn" "$SAMPLE_LOG" | while IFS= read -r line; do
    if echo "$line" | grep -qi "error"; then
      red "$line"
    else
      warn "$line"
    fi
  done
  green "Sample log parsed"
else
  info "Sample log not found at $SAMPLE_LOG"
fi

echo ""
info "=== Done ==="
