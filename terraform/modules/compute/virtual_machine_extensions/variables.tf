variable "virtual_machine_id" {
  description = "Virtual machine ID."
  type        = string
}

variable "extension" {
  description = "Extension object."
  type        = any
}

variable "extension_name" {
  description = "Extension name."
  type        = string
}

variable "settings" {
  description = "(Required) configuration object describing the networking configuration, as described in README"
  type        = any
}

variable "client_config" {
  description = "Client configuration object (see module README.md)."
  type        = any
}

variable "keyvaults" {
  description = "Keyvaults to use for storing secrets."
  default     = {}
  type        = any
}

variable "wvd_host_pools" {
  description = "WVD host pools."
  default     = {}
  type        = any
}

variable "managed_identities" {
  description = "Managed identities."
  default     = {}
  type        = any
}

variable "storage_accounts" {
  description = "Storage accounts."
  default     = {}
  type        = any
}

variable "virtual_machine_os_type" {
  description = "Virtual machine OS type."
  type        = string
}
