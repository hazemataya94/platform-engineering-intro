# Git-Controlled Changes

## Purpose

Show how overlay values on golden-path charts act as a controlled delivery interface.

## Prerequisites

- Local Helm available
- Charts under `charts/backend` and `charts/frontend`
- Optional: running `kind` cluster `platform-engineering` if you want to apply

## Steps

1. Review the example GitLab pipeline:

```bash
cat cicd/pipelines/.gitlab-ci.example.yml
```

2. Review overlay values:

```bash
cat cicd/deployment-config/sample-backend-values.yaml
cat cicd/deployment-config/sample-frontend-values.yaml
```

3. Validate renders without applying:

```bash
helm template sample-backend ./charts/backend \
  -f cicd/deployment-config/sample-backend-values.yaml >/dev/null

helm template sample-frontend ./charts/frontend \
  -f cicd/deployment-config/sample-frontend-values.yaml >/dev/null
```

4. Optional apply on the lab cluster:

```bash
helm --kube-context kind-platform-engineering upgrade --install sample-backend ./charts/backend \
  --namespace platform-apps \
  -f cicd/deployment-config/sample-backend-values.yaml

helm --kube-context kind-platform-engineering upgrade --install sample-frontend ./charts/frontend \
  --namespace platform-apps \
  -f cicd/deployment-config/sample-frontend-values.yaml
```

## Expected Outcome

- Template validation succeeds.
- Overlay `replicaCount: 2` is visible in rendered output or applied Deployments when applied.
- Talking point remains: Git change → review → overlay → cluster change.

## Cleanup

If you applied overlays and want chart defaults again:

```bash
make backend-up
make frontend-up
```
