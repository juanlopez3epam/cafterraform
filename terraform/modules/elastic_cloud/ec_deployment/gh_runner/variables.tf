variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}

variable "settings" {
  description = "variables to create a elastic cloud cluster"
  type = object({
    name                   = string
    region                 = string
    version                = string
    deployment_template_id = string
    alias                  = optional(string)
    request_id             = optional(string)
    tags                   = optional(string)
    resource_group_key     = string

    elasticsearch = object({
      hot = object({
        size = optional(string)

        autoscaling = optional(object({
          min_size          = optional(string)
          min_size_resource = optional(string)
          max_size          = optional(string)
          max_size_resource = optional(string)
        }), {})
      })
    })
    kibana = optional(object({}), null)
    private_endpoint = optional(object({
      name = string
      subnet = object({
        lz_key     = optional(string, null)
        subnet_key = string
      })
      private_service_connection = object({
        is_manual_connection = optional(string, false)
        subresource_names    = optional(list(string))
        request_message      = optional(string, null)
      })
      private_dns = map(object({
        dns_zone_key = string
        lz_key       = optional(string, null)
      }))
      tags = optional(map(string), {})
    }), null)
    private_dns_zone_rg = string
    base_vnet_id        = string
  })
}

variable "subnets" {
  description = "Subnets object"
  type        = any
  default     = {}
}

variable "runner_settings" {
  description = "variables to identify where self hosted runner is located"
  type = object({
    region                         = string
    resource_group                 = string
    vnet                           = string
    subscription_id                = string
    pvt_endpoint_subnet_name       = string
  })
}

variable "ec_region" {
  description = "Region of the ec to be attached"
  type        = string
}

variable "ec_id" {
  description = "Id of the ec to be attached"
  type        = string
}

variable "ec_search_id" {
  description = "Id of the ec to be attached"
  type        = string
}

variable "ec_privatelink" {
  description = "private link alias of the ec to be attached"
  type        = string
}

variable "create_ec_gh-runner_privatelink" {
  description = "Create a new private DNS zone for the subscription"
  type        = bool
}