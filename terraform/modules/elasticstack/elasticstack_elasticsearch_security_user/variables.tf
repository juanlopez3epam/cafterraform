variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}
variable "settings" {
  description = "The settings for the user"
  type = object({
    username     = string
    roles        = set(string)
    email        = optional(string, null)
    full_name    = optional(string, null)
    metadata     = optional(map(string), {})
    lz_key       = optional(string, null)
    password_key = optional(string, null)
    enabled      = optional(bool, true)
  })
}
variable "key_vault_secrets" {
  description = "Key Vault Secrets"
  type        = any
}
