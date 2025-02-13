variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)"
  default     = {}
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group"
  type        = string
}

variable "subnets" {
  description = "map structure for the subnets to be created"
  type        = any
}

variable "tags" {
  description = "tags of the resource"
  default     = {}
  type        = map(any)
}

variable "location" {
  description = "location of the resource"
  type        = string
}

variable "application_security_groups" {
  default     = {}
  type        = any
  description = "Application Security Groups to be created"
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = null
}

variable "network_security_group_definition" {
  description = "Network Security Group definition"
  type        = any
  default     = {}
}
