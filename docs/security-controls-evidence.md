# Security Controls and Evidence

This document maps the security controls implemented in this lab to
operational evidence. It is intended for security-operations and
audit-readiness practice only. No production systems, credentials,
employer data, or customer data are included.

---

## Control mapping

| Control area | Implementation in this lab | Evidence location |
|---|---|---|
| Secret prevention | `.gitignore` blocks `.env`, keys, and state files; `.env.example` documents variables safely; Gitleaks scans full git history on every push | `.gitignore`, `.env.example`, GitHub Actions secret-scan job logs |
| CI/CD security integration | GitHub Actions runs validate, secret scan, Trivy scan, and Docker build on every push | `.github/workflows/validate.yml`, Actions run history |
| IaC validation | Terraform init, fmt, and validate run without cloud credentials or backend | Terraform CI job logs, `terraform/README.md` |
| IaC misconfiguration scanning | Trivy filesystem scan checks Terraform and Ansible for HIGH and CRITICAL findings | GitHub Actions security-scan job logs |
| Container baseline | App container runs as non-root user; Dockerfile uses slim base image; healthcheck defined | `Dockerfile`, `docker-compose.yml` |
| Container scanning | Trivy scans Dockerfile and dependencies on every push | GitHub Actions security-scan job logs |
| Dependency visibility | Dependabot monitors pip, Docker, GitHub Actions, and Terraform weekly | `.github/dependabot.yml`, GitHub Dependabot alerts |
| Monitoring | Prometheus scrapes live metrics; alert rules defined for app down and restart loop | `monitoring/prometheus.yml`, `monitoring/alert-rules-example.yml` |
| Auditability | All changes tracked in Git commits; CI logs retained by GitHub | Git commit history, GitHub Actions logs |
| Change tracking | Every push triggers CI; workflow status visible in Actions tab | GitHub Actions run history |
| Incident response | Mock incident documented end-to-end: detection, triage, root cause, remediation, validation, prevention | `docs/incident-response-example.md` |
| Rollback readiness | Rollback plan documented; Docker images tagged by commit SHA in registry | `docs/rollback-plan.md`, GHCR image versions |
| Security hygiene notes | Security boundaries, what is and is not in the repo, and git history check documented | `docs/security-notes.md` |

---

## CI pipeline — security jobs

| Job | Tool | Trigger | Exit behaviour |
|---|---|---|---|
| `secret-scan` | Gitleaks v2 | Every push and pull request | Fails CI if secrets are found |
| `security-scan` | Trivy Action v0.35.0 | Every push and pull request | Reports HIGH/CRITICAL findings; `exit-code: 0` during lab phase |

---

## Evidence generation workflow

Every push to this repository automatically produces the following
auditable evidence:

1. **Validate job log** — Python syntax, Docker Compose config, Terraform
   init/fmt/validate results
2. **Secret scan log** — Gitleaks output confirming no credentials in
   full commit history
3. **Trivy scan log** — Filesystem scan results for HIGH and CRITICAL
   findings in IaC and container configuration
4. **Build log** — Docker image build and push confirmation with image
   digest

All logs are retained by GitHub Actions and accessible via the Actions
tab at:

```
https://github.com/janice-aliten/cloud-devops-lab/actions
```

---

## Limitations and scope

This is a sanitized lab environment. The controls documented here are
practice implementations, not production security controls. Specifically:

- No production data, customer data, or employer systems are involved
- Trivy `exit-code` is set to `0` during the lab phase so findings are
  reported without blocking CI — this would be set to `1` in a
  production pipeline
- Dependabot alerts require review and remediation; this lab does not
  have a formal SLA for dependency updates
- Gitleaks runs against the lab repository only; no employer or
  production repositories are scanned
