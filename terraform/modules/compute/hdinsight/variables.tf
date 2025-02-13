variable "resource_groups" {
  description = "Resource Groups"
  type        = any
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = {}
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}

variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type = object({
    name                = string
    resource_group_key  = string
    storage_account_key = string
    container_key       = string
    keyvault_key        = string
    cluster_version     = optional(string, "5.0")
    component_version   = optional(string, "2.4")
    tier                = optional(string, "Standard")
    tls_min_version     = optional(string, "1.2")
    vnet_key            = optional(string, null)
    vnet_subnet_key     = optional(string, null)
    administrator_password_configuration = optional(object({
      length           = optional(number, 64)
      keystore_length  = optional(number, 12)
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
    encryption = object({
      at_host_enabled    = optional(bool, true)
      in_transit_enabled = optional(bool, true)
    })
    gateway = object({
      username = optional(string, "acctestusrgw")
      password = optional(string, null)
    })
    roles = object({
      head_node = object({
        vm_size  = string
        username = optional(string, "acctestusrvm")
      })
      worker_node = object({
        vm_size                  = string
        username                 = optional(string, "acctestusrvm")
        password                 = optional(string, null)
        number_of_disks_per_node = number
        target_instance_count    = number
      })
      zookeeper_node = object({
        vm_size  = string
        username = optional(string, "acctestusrvm")
        password = optional(string, null)
      })
    })
    metastores = optional(object({
      hive = optional(object({
        server_key                   = string
        database_name                = string
        username                     = string
        password_keyvault_secret_key = string
      }), null)
      oozie = optional(object({
        server_key                   = string
        database_name                = string
        username                     = string
        password_keyvault_secret_key = string
      }), null)
      ambari = optional(object({
        server_key                   = string
        database_name                = string
        username                     = string
        password_keyvault_secret_key = string
      }), null)
    }), null)
    log_analytics_workspace_key = optional(string, null)
    tags                        = optional(map(any), {})
  })
}

variable "key_vault_secrets" {
  description = "Key Vault Secrets"
  type        = any
}

variable "mssql_servers" {
  description = "MSSQL Servers that can be used for metastore configuration"
  type        = any
}

variable "keyvaults" {
  description = "Key Vaults"
  type        = any
}

variable "storage_accounts" {
  description = "Storage Accounts"
  type        = any
}
variable "vnets" {
  description = "Virtual network objects"
  type        = map(any)
  default     = null
}

variable "diagnostics" {
  description = "Diagnostics object"
  type = object({
    diagnostics_definition   = optional(any, null)
    diagnostics_destinations = optional(any, null)
    log_analytics_workspaces = optional(any, null)
    eventhub_name            = optional(any, null)
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

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = {}
}
