variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}

variable "settings" {
  type        = any
  description = "(Required) Used to handle passthrough parameters."
}

variable "resource_group" {
  description = "(Required) A Resource Group object."
  type        = any
}
