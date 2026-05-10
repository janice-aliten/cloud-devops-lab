# Bitcoin Monitor Reference — Infrastructure Context

## What this document is

A documentation-only note explaining how the DevOps reliability patterns
in this lab relate to a separate Bitcoin market-data monitoring project.

This document contains no trading logic, no execution logic, no signal
generation, no position sizing, and no exchange credentials.

## Context

A companion project (maintained in a separate private repository)
implements a Python-based Bitcoin market-data monitoring and analysis
workflow using the Binance public API.

From an infrastructure perspective, that project has the same
operational requirements as any data-pipeline service:

| Requirement | DevOps pattern demonstrated in this lab |
|---|---|
| Service must stay running | Docker restart policy, health checks |
| Failures must be detected quickly | Prometheus alerting, Grafana dashboard |
| Logs must be reviewable | `check-container-logs.sh`, structured logging |
| Deployments must be repeatable | Docker Compose, CI/CD pipeline |
| Infrastructure must be version-controlled | Terraform, Git |
| Rollback must be possible | `rollback-plan.md`, image tagging |

## Relevance to blockchain infrastructure roles

Blockchain infrastructure — including rollup sequencers, validators,
and data-availability layers — has the same operational requirements
as any production service:

- Containers must start reliably and pass health checks
- Metrics must be scraped and alerting must fire on failures
- Deployments must be automated and reproducible
- Rollbacks must be fast and tested in advance

The patterns in this lab apply directly to running and maintaining
blockchain node infrastructure, including sequencer services of the
kind operated by Espresso Systems and similar teams.

## What is not here

- Trading strategy or signal logic
- Execution or order management logic
- Position sizing logic
- Exchange API credentials
- Account or order data
- Any proprietary analysis methods
