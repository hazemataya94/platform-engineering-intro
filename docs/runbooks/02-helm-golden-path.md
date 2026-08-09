# Helm Golden Path

## Purpose

Deploy sample workloads through opinionated Helm charts.

## Prerequisites

- Read [Golden Paths Intro](../fundamentals/02-golden-paths-intro.md).
- Monitoring stack from [Runbook 01](01-bring-up-demo.md) is installed.

## Steps

From the repository root:

```bash
make apps-up
make status
```

Optional individual targets:

```bash
make backend-up
make frontend-up
make exporter-up
```

## Expected Outcomes

- Releases exist in `platform-apps`: `sample-backend`, `sample-frontend`, `support-exporter`.
- Backend and exporter expose `/metrics`.
- Frontend serves the React UI and `/healthz`.

## Validation

```bash
kubectl --context kind-platform-engineering -n platform-apps get pods,svc
helm --kube-context kind-platform-engineering -n platform-apps list
```

Inspect chart defaults:

- `charts/backend/values.yaml`
- `charts/frontend/values.yaml`
- `charts/support-exporter/values.yaml`

## Rollback

```bash
make apps-down
```

## Next

Continue with [Observability Self-Service](../fundamentals/03-observability-self-service.md).
