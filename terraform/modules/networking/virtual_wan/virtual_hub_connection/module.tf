resource "azurecaf_name" "vhub_connection" {
  name          = var.settings.name
  resource_type = "azurerm_virtual_hub"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azurerm_virtual_hub_connection" "vhub_connection" {
  name                      = azurecaf_name.vhub_connection.result
  virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = var.remote_virtual_network_id
  internet_security_enabled = try(var.settings.internet_security_enabled, null)
}
