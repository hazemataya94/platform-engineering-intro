# Secure Self-Service

## Purpose

Explain how platforms encode security into reusable capabilities.

## Main Ideas

- Move repeated secret and database-access work into controlled interfaces.
- Terraform can configure Vault without becoming the secret store.
- Dynamic credentials beat long-lived shared database passwords.
- Applications can receive secrets through Vault Agent Injector.

## Lab Connection

- PostgreSQL and Adminer show a reusable data capability.
- Vault issues dynamic DB credentials with a 1-hour TTL.
- sample-backend reads a Vault-managed app secret via Agent Injector.

## Takeaway

Security and developer experience improve together when guardrails are part of the path.
