#tflint-ignore: terraform_unused_declarations
variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Redis Cache settings object (see module README.md)"
  type = object({
    primary_cluster_key = string
    client_protocol     = optional(string, null)
    clustering_policy   = optional(string, null)
    eviction_policy     = optional(string, null)
    port                = optional(number, null)
    module = optional(map(object({
      name = string
      args = optional(map(string), null)
    })), null)
    linked_database_id             = optional(set(string), null)
    linked_database_group_nickname = optional(string, null)
  })
}
variable "redis_cluster" {
  description = "The Redis Enterprise Cluster objects"
  type        = any
}
#tflint-ignore: terraform_unused_declarations
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
#tflint-ignore: terraform_unused_declarations
variable "diagnostic_profiles" {
  description = "Diagnostics profiles"
  type = map(object({
    definition_key   = string
    destination_type = string
    destination_key  = string
  }))
  default = null
}
