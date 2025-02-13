variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}

variable "resource_groups" {
  description = "Resource group objects (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Key Vault settings object (see module README.md)"
  type = object({
    name                            = string
    resource_group_key              = string
    lz_key                          = optional(string, null)
    sku_name                        = optional(string, "standard")
    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enable_rbac_authorization       = optional(bool, false)
    purge_protection_enabled        = optional(bool, false)
    soft_delete_retention_days      = optional(number, 7)
    network = optional(object({
      bypass         = optional(string, "AzureServices")
      default_action = optional(string, "Deny")
      ip_rules       = optional(list(string), null)
      subnets = optional(map(object({
        subnet_id  = optional(string, null)
        vnet_key   = optional(string, null)
        subnet_key = optional(string, null)
      })), {})
    }), null)
    contacts = optional(map(object({
      email = string
      name  = optional(string, null)
      phone = optional(string, null)
    })), {})
    creation_policies = optional(map(object({
      lz_key                  = optional(string, null)
      managed_identity_key    = optional(string, null)
      object_id               = optional(string, null)
      tenant_id               = optional(string, null)
      key_permissions         = optional(list(string), null)
      secret_permissions      = optional(list(string), null)
      certificate_permissions = optional(list(string), null)
      storage_permissions     = optional(list(string), null)
    })), null)
    private_endpoints = optional(map(object({
      name = string
      subnet = object({
        lz_key     = optional(string, null)
        subnet_key = string
      })
      private_service_connection = object({
        is_manual_connection = optional(string, false)
        subresource_names    = list(string)
        request_message      = optional(string, null)
      })
      private_dns = map(object({
        dns_zone_key = string
        lz_key       = optional(string, null)
      }))
      tags = optional(map(string), {})
    })), null)
  })
}
variable "vnets" {
  description = "Virtual Network objects (see module README.md)"
  type        = any
  default     = {}
}
variable "azuread_groups" {
  description = "Azure AD groups objects (see module README.md)"
  type        = any
  default     = {}
}
variable "managed_identities" {
  description = "Managed Identity objects (see module README.md)"
  type        = any
  default     = {}
}
# For diagnostics settings
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
variable "subnets" {
  description = "Subnets object"
  type        = any
  default     = {}
}
variable "dns_zones" {
  description = "DNS Zones Object"
  type        = any
  default     = {}
}
