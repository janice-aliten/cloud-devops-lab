# Security Notes — cloud-devops-lab

## Repository safety boundaries

This is a sanitized public lab. The following items are never included
and must never be committed to this repository.

### Never commit

| Category | Examples |
|---|---|
| API keys | Binance API key, AWS access key, GitHub tokens |
| Exchange credentials | Binance, Bybit, Bitget, or any exchange credentials |
| Real .env files | Any file containing live secrets |
| SSH private keys | id_rsa, id_ed25519, any *.pem or *.key |
| SSL/TLS private keys | Certificate private keys, PKCS12 files |
| Terraform state | *.tfstate, *.tfstate.backup |
| Employer code | Any code from current or previous employers |
| Employer infrastructure | Firewall rules, internal hostnames, IP maps, diagrams |
| Production logs | Real application logs with IPs, account IDs, or hostnames |
| Trading logic | Signal generation, execution logic, position sizing |
| Account/order data | Exchange order history, account balances |

### Required controls

| Control | Implementation |
|---|---|
| `.env.example` | Placeholder values only — never real secrets |
| `.gitignore` | Blocks `.env`, `*.tfstate`, logs, caches, keys |
| `samples/sanitized-app.log` | Fake log data — no real IPs, hostnames, or keys |
| Terraform | Never commit `terraform.tfstate` or `tfvars` with secrets |

## Git history check

Before making the repository public, verify that no secrets appear in
the Git history:

```bash
# Search commit history for common secret patterns
git log --all --full-history -- '**/.env'
git log --all --full-history -- '**/*.tfstate'

# If a secret was committed and then deleted, it still exists in history.
# Use git filter-repo or BFG Repo-Cleaner to remove it before publishing.
```

## Local environment

- Copy `.env.example` to `.env` for local use
- `.env` is blocked by `.gitignore` and must never be committed
- Use environment variables or a secrets manager for any credentials
  if extending this lab to real cloud deployments

## What this lab contains

- A minimal FastAPI service with health and metrics endpoints
- Docker Compose configuration for local monitoring
- Terraform configuration for AWS infrastructure modelling (validate only)
- GitHub Actions CI/CD workflow using only GITHUB_TOKEN
- Shell scripts using only safe, generic targets
- Sanitized sample logs with no real operational data
- Documentation referencing lab tooling only
