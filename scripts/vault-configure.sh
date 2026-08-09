#!/usr/bin/env bash
set -euo pipefail

# Configure Vault with Terraform for the local lab.
# Expects Vault reachable at VAULT_ADDR and a configuration token in VAULT_TOKEN.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform/demo"
KIND_CONTEXT="${KIND_CONTEXT:-kind-platform-engineering}"

# Prefer lab-local CLIs when present (gitignored under .tools/bin).
if [ -d "${ROOT_DIR}/.tools/bin" ]; then
  export PATH="${ROOT_DIR}/.tools/bin:${PATH}"
fi

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
TF_VAR_postgres_admin_password="${TF_VAR_postgres_admin_password:-platform-local-password}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: terraform is required."
  echo "Install terraform, or place a binary at ${ROOT_DIR}/.tools/bin/terraform"
  exit 1
fi
if ! command -v vault >/dev/null 2>&1; then
  echo "Error: vault CLI is required for mount import checks."
  echo "Install vault, or place a binary at ${ROOT_DIR}/.tools/bin/vault"
  exit 1
fi

export VAULT_ADDR VAULT_TOKEN TF_VAR_postgres_admin_password

# Provide Kubernetes auth reviewer material when the lab context exists.
if kubectl --context "${KIND_CONTEXT}" get ns vault >/dev/null 2>&1; then
  TF_VAR_kubernetes_ca_cert="$(kubectl --context "${KIND_CONTEXT}" -n vault get configmap kube-root-ca.crt -o jsonpath='{.data.ca\.crt}' 2>/dev/null || true)"
  if [ -z "${TF_VAR_kubernetes_ca_cert}" ]; then
    TF_VAR_kubernetes_ca_cert="$(kubectl --context "${KIND_CONTEXT}" get configmap -n kube-system kube-root-ca.crt -o jsonpath='{.data.ca\.crt}' 2>/dev/null || true)"
  fi
  # Prefer TokenRequest API (Kubernetes 1.24+ no longer auto-creates SA secrets).
  TF_VAR_token_reviewer_jwt="$(kubectl --context "${KIND_CONTEXT}" -n vault create token vault --duration=24h 2>/dev/null || true)"
  if [ -n "${TF_VAR_kubernetes_ca_cert}" ]; then
    export TF_VAR_kubernetes_ca_cert
  fi
  if [ -n "${TF_VAR_token_reviewer_jwt}" ]; then
    export TF_VAR_token_reviewer_jwt
  fi
fi

cd "${TF_DIR}"
terraform init -input=false

# If a prior seed or manual enable already created mounts, adopt them into state
# so apply stays idempotent for lab reruns.
if ! terraform state list 2>/dev/null | grep -q 'module.vault_config.vault_mount.kv$'; then
  if vault secrets list -format=json 2>/dev/null | grep -q '"secret/"'; then
    terraform import -input=false module.vault_config.vault_mount.kv secret || true
  fi
fi
if ! terraform state list 2>/dev/null | grep -q 'module.vault_config.vault_mount.database$'; then
  if vault secrets list -format=json 2>/dev/null | grep -q '"database/"'; then
    terraform import -input=false module.vault_config.vault_mount.database database || true
  fi
fi

terraform apply -auto-approve -input=false

echo "Vault configuration applied."
echo "Next: make vault-seed-demo-secrets"
