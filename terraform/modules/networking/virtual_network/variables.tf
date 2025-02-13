variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "settings" {
  description = "Virtual network settings object (see module README.md)"
  type        = any
}

variable "resource_group" {
  description = "Resource group object"
  type        = any
}

variable "application_security_groups" {
  description = "Application Security Group objects"
  type        = any
  default     = {}
}

variable "network_security_group_definition" {
  description = "Network Security Group definition"
  type        = any
  default     = {}
}

variable "dns_servers" {
  default     = []
  type        = list(string)
  description = "List of DNS server IPs - leave blank to juse Azure DNS"
}

variable "ddos_protection_plan" {
  default     = {}
  type        = any
  description = "DDoS Protection Plan to use with this VNet"
}
variable "route_tables" {
  default     = {}
  type        = any
  description = "Route table objects"
}
