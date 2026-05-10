# Secrets Management

## Purpose

This document describes how secrets are managed in this lab environment
and how they would be managed in a production environment. It is a
practice reference for secrets management principles and does not
contain real credentials, tokens, or keys.

---

## Current lab approach

The lab uses a minimal, convention-based approach appropriate for a
local development environment.

| Secret type | Lab approach | Where defined |
|---|---|---|
| Application environment | `.env` file (gitignored) | `.env.example` as template |
| Grafana admin credentials | `.env` file (gitignored) | `.env.example` as template |
| AWS credentials | Not used (validate only) | Never stored in repo |
| GitHub token for CI | GitHub Actions `GITHUB_TOKEN` | Injected automatically |
| Docker registry credentials | `GITHUB_TOKEN` | Injected automatically |

**Controls in place:**

- `.gitignore` blocks `.env`, `*.tfstate`, `*.pem`, `*.key`, and all
  credential file patterns
- `.env.example` documents required variables without real values
- Gitleaks scans full git history on every push for accidentally
  committed secrets
- `terraform apply` is never run, so no real AWS credentials are needed

---

## Production approach

In a production environment, the following tools and patterns would
replace the local `.env` file approach.

### HashiCorp Vault

Vault provides centralised, auditable secret storage and dynamic
credential generation.

**Core capabilities used in practice:**

| Capability | Use case |
|---|---|
| KV secrets engine | Store static credentials and API keys |
| Dynamic secrets | Generate short-lived AWS credentials on demand |
| PKI secrets engine | Issue short-lived TLS certificates |
| AppRole authentication | Allow CI/CD pipelines to authenticate |
| Audit logging | Record every secret access with timestamp and identity |

**Example workflow for ECS containers:**

1. ECS task authenticates to Vault using IAM role (AWS auth method)
2. Vault verifies the IAM role and issues a short-lived token
3. Container fetches required secrets from Vault KV path
4. Secrets are injected as environment variables at runtime
5. Token expires after the task completes — no long-lived credentials

**Example workflow for CI/CD:**

1. GitLab CI or GitHub Actions authenticates to Vault using JWT
2. Pipeline fetches only the secrets it needs for that stage
3. Secrets are masked in logs and never stored in pipeline artifacts
4. Token expires when the pipeline completes

### AWS Secrets Manager

AWS-native alternative to Vault for AWS-hosted workloads.

| Capability | Use case |
|---|---|
| Secret storage | Database passwords, API keys, TLS certificates |
| Automatic rotation | RDS credentials rotated on a schedule |
| ECS integration | Secrets injected directly into task definition |
| IAM access control | Least-privilege policy controls who can read each secret |
| CloudTrail audit | Every access logged to CloudTrail |

**Example ECS task definition reference:**

```json
{
  "secrets": [
    {
      "name": "DB_PASSWORD",
      "valueFrom": "arn:aws:secretsmanager:ap-southeast-2:ACCOUNT:secret:prod/app/db-password"
    }
  ]
}
```

This injects the secret at container startup without it ever appearing
in source code, environment files, or build artifacts.

---

## Secret rotation policy

| Secret type | Rotation frequency | Method |
|---|---|---|
| Application API keys | 90 days | Manual or automated via Vault |
| Database passwords | 30 days | AWS Secrets Manager automatic rotation |
| TLS certificates | Before expiry | Vault PKI with auto-renew |
| CI/CD tokens | 90 days | Manual rotation with approval |
| AWS IAM access keys | Avoid long-lived keys | Use IAM roles and STS instead |

---

## Secret scanning in CI

Every push to this repository runs Gitleaks against the full git
history. Gitleaks detects patterns matching known secret formats
including AWS access keys, GitHub tokens, private keys, and generic
high-entropy strings.

If a secret is detected:

1. The `secret-scan` CI job fails and blocks the build
2. The secret must be rotated immediately — assume it is compromised
3. Remove it from git history using `git filter-repo`
4. Force push the cleaned history
5. Update the `.gitignore` to prevent recurrence

---

## What is not in this repository

- No real credentials, tokens, API keys, or passwords
- No employer secrets or production configuration
- No trading platform credentials or exchange API keys
- No private keys, certificates, or SSH keys
- No `.env` files (blocked by `.gitignore` and `.gitattributes`)
