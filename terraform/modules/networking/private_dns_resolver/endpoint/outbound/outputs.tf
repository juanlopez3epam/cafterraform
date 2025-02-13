output "id" {
  description = "The resource ID of the outbound endpoint"
  value       = azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint.id
}

output "endpoint_name" {
  description = "The name of the inbound endpoint"
  value       = azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint.name
}
