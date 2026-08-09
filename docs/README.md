# Platform Engineering Introduction Docs

## Purpose

These docs support a hands-on Platform Engineering Introduction lab on a local `kind` cluster.

## How To Navigate

1. For the talk: open [Presentation](presentation/README.md) (`slides.md` or `slides.html`).
2. For the lab: start with the [Demo Guide](demo-guide.md) — theory → lab → theory → lab.
3. Use [Architecture](architecture.md) when you want the full component map.
4. Use [Fundamentals](fundamentals/README.md) or [Runbooks](runbooks/README.md) only as supporting indexes.

## Documentation Index

- [Presentation](presentation/README.md) (Marp + Reveal slides)
- [Demo Guide](demo-guide.md) (primary lab path)
- [Architecture](architecture.md)
- [Fundamentals](fundamentals/README.md)
- [Runbook Index](runbooks/README.md)
- [01 Bring Up Demo](runbooks/01-bring-up-demo.md)
- [02 Helm Golden Path](runbooks/02-helm-golden-path.md)
- [03 Observability Self-Service](runbooks/03-observability-self-service.md)
- [04 Vault And Dynamic Credentials](runbooks/04-vault-and-dynamic-credentials.md)
- [05 Git-Controlled Changes](runbooks/05-git-controlled-changes.md)
- [06 Sample Alerts](runbooks/06-sample-alerts.md)

## Local-Only Boundary

All commands target a local `kind` cluster named `platform-engineering`.

Do not point this lab at a remote Kubernetes cluster unless you intentionally change that scope.
