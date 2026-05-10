# Free-Tier DevOps Lab Toolkit

This is a curated reference of free or low-cost tools used to build and
validate this repository. It is intentionally narrower than general
free-tier directories. The focus is on tools directly relevant to this
lab: Docker, Terraform, GitHub Actions, Prometheus, Grafana, Linux
troubleshooting, cloud infrastructure modelling, and security hygiene.

---

## Scope

**Included:**

- Free or low-cost tools useful for DevOps and infrastructure labs
- Tools used directly in this repository
- Tools suitable for beginner-to-intermediate cloud and platform engineering practice
- Tools that can be tested without exposing credentials or production systems

**Excluded:**

- Paid-only tools
- Short trial-only tools unless clearly marked
- Trading logic, strategy code, or exchange credentials
- Employer-specific systems or private infrastructure

---

## Toolkit

### Source Control and CI/CD

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| GitHub | Free public repositories and Actions minutes, subject to GitHub limits | Source control and public portfolio hosting |
| GitHub Actions | Free for public repositories with hosted runners, subject to GitHub limits | Validate job and Docker image build workflow |
| GitHub Container Registry | Free for public packages, limits may apply | Docker image published on merge to main |

### Containers

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| Docker Desktop | Free for personal use and small businesses; commercial plans may apply for larger organisations | Local container runtime for the lab stack |
| Docker Compose | Free, included with Docker Desktop | Orchestrates the app, Prometheus, and Grafana services locally |

### Infrastructure as Code

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| Terraform CLI | Free CLI | Validates AWS VPC, security group, and ECS cluster skeleton |
| HashiCorp AWS Provider | Free provider plugin | Downloaded during `terraform init -backend=false` |

### Monitoring and Observability

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| Prometheus | Free, open source | Scrapes the FastAPI `/metrics` endpoint |
| Grafana OSS | Free, open source | Visualises app status, uptime, and request rate |
| prometheus-client for Python | Free, open source | Exposes `app_requests_total` and `app_uptime_seconds` |

### Security and Hygiene

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| `.gitignore` | Built in to Git | Blocks `.env`, Terraform state files, keys, certificates, and logs from being committed |
| `.env.example` | Convention, no cost | Documents required environment variables without exposing real values |
| Gitleaks | Free, open source | Planned future CI enhancement for detecting accidentally committed secrets |
| Trivy | Free, open source | Planned future CI enhancement for scanning container images, Terraform, and Ansible configuration |

### Configuration Management

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| Ansible | Free, open source | Localhost Docker validation playbook |
| ansible-core | Free, open source | Supports the local playbook workflow when run from a suitable Linux, WSL, or CI environment |

### Local Development and Scripting

| Tool | Free tier / cost note | Used in this repo |
|---|---|---|
| Git Bash for Windows | Free, included with Git for Windows | Runs `.sh` scripts on Windows without requiring WSL |
| Python 3.11 | Free, open source | FastAPI service and healthcheck script |
| FastAPI | Free, open source | Health, readiness, and metrics endpoints |
| Uvicorn | Free, open source | ASGI server running the FastAPI app |
| VS Code | Free | Repo editing, YAML review, and Markdown review |

### Cloud: Modelled, Not Deployed

| Tool | Free tier / cost note | Notes |
|---|---|---|
| AWS Free Tier | Selected AWS services have free-tier allowances; account and billing setup required | Terraform skeleton models AWS infrastructure only |
| AWS ECS / Fargate | Pay-per-use; charges apply when services are deployed or running | Target container orchestration platform modelled in Terraform |
| AWS VPC | VPC itself has no hourly charge, but related services such as NAT Gateway, public IPv4, load balancers, and data transfer can cost money | Modelled in Terraform and validated only |

> **Billing note:** `terraform apply` is not run as part of this repository.
> See `terraform/README.md` for safe validation commands and cost warnings.

---

## CI pipeline — what runs on every push

| Step | Tool | What it checks |
|---|---|---|
| Python syntax | Python 3.11 | `app.py` and `healthcheck.py` compile without errors |
| Docker Compose config | Docker Compose | `docker compose config` validates the service definitions |
| Terraform init | Terraform CLI | Provider downloads and initialises without backend or cloud credentials |
| Terraform format | Terraform CLI | `.tf` files are consistently formatted |
| Terraform validate | Terraform CLI | Terraform configuration syntax and types are valid |
| Docker build and push | Docker + GitHub Container Registry | Image builds successfully and is pushed to the registry on merge to main |

---

## Local validation — what runs manually

| Step | Tool | Command |
|---|---|---|
| Stack startup | Docker Compose | `docker compose up --build` |
| Full smoke test | Git Bash / Bash | `bash scripts/smoke-test.sh` |
| Container log review | Git Bash / Bash | `bash scripts/check-container-logs.sh` |
| DNS and connectivity | Git Bash / Bash | `bash scripts/check-dns.sh` |
| Service reachability | Python | `python healthcheck.py` |
| Terraform validation | Terraform CLI | `terraform init -backend=false`, `terraform fmt -check -recursive`, `terraform validate` |
| Ansible environment check | Ansible | `ansible-playbook -i ansible/inventory.ini ansible/playbook.yml` |

> Note: The Ansible playbook is included as a localhost configuration-management example.
> It is best run from Linux, WSL, or CI rather than native Windows PowerShell.

---

## Smoke test results validated locally

```text
[PASS] App container — container state: running
[PASS] Prometheus container — container state: running
[PASS] Grafana container — container state: running
[PASS] App /health — HTTP 200
[PASS] App /ready — HTTP 200
[PASS] App /metrics — HTTP 200
[PASS] Metrics: request count — found 'app_requests_total' in response
[PASS] Metrics: uptime — found 'app_uptime_seconds' in response
[PASS] Prometheus UI — HTTP 200

Results: 9 passed, 0 failed
```

---

## Roadmap

| Item | Status | Notes |
|---|---|---|
| Docker image build and push | Implemented | Pushes to GitHub Container Registry on merge to main |
| Gitleaks secret scanning in CI | Planned | Future enhancement for detecting accidentally committed secrets |
| Trivy IaC/container scan in CI | Planned | Future enhancement for Terraform, Ansible, and container scanning |
| AWS S3 log archive Terraform module | Planned | Extend Terraform skeleton with S3 bucket and least-privilege IAM policy |
| MongoDB sample schema documentation | Planned | Document market-data storage schema for companion infrastructure project |
| ECS task definition and service skeleton | Planned | Extend Terraform to include deployable task definition |
| Actual AWS deployment | Planned | Requires billing controls, AWS credentials, and explicit cleanup plan |

---

## References

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Terraform CLI documentation](https://developer.hashicorp.com/terraform/cli)
- [Prometheus documentation](https://prometheus.io/docs/)
- [Grafana documentation](https://grafana.com/docs/)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Trivy](https://github.com/aquasecurity/trivy)
- [FastAPI documentation](https://fastapi.tiangolo.com/)
- [Docker documentation](https://docs.docker.com/)
- [Ansible documentation](https://docs.ansible.com/)