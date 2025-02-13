variable "settings" {
  description = "File share settings object (see module README.md)"
  type = object({
    name             = string
    access_tier      = optional(string, null)
    quota            = optional(number, null)
    metadata         = optional(map(string), null)
    enabled_protocol = optional(string, null)
    acl = optional(map(object({
      id = string
      access_policy = optional(object({
        permissions = string
        start       = optional(string, null)
        expiry      = optional(string, null)
      }), null)
    })), {})
  })
}
variable "storage_account_name" {
  description = "The name of the storage account in which to create the file share. Changing this forces a new resource to be created."
  type        = string
}
