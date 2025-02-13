resource "azurecaf_name" "postgresql_flexible_server" {
  name          = var.settings.name
  resource_type = "azurerm_postgresql_flexible_server"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                          = azurecaf_name.postgresql_flexible_server.result
  resource_group_name           = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].name
  location                      = var.global_settings.regions[coalesce(var.settings.region, var.global_settings.default_region)]
  version                       = var.settings.version
  sku_name                      = var.settings.sku_name
  zone                          = var.settings.zone
  storage_mb                    = var.settings.storage_mb
  public_network_access_enabled = var.settings.public_network_access_enabled

  delegated_subnet_id = try(var.settings.vnet_integration.subnet_key, null) != null ? var.subnets[coalesce(try(var.settings.vnet_integration.lz_key, null), var.client_config.landingzone_key)][var.settings.vnet_integration.subnet_key].id : null
  private_dns_zone_id = try(var.settings.dns_zone.dns_zone_key, null) != null ? var.private_dns_zones[coalesce(try(var.settings.dns_zone.lz_key, null), var.client_config.landingzone_key)][var.settings.dns_zone.dns_zone_key].id : null

  create_mode                       = var.settings.create_mode
  point_in_time_restore_time_in_utc = var.settings.create_mode == "PointInTimeRestore" ? var.settings.point_in_time_restore_time_in_utc : null
  source_server_id                  = var.settings.create_mode == "PointInTimeRestore" || var.settings.create_mode == "Replica" ? coalesce(var.settings.source_server_id, var.source_postgresql_flexible_servers[var.settings.source_server_key].id) : null

  administrator_login    = var.settings.create_mode == "Default" ? var.settings.administrator_username : null
  administrator_password = var.settings.create_mode == "Default" ? coalesce(var.settings.administrator_password, azurerm_key_vault_secret.postgresql_administrator_password[0].value) : null

  backup_retention_days        = var.settings.backup_retention_days
  geo_redundant_backup_enabled = var.settings.geo_redundant_backup_enabled

  dynamic "authentication" {
    for_each = try(var.settings.authentication, null) == null ? [] : [var.settings.authentication]

    content {
      active_directory_auth_enabled = var.settings.authentication.active_directory_auth_enabled
      password_auth_enabled         = var.settings.authentication.password_auth_enabled
      tenant_id                     = var.client_config.tenant_id
    }
  }

  dynamic "maintenance_window" {
    for_each = var.settings.maintenance_window == null ? [] : [var.settings.maintenance_window]

    content {
      day_of_week  = var.settings.maintenance_window.day_of_week
      start_hour   = var.settings.maintenance_window.start_hour
      start_minute = var.settings.maintenance_window.start_minute
    }
  }

  dynamic "high_availability" {
    for_each = try(var.settings.high_availability, null) == null ? [] : [var.settings.high_availability]

    content {
      mode = var.settings.high_availability.mode
      # Setting standby_availability_zone to `null` will cause Azure to pick one for us.
      standby_availability_zone = var.settings.zone == null ? null : (try(var.settings.high_availability.standby_availability_zone, null) == null ? null : var.settings.high_availability.standby_availability_zone)
    }
  }

  lifecycle {
    ignore_changes = [
      replication_role,
      zone,
      high_availability[0].standby_availability_zone,
      tags
    ]
  }

  # configuring timeouts for PostgreSQL Flexible Server resource based on timeouts from 
  # Azure SQL Managed Instance resource to accomidate for long running operations 
  # when restoring from a point in time or creating a replica.
  timeouts {
    create = "10h"
    update = "10h"
    delete = "10h"
    read   = "5m"
  }
}

# Store the postgresql_flexible_server administrator_username into keyvault if the attribute keyvault{} is defined.
resource "azurerm_key_vault_secret" "postgresql_administrator_username" {
  count = (var.settings.keyvault_key != null && var.settings.create_mode == "Default") ? 1 : 0

  name         = format("%s-username", azurecaf_name.postgresql_flexible_server.result)
  value        = var.settings.administrator_username
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id
}

# Generate random postgresql_flexible_administrator_password if attribute administrator_password not provided.
resource "random_password" "postgresql_administrator_password" {
  count = var.settings.administrator_password == null ? 1 : 0

  length           = var.settings.administrator_password_configuration.length
  upper            = var.settings.administrator_password_configuration.upper
  numeric          = var.settings.administrator_password_configuration.numeric
  special          = var.settings.administrator_password_configuration.special
  min_lower        = var.settings.administrator_password_configuration.min_lower
  min_numeric      = var.settings.administrator_password_configuration.min_numeric
  min_special      = var.settings.administrator_password_configuration.min_special
  min_upper        = var.settings.administrator_password_configuration.min_upper
  override_special = var.settings.administrator_password_configuration.override_special
}

# Store the postgresql_flexible_administrator_password into keyvault if the attribute keyvault{} is defined.
resource "azurerm_key_vault_secret" "postgresql_administrator_password" {
  count = (var.settings.keyvault_key != null && var.settings.create_mode == "Default") ? 1 : 0

  name         = format("%s-password", azurecaf_name.postgresql_flexible_server.result)
  value        = coalesce(var.settings.administrator_password, random_password.postgresql_administrator_password[0].result)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id
}
