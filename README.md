# Platform Engineering Introduction

## Purpose

This repository is a local hands-on lab for learning Platform Engineering.

It shows how good engineering practices become easier to follow at scale by encoding them into reusable platform capabilities.

## What Is Included

- Local `kind` cluster definition and monitoring foundation (Prometheus, Grafana, Alertmanager)
- Helm golden-path charts, FastAPI sample backend, React sample frontend, support-request metrics exporter, Loki, cluster-wide Promtail, and Grafana dashboards
- PostgreSQL, Adminer, Vault with Agent Injector, Terraform Vault configuration, and dynamic database credentials
- Example GitLab CI, Helm overlay values under `cicd/`, and sample Prometheus alerts
- MIT license

## Prerequisites

- A local Docker runtime
- `kind`
- `kubectl`
- `helm`
- `helmfile`
- `make`

## Quick Start

Follow the alternating theory → lab path in [`docs/demo-guide.md`](docs/demo-guide.md).

That guide is the primary walkthrough. Do not use the command blocks below as a second competing path; they are only a compressed reminder after you understand the beats.

```bash
make check-prereqs
make kind-up
make monitoring-preload-images
make monitoring-up
make apps-up
make logging-up
make dashboard-up
make data-up
make vault-up
make grafana-port-forward
```

Open `http://localhost:3000` and sign in with `admin` / `admin`.

These credentials are only for the local `kind` lab.

If image pulls into the kind nodes fail because of local network or IPv6 issues, keep using `make monitoring-preload-images` before `make monitoring-up`.

## Documentation

1. [`docs/demo-guide.md`](docs/demo-guide.md) — start here (theory → lab)
2. [`docs/architecture.md`](docs/architecture.md)
3. [`docs/fundamentals/README.md`](docs/fundamentals/README.md)
4. [`docs/runbooks/README.md`](docs/runbooks/README.md)
5. [`docs/README.md`](docs/README.md)

## Cleanup

```bash
make clean
```

## Lab Pattern

This lab uses `kind` for local Kubernetes, Helmfile for platform components, Helm charts for application golden paths, Git overlays for controlled changes, and Make targets for reproducible steps.

## License

MIT. See [`LICENSE`](LICENSE).
