terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.5"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token != "" ? var.vault_token : null
}

module "vault_config" {
  source = "../modules/vault-config"

  postgres_host           = var.postgres_host
  postgres_port           = var.postgres_port
  postgres_database       = var.postgres_database
  postgres_admin_username = var.postgres_admin_username
  postgres_admin_password = var.postgres_admin_password
  dynamic_credential_ttl  = var.dynamic_credential_ttl
  kubernetes_host        = var.kubernetes_host
  kubernetes_ca_cert     = var.kubernetes_ca_cert
  token_reviewer_jwt      = var.token_reviewer_jwt
  backend_service_account = var.backend_service_account
  backend_namespace       = var.backend_namespace
}
