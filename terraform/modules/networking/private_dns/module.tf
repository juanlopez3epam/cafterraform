resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.name # Intentionally not using the aztfmod naming service here
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

module "private_dns_zone_vnet_link" {
  source   = "./vnet_link"
  for_each = try(var.vnet_links, {})

  name                  = var.virtual_networks[coalesce(try(each.value.lz_key, null), var.client_config.landingzone_key)][each.value.vnet_key].name
  global_settings       = var.global_settings
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.virtual_networks[coalesce(try(each.value.lz_key, null), var.client_config.landingzone_key)][each.value.vnet_key].id
  registration_enabled  = each.value.registration_enabled
  tags                  = var.tags
}
