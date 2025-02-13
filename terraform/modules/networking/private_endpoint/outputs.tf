output "id" {
  description = "ID Of the private endpoint"
  value       = azurerm_private_endpoint.pep.id
}

output "private_ip_address" {
  description = "The private IP address of this endpoint"
  value       = azurerm_private_endpoint.pep.private_service_connection[0].private_ip_address # This assumes only one ip_configuration block per module, which should be safe.
}

output "name" {
  description = "Name of the private endpoint"
  value = azurerm_private_endpoint.pep.name
}
