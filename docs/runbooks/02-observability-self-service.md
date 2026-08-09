# Observability Self-Service

## Purpose

Install logging and dashboards so developers can investigate without asking another team for every metrics or logs question.

## Prerequisites

- Monitoring stack from runbook 01 is installed.

## Steps

From the repository root:

```bash
make logging-up
make dashboard-up
make grafana-port-forward
```

## Expected Outcomes

- Loki and Promtail are present in the `logging` namespace.
- Promtail runs as a cluster-wide DaemonSet.
- Grafana shows the Sample Backend and Support Requests dashboards.
- Grafana has a Loki datasource.

## Validation

```bash
kubectl --context kind-platform-engineering -n logging get pods,ds
kubectl --context kind-platform-engineering -n monitoring get configmap -l grafana_dashboard=1
```

## Rollback

```bash
make dashboard-down
make logging-down
```
