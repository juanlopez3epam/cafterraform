#tflint-ignore: terraform_unused_declarations
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
  description = "Key Vault Secret settings object (see module README.md)"
  type = object({
    keyvault_key       = string
    lz_key             = optional(string, null)
    secret_name        = string
    template_name      = string
    template_path      = string
    template_variables = map(string)
    template_type      = optional(string, "multi-line")
    resources          = any
  })
}

variable "keyvault" {
  description = "Key Vault object"
  type        = any
  default     = {}
}
variable "resources" {
  description = "Map of resources to be used in the template"
  type = object({
    keyvault_dynamic_secrets     = optional(map(any), null)
    keyvault_secrets             = optional(map(any), null)
    postgresql_flexible_servers  = optional(map(any), null)
    redis_caches                 = optional(map(any), null)
    enterprise_redis_clusters    = optional(map(any), null)
    enterprise_redis_databases   = optional(map(any), null)
    elasticsearch_security_users = optional(map(any), null)
    elastic_cloud_deployments    = optional(map(any), null)
    confluent_cloud_deployments  = optional(map(any), null)
    storage_accounts             = optional(map(any), null)
  })
  default = null
}
variable "level_path" {
  description = "Path to the level"
  type        = string
}
