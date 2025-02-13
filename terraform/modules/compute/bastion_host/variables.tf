variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "settings" {
  description = "Bastion settings object (see module README.md)"
  type        = any
}


variable "resource_groups" {
  description = "Resource group objects"
  type        = any
}

variable "virtual_networks" {
  description = "virtual_networks objects"
  type        = any
}

variable "public_ip_addresses" {
  description = "public_ip_address objects"
  type        = any
}
