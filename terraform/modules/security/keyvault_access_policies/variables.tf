variable "keyvaults" {
  description = "Key Vault objects"
  type        = any
  default     = {}
}
variable "keyvault_key" {
  description = "value of the keyvaults map"
  type        = string
  default     = null
}
variable "keyvault_id" {
  description = "The ID of the Key Vault to which the access policy should be applied."
  type        = string
  default     = null
}
variable "access_policies" {
  description = "A map of access policies to apply to the Key Vault."
  type = map(object({
    lz_key                        = optional(string, null)
    managed_identity_key          = optional(string, null)
    azuread_app_key               = optional(string, null)
    azuread_service_principal_key = optional(string, null)
    enterprise_application_key    = optional(string, null)
    azuread_group_key             = optional(string, null)
    object_id                     = optional(string, null)
    tenant_id                     = optional(string, null)
    key_permissions               = optional(list(string), null)
    secret_permissions            = optional(list(string), null)
    certificate_permissions       = optional(list(string), null)
    storage_permissions           = optional(list(string), null)
  }))
  validation {
    condition     = length(var.access_policies) <= 16
    error_message = "A maximun of 16 access policies can be set."
  }
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}
variable "azuread_groups" {
  description = "Azure AD groups"
  type        = any
  default     = {}
}
variable "azuread_apps" {
  description = "Azure AD applications"
  type        = any
  default     = {}
}
variable "resources" {
  description = "Resources that contain identity information"
  type        = any
  default     = {}
}
