output "id" {
  value       = azurerm_private_dns_resolver.private_dns_resolver.id
  description = "The resource ID of the created Private DNS Resolver"
}

output "name" {
  value       = azurerm_private_dns_resolver.private_dns_resolver.name
  description = "The name of the Private DNS Resolver"
}

output "vnet_id" {
  value       = var.virtual_networks[var.settings.vnet_key].id
  description = "The VNet ID that the Private DNS Resolver is attached to"
}

output "vnet_name" {
  value       = var.virtual_networks[var.settings.vnet_key].name
  description = "The VNet Name that the Private DNS Resolver is attached to"
}

output "inbound_endpoints" {
  value       = module.private_dns_resolver_inbound_endpoint
  description = "Returns all the inbound endpoints in the Private DNS Resolver. As a map of keys, ID"
}
