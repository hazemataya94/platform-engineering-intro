#!/usr/bin/env bash
set -euo pipefail

# Seed a local-lab application secret into Vault KV.
# Secret values are provided at runtime and are not committed to git.

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
SECRET_PATH="${SECRET_PATH:-secret/data/sample-backend/config}"
APP_API_TOKEN="${APP_API_TOKEN:-platform-demo-api-token}"

if ! command -v vault >/dev/null 2>&1; then
  echo "Error: vault CLI is required for seeding demo secrets."
  exit 1
fi

export VAULT_ADDR VAULT_TOKEN

echo "Writing demo KV secret to ${SECRET_PATH}"
vault kv put secret/sample-backend/config api_token="${APP_API_TOKEN}" >/dev/null

echo "Demo application secret seeded."
echo "This value is local-lab only and must not be used outside the teaching cluster."
