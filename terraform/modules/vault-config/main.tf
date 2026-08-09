terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.5"
    }
  }
}

resource "vault_mount" "kv" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV v2 mount for lab application secrets."
}

resource "vault_mount" "database" {
  path        = "database"
  type        = "database"
  description = "Database secrets engine for dynamic PostgreSQL credentials."
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.database.path
  name          = "postgres"
  allowed_roles = ["platform-readonly"]

  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${var.postgres_host}:${var.postgres_port}/${var.postgres_database}?sslmode=disable"
    username       = var.postgres_admin_username
    password       = var.postgres_admin_password
  }
}

resource "vault_database_secret_backend_role" "platform_readonly" {
  backend = vault_mount.database.path
  name    = "platform-readonly"
  db_name = vault_database_secret_backend_connection.postgres.name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT CONNECT ON DATABASE ${var.postgres_database} TO \"{{name}}\";",
    "GRANT USAGE ON SCHEMA public TO \"{{name}}\";",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
  ]
  default_ttl = var.dynamic_credential_ttl
  max_ttl     = var.dynamic_credential_ttl
}

resource "vault_policy" "sample_backend" {
  name = "sample-backend"

  policy = <<-EOT
    path "secret/data/sample-backend/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "default" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host          = var.kubernetes_host
  kubernetes_ca_cert       = var.kubernetes_ca_cert != "" ? var.kubernetes_ca_cert : null
  token_reviewer_jwt     = var.token_reviewer_jwt != "" ? var.token_reviewer_jwt : null
  disable_iss_validation = true
}

resource "vault_kubernetes_auth_backend_role" "sample_backend" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "sample-backend"
  bound_service_account_names      = [var.backend_service_account]
  bound_service_account_namespaces = [var.backend_namespace]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.sample_backend.name]
}
