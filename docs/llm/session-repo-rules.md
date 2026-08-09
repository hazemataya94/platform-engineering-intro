# Session Repo Rules

## Purpose

Constraints specific to this public Platform Engineering session repository.

## Must Follow

- Keep all teaching content generic and public-safe.
- Do not include personal paths, machine-specific details, employer names, private hostnames, or internal product identifiers.
- Use cluster name `platform-engineering` and context `kind-platform-engineering`.
- Prefer Make targets over long manual kubectl or helm command lists in operator docs.
- Keep docs local-only; do not document remote cluster targets.
- Deploy applications through Helm charts under `charts/`; keep application source under `apps/`.
- Keep a single Helmfile at `infrastructure/kubernetes/helmfile.yaml`.
- Terraform under `terraform/` may configure Vault engines, roles, and policies, but must not store application secret values.
- Use Vault Agent Injector for sample-backend secret delivery in this lab.
- Mark unfinished demo beats as TBD by phase only when work remains; L1–L5 files are complete.
- Keep `cicd/` examples illustrative; GitLab pipeline is not required to run for the session.
- Do not commit secrets, private endpoints, or organization-specific identifiers.
- Do not initialize git remotes or publish the repository unless the repository owner explicitly asks.

## Validation

1. Confirm naming stays generic (`platform-engineering`, `platform_*`).
2. Confirm Grafana and other demo credentials are clearly labeled local-lab only.
3. Confirm architecture and demo-guide stay aligned with implemented phases.
4. Confirm docs and scripts contain no absolute home-directory or workspace paths.
