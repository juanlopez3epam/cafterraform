resource "azurecaf_name" "cdnprof" {
  name          = var.settings.name
  resource_type = "azurerm_cdn_profile"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = azurecaf_name.cdnprof.result
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = try(var.settings.sku, "Standard_Microsoft")
  tags                = var.settings.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurecaf_name" "cdn" {
  for_each      = var.settings.cdn_endpoint
  name          = each.key
  resource_type = "azurerm_cdn_endpoint"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  for_each            = var.settings.cdn_endpoint
  name                = azurecaf_name.cdn[each.key].result
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = var.location
  resource_group_name = var.resource_group_name
  is_http_allowed     = each.value.is_http_allowed
  is_https_allowed    = each.value.is_https_allowed
  origin_path         = each.value.origin_path
  origin_host_header  = each.value.origin_host_header
  tags                = var.settings.tags

  origin {
    name       = each.value.name
    host_name  = each.value.host_name
    http_port  = each.value.http_port
    https_port = each.value.https_port
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}