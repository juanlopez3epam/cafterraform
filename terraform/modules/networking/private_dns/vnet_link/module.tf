resource "azurecaf_name" "private_dns_zone_vnet_link" {
  name          = var.name
  resource_type = "azurerm_private_dns_zone_virtual_network_link"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = azurecaf_name.private_dns_zone_vnet_link.result
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.registration_enabled
  tags                  = local.tags
}
