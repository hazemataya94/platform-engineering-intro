# Bring Up Demo

## Purpose

Create the local `kind` cluster and install the monitoring foundation.

## Prerequisites

- Read [Visibility As A Platform Capability](../fundamentals/01-visibility-as-platform-capability.md).
- A local Docker runtime is running.
- Tools from `make check-prereqs` are installed.

## Steps

From the repository root:

```bash
make check-prereqs
make kind-up
make monitoring-preload-images
make monitoring-up
make status
```

## Expected Outcomes

- `kind get clusters` lists `platform-engineering`.
- Monitoring pods become Ready in the `monitoring` namespace.
- Grafana is reachable after `make grafana-port-forward` at `http://localhost:3000` with `admin` / `admin`.

## Validation

```bash
kubectl --context kind-platform-engineering get nodes
kubectl --context kind-platform-engineering -n monitoring get pods
```

## Troubleshooting

- If `ensure-kind-context` fails, run `kubectl config use-context kind-platform-engineering`.
- If pods stay in `ImagePullBackOff`, run `make monitoring-preload-images` and restart the affected pods.
- If pods stay Pending, check local Docker memory headroom.

## Cleanup / Rollback

```bash
make clean
```

## Next

Continue with [Golden Paths Intro](../fundamentals/02-golden-paths-intro.md).
