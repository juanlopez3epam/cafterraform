variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "name" {
  description = "(Required) Specifies the name of the Route Table resource. Changing this forces a new resource to be created."
  type        = string
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "disable_bgp_route_propagation" {
  description = "(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}
variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
  default     = {}
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = {}
}
