"""
healthcheck.py — local service reachability check

Checks that the FastAPI app is responding on /health.
Exits 0 on success, 1 on failure. Safe for automation.

Usage:
    python healthcheck.py
    python healthcheck.py --port 8000
"""

import sys
import argparse
import urllib.request
import urllib.error
import json


def check_health(host: str, port: int) -> bool:
    url = f"http://{host}:{port}/health"
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            body = json.loads(response.read())
            status = body.get("status", "")
            if status == "healthy":
                print(f"[OK] {url} — status: {status}")
                return True
            else:
                print(f"[FAIL] {url} — unexpected status: {status}")
                return False
    except urllib.error.URLError as e:
        print(f"[FAIL] {url} — connection error: {e.reason}")
        return False
    except Exception as e:
        print(f"[FAIL] {url} — unexpected error: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Check app health endpoint")
    parser.add_argument("--host", default="localhost", help="App host")
    parser.add_argument("--port", type=int, default=8000, help="App port")
    args = parser.parse_args()

    if check_health(args.host, args.port):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
