# naming convention
resource "azurecaf_name" "keyvault" {
  name          = var.settings.name
  resource_type = "azurerm_key_vault"
  prefixes      = var.global_settings.keyvault_prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = false
}

resource "azurerm_key_vault" "keyvault" {
  name                            = azurecaf_name.keyvault.result
  location                        = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  resource_group_name             = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].name
  tenant_id                       = var.client_config.tenant_id
  sku_name                        = var.settings.sku_name
  enabled_for_deployment          = var.settings.enabled_for_deployment
  enabled_for_disk_encryption     = var.settings.enabled_for_disk_encryption
  enabled_for_template_deployment = var.settings.enabled_for_template_deployment
  enable_rbac_authorization       = var.settings.enable_rbac_authorization
  purge_protection_enabled        = var.settings.purge_protection_enabled
  soft_delete_retention_days      = var.settings.soft_delete_retention_days

  dynamic "network_acls" {
    for_each = try(var.settings.network[*], {})
    content {
      bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules
      virtual_network_subnet_ids = try(network_acls.value.subnets, null) == null ? [] : [
        for key, value in network_acls.value.subnets : try(value.subnet_id, null) != null ? value.subnet_id : var.vnets[value.vnet_key].subnets[value.subnet_name].id
      ]
    }
  }

  dynamic "contact" {
    for_each = try(var.settings.contacts, {})
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }

  timeouts {
    delete = "60m"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

module "private_endpoints" {
  source              = "../../networking/private_endpoint"
  depends_on          = [azurerm_key_vault.keyvault]
  for_each            = try(var.settings.private_endpoints, null) != null ? var.settings.private_endpoints : {}
  resource_id         = azurerm_key_vault.keyvault.id
  global_settings     = var.global_settings
  client_config       = var.client_config
  subnets             = var.subnets
  dns_zones           = var.dns_zones
  resource_group_name = azurerm_key_vault.keyvault.resource_group_name
  location            = azurerm_key_vault.keyvault.location
  settings            = each.value
}
