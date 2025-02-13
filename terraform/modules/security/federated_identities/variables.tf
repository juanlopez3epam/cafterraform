variable "global_settings" {
  description = "Global settings"
  type        = any
}
variable "client_config" {
  description = "Client configuration"
  type        = any
  default     = {}
}

variable "settings" {
  description = "Settings"
  type = map(object({
    name                  = string
    resource_group_key    = optional(string, null)
    audience              = optional(list(string), null)
    issuer                = optional(string, null)
    subject               = string
    kubernetes_issuer_key = optional(string, null)
    managed_identity_key  = optional(string, null)
  }))
}

variable "user_assigned_identity_resource_id" {
  description = "Parent ID"
  type        = string
  default     = null
}

variable "resource_groups" {
  description = "Resource groups"
  type        = any
  default     = {}
}

variable "resources" {
  description = "Resources that contain identity information"
  type        = any
  default     = {}
}
