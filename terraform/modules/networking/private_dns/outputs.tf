output "id" {
  description = "The ID of the created Private DNS Zone"
  value       = azurerm_private_dns_zone.private_dns.id

}

output "name" {
  description = "The name of the created Private DNS Zone"
  value       = azurerm_private_dns_zone.private_dns.name
}

output "vnet_links" {
  description = "The VNet links created for this Private DNS Zone"
  value       = module.private_dns_zone_vnet_link
}

output "resource_group_name" {
  description = "The resource group name of the Private DNS Zone"
  value       = azurerm_private_dns_zone.private_dns.resource_group_name
}
