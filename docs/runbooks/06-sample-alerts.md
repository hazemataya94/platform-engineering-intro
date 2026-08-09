# Sample Alerts

## Purpose

Apply a small PrometheusRule set that reinforces the lab narrative.

## Prerequisites

- Monitoring stack is up (`make monitoring-up`)
- Lab kubectl context is `kind-platform-engineering`

## Steps

```bash
make alerts-up
```

Inspect:

```bash
kubectl --context kind-platform-engineering -n monitoring get prometheusrule sample-platform-alerts -o yaml
```

## What It Teaches

- Alerts are part of the feedback loop.
- `PlatformSampleBackendDown` is a basic availability signal.
- `PlatformSupportRequestsSpike` is a teaching cue for productizing support pain.

## Cleanup

```bash
make alerts-down
```
