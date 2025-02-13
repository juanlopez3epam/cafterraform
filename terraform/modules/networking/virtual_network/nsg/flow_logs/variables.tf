variable "resource_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  type        = string
}

variable "resource_location" {
  description = "(Required) location of the resource"
  type        = string
}

variable "client_config" {
  description = "client_config object (see module README.md)"
  type        = any
}

variable "diagnostics" {
  description = "(Required) Contains the diagnostics setting object."
  type        = any
}

variable "settings" {
  description = "(Optional) Map of Azure Firewall settings"
  type        = any
}

variable "network_watchers" {
  description = "Network Watchers to be created"
  default     = {}
  type        = any
}
