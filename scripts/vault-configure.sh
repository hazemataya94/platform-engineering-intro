#!/usr/bin/env bash
set -euo pipefail

# Configure Vault with Terraform for the local lab.
# Expects Vault reachable at VAULT_ADDR and a configuration token in VAULT_TOKEN.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform/demo"
KIND_CONTEXT="${KIND_CONTEXT:-kind-platform-engineering}"

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
TF_VAR_postgres_admin_password="${TF_VAR_postgres_admin_password:-platform-local-password}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: terraform is required."
  exit 1
fi

export VAULT_ADDR VAULT_TOKEN TF_VAR_postgres_admin_password

# Best-effort Kubernetes auth reviewer material when cluster context exists.
if kubectl --context "${KIND_CONTEXT}" get ns vault >/dev/null 2>&1; then
  SA_SECRET_NAME="$(kubectl --context "${KIND_CONTEXT}" -n vault get sa vault -o jsonpath='{.secrets[0].name}' 2>/dev/null || true)"
  if [ -n "${SA_SECRET_NAME}" ]; then
    TF_VAR_token_reviewer_jwt="$(kubectl --context "${KIND_CONTEXT}" -n vault get secret "${SA_SECRET_NAME}" -o jsonpath='{.data.token}' 2>/dev/null | base64 --decode || true)"
    TF_VAR_kubernetes_ca_cert="$(kubectl --context "${KIND_CONTEXT}" -n vault get secret "${SA_SECRET_NAME}" -o jsonpath='{.data.ca\.crt}' 2>/dev/null | base64 --decode || true)"
    export TF_VAR_token_reviewer_jwt TF_VAR_kubernetes_ca_cert
  fi
fi

cd "${TF_DIR}"
terraform init -input=false
terraform apply -auto-approve -input=false

echo "Vault configuration applied."
echo "Next: make vault-seed-demo-secrets"
