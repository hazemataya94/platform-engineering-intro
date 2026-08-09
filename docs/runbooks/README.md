# Runbooks

## Purpose

Step-by-step labs for the Platform Engineering Introduction path.

Follow the [Demo Guide](../demo-guide.md) in theory → lab order. Use this index only if you need one lab out of sequence.

## Operating Boundaries

- Local `kind` cluster `platform-engineering` only.
- Do not target remote clusters.
- Demo-only credentials such as Grafana `admin` / `admin` are local-lab only.

## Runbook Index

| Beat | Runbook | Purpose |
| --- | --- | --- |
| 1 | [01 Bring Up Demo](01-bring-up-demo.md) | Create cluster and install monitoring |
| 2 | [02 Helm Golden Path](02-helm-golden-path.md) | Deploy apps through Helm charts |
| 3 | [03 Observability Self-Service](03-observability-self-service.md) | Logging stack and dashboards |
| 4 | [04 Vault And Dynamic Credentials](04-vault-and-dynamic-credentials.md) | Vault, Adminer, dynamic DB creds |
| 5 | [05 Git-Controlled Changes](05-git-controlled-changes.md) | Overlay values and example CI |
| 6 | [06 Sample Alerts](06-sample-alerts.md) | Apply sample PrometheusRules |

Cleanup is covered in runbook 01 (`make clean`).
