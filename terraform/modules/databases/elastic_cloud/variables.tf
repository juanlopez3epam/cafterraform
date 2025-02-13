variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type = object({
    name                        = string
    sku_name                    = optional(string, null)
    elastic_cloud_email_address = optional(string, null)
  })
}
variable "resource_group" {
  description = "Resource group object"
  type        = any
}
