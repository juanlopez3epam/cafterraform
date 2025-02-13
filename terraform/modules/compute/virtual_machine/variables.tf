variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = null
}

variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)"
  default     = {}
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = any
  default     = {}
}

variable "settings" {
  description = "(Optional) Map of Azure Firewall settings"
  type        = any
}

variable "location" {
  description = "(Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the resource. Changing this forces a new resource to be created. "
  type        = string
}

variable "vnets" {
  description = "(Required) Map of VNet objects."
  type        = any
}

variable "network_security_groups" {
  description = "(Required) Map of Network Security Group objects."
  type        = any
}

variable "public_ip_addresses" {
  description = "Public IP addresses"
  type        = any
}

variable "keyvaults" {
  description = "Refernces to Keyvaults"
  type        = any
}

variable "disk_encryption_sets" {
  description = "Values for disk encryption sets"
  type        = any
  default     = {}
}

variable "image_definitions" {
  description = "Image definitions"
  type        = any
  default     = {}
}

variable "boot_diagnostics_storage_account" {
  description = "Boot diagnostics storage account"
  type        = any
  default     = ""
}

variable "managed_identities" {
  description = "Managed identities"
  type        = any
  default     = {}
}
