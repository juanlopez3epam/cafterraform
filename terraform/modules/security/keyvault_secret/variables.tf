variable "settings" {
  description = "Key Vault Secret settings object (see module README.md)"
  type = object({
    name            = string
    value           = string
    content_type    = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(string), {})
  })
  sensitive = true
}
variable "keyvault" {
  description = "Key Vault object"
  type        = any
  default     = {}
}
