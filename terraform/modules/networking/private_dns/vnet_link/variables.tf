variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "tags" {
  description = "Tags for the resource."
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "(Required) The name of the private DNS zone. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the private DNS zone."
  type        = string
}

variable "private_dns_zone_name" {
  description = "(Required) The name of the Private DNS Zone to link with the VNet"
  type        = string
}

variable "virtual_network_id" {
  description = "(Required) The ID of the VNet to link the DNS zone with"
  type        = string
}

variable "registration_enabled" {
  description = "Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?"
  type        = bool
}
