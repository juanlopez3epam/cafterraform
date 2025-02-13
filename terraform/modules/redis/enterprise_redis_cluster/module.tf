resource "azurecaf_name" "redis" {
  name          = var.settings.name
  resource_type = "azurerm_redis_cache" #Temporary fix for lack of Enterprise Redis Cache resource type in azurecaf
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}
resource "azurerm_redis_enterprise_cluster" "redis" {
  name                = azurecaf_name.redis.result
  location            = var.global_settings.regions[coalesce(var.settings.region, var.global_settings.default_region)]
  resource_group_name = var.resource_group_name
  sku_name            = var.settings.sku_name
  minimum_tls_version = var.settings.minimum_tls_version
  zones               = var.settings.zones
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


