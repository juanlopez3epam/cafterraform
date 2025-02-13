output "id" {
  description = "The Resource ID of the Enterprise Redis Cache database."
  value       = azurerm_redis_enterprise_database.redis.id
}
output "primary_access_key" {
  description = "The primary access key of the Enterprise Redis Cache database."
  value       = azurerm_redis_enterprise_database.redis.primary_access_key
  sensitive   = true
}
output "secondary_access_key" {
  description = "The secondary access key of the Enterprise Redis Cache database."
  value       = azurerm_redis_enterprise_database.redis.secondary_access_key
  sensitive   = true
}
output "port" {
  description = "The port of the Enterprise Redis Cache database."
  value       = azurerm_redis_enterprise_database.redis.port
}
