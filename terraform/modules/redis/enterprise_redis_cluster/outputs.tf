output "id" {
  description = "The Resource ID of the Redis Cache."
  value       = azurerm_redis_enterprise_cluster.redis.id
}
output "resource_group_name" {
  description = "The name of the Resource Group in which the Redis Cache exists."
  value       = azurerm_redis_enterprise_cluster.redis.resource_group_name
}
output "location" {
  description = "The Azure Region in which the Redis Cache exists."
  value       = azurerm_redis_enterprise_cluster.redis.location
}
output "hostname" {
  description = "The hostname of the Redis Cache."
  value       = azurerm_redis_enterprise_cluster.redis.hostname
}
output "redis_cache" {
  description = "The Redis Cache object."
  value       = azurerm_redis_enterprise_cluster.redis
}

