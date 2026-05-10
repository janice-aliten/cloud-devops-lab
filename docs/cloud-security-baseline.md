# Cloud Security Baseline

This document defines cloud-security guardrails for AWS, Azure, GCP, and
similar cloud environments. It is a lab-level reference and does not
deploy live infrastructure.

---

## Purpose

The purpose of this document is to show how security controls can be
embedded into cloud provisioning, CI/CD workflows, monitoring, and
operational evidence.

---

## Baseline control areas

| Area | Control objective |
|---|---|
| Identity | Enforce least privilege, MFA, and role-based access |
| Network | Avoid unnecessary public exposure |
| Secrets | Use managed secret stores and avoid hardcoded values |
| Logging | Enable audit logs for control-plane and security events |
| CI/CD | Validate code, IaC, secrets, and security posture before build/deploy |
| IaC | Version-control infrastructure and validate before deployment |
| Monitoring | Collect service metrics, logs, and alerts |
| Change tracking | Use Git commits and CI logs as evidence |
| Incident response | Document triage, containment, remediation, and validation |
| Cost control | Avoid live deployment without budgets and cleanup plans |

---

## AWS control examples

| Control area | Example control |
|---|---|
| Identity | IAM roles instead of static access keys |
| Logging | CloudTrail for control-plane audit events |
| Secrets | AWS Secrets Manager or SSM Parameter Store |
| Network | Security groups with restricted ingress |
| Storage | S3 public access block and encryption |
| Compute | ECS task roles for workload permissions |
| IaC | Terraform validation before deployment |

---

## Azure control examples

| Control area | Example control |
|---|---|
| Identity | Microsoft Entra ID role-based access |
| Secrets | Azure Key Vault |
| Logging | Azure Activity Logs |
| Network | Network Security Groups |
| Compute | Managed identities for workloads |
| IaC | Terraform validation before deployment |

---

## GCP control examples

| Control area | Example control |
|---|---|
| Identity | IAM roles with least privilege |
| Secrets | Secret Manager |
| Logging | Cloud Audit Logs |
| Network | VPC firewall rules |
| Compute | Service accounts with scoped permissions |
| IaC | Terraform validation before deployment |

---

## Multi-cloud guardrail pattern

| Guardrail | AWS | Azure | GCP |
|---|---|---|---|
| Least privilege | IAM roles | Entra ID / RBAC | IAM roles |
| Managed secrets | Secrets Manager / SSM | Key Vault | Secret Manager |
| Audit logging | CloudTrail | Activity Logs | Cloud Audit Logs |
| Network control | Security groups / NACLs | NSGs | Firewall rules |
| IaC validation | Terraform | Terraform | Terraform |
| Security scanning | Trivy / IaC scan | Trivy / IaC scan | Trivy / IaC scan |

---

## CI/CD security controls in this lab

This repository demonstrates CI/CD security guardrails through:

- Python syntax validation
- Docker Compose validation
- Terraform init/fmt/validate
- Gitleaks secret scanning
- Trivy filesystem scan
- Docker image build gated by validation and security jobs
- GitHub Actions workflow evidence

---

## Cloud deployment boundary

This lab currently models cloud infrastructure but does not deploy it.

Reason:

- Avoid unnecessary cloud cost
- Avoid accidental public exposure
- Avoid real credential handling in a public repo
- Keep the lab safe and reproducible for review

Before any live deployment, required controls would include:

1. AWS/Azure/GCP budget alerts
2. Dedicated lab account or subscription
3. Least-privilege IAM role
4. No static credentials in GitHub
5. Terraform state protection
6. Cleanup and destroy plan
7. Explicit review before `terraform apply`

---

## Evidence in this repository

| Evidence | Location |
|---|---|
| Cloud infrastructure model | `terraform/` |
| IAM Terraform baseline | `terraform/iam.tf` |
| CI/CD validation | `.github/workflows/validate.yml` |
| Security scan evidence | GitHub Actions logs |
| Secrets boundary | `.env.example`, `.gitignore` |
| Operational monitoring | `monitoring/` |
| Incident response | `docs/incident-response-example.md` |
| Rollback planning | `docs/rollback-plan.md` |
| Security controls mapping | `docs/security-controls-evidence.md` |