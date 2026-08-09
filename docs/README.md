# Platform Engineering Introduction Docs

## Purpose

These docs support a hands-on Platform Engineering Introduction lab on a local `kind` cluster.

## How To Navigate

1. Read [Architecture](architecture.md).
2. Use the [Demo Guide](demo-guide.md) for the live walkthrough.
3. Follow the runbooks under [Runbooks](runbooks/README.md).
4. Read [Fundamentals](fundamentals/README.md) for short concept notes.

## Documentation Index

- [Architecture](architecture.md)
- [Demo Guide](demo-guide.md)
- [Fundamentals](fundamentals/README.md)
- [Runbook Index](runbooks/README.md)
- [Bring Up Demo](runbooks/01-bring-up-demo.md)
- [Observability Self-Service](runbooks/02-observability-self-service.md)
- [Helm Golden Path](runbooks/03-helm-golden-path.md)
- [Vault And Dynamic Credentials](runbooks/04-vault-and-dynamic-credentials.md)
- [Git-Controlled Changes](runbooks/05-git-controlled-changes.md)
- [Sample Alerts](runbooks/06-sample-alerts.md)

## Local-Only Boundary

All commands target a local `kind` cluster named `platform-engineering`.

Do not point this lab at a remote Kubernetes cluster unless you intentionally change that scope.
