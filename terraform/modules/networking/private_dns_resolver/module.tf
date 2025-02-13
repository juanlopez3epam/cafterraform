resource "azurecaf_name" "private_dns_resolver" {
  name          = var.settings.name
  resource_type = "azurerm_private_dns_resolver"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = azurecaf_name.private_dns_resolver.result
  resource_group_name = var.resource_group.name
  location            = coalesce(var.settings.location, var.global_settings.regions.region1)
  virtual_network_id  = var.virtual_networks[var.settings.vnet_key].id
  tags                = local.tags
}

module "private_dns_resolver_inbound_endpoint" {
  source = "./endpoint/inbound"
  depends_on = [
    azurerm_private_dns_resolver.private_dns_resolver
  ]
  for_each                = var.settings.inbound_endpoints
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  settings                = each.value
  global_settings         = var.global_settings
  subnets                 = var.virtual_networks[var.settings.vnet_key].subnets
}

module "private_dns_resolver_outbound_endpoint" {
  source = "./endpoint/outbound"
  depends_on = [
    azurerm_private_dns_resolver.private_dns_resolver
  ]
  for_each                = var.settings.outbound_endpoints
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  settings                = each.value
  global_settings         = var.global_settings
  subnets                 = var.virtual_networks[var.settings.vnet_key].subnets
}
