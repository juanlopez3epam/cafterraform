output "id" {
  description = "The resource ID of the inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.id
}

output "private_ip_address" {
  description = "The private IP of the inbound endpoint"
  # NOTE - This is working with the assumption that an endpoint is only going to have 1 IP configuration.  Since that's how
  #     the module is being built, I feel that this is a safe assumption.
  value = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations[0].private_ip_address
}

output "endpoint_name" {
  description = "The name of the inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.name
}
