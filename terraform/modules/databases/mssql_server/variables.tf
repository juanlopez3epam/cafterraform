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
  description = "Client configuration object (see module README.md)."
  type = object({
    landingzone_key = optional(string)
  })
  default = {}
}
variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type = object({
    name                          = string
    resource_group_key            = string
    version                       = optional(string, "12.0")
    public_network_access_enabled = optional(bool, false)
    connection_policy             = optional(string, null)
    minimum_tls_version           = optional(string, "1.2")
    administrator_login           = optional(string, null)
    azuread_administrator = optional(object({
      azuread_authentication_only = optional(bool, true)
      login_username              = optional(string)
      object_id                   = optional(string)
      tenant_id                   = optional(string)
    }), null)
    identity = optional(object({
      type = string
    }), null)
    firewall_rules = optional(map(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
    })), {})
    network_rules = optional(map(object({
      name       = string
      subnet_id  = string
      lz_key     = optional(string, null)
      vnet_key   = string
      subnet_key = string
    })), {})
    keyvault_secret_name = optional(string, null)
    transparent_data_encryption = optional(object({
      enable = optional(bool, false)
      encryption_key = optional(object({
        lz_key           = string
        keyvault_key_key = string
      }), null)
    }), null)
  })
}
variable "vnets" {
  description = "Vnets object (see module README.md)"
  type        = any
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = {}
}
variable "key_vault_secret" {
  description = "The Key Vault secret object where the SQL admin password is stored."
  type        = any
  default     = null
}
