variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "Managed Identity settings object (see module README.md)"
  type        = any
}
variable "name" {
  description = "Name of the Managed Identity"
  type        = string
}
variable "resource_group" {
  description = "Resource group object"
  type        = any
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = null
}
variable "tags" {
  description = "(optional) Map of tags to be applied to the resource"
  type        = map(any)
  default     = null
}
