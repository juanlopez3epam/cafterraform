variable "global_settings" {
  description = "global settings"
  type        = any
}

variable "settings" {
  description = "virtual hub settings"
  type        = any
}

variable "location" {
  description = "(Required) Location where to create the hub resources"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group to create the hub resources"
  type        = string
}

variable "vwan_id" {
  description = "(optional) Resource ID for the Virtual WAN object"
  type        = string
}

variable "virtual_networks" {
  description = "Combined object for Virtual Networks"
  type        = any
}
