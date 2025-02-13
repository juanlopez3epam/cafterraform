resource "azurecaf_name" "msi" {
  name          = var.name
  resource_type = "azurerm_user_assigned_identity"
  prefixes      = try(var.settings.naming_convention.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.use_slug, try(var.global_settings.use_slug, null))
}

resource "azurerm_user_assigned_identity" "msi" {
  name                = azurecaf_name.msi.result
  resource_group_name = var.resource_group.name
  location            = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
