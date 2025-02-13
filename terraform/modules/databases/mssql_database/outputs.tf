output "id" {
  description = "The ID of the SQL Database."
  value       = azurerm_mssql_database.mssqldb.id
}
output "name" {
  description = "The name of the SQL Database."
  value       = azurerm_mssql_database.mssqldb.name
}
output "server_id" {
  description = "The ID of the SQL Server."
  value       = azurerm_mssql_database.mssqldb.server_id
}
