variable "settings" {
  description = "Container settings object (see module README.md)"
  type = object({
    name        = string
    access_type = optional(string, "private")
    metadata    = optional(map(string), null)
  })
}
variable "storage_account_name" {
  description = "The name of the storage account in which to create the container. Changing this forces a new resource to be created."
  type        = string
}
