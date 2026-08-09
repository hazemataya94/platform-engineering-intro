#!/usr/bin/env bash
set -euo pipefail

# Request dynamic PostgreSQL credentials from Vault for the live demo.

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
ROLE_PATH="${ROLE_PATH:-database/creds/platform-readonly}"

if ! command -v vault >/dev/null 2>&1; then
  echo "Error: vault CLI is required."
  exit 1
fi

export VAULT_ADDR VAULT_TOKEN

echo "Requesting dynamic database credentials from ${ROLE_PATH}"
echo "Expected TTL for this lab role: 1h"
echo

vault read -format=json "${ROLE_PATH}" | python3 -c '
import json
import sys

payload = json.load(sys.stdin)
data = payload.get("data", {})
lease = payload.get("lease_duration")
print("username={}".format(data.get("username")))
print("password={}".format(data.get("password")))
print("lease_duration_seconds={}".format(lease))
print()
print("Use these credentials with Adminer or psql against the lab PostgreSQL service.")
print("They expire automatically when the lease ends.")
'
