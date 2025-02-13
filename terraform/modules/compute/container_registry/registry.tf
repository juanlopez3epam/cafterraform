resource "azurecaf_name" "acr" {
  name          = var.name
  resource_type = "azurerm_container_registry"
  prefixes      = try(var.settings.naming_convention.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.use_slug, try(var.global_settings.use_slug, null))
}

resource "azurerm_container_registry" "acr" {
  name                          = azurecaf_name.acr.result
  resource_group_name           = local.resource_group_name
  location                      = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  sku                           = coalesce(var.settings.sku, var.sku, "Basic")
  admin_enabled                 = coalesce(var.settings.admin_enabled, var.admin_enabled, false)
  public_network_access_enabled = coalesce(var.settings.public_network_access_enabled, var.public_network_access_enabled, true)
  quarantine_policy_enabled     = try(var.settings.quarantine_policy_enabled, null)
  zone_redundancy_enabled       = try(var.settings.zone_redundancy_enabled, null)
  export_policy_enabled         = try(var.settings.export_policy_enabled, null)
  anonymous_pull_enabled        = try(var.settings.anonymous_pull_enabled, null)
  data_endpoint_enabled         = try(var.settings.data_endpoint_enabled, null)
  tags                          = local.tags

  dynamic "network_rule_set" {
    for_each = try(merge(var.settings.network_rule_set, var.network_rule_set, {}), {})

    content {
      default_action = try(network_rule_set.value.default_action, "Allow")

      dynamic "ip_rule" {
        for_each = try(network_rule_set.value.ip_rule, [])

        content {
          action   = "Allow"
          ip_range = try(ip_rule.value.ip_range, null)
        }
      }
    }
  }

  dynamic "georeplications" {
    for_each = try(merge(var.settings.georeplications, var.georeplications, {}))

    content {
      location                  = var.global_settings.regions[georeplications.key]
      regional_endpoint_enabled = try(georeplications.value.regional_endpoint_enabled, null)
      zone_redundancy_enabled   = try(georeplications.value.zone_redundancy_enabled, null)
      tags                      = try(georeplications.value.tags)
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
