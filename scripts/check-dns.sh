#!/usr/bin/env bash
# check-dns.sh — DNS and network reachability checks
# Uses only safe, generic public targets — no employer hostnames
# Usage: bash scripts/check-dns.sh

set -euo pipefail

green() { echo -e "\033[0;32m[PASS]\033[0m $1"; }
red()   { echo -e "\033[0;31m[FAIL]\033[0m $1"; }
warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }
info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }

echo ""
info "=== DNS and network reachability checks ==="
echo ""

# DNS resolution check
dns_check() {
  local label="$1"
  local host="$2"
  if nslookup "$host" > /dev/null 2>&1; then
    green "DNS resolve: $label ($host)"
  else
    red "DNS resolve failed: $label ($host)"
  fi
}

# HTTP reachability check
http_check() {
  local label="$1"
  local url="$2"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" || echo "000")
  if [[ "$code" =~ ^[23] ]]; then
    green "HTTP reach: $label — $code"
  else
    red "HTTP reach failed: $label — $code"
  fi
}

# Ping check — gracefully skipped if ICMP is blocked
# ICMP ping is disabled in WSL2 and most cloud environments (AWS, GCP, Azure).
# DNS resolution and HTTP reachability are the meaningful operational checks.
ping_check() {
  local label="$1"
  local host="$2"
  if ping -c 1 -W 3 "$host" > /dev/null 2>&1; then
    green "Ping: $label ($host)"
  else
    warn "Ping skipped/blocked: $label ($host) — ICMP may be disabled in WSL2 or cloud environments"
  fi
}

# Safe generic DNS targets
dns_check "Google public DNS" "8.8.8.8"
dns_check "Cloudflare public DNS" "1.1.1.1"
dns_check "example.com" "example.com"

echo ""

# Ping checks (informational — failure does not indicate a network problem)
info "Ping checks — may show as skipped in WSL2 or cloud environments where ICMP is blocked"
ping_check "Google DNS" "8.8.8.8"
ping_check "Cloudflare DNS" "1.1.1.1"

echo ""

# HTTP reachability — primary connectivity check
http_check "example.com" "http://example.com"

echo ""
info "=== Done ==="