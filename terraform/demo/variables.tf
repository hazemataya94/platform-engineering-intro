variable "vault_address" {
  type    = string
  default = "http://127.0.0.1:8200"
}

variable "vault_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "postgres_host" {
  type    = string
  default = "postgres.platform-data.svc.cluster.local"
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "postgres_database" {
  type    = string
  default = "platform"
}

variable "postgres_admin_username" {
  type    = string
  default = "platform"
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
  # Local-lab default matching charts/postgres values. Override with TF_VAR_postgres_admin_password.
  default   = "platform-local-password"
}

variable "dynamic_credential_ttl" {
  type    = number
  default = 3600
}

variable "kubernetes_host" {
  type    = string
  default = "https://kubernetes.default.svc:443"
}

variable "kubernetes_ca_cert" {
  type    = string
  default = ""
}

variable "token_reviewer_jwt" {
  type      = string
  sensitive = true
  default   = ""
}

variable "backend_service_account" {
  type    = string
  default = "sample-backend"
}

variable "backend_namespace" {
  type    = string
  default = "platform-apps"
}
