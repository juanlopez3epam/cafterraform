variable "firewall_policy_id" {
  description = "The firewall policy ID to deploy this rule collection group in"
  type        = string
}

variable "name" {
  description = "The name of the firewall policy rule collection group"
  type        = string
}

variable "priority" {
  description = "The priority of the firewall policy rule collection group - defaults to 500"
  type        = number
  default     = 500
}

variable "application_rule_collections" {
  description = "Application Rule Collection objects"
  type        = map(any)
  default     = {}
}

variable "network_rule_collections" {
  description = "Network Rule Collection objects"
  type        = map(any)
  default     = {}
}

variable "nat_rule_collections" {
  description = "NAT Rule Collection objects"
  type        = map(any)
  default     = {}
}
