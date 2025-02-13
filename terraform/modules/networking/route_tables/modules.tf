resource "azurecaf_name" "route_table" {
  name          = var.name
  resource_type = "azurerm_route_table"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_route_table" "rt" {
  name                          = azurecaf_name.route_table.result
  resource_group_name           = var.resource_group_name
  location                      = var.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = local.tags
}
