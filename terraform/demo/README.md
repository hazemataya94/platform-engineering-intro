# Terraform Demo Root

Configures Vault for the Platform Engineering Introduction lab.

## Boundary

Terraform configures Vault mounts, roles, policies, and database connectivity.

Terraform does not act as the store for application secret values.

Seed demo KV secrets with Make after configuration:

```bash
make vault-seed-demo-secrets
```

## Prerequisites

- Vault is running in the lab cluster
- Vault port-forward is available on localhost:8200, or `VAULT_ADDR` points at Vault
- `VAULT_TOKEN` is set for local-lab configuration
- `TF_VAR_postgres_admin_password` is set for database engine configuration

## Apply

From the repository root:

```bash
make vault-configure
```
