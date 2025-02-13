variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Resource group settings object (see module README.md)"
  type        = any
}
variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}
