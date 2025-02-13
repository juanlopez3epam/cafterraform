variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "log_analytics" {
  description = "Log Analytics object"
  type        = any
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Log Analytics Workspace is created."
  type        = string
}

variable "location" {
  description = "The location of the Log Analytics Workspace."
  type        = string
}
