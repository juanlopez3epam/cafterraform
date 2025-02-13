variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "location" {
  description = "(Required) Location of the Azure Firewall to be created"
  type        = string
}
variable "resource_group_name" {
  description = "(Required) Resource Group of the Azure Firewall to be created"
  type        = string
}
variable "settings" {
  description = "(Optional) Map of Azure Firewall settings"
  type        = any
}
variable "virtual_hubs" {
  description = "Map of virtual hubs"
  type        = any
  default     = {}
}
variable "firewall_policies" {
  description = "Map of firewall policy objects"
  type        = any
  default     = {}
}
