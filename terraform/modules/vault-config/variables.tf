variable "postgres_host" {
  type        = string
  description = "PostgreSQL host used by Vault database secrets engine."
  default     = "postgres.platform-data.svc.cluster.local"
}

variable "postgres_port" {
  type        = number
  description = "PostgreSQL port."
  default     = 5432
}

variable "postgres_database" {
  type        = string
  description = "PostgreSQL database name."
  default     = "platform"
}

variable "postgres_admin_username" {
  type        = string
  description = "PostgreSQL admin username for Vault to manage dynamic users."
  default     = "platform"
}

variable "postgres_admin_password" {
  type        = string
  description = "PostgreSQL admin password for Vault configuration."
  sensitive   = true
}

variable "dynamic_credential_ttl" {
  type        = number
  description = "Default TTL in seconds for dynamic database credentials."
  default     = 3600
}

variable "kubernetes_host" {
  type        = string
  description = "Kubernetes API host for Vault Kubernetes auth."
  default     = "https://kubernetes.default.svc:443"
}

variable "kubernetes_ca_cert" {
  type        = string
  description = "Kubernetes CA certificate PEM for Vault Kubernetes auth."
  default     = ""
}

variable "token_reviewer_jwt" {
  type        = string
  description = "JWT used by Vault to validate Kubernetes service account tokens."
  sensitive   = true
  default     = ""
}

variable "backend_service_account" {
  type        = string
  description = "Kubernetes service account name used by sample-backend."
  default     = "sample-backend"
}

variable "backend_namespace" {
  type        = string
  description = "Namespace of sample-backend."
  default     = "platform-apps"
}
