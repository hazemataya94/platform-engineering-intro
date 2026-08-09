output "kv_mount_path" {
  value       = vault_mount.kv.path
  description = "KV mount path configured for application secrets."
}

output "database_mount_path" {
  value       = vault_mount.database.path
  description = "Database secrets engine mount path."
}

output "dynamic_role_name" {
  value       = vault_database_secret_backend_role.platform_readonly.name
  description = "Dynamic database role name."
}

output "backend_k8s_auth_role" {
  value       = vault_kubernetes_auth_backend_role.sample_backend.role_name
  description = "Kubernetes auth role used by sample-backend Vault Agent Injector."
}
