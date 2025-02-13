output "keyvault_template_secrets" {
  description = "Keyvault template secrets"
  value       = local.consolidated_objects_keyvault_template_secrets
  sensitive   = true
}
output "keyvault_dynamic_secrets" {
  value       = local.consolidated_objects_keyvault_dynamic_secrets
  description = "Key Vault Dynamic Secrets"
  sensitive   = true
}
output "elasticsearch_security_users" {
  value       = local.consolidated_objects_elasticsearch_security_users
  description = "Elasticsearch Security Users"
  sensitive   = true
}
