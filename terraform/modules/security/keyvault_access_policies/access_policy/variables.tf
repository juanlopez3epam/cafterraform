variable "keyvault_id" {
  description = "The ID of the Key Vault to which the access policy should be applied."
  type        = string
}
variable "tenant_id" {
  description = "The ID of the tenant to which the access policy should be applied."
  type        = string
}
variable "object_id" {
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
  type        = string
}
variable "access_policy" {
  description = "The access policy to apply to the Key Vault."
  type = object({
    key_permissions         = optional(list(string), null)
    secret_permissions      = optional(list(string), null)
    certificate_permissions = optional(list(string), null)
    storage_permissions     = optional(list(string), null)
  })
}
