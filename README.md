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

Run all commands from the repository root.

```bash
make check-prereqs
make kind-up
make monitoring-preload-images
make monitoring-up
make logging-up
make apps-up
make dashboard-up
make data-up
make vault-up
make grafana-port-forward
```

Open `http://localhost:3000` and sign in with `admin` / `admin`.

These credentials are only for the local `kind` lab.

For Vault and dynamic credentials after Vault is up:

```bash
make vault-ui
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
make vault-configure
make vault-seed-demo-secrets
make demo-db-credentials
make adminer-port-forward
```

Optional extras:

```bash
make alerts-up
# Review cicd/ for Git-as-interface overlays and the GitLab CI example
```

If image pulls into the kind nodes fail because of local network or IPv6 issues, keep using `make monitoring-preload-images` before `make monitoring-up`.

## Documentation

1. [`docs/architecture.md`](docs/architecture.md)
2. [`docs/demo-guide.md`](docs/demo-guide.md)
3. [`docs/runbooks/README.md`](docs/runbooks/README.md)
4. [`docs/fundamentals/README.md`](docs/fundamentals/README.md)
5. [`docs/README.md`](docs/README.md)

## Cleanup

```bash
make clean
```

## Lab Pattern

This lab uses `kind` for local Kubernetes, Helmfile for platform components, Helm charts for application golden paths, Git overlays for controlled changes, and Make targets for reproducible steps.

## License

MIT. See [`LICENSE`](LICENSE).
