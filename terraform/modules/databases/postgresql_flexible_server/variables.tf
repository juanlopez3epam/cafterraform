variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = {}
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
  type        = any
  default     = {}
}
variable "resource_groups" {
  description = "(Required) The name of the Resource Group where the resource should exist. Changing this forces a new resource to be created."
  type        = any
}
variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type = object({
    name                          = string
    region                        = optional(string, null)
    resource_group_key            = string
    sku_name                      = optional(string, null)
    version                       = optional(string, null)
    public_network_access_enabled = optional(bool, false)
    storage_mb                    = optional(number, null)
    administrator_username        = optional(string, "pgadmin")
    administrator_password        = optional(string, null)
    administrator_password_configuration = optional(object({
      length           = optional(number, 128)
      upper            = optional(bool, true)
      lower            = optional(bool, true)
      numeric          = optional(bool, true)
      special          = optional(bool, true)
      min_lower        = optional(number, 1)
      min_numeric      = optional(number, 1)
      min_special      = optional(number, 1)
      min_upper        = optional(number, 1)
      override_special = optional(string, "_!#")
    }), null)
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
    }), null)
    backup_retention_days             = optional(number, null)
    geo_redundant_backup_enabled      = optional(bool, null)
    point_in_time_restore_time_in_utc = optional(string, null)
    source_server_id                  = optional(string, null)
    source_server_key                 = optional(string, null)
    create_mode                       = optional(string, "Default")
    keyvault_key                      = optional(string, null)
    zone                              = optional(string, null)
    vnet_integration = optional(object({
      subnet_key = optional(string, null)
      lz_key     = optional(string, null)
    }), null)
    dns_zone = optional(object({
      dns_zone_key = optional(string, null)
      lz_key       = optional(string, null)
    }), null)
    maintenance_window = optional(object({
      day_of_week  = optional(number, 0)
      start_hour   = optional(number, 0)
      start_minute = optional(number, 0)
    }), null)
    tags = optional(map(any), {})
    postgresql_configurations = optional(map(object({
      name  = optional(string, null)
      value = optional(string, null)
    })), {})
    postgresql_databases = optional(map(object({
      name      = optional(string, null)
      collation = optional(string, "en_US.utf8")
      charset   = optional(string, "utf8")
    })), {})
    postgresql_firewall_rules = optional(map(object({
      name             = optional(string, null)
      start_ip_address = optional(string, null)
      end_ip_address   = optional(string, null)
    })), {})
    postgres_aad_administrators = optional(map(object({
      object_id      = optional(string, null)
      tenant_id      = optional(string, null)
      principal_name = optional(string, null)
      principal_type = optional(string, null)
    })), {})
    high_availability = optional(map(any), null)
    # high_availability = optional(object({
    #   mode                      = string
    #   standby_availability_zone = optional(string, null)
    # }))
  })
}
variable "subnets" {
  description = "Subnets Object"
  type        = any
  default     = {}
}
variable "source_postgresql_flexible_servers" {
  description = "Source PostgreSQL Flexible Servers object (see module README.md)"
  type        = any
  default     = {}
}
variable "private_dns_zones" {
  description = "Private DNS Zones Object"
  type        = any
  default     = {}
}
variable "keyvaults" {
  description = "Key Vaults object (see module README.md)"
  type        = any
}
variable "diagnostics" {
  description = "Diagnostics object"
  type = object({
    diagnostics_definition         = optional(any, null)
    diagnostics_destinations       = optional(any, null)
    log_analytics_workspaces       = optional(any, null)
    eventhub_name                  = optional(any, null)
    eventhub_authorization_rule_id = optional(any, null)
  })
  default = null
}
variable "diagnostic_profiles" {
  description = "Diagnostics profiles"
  type = map(object({
    definition_key   = string
    destination_type = string
    destination_key  = string
  }))
  default = null
}
