variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "settings" {
  description = "Private DNS Resolver Inbound Endpoint settings object (see module README.md)"
  type = object({
    name       = string
    location   = optional(string, null)
    subnet_key = string
  })
}

variable "private_dns_resolver_id" {
  description = "The ID of the Private DNS Resolver resource to create this Inbound Endpoint in"
  type        = string
}

variable "subnets" {
  description = "Collection of subnets contained in the Private DNS Resolver VNet - the actual subnet is selected buy the subnet_key in the settings object."
  type        = any
}
