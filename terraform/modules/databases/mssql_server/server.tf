resource "azurecaf_name" "mssql" {
  name          = var.settings.name
  resource_type = "azurerm_sql_server"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_mssql_server" "mssql" {
  name                          = azurecaf_name.mssql.result
  resource_group_name           = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].name
  location                      = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].location
  version                       = var.settings.version
  public_network_access_enabled = var.settings.public_network_access_enabled
  connection_policy             = var.settings.connection_policy
  minimum_tls_version           = var.settings.minimum_tls_version
  administrator_login           = try(var.settings.azuread_administrator.azuread_authentication_only, false) == true ? null : var.settings.administrator_login
  administrator_login_password  = try(var.key_vault_secret, null) == null ? null : var.key_vault_secret.value

  tags = local.tags
  azuread_administrator {
    azuread_authentication_only = var.settings.azuread_administrator.azuread_authentication_only
    login_username              = var.settings.azuread_administrator.login_username
    object_id                   = var.settings.azuread_administrator.object_id
    tenant_id                   = var.global_settings.tenant_id
  }

  dynamic "identity" {
    for_each = can(var.settings.identity) ? [var.settings.identity] : []

    content {
      type = identity.value.type
    }
  }
}

resource "azurerm_mssql_firewall_rule" "firewall_rules" {
  for_each = try(var.settings.firewall_rules, {})

  name             = each.value.name
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_virtual_network_rule" "network_rules" {
  for_each = var.settings.network_rules

  name      = each.value.name
  server_id = azurerm_mssql_server.mssql.id
  subnet_id = can(each.value.subnet_id) ? each.value.subnet_id : var.vnets[coalesce(each.value.lz_key, var.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
}
