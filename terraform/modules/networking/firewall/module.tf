resource "azurecaf_name" "fw" {
  name          = var.settings.name
  resource_type = "azurerm_firewall"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_firewall" "fw" {

  name                = azurecaf_name.fw.result
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = try(var.settings.sku_name, "AZFW_VNet")
  sku_tier            = try(var.settings.sku_tier, "Standard")
  dns_servers         = try(var.settings.dns_servers, null)
  zones               = try(var.settings.zones, null)
  firewall_policy_id  = try(var.firewall_policies[var.settings.firewall_policy_key].firewall_policy_id, null)
  threat_intel_mode   = try(var.settings.threat_intel_mode, "Deny")

  dynamic "virtual_hub" {
    for_each = {
      for key, value in var.settings.virtual_hub : key => value
    }

    content {
      virtual_hub_id  = var.virtual_hubs[virtual_hub.value.virtual_hub_key].id
      public_ip_count = try(virtual_hub.value.public_ip_count, 1)
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
