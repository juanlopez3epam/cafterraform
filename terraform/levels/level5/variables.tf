variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)"
  default     = {}
}
variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}
variable "logged_user_object_id" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_object_id" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}
# variable "remote_state" {
#   description = "Remote state object (see module README.md)"
#   type = object({
#     resource_group_name  = string
#     storage_account_name = string
#     container_name       = string
#     key                  = optional(string, "state")
#   })
# }

variable "provider_azurerm_features_keyvault" {
  type        = any
  description = "Provider azurerm features keyvault"
  default = {
    purge_soft_delete_on_destroy = true
  }
}
# variable "provider_elasticstack_elasticsearch" {
#   type = object({
#     lz_key      = optional(string, "local")
#     cluster_key = string
#   })
#   description = "Provider elasticstack elasticsearch configuration"
# }
variable "dynamic_keyvault_secrets" {
  description = "Dynamic Key Vault Secret objects"
  type        = any
  default     = {}
}
variable "keyvault_template_secrets" {
  type        = any
  description = "Keyvault template secrets"
  default     = {}
}
variable "elasticsearch_indexes" {
  description = "Elastic Search indexes"
  type        = any
  default     = {}
}
variable "elasticsearch_index_templates" {
  description = "Elastic Search Index Template"
  type        = any
  default     = {}
}
variable "elasticsearch_security_roles" {
  description = "Elastic Search Security Roles"
  type        = any
  default     = {}
}
variable "elasticsearch_security_users" {
  description = "Elastic Search Security Users"
  type        = any
  default     = {}
}
variable "lvl4_landingzone_key" {
  description = "Key for the lvl 4 landing zones where the deployment is executed."
  default     = "local"
  type        = string
}
variable "remote_state-resource_group_name" {
  description = "Level3 remote tf state resource group name"
  type        = string
  default     = ""
}

variable "remote_state-storage_account_name" {
  description = "Level3 remote tf state storage account name"
  type        = string
  default     = ""
}

variable "separate-sample_rate_limiting-cache-enabled" {
  description = "Set to true if a separate sample rate limiting redis cache was created in level4"
  type        = bool 
  default     = false
}

variable "separate-sample_device_checkin-cache-enabled" {
  description = "Set to true if a separate sample rate limiting redis cache was created in level4"
  type        = bool 
  default     = false
}