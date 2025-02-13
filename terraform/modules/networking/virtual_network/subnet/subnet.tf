resource "azurecaf_name" "subnet" {
  name          = local.subnet_name
  resource_type = "azurerm_subnet"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = (local.subnet_name == "AzureBastionSubnet") || (local.subnet_name == "AzureFirewallSubnet") || (local.subnet_name == "GatewaySubnet") || (local.subnet_name == "RouteServerSubnet") || (local.subnet_name == "AzureFirewallManagementSubnet") ? true : var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_subnet" "subnet" {
  name                                          = azurecaf_name.subnet.result
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = var.address_prefixes
  service_endpoints                             = var.service_endpoints
  private_endpoint_network_policies_enabled     = coalesce(var.private_endpoint_network_policies_enabled, try(var.settings.private_endpoint_network_policies_enabled, false))
  private_link_service_network_policies_enabled = coalesce(var.private_link_service_network_policies_enabled, try(var.settings.private_link_service_network_policies_enabled, false))

  dynamic "delegation" {
    for_each = try(var.settings.delegation, null) == null ? [] : [1]

    content {
      name = var.settings.delegation.name

      service_delegation {
        name    = var.settings.delegation.service_delegation
        actions = lookup(var.settings.delegation, "actions", null)
      }
    }
  }
}
