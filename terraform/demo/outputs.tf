output "kv_mount_path" {
  value = module.vault_config.kv_mount_path
}

output "database_mount_path" {
  value = module.vault_config.database_mount_path
}

output "dynamic_role_name" {
  value = module.vault_config.dynamic_role_name
}

output "backend_k8s_auth_role" {
  value = module.vault_config.backend_k8s_auth_role
}
