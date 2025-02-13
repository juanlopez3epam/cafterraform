variable "settings" {
  description = "Queue settings object (see module README.md)"
  type = object({
    name     = string
    metadata = optional(map(string), null)
  })
}
variable "storage_account_name" {
  description = "The name of the storage account in which to create the queue. Changing this forces a new resource to be created."
  type        = string
}
