variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)"
  default     = {}
}
variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}
variable "logged_user_object_id" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_object_id" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}
# variable "remote_state" {
#   description = "Remote state object (see module README.md)"
#   type = object({
#     resource_group_name  = string
#     storage_account_name = string
#     container_name       = string
#     key                  = optional(string, "state")
#   })
# }
variable "provider_azurerm_features_keyvault" {
  type        = any
  description = "Provider azurerm features keyvault"
  default = {
    purge_soft_delete_on_destroy = true
  }
}

variable "resource_groups" {
  type        = any
  description = "Resource groups"
  default     = {}
}

variable "container_registries" {
  type        = any
  description = "Container registries"
  default     = {}
}

variable "virtual_networks" {
  type        = any
  description = "Virtual networks"
  default     = {}
}

variable "virtual_hub_connections" {
  type        = any
  description = "Virtual hub connections"
  default     = {}
}

variable "private_dns_zones" {
  type        = any
  description = "Private DNS Zones"
  default     = {}
}

variable "log_analytics" {
  description = "Log Analytics objects"
  type        = any
  default     = {}
}

variable "remote_state-resource_group_name" {
  description = "Level2 remote tf state resource group name"
  type        = string
  default     = ""
}

variable "remote_state-storage_account_name" {
  description = "Level2 remote tf state storage account name"
  type        = string
  default     = ""
}

variable "virtual_networks-vnet01-vnet-address_space" {
  description = "Address space for VNET"
  type        = list(any)
  default     = ["10.22.0.0/17"]
}

variable "virtual_networks-vnet01-dns-dns_server_ips" {
  description = "Address space for VNET"
  type        = list(any)
  default     = []
}

variable "virtual_networks-confluent-vnet-address_space" {
  description = "Address space for VNET"
  type        = list(any)
  default     = ["10.22.128.0/26"]
}
variable "ddos_protection_plan_enabled" {
  description = "Set to true to enable ddos_protection_plan" 
  type        = bool
  default     = false
}

variable "private_dns_zones-hdinsights-name" {
  description = "Private DNS for HDInsights"
  type        = string
  default     = "hdinsights.stamp-eastus.mi.sampleorg.io" #Replace stamp with env name
}
variable "private_dns_zones-postgres-name" {
  description = "Private DNS for Postgres"
  type        = string
  default     = "stamp-postgres.database.azure.com" #Replace stamp with env name
}
variable "create-public_ip_address-kong-lb" {
  description = "Create Public IP Address for Kong LB"
  type        = bool
  default     = false
}
variable "kong-lb-idle-timeout" {
  description = "Create Public IP Address for Kong LB"
  type        = number
  default     = 10
}