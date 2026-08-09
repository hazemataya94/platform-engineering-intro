# Architecture

## Purpose

This document explains the local architecture for the Platform Engineering Introduction lab.

## Component Topology

```mermaid
flowchart TD
  makefile["Makefile"] --> kind["kind cluster<br>platform-engineering"]
  makefile --> helmfile["helmfile.yaml"]
  makefile --> charts["Helm golden-path charts"]
  makefile --> dashboards["Grafana dashboards"]
  makefile --> alerts["Sample PrometheusRules"]
  makefile --> terraform["Terraform Vault config"]
  cicd["cicd/ overlays + GitLab example"] --> charts

  helmfile --> monitoring["kube-prometheus-stack"]
  helmfile --> loki["Loki"]
  helmfile --> promtail["Promtail DaemonSet"]
  helmfile --> postgres["PostgreSQL"]
  helmfile --> adminer["Adminer"]
  helmfile --> vault["Vault + Injector"]

  charts --> backend["sample-backend FastAPI"]
  charts --> frontend["sample-frontend React"]
  charts --> exporter["support-metrics-exporter"]

  terraform --> vault
  backend -->|"Agent Injector"| vault
  vault --> postgres
  adminer --> postgres
  backend --> prometheus["Prometheus"]
  exporter --> prometheus
  alerts --> prometheus
  promtail --> loki
  prometheus --> grafana["Grafana"]
  loki --> grafana
  dashboards --> grafana
```

## Runtime Flow

```mermaid
sequenceDiagram
  participant You
  participant Make as Makefile
  participant Helmfile
  participant Terraform
  participant Vault
  participant Backend

  You->>Make: make data-up
  Make->>Helmfile: sync Postgres and Adminer
  You->>Make: make vault-up
  Make->>Helmfile: sync Vault and injector
  You->>Make: make vault-configure
  Make->>Terraform: configure engines roles policies
  You->>Make: make vault-seed-demo-secrets
  Make->>Vault: write demo KV secret
  You->>Make: make backend-up
  Make->>Backend: deploy with Agent Injector
  Backend->>Vault: authenticate and render secret file
```

## Boundary Rules

- `Makefile` owns local commands.
- `infrastructure/kubernetes/helmfile.yaml` owns platform chart releases.
- `charts/` owns application and lab data golden paths.
- `apps/` owns application source.
- `terraform/` configures Vault capabilities and does not store application secret values.
- `cicd/` owns example GitLab CI and Helm overlay values for learning.
- `infrastructure/kubernetes/alerts/` owns sample PrometheusRules.
- `docs/demo-guide.md` owns the live demo walkthrough.

## Chart Compatibility

- `kube-prometheus-stack` `87.10.1`
- `loki` `6.55.0`
- `promtail` `6.16.6`
- `hashicorp/vault` `0.29.1`
- Postgres image `postgres:17-alpine`
- Adminer image `adminer:5-standalone`

## Resource Model

The lab uses memory limits and CPU requests only.

## Platform Layers

| Layer | Intent | Lab mapping |
| --- | --- | --- |
| Visibility | See what is running and how it behaves | Prometheus, Grafana, Loki, Promtail, dashboards, sample alerts |
| Controlled self-service | Safe paths to request capabilities | Vault, dynamic credentials, Adminer |
| Standardization | Reuse shared shapes instead of one-off setups | Helm golden paths, Git overlays, example CI |
