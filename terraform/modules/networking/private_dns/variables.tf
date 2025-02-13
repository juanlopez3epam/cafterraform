variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "name" {
  description = "Name of the Private DNS Zone to create"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group to create the Private DNS Zone In"
  type        = string
}

variable "vnet_links" {
  description = "A collection of VNet Link Settings Objects"
  type = map(object({
    vnet_key             = string
    lz_key               = optional(string, null)
    registration_enabled = optional(bool, false)
  }))
}

variable "virtual_networks" {
  description = "(Optional) A `vnets` block as defined below."
  type        = any
  default     = {}
}

variable "client_config" {
  description = "Client Config"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags for the resource."
  type        = map(any)
  default     = {}
}
