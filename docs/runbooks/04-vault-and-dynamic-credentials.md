# Vault And Dynamic Credentials

## Purpose

Configure Vault, seed a demo application secret, and request dynamic PostgreSQL credentials.

## Prerequisites

- Cluster is running.
- `make data-up` and `make vault-up` have been applied.
- `vault` and `terraform` CLIs are installed.
- Vault is port-forwarded: `make vault-ui`

## Steps

From the repository root:

```bash
make vault-ui
```

In another terminal:

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
