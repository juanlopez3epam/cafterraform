variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Key Vault Key settings object (see module README.md)"
  type = object({
    name            = string
    key_type        = string
    key_size        = optional(number, null)
    key_opts        = list(string)
    curve           = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(string), {})
  })
}
variable "keyvault" {
  description = "Key Vault object"
  type        = any
  default     = {}
}
