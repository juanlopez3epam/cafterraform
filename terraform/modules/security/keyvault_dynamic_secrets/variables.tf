variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Key Vault Secret settings object (see module README.md)"
  type = object({
    keyvault_key = string
    secret_name  = string
    config = object({
      length           = optional(number, 128)
      upper            = optional(bool, true)
      numeric          = optional(bool, true)
      special          = optional(bool, true)
      min_lower        = optional(number, 1)
      min_numeric      = optional(number, 1)
      min_special      = optional(number, 1)
      min_upper        = optional(number, 1)
      override_special = optional(string, "")
    })
  })
  sensitive = true
}
variable "keyvault" {
  description = "Key Vault object"
  type        = any
  default     = {}
}
