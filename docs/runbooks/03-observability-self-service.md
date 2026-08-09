# Observability Self-Service

## Purpose

Install logging and dashboards so you can investigate without asking another team for every metrics or logs question.

## Prerequisites

- Read [Observability Self-Service](../fundamentals/03-observability-self-service.md).
- Monitoring stack from [Runbook 01](01-bring-up-demo.md) is installed.
- Sample apps from [Runbook 02](02-helm-golden-path.md) are recommended so dashboards have live targets.

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

## Next

Continue with [Secure Self-Service](../fundamentals/04-secure-self-service.md).
