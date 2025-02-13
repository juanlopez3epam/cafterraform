resource "azurecaf_name" "pip" {

  name          = try(var.settings.name, null)
  resource_type = "azurerm_public_ip"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azurerm_public_ip" "pip" {
  name                = azurecaf_name.pip.result
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = try(var.settings.allocation_method, "Static")
  sku                 = try(var.settings.sku, "Basic")
  sku_tier            = try(var.settings.sku_tier, "Regional")
}
