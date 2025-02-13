output "id" {
  description = "The Resource ID of the Redis Cache."
  value       = azurerm_redis_cache.redis.id
}
output "hostname" {
  description = "The hostname of the Redis Cache."
  value       = azurerm_redis_cache.redis.hostname
}

output "ssl_port" {
  description = "The SSL port of the Redis Cache."
  value       = azurerm_redis_cache.redis.ssl_port
}

output "port" {
  description = "The port of the Redis Cache."
  value       = azurerm_redis_cache.redis.port
}

output "primary_access_key" {
  description = "The primary access key of the Redis Cache."
  value       = azurerm_redis_cache.redis.primary_access_key
}

output "secondary_access_key" {
  description = "The secondary access key of the Redis Cache."
  value       = azurerm_redis_cache.redis.secondary_access_key
}

output "primary_connection_string" {
  description = "The primary connection string of the Redis Cache."
  value       = azurerm_redis_cache.redis.primary_connection_string
}

output "secondary_connection_string" {
  description = "The secondary connection string of the Redis Cache."
  value       = azurerm_redis_cache.redis.secondary_connection_string
}
output "redis_cache" {
  description = "The Redis Cache object."
  value       = azurerm_redis_cache.redis
}
output "rbac_id" {
  description = "The RBAC ID of the Redis Cache."
  value       = try(azurerm_redis_cache.redis.identity[0].principal_id, null)
}
