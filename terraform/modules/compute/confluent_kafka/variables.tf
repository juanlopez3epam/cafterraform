variable "global_settings" {
  description = "Global settings object"
  type        = any
  default     = {}
}
variable "client_config" {
  description = "Client configuration object"
  type        = any
  default     = {}
}

variable "keyvaults" {
  description = "Key Vaults"
  type        = any
}

variable "vnets" {
  description = "Virtual network objects"
  type        = map(any)
  default     = null
}
variable "cluster_settings" {
  description = "variables to create a confluent cloud kafka cluster"
  type = object({
    env_display_name        = string
    display_name            = string
    availability            = string
    cloud                   = string
    region                  = string
    cku                     = number
    keyvault_key            = string
    vnet_key                = string
    vnet_subnet_key         = string
    is_multizone_cluster    = bool
  })
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
