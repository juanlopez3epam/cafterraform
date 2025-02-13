variable "resource_id" {
  type        = string
  description = "The resource ID that this PE is being created for"
  default     = null
}

variable "resource_alias" {
  type        = string
  description = "The resource Alias that this PE is being created for"
  default     = null
}

variable "subnets" {
  description = "Combined_objects of subnets"
  type        = any
  default     = {}
}

variable "dns_zones" {
  description = "Combined objects of dns zones"
  type        = any
  default     = {}
}

variable "resource_group_name" {
  description = "Resource Group Name to create the private endpoint in"
  type        = string
}

variable "location" {
  description = "Location of the PE"
  type        = string
}

variable "settings" {
  description = "Private Endpoint Settings object"
  type = object({
    name = string
    subnet = object({
      lz_key     = optional(string, null)
      subnet_key = string
    })
    private_service_connection = object({
      is_manual_connection = optional(string, false)
      subresource_names    = optional(list(string),null)
      request_message      = optional(string, null)
    })
    private_dns = map(object({
      dns_zone_key = string
      lz_key       = optional(string, null)
    }))
    tags = optional(map(string), {})
  })
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = {}
}

variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}
