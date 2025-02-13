variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "name" {
  description = "(Required) Specifies the name of the Route resource. Changing this forces a new resource to be created."
  type        = string
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "route_table_name" {
  description = "(Required) The name of the Route Table where to create the Route."
  type        = string
}
variable "address_prefix" {
  description = "(Required) The destination CIDR to which the route applies."
  type        = string
}
variable "next_hop_type" {
  description = "(Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None."
  type        = string
}
variable "next_hop_in_ip_address_fw" {
  description = "(Optional) The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "next_hop_in_ip_address_vm" {
  description = "(Optional) The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "next_hop_in_ip_address" {
  description = "(Optional) The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
