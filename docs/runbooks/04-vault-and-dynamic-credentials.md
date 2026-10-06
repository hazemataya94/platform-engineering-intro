# Vault And Dynamic Credentials

## Purpose

Bring up Postgres and Vault, configure Vault, seed a demo application secret, and request dynamic PostgreSQL credentials.

## Prerequisites

- Read [Secure Self-Service](../fundamentals/04-secure-self-service.md).
- Cluster is running from earlier runbooks.
- `vault` and `terraform` CLIs are installed, **or** present under `.tools/bin/` in this repository (scripts prepend that path automatically).

## Steps

From the repository root (`academy/sessions/platform-engineering-intro`):

```bash
make data-up
make vault-up
make vault-ui
```

If `make vault-up` fails with a MutatingWebhookConfiguration `caBundle` conflict and `kubectl -n vault get pods` already shows `vault-0` and the injector Ready, continue. The release is already usable for the lab.

In another terminal (same repository root):

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
make vault-configure
make vault-seed-demo-secrets
make demo-db-credentials
```

Open Adminer:

```bash
make adminer-port-forward
```

Browse `http://localhost:8081`.

Local-lab Postgres values:

- Server: value shown by Adminer default, or `postgres.platform-data.svc.cluster.local`
- Database: `platform`
- Username/password: either the static lab bootstrap user, or dynamic credentials from `make demo-db-credentials`

Then redeploy the backend so Vault Agent Injector can render the secret:

```bash
make backend-up
```

## Expected Outcomes

- Terraform configures KV, database engine, policies, and Kubernetes auth role.
- Demo KV secret exists for sample-backend.
- Dynamic credentials print with a lease duration of 3600 seconds (1 hour).
- sample-backend can start with Vault Agent Injector after `make backend-up`.

## Boundary Reminder

Terraform configures Vault.

Vault protects and issues secret material.

Do not commit real secrets.

## Rollback

```bash
make vault-down
make data-down
```

## Next

Continue with [Git As A Platform Interface](../fundamentals/05-git-as-platform-interface.md).
