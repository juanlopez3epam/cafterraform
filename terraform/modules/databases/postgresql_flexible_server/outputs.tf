output "id" {
  description = "ID of the PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.id
}
output "location" {
  description = "Azure Region where the resource exists"
  value       = azurerm_postgresql_flexible_server.postgresql.location
}
output "postgresql_flexible_server_administrator_username" {
  description = "Administrator username of PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.administrator_login
  sensitive   = true
}
output "postgresql_flexible_server_administrator_password" {
  description = "Administrator password of PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.administrator_password
  sensitive   = true
}
output "postgresql_flexible_server_id" {
  description = "ID of the PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.id
}
output "postgresql_flexible_server_fqdn" {
  description = "FQDN of the PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.fqdn
}
output "postgresql_flexible_server_name" {
  description = "Name of the PostgreSQL flexible server"
  value       = azurerm_postgresql_flexible_server.postgresql.name
}
output "postgresql_flexible_server_public_network_access_enabled" {
  description = "Is public network access enabled?"
  value       = azurerm_postgresql_flexible_server.postgresql.public_network_access_enabled
}
output "resource_group_name" {
  description = "Name of the Resource Group where the resource exists."
  value       = azurerm_postgresql_flexible_server.postgresql.resource_group_name
}
