variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "settings" {
  description = "Private DNS Resolver settings object (see module README.md)"
  type = object({
    name               = string
    resource_group_key = string
    location           = optional(string, null)
    vnet_key           = string
    tags               = optional(map(string), {})
    inbound_endpoints = optional(map(object({
      name       = string
      location   = optional(string, null)
      subnet_key = string
    })), {})
    outbound_endpoints = optional(map(object({
      name       = string
      location   = optional(string, null)
      subnet_key = string
    })), {})
  })
}

variable "resource_group" {
  description = "The resource group to create the Private DNS Resolver in"
  type        = any
}

variable "virtual_networks" {
  description = "Collection of Virtual Networks - the Virtual Network info is selected by the vnet_key in the Private DNS Resolver settings object."
  type        = map(any)
}
