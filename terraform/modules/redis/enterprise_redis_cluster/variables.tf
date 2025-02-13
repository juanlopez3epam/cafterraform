variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "client_config" {
  description = "Client config settings object"
  type        = any
}
variable "settings" {
  description = "Redis Cache settings object (see module README.md)"
  type = object({
    name                = string
    region              = optional(string, null)
    sku_name            = string
    tags                = optional(map(any), null)
    minimum_tls_version = optional(string, null)
    zones               = optional(list(string), null)
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
    })), {})
  })
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = any
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
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
variable "subnets" {
  description = "Subnets object"
  type        = any
  default     = null
}
variable "dns_zones" {
  description = "Private DNS Zones"
  type        = any
  default     = null
}
