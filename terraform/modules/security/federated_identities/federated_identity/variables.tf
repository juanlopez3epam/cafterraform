variable "global_settings" {
  description = "Global settings"
  type        = any
}
variable "settings" {
  description = "Settings"
  type = object({
    name     = string
    audience = optional(list(string), null)
    subject  = string
  })
}
variable "parent_id" {
  description = "Parent ID"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
variable "issuer" {
  description = "Issuer Uri"
  type        = string
  default     = null
}
