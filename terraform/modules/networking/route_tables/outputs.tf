output "id" {
  description = "The ID of the route table."
  value       = azurerm_route_table.rt.id
}
output "name" {
  description = "The name of the route table."
  value       = azurerm_route_table.rt.name
}
output "location" {
  description = "The location of the route table."
  value       = azurerm_route_table.rt.location
}
output "resource_group_name" {
  description = "The name of the resource group in which the route table is created."
  value       = azurerm_route_table.rt.resource_group_name
}
