variable "settings" {
  description = "(Required) The settings object for the virtual wan"
  type        = any
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
