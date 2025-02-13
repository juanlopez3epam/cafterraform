resource "azurecaf_name" "vwan_hub" {
  name          = var.settings.name
  resource_type = "azurerm_virtual_hub"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_virtual_hub" "connectivity" {
  name                = azurecaf_name.vwan_hub.result
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.vwan_id
  address_prefix      = var.settings.address_prefix

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurecaf_name" "vhub_connection" {
  for_each = try(var.settings.vnet_connections, {})

  name          = each.value.name
  resource_type = "azurerm_virtual_hub_connection"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_virtual_hub_connection" "vhub_connection" {
  for_each = try(var.settings.vnet_connections, {})

  name                      = azurecaf_name.vhub_connection[each.key].result
  virtual_hub_id            = azurerm_virtual_hub.connectivity.id
  remote_virtual_network_id = try(var.virtual_networks[each.value.vnet.key].id)
  internet_security_enabled = try(each.value.internet_security_enabled, null)
}
