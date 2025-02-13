variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Container Registry settings object (see module README.md)"
  type = object({
    name                          = string
    resource_group_key            = optional(string, null)
    resource_group_name           = optional(string, null)
    sku                           = optional(string, null)
    admin_enabled                 = optional(bool, null)
    public_network_access_enabled = optional(bool, null)
    quarantine_policy_enabled     = optional(bool, null)
    zone_redundancy_enabled       = optional(bool, null)
    export_policy_enabled         = optional(bool, null)
    anonymous_pull_enabled        = optional(bool, false)
    data_endpoint_enabled         = optional(bool, null)
    network_rule_set              = optional(any, {})
    network_rule_bypass_option    = optional(string, null)
    georeplications = optional(map(object({
      regional_endpoint_enabled = optional(bool, null)
      zone_redundancy_enabled   = optional(bool, null)
      tags                      = optional(map(string), null)
    })), null)
    tags = optional(map(string), null)
    naming_convention = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
  })
}
variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "sku" {
  description = "(Optional) The SKU name of the container registry. Possible values are Basic, Standard and Premium. Defaults to Basic"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "georeplications" {
  description = "(Optional) Updated structure for Azure locations where the container registry should be geo-replicated."
  type = map(object({
    regional_endpoint_enabled = optional(bool, null)
    zone_redundancy_enabled   = optional(bool, null)
    tags                      = optional(map(string), null)
  }))
  default = {}
}
#tflint-ignore: terraform_unused_declarations
variable "vnets" {
  description = "(Optional) A list of virtual network rules that specify which networks can access the container registry."
  type        = any
  default     = {}
}

variable "network_rule_set" {
  description = " (Optional) A network_rule_set block as documented https://www.terraform.io/docs/providers/azurerm/r/container_registry.html"
  type        = any
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "diagnostic_profiles" {
  description = "(Optional) A diagnostic_profiles blocks"
  type        = any
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "diagnostics" {
  description = "(Optional) A diagnostics blocks"
  type        = any
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "private_endpoints" {
  description = "(Optional) private endpoints that should be created for this Container Registry."
  type        = any
  default     = {}
}

variable "resource_groups" {
  description = "Resource groups objects"
  type        = any
  default     = {}
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "private_dns" {
  description = "Private DNS objects"
  type        = any
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the container registry. Defaults to true."
  type        = bool
  default     = "true"
}
