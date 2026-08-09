# Runbooks

## Purpose

Step-by-step procedures for the Platform Engineering Introduction lab.

## Operating Boundaries

- Local `kind` cluster `platform-engineering` only.
- Do not target remote clusters.
- Demo-only credentials such as Grafana `admin` / `admin` are local-lab only.

## Runbook Index

| Runbook | Purpose |
| --- | --- |
| [01 Bring Up Demo](01-bring-up-demo.md) | Create cluster and install monitoring |
| [02 Observability Self-Service](02-observability-self-service.md) | Logging stack, dashboards, metrics story |
| [03 Helm Golden Path](03-helm-golden-path.md) | Deploy apps through Helm charts |
| [04 Vault And Dynamic Credentials](04-vault-and-dynamic-credentials.md) | Vault, Adminer, dynamic DB creds |
| [05 Git-Controlled Changes](05-git-controlled-changes.md) | Overlay values and example CI |
| [06 Sample Alerts](06-sample-alerts.md) | Apply sample PrometheusRules |
| Cleanup | Remove the lab cluster (covered in 01) |
