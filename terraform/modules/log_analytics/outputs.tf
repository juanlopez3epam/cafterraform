output "id" {
  value       = azurerm_log_analytics_workspace.law.id
  description = "The ID of the Log Analytics Workspace."
}

output "location" {
  value       = azurerm_log_analytics_workspace.law.location
  description = "The location of the Log Analytics Workspace."
}

output "name" {
  value       = azurerm_log_analytics_workspace.law.name
  description = "The name of the Log Analytics Workspace."
}

output "resource_group_name" {
  value       = azurerm_log_analytics_workspace.law.resource_group_name
  description = "The name of the resource group in which the Log Analytics Workspace is created."
}

output "workspace_id" {
  value       = azurerm_log_analytics_workspace.law.workspace_id
  description = "The Workspace ID of the Log Analytics Workspace."
}

output "primary_shared_key" {
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
  description = "The Primary Shared Key of the Log Analytics Workspace."
}
