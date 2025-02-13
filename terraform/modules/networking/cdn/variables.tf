variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "resource_group_name" {
  description = "(Required) Resource Group of the CDN to be created"
  type        = string
}

variable "location" {
  description = "(Required) Location of the CDN to be created"
  type        = string
}

variable "settings" {
  description = "Private Endpoint Settings object"
  type = object({
    name = string
    sku  = optional(string, null)
    cdn_endpoint = map(object({
      name               = string
      host_name          = string
      http_port          = number
      https_port         = number
      is_http_allowed    = bool
      is_https_allowed   = bool
      origin_path        = string
      origin_host_header = optional(string, null)
    }))
    tags = optional(map(string), {})
  })
}
