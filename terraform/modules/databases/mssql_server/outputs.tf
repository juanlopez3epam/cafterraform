output "id" {
  description = "The ID of the SQL Server."
  value       = azurerm_mssql_server.mssql.id
}

output "fully_qualified_domain_name" {
  description = "The FQDN of the SQL Server."
  value       = azurerm_mssql_server.mssql.fully_qualified_domain_name
}

output "rbac_id" {
  description = "The ID of the identity that has been assigned to the SQL Server."
  value       = try(azurerm_mssql_server.mssql.identity[0].principal_id, null)
}

output "identity" {
  description = "value of the identity that has been assigned to the SQL Server."
  value       = try(azurerm_mssql_server.mssql.identity, null)
}

output "azuread_administrator" {
  description = "The Azure Active Directory administrator of the SQL Server."
  value       = try(azurerm_mssql_server.mssql.azuread_administrator, null)
}

output "name" {
  description = "The name of the SQL Server."
  value       = azurecaf_name.mssql.result
}

output "resource_group_name" {
  description = "Name of the resource group in which the SQL Server is created."
  value       = azurerm_mssql_server.mssql.resource_group_name
}

output "location" {
  description = "The location of the SQL Server."
  value       = azurerm_mssql_server.mssql.location
}
