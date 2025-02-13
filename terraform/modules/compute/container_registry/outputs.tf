output "id" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.acr.id
}
output "name" {
  description = "The name of the Container Registry."
  value       = azurecaf_name.acr.result
}
output "resource_group_name" {
  value       = local.resource_group_name
  description = "Resource group name is exported to allow the data source to retrieve the admin password if needed."
}
output "login_server" {
  description = "The login server of the Container Registry."
  value       = azurerm_container_registry.acr.login_server
}
output "login_server_url" {
  description = "The login server url of the Container Registry."
  value       = "https://${azurerm_container_registry.acr.login_server}"
}
output "admin_username" {
  description = "The admin username of the Container Registry."
  value       = azurerm_container_registry.acr.admin_username
}
