variable "settings" {
  description = "(Required) Azure Firewall Policy Configuration"
  type        = any
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "resource_group" {
  description = "(Required) A resource_group object."
  type        = any
}

variable "base_policy_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the base Firewall Policy."
}

variable "dns_resolver_ip" {
  description = "(Optional) IP Address for the DNS Proxy to use to resolve DNS queries - leave `null` to use Azure DNS"
  type        = string
  default     = null
}
