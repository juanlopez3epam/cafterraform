variable "settings" {
  description = "Filesystem settings object (see module README.md)"
  type = object({
    name       = string
    properties = optional(map(string), {})
    owner      = optional(string, null)
    group      = optional(string, null)
  })
}
variable "storage_account_id" {
  description = "The ID of the storage account in which to create the filesystem. Changing this forces a new resource to be created."
  type        = string
}
