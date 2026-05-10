# cloud-devops-lab

A sanitized DevOps and infrastructure lab demonstrating container
configuration, CI/CD pipelines, infrastructure-as-code, live
Prometheus/Grafana monitoring, Linux operational tooling, and
deployment documentation.

> This repository does not contain employer code, proprietary systems,
> live trading logic, exchange credentials, API keys, production logs,
> or sensitive infrastructure details.

---

## What this lab demonstrates

| Capability | Evidence |
|---|---|
| Containerized service | FastAPI app with Dockerfile |
| Multi-service local stack | Docker Compose: app + Prometheus + Grafana |
| Live metrics | `/metrics` endpoint with request count and uptime |
| Monitoring | Prometheus scraping, Grafana dashboard auto-provisioned |
| Alerting | Prometheus alert rules for app down and restart loop |
| CI/CD pipeline | GitHub Actions: validate job + build-and-push job |
| Infrastructure as Code | Terraform AWS VPC + security group + ECS cluster |
| Configuration management | Ansible localhost Docker/app check playbook |
| Linux troubleshooting | Bash scripts: smoke test, DNS check, log review |
| Deployment documentation | Runbook, troubleshooting notes, rollback plan |
| Incident response | Container restart loop scenario end-to-end |
| Security hygiene | `.env.example`, `.gitignore`, security notes |

---

## Repository structure

```
cloud-devops-lab/
├── app.py                  FastAPI health and metrics service
├── Dockerfile              Container image definition
├── docker-compose.yml      Local three-service stack
├── requirements.txt        Python dependencies
├── healthcheck.py          Local service reachability check
├── .env.example            Environment variable template (no secrets)
├── terraform/              AWS VPC + security group + ECS skeleton
├── ansible/                Localhost Docker/app validation playbook
├── .github/workflows/      CI validate + CD build-and-push
├── monitoring/             Prometheus config, alert rules, Grafana provisioning
├── scripts/                Smoke test, DNS check, log review
├── docs/                   Runbook, troubleshooting, incident, rollback, security
└── samples/                Sanitized log sample
```

---

## Quick start

```bash
# Clone
git clone https://github.com/janice-aliten/cloud-devops-lab.git
cd cloud-devops-lab

# Configure (copy template — edit if needed)
cp .env.example .env

# Build and start
docker compose up --build

# Validate
bash scripts/smoke-test.sh
```

Access:

| Service | URL |
|---|---|
| App health | http://localhost:8000/health |
| App metrics | http://localhost:8000/metrics |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 (lab-admin / local-lab-password) |

---

## CI/CD pipeline

Every push runs two jobs:

**validate** — Python syntax, Docker Compose config, Terraform init/fmt/validate.
No cloud credentials required.

**build-and-push** — Builds the Docker image and pushes to
`ghcr.io/janice-aliten/cloud-devops-lab:latest` on merge to main.
Uses `GITHUB_TOKEN` only.

---

## Terraform

AWS infrastructure skeleton: VPC, security group, ECS cluster.

```bash
cd terraform
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

> Do not run `terraform apply` without billing controls configured.
> See `terraform/README.md` for details.

---

## Ansible

Localhost-only playbook. Run after `docker compose up`:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

Not part of the CI workflow — local validation only.

---

## Security

See `docs/security-notes.md` for a full list of what is and is not
included in this repository.
