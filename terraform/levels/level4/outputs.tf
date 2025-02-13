output "resource_groups" {
  value       = local.consolidated_objects_resource_groups
  description = "Resource Groups"
}
output "vnets" {
  value       = local.virtual_networks
  description = "Virtual networks"
}
output "aks_clusters" {
  value       = local.consolidated_objects_aks_clusters
  description = "AKS Clusters"
  sensitive   = true
}
output "managed_identities" {
  value       = local.consolidated_objects_managed_identities
  description = "Managed Identities"
}
output "federated_identities" {
  value       = local.consolidated_objects_federated_identities
  description = "Federated Identities"
}
output "keyvaults" {
  value       = local.consolidated_objects_keyvaults
  description = "Key Vaults"
}
output "keyvault_secrets" {
  value       = local.consolidated_objects_keyvault_secrets
  description = "Key Vault Secrets"
  sensitive   = true
}
output "keyvault_dynamic_secrets" {
  value       = local.consolidated_objects_keyvault_dynamic_secrets
  description = "Key Vault Dynamic Secrets"
  sensitive   = true
}
output "postgresql_flexible_servers" {
  value       = local.consolidated_objects_postgresql_flexible_servers
  description = "PostgreSQL Flexible Servers"
  sensitive   = true
}
# output "redis_caches" {
#   value       = local.consolidated_objects_redis_caches
#   description = "Redis Caches"
#   sensitive   = true
# }
output "enterprise_redis_clusters" {
  value       = local.consolidated_objects_enterprise_redis_clusters
  description = "Enterprise Redis Clusters"
  sensitive   = true
}
output "enterprise_redis_databases" {
  value       = local.consolidated_objects_enterprise_redis_databases
  description = "Enterprise Redis Databases"
  sensitive   = true
}
output "route_tables" {
  value       = local.consolidated_objects_route_tables
  description = "Route Tables"
}
output "storage_accounts" {
  value       = local.consolidated_objects_storage_accounts
  description = "Storage Accounts"
  sensitive   = true
}
output "elastic_cloud_deployments" {
  value       = local.consolidated_objects_elastic_cloud_deployments
  description = "Elastic Cloud Deployments outputs"
  sensitive   = true
}
output "confluent_cloud_deployments" {
  value       = local.consolidated_objects_confluent_cloud_deployments
  description = "Confluent Cloud Deployments outputs"
  sensitive   = true
}
