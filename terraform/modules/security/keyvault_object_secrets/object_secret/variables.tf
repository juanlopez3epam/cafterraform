variable "settings" {
  description = "Key Vault Secret settings object (see module README.md)"
  type = object({
    content_type    = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(string), {})
  })
  sensitive = true
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "name" {
  description = "Name of the Secret"
  type        = string
}

variable "value" {
  description = "value of the Secret"
  type        = string
}
