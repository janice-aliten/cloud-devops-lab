[![CI/CD](https://github.com/janice-aliten/cloud-devops-lab/actions/workflows/validate.yml/badge.svg)](https://github.com/janice-aliten/cloud-devops-lab/actions/workflows/validate.yml)

# cloud-devops-lab

A sanitized DevOps, infrastructure, monitoring, and security-operations lab demonstrating container configuration, CI/CD pipelines, infrastructure-as-code, live Prometheus/Grafana monitoring, Linux operational tooling, vulnerability-management workflow, and deployment documentation.

> This repository does not contain employer code, proprietary systems, live trading logic, exchange credentials, API keys, production logs, real cloud credentials, Terraform state, or sensitive infrastructure details.

---

## What this lab demonstrates

| Capability | Evidence |
|---|---|
| Containerized service | FastAPI app with Dockerfile |
| Multi-service local stack | Docker Compose: app + Prometheus + Grafana |
| Live metrics | `/metrics` endpoint with request count and uptime |
| Monitoring | Prometheus scraping, Grafana dashboard auto-provisioned |
| Alerting | Prometheus alert rules for app down and restart loop |
| CI/CD pipeline | GitHub Actions: validate, secret scan, Trivy scan, build-and-push |
| GitLab CI portability | `.gitlab-ci.yml` example with equivalent validate, scan, and build stages |
| Infrastructure as Code | Terraform AWS VPC + security group + ECS cluster modelling |
| Configuration management | Ansible localhost Docker/app check playbook |
| Linux troubleshooting | Bash scripts: smoke test, DNS check, log review |
| Deployment documentation | Runbook, troubleshooting notes, rollback plan |
| Incident response | Container restart loop scenario end-to-end |
| Vulnerability management | Gitleaks, Trivy, Dependabot, vulnerability-management runbook |
| Security evidence | Security controls mapped to Git commits, CI logs, runbooks, and config files |
| Security hygiene | `.env.example`, `.gitignore`, Gitleaks, Trivy, Dependabot, security notes |

---

## Validation status

Validated locally:

- Docker Compose stack starts successfully
- FastAPI `/health`, `/ready`, and `/metrics` return HTTP 200
- Prometheus target is UP and scrapes app metrics
- Grafana datasource and dashboard are provisioned successfully
- Smoke test passes 9/9 checks
- Terraform validates with `terraform init -backend=false`, `terraform fmt -check -recursive`, and `terraform validate`

Validated in CI:

- Python syntax check
- Docker Compose configuration check
- Terraform init/fmt/validate
- Gitleaks secret scan across full git history
- Trivy filesystem scan for HIGH and CRITICAL findings
- Docker image build and push to GitHub Container Registry

---

## Repository structure

```text
cloud-devops-lab/
├── app.py                         FastAPI health and metrics service
├── Dockerfile                     Container image definition
├── docker-compose.yml             Local three-service stack
├── .gitlab-ci.yml                 GitLab CI portability example
├── requirements.txt               Python dependencies
├── healthcheck.py                 Local service reachability check
├── .env.example                   Environment variable template; no secrets
├── terraform/                     AWS VPC + security group + ECS skeleton
├── ansible/                       Localhost Docker/app validation playbook
├── .github/
│   ├── workflows/validate.yml     GitHub Actions CI/CD and security checks
│   └── dependabot.yml             Dependency visibility configuration
├── monitoring/                    Prometheus config, alert rules, Grafana provisioning
├── scripts/                       Smoke test, DNS check, log review
├── docs/                          Runbooks, security notes, platform references
└── samples/                       Sanitized log sample
```

---

## Quick start

```bash
# Clone
git clone https://github.com/janice-aliten/cloud-devops-lab.git
cd cloud-devops-lab

# Configure
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
| App readiness | http://localhost:8000/ready |
| App metrics | http://localhost:8000/metrics |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 (`lab-admin / local-lab-password`) |

> Grafana credentials are local lab defaults only. Override them in `.env` for non-local use. Do not reuse them in production.

---

## CI/CD pipeline

Every push runs four GitHub Actions jobs:

**validate** — Python syntax, Docker Compose config, Terraform init/fmt/validate. No cloud credentials required.

**secret-scan** — Gitleaks scans the full git history for accidentally committed secrets, tokens, or credentials.

**security-scan** — Trivy scans the repository filesystem for HIGH and CRITICAL vulnerabilities and misconfigurations in Terraform, Dockerfiles, and configuration files.

**build-and-push** — Builds the Docker image and pushes to `ghcr.io/janice-aliten/cloud-devops-lab:latest` on merge to `main` only after validation and security checks pass. Uses `GITHUB_TOKEN` only.

---

## GitLab CI portability

This repository also includes:

```text
.gitlab-ci.yml
```

This file is a GitLab CI pipeline example showing equivalent stages for:

- Python syntax validation
- Docker Compose validation
- Terraform validation
- Gitleaks secret scanning
- Trivy filesystem scanning
- Docker image build and push to GitLab Container Registry

The GitLab CI file is provided as a portability example. It is not the active CI system for this GitHub-hosted repository unless the project is later mirrored to GitLab.

---

## Terraform

AWS infrastructure skeleton:

- VPC modelling
- Security group modelling
- ECS cluster modelling
- Terraform validation without backend or cloud credentials

```bash
cd terraform
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

> Do not run `terraform apply` without billing controls, reviewed plan output, safe credential handling, Terraform state protection, and a cleanup/destroy plan. See `terraform/README.md` for details.

---

## Ansible

Localhost-only playbook. Run after `docker compose up`:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

The Ansible playbook is included as a configuration-management example and is best run from Linux, WSL, or CI rather than native Windows PowerShell.

---

## Security operations relevance

This lab includes security-operations practices relevant to CI/CD and infrastructure environments:

- Secret scanning using Gitleaks, running through GitHub Actions
- IaC and container scanning using Trivy, running through GitHub Actions
- Dependabot configuration for dependency visibility across pip, Docker, GitHub Actions, and Terraform
- Security controls and evidence mapping in `docs/security-controls-evidence.md`
- Vulnerability-management workflow in `docs/vulnerability-management-runbook.md`
- Rollback, incident-response, and audit-oriented documentation
- Safe public-repo boundaries for secrets, Terraform state, employer data, production logs, and trading logic

---

## Cloud and secrets security relevance

This lab includes reference material for cloud and infrastructure-security practices:

- Cloud-security baseline for AWS, Azure, and GCP control areas such as identity, logging, secrets, network exposure, CI/CD guardrails, change tracking, and cost control
- Secrets-management reference covering local `.env` handling, GitHub Actions tokens, Vault, AWS Secrets Manager, rotation, and secret-scanning response
- Security evidence documentation mapping controls to GitHub Actions logs, Git commits, runbooks, and configuration files

These documents are lab-level security references only. They do not claim production HSM, custody, trading-key, or multi-cloud security operations.

---

## Platform and delivery strategy references

This lab also includes reference material for broader DevOps and platform-security practices:

- GitLab CI pipeline example (`.gitlab-ci.yml`) showing equivalent validation, secret scanning, Trivy scanning, Terraform validation, and Docker build stages for GitLab-based environments
- GitOps strategy document (`docs/gitops-strategy.md`) describing planned Kubernetes, Helm, ArgoCD/FluxCD, rollback, and drift-detection patterns
- Free-tier DevOps toolkit (`docs/free-tier-devops-toolkit.md`) documenting free or low-cost tooling used or considered for this lab

These files are reference and strategy documents unless explicitly validated by the active GitHub Actions workflow.

---

## Operational documentation

| Document | Purpose |
|---|---|
| `docs/deployment-runbook.md` | Local deployment and validation steps |
| `docs/troubleshooting-notes.md` | Container, endpoint, DNS, Prometheus, and Grafana troubleshooting |
| `docs/incident-response-example.md` | Mock incident response for container restart loop |
| `docs/rollback-plan.md` | Local, image-based, and ECS/Fargate-equivalent rollback guidance |
| `docs/security-notes.md` | Repository safety boundaries and prohibited content |
| `docs/security-controls-evidence.md` | Security controls mapped to repository evidence |
| `docs/vulnerability-management-runbook.md` | Vulnerability identification, scoping, remediation, validation, and evidence workflow |
| `docs/secrets-management.md` | Local and production-style secrets-management reference |
| `docs/cloud-security-baseline.md` | Multi-cloud security baseline reference |
| `docs/free-tier-devops-toolkit.md` | Free or low-cost DevOps tooling reference |
| `docs/gitops-strategy.md` | Planned v2 GitOps strategy reference |
| `docs/bitcoin-monitor-reference.md` | Sanitized infrastructure context for market-data monitoring |

---

## Blockchain and market-data infrastructure context

`docs/bitcoin-monitor-reference.md` explains how the reliability patterns in this lab relate to a separate private Bitcoin market-data monitoring project.

That reference is documentation-only. It contains no trading logic, execution logic, signal generation, position sizing, account data, order data, exchange credentials, or proprietary analysis methods.

---

## Security

See `docs/security-notes.md` for a full list of what is and is not included in this repository.

This repository is intentionally sanitized for public review.

Never commit:

- real `.env` files
- API keys or tokens
- AWS credentials
- Terraform state
- SSH keys or certificates
- employer code
- production logs
- exchange credentials
- trading strategy, execution logic, or account/order data