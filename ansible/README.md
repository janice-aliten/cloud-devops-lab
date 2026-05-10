# Ansible — Localhost Environment Check

This playbook validates the local Docker environment and lab container
state. It is a local validation tool only.

## Important

**This playbook is not part of the CI workflow.**

It is designed to run locally after `docker compose up`, to demonstrate
Ansible-based configuration validation in a safe, credential-free way.

## Requirements

- Ansible installed locally (`pip install ansible`)
- Docker Desktop or Docker Engine running
- Lab stack started: `docker compose up --build`

## Usage

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

## What it checks

| Task | Description |
|---|---|
| Check Docker installed | Runs `docker --version` and confirms exit code 0 |
| Verify Docker daemon reachable | Runs `docker info` to confirm daemon is responding |
| Verify FastAPI container running | Inspects `devops-lab-app` container state |
| Print status summary | Outputs a human-readable result summary |

## Expected output

```
TASK [Check Docker is installed] ....... ok
TASK [Print Docker version] ........... ok — Docker installed: Docker version X.X.X
TASK [Verify Docker daemon is reachable] ok
TASK [Verify FastAPI container is running] ok
TASK [Print status summary] ........... ok
  Docker: installed and daemon reachable
  FastAPI container status: running
  All checks passed
```
