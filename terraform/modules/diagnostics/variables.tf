variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}

variable "resource_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  type        = string
}

variable "diagnostics" {
  description = "Diagnostics object"
  type = object({
    diagnostics_definition   = optional(any, null)
    diagnostics_destinations = optional(any, null)
    log_analytics_workspaces = optional(any, null)
    eventhub_name            = optional(any, null)
    eventhub_authorization_rule_id = optional(any, null)
  })
  default = null
}

variable "profiles" {
  description = "Diagnostics profiles"
  type = map(object({
    definition_key   = string
    destination_type = string
    destination_key  = string
  }))
  default = {}
  validation {
    condition     = length(var.profiles) < 6
    error_message = "Maximun of 5 diagnostics profiles are supported."
  }
}
