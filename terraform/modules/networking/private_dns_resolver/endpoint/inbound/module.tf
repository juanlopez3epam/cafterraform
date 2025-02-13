resource "azurecaf_name" "private_dns_resolver_inbound_endpoint" {
  name          = var.settings.name
  resource_type = "azurerm_private_dns_resolver_inbound_endpoint"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint" {
  name                    = azurecaf_name.private_dns_resolver_inbound_endpoint.result
  location                = coalesce(var.settings.location, var.global_settings.regions.region1)
  private_dns_resolver_id = var.private_dns_resolver_id

  ip_configurations {
    private_ip_allocation_method = "Dynamic" #This is the only allowed value...
    subnet_id                    = var.subnets[var.settings.subnet_key].id
  }
}
