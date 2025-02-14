variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the resource. Changing this forces a new resource to be created. "
  type        = string
}

variable "location" {
  description = "(Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "diagnostics" {
  description = "(Required) Diagnostics object with the definitions and destination services"
  type        = any
}

variable "settings" {
  description = "(Required) configuration object describing the networking configuration, as described in README"
  type        = any
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = null
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

variable "network_watchers" {
  description = "Optional - Network Watches Object"
  type        = any
  default     = {}
}

variable "client_config" {
  description = "client_config object (see module README.md)"
  type        = any
}

variable "application_security_groups" {
  description = "Application Security Groups to attach the NSG"
  type        = any
  default     = {}
}
