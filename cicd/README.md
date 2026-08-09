# CI/CD Examples

This directory demonstrates **Git as a controlled platform interface**.

It is an example for the Platform Engineering Introduction lab.

It is not a live production CI system.

## Layout

```text
cicd/
├── pipelines/
│   └── .gitlab-ci.example.yml
└── deployment-config/
    ├── sample-backend-values.yaml
    └── sample-frontend-values.yaml
```

## Teaching Point

```text
Engineer
  → Git change
  → reviewable history
  → overlay values on golden-path charts
  → cluster change
```

Self-service does not mean unrestricted cluster access.

## Apply An Overlay Locally

From the repository root, after the lab cluster and charts are available:

```bash
helm --kube-context kind-platform-engineering upgrade --install sample-backend ./charts/backend \
  --namespace platform-apps \
  -f cicd/deployment-config/sample-backend-values.yaml
```

```bash
helm --kube-context kind-platform-engineering upgrade --install sample-frontend ./charts/frontend \
  --namespace platform-apps \
  -f cicd/deployment-config/sample-frontend-values.yaml
```

## GitLab CI Example

See [`pipelines/.gitlab-ci.example.yml`](pipelines/.gitlab-ci.example.yml).

The filename uses `.example` so it is not picked up as an active pipeline by default.
