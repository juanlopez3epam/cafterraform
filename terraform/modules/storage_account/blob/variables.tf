variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "storage_container_name" {
  description = "The name of the storage container."
  type        = string
}

variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type        = any
}
