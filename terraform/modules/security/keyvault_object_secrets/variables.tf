variable "settings" {
  description = "Key Vault Secret settings object (see module README.md)"
  type = object({
    app_registration_key = string
    keyvault_key         = string
  })
}
variable "keyvault" {
  description = "Key Vault object"
  type        = any
  default     = {}
}

variable "resources" {
  description = "Resources that contain identity information"
  type        = any
  default     = {}
}

variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}