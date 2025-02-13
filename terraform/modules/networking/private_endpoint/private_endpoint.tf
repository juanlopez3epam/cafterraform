resource "azurecaf_name" "pep" {
  name          = var.settings.name
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_private_endpoint" "pep" {
  name                = azurecaf_name.pep.result
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnets[coalesce(try(var.settings.subnet.lz_key, null), var.client_config.landingzone_key)][var.settings.subnet.subnet_key].id
  tags                = local.tags

  private_service_connection {
    name                              = "${azurecaf_name.pep.result}-psc"
    private_connection_resource_id    = var.resource_id
    private_connection_resource_alias = var.resource_alias
    is_manual_connection              = try(var.settings.private_service_connection.is_manual_connection, null) == null ? false : var.settings.private_service_connection.is_manual_connection
    subresource_names                 = var.settings.private_service_connection.subresource_names
    request_message                   = try(var.settings.private_service_connection.request_message, null) == null ? null : var.settings.private_service_connection.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = try(var.settings.private_dns, null) != null ? var.settings.private_dns : {}

    content {
      name                 = "${coalesce(try(private_dns_zone_group.value.lz_key, null), var.client_config.landingzone_key)}_${private_dns_zone_group.value.dns_zone_key}"
      private_dns_zone_ids = [var.dns_zones[coalesce(try(private_dns_zone_group.value.lz_key, null), var.client_config.landingzone_key)][private_dns_zone_group.value.dns_zone_key].id]
    }
  }

}
