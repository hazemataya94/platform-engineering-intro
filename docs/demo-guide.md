# Demo Guide

Live walkthrough for the Platform Engineering Introduction lab.

Run commands from the repository root.

## Key Message

Platform Engineering makes good practices easy to follow at scale.

It removes unnecessary responsibility from developers without removing ownership.

## Monitoring Foundation

```bash
make check-prereqs
make kind-up
make monitoring-preload-images
make monitoring-up
make status
make grafana-port-forward
```

Open `http://localhost:3000` with local lab credentials `admin` / `admin`.

Talking point:

> Visibility is the first platform layer.

## Golden Paths And Observability Self-Service

```bash
make logging-up
make apps-up
make dashboard-up
```

Show `charts/backend` and `charts/frontend`.

Talking points:

> Teams do not redesign deployment for every Python backend or React frontend.
>
> Developers investigate metrics and logs themselves.
>
> Repeated support requests are product signals for the platform team.

## Secure Self-Service

```bash
make data-up
make vault-up
make vault-ui
```

In another terminal:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
make vault-configure
make vault-seed-demo-secrets
make demo-db-credentials
make adminer-port-forward
```

Then redeploy backend so Agent Injector can render the secret:

```bash
make backend-up
```

Talking points:

> Terraform configures Vault. Vault protects secret material.
>
> Dynamic database credentials expire automatically. This lab uses a 1-hour TTL.
>
> The backend receives its application secret through Vault Agent Injector.

Adminer is available at `http://localhost:8081` for local inspection only.

## Git As Controlled Interface

Show `cicd/README.md`, the GitLab example, and overlay values.

Optional dry-run:

```bash
helm template sample-backend ./charts/backend \
  -f cicd/deployment-config/sample-backend-values.yaml >/dev/null
```

Talking points:

> Self-service is not unrestricted cluster access.
>
> Git change → reviewable history → overlay on golden-path charts → cluster change.

## Sample Alerts (Optional)

```bash
make alerts-up
```

Talking point:

> Alerts close the feedback loop for availability and support-signal spikes.

## Discussion Prompts

1. What is the most annoying repeated step between writing code and running it in production?
2. What do developers currently need to ask another team to do for them?
3. Which engineering or security rule exists only as documentation today, but could become automation?

## Cleanup

```bash
make clean
```
