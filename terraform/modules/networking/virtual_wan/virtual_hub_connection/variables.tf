variable "settings" {
  description = "(Required) The settings object for the virtual hub connection"
  type        = any
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "virtual_hub_id" {
  description = "(Required) The ID of the virtual hub to which to connect"
  type        = string
}
variable "remote_virtual_network_id" {
  description = "(Required) The ID of the remote virtual network to connect to"
  type        = string
}
