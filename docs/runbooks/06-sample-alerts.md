# Sample Alerts

## Purpose

Apply a small PrometheusRule set that reinforces the lab narrative.

## Prerequisites

- Read [Feedback Loops And Alerts](../fundamentals/06-feedback-loops-and-alerts.md).
- Monitoring stack is up (`make monitoring-up`).
- Lab kubectl context is `kind-platform-engineering`.

## Steps

```bash
make alerts-up
```

Inspect:

```bash
kubectl --context kind-platform-engineering -n monitoring get prometheusrule sample-platform-alerts -o yaml
```

## What It Shows

- Alerts are part of the feedback loop.
- `PlatformSampleBackendDown` is a basic availability signal.
- `PlatformSupportRequestsSpike` is a cue for productizing support pain.

## Cleanup

```bash
make alerts-down
```

## Next

You finished the alternating path. Return to the [Demo Guide](../demo-guide.md) for discussion prompts and cleanup, or read [Architecture](../architecture.md) for the full component map.
