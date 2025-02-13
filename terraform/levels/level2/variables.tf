# TO DO: cleanup unused vars once changes are working as expected
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
  default     = "core_lvl2"
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
variable "provider_azurerm_features_keyvault" {
  type        = any
  description = "Provider azurerm features keyvault"
  default = {
    purge_soft_delete_on_destroy = true
  }
}

# ==================================================================
# Tagging variables
# for more info refer: https://sampleorg.atlassian.net/wiki/spaces/GDO/pages/3094251696/Tagging+Policy
# ==================================================================
variable "tag_bussines_unit" {
  description = "Log analytics retention in days"
  type        = string
  default     = "Engineering" #Engineering | IT | Sales | Marketing | Legal | etc
}
variable "tag_cogs" {
  description = "Cogs"
  type        = string
  default     = "Yes"
}
variable "tag_cost_center" {
  description = "Cost Center"
  type        = string
  default     = ""
}
variable "tag_team" {
  description = "Team"
  type        = string
  default     = "DL-Eng-MIDevOps@sampleorg.com"
}
variable "tag_environment" {
  description = "Environment"
  type        = string
  default     = "Development"
}
# ==================================================================
# Log analytics variables
# ==================================================================
variable "log_analytics-law_platform-retention_in_days" {
  description = "Log analytics retention in days"
  type        = number
  default     = 90
}

# ==================================================================
# Jumpbox VM variables
# ==================================================================
variable "jumpbox-vm_settings-size" {
  description = "Jumpbox virtual machine size"
  type        = string
  default     = "Standard_F2s"
}
variable "jumpbox-vm_settings-sa_type" {
  description = "Jumpbox virtual machine storage account type"
  type        = string
  default     = "Standard_LRS"
}
variable "jumpbox-vm_settings-source_image-publisher" {
  description = "Jumpbox virtual machine source image publisher"
  type        = string
  default     = "canonical"
}
variable "jumpbox-vm_settings-source_image-offer" {
  description = "Jumpbox virtual machine source image offer"
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}
variable "jumpbox-vm_settings-source_image-sku" {
  description = "Jumpbox virtual machine source image sku"
  type        = string
  default     = "20_04-lts"
}
variable "jumpbox-vm_settings-source_image-version" {
  description = "Jumpbox virtual machine source image version"
  type        = string
  default     = "latest"
}

# ==================================================================
# KeyVault variables
# ==================================================================
variable "keyvault_access_policies-ssh_keys-aad_group-object_id" {
  description = "Object ID for KV access policies ssh keys common AAD group"
  type        = string
  default     = "3fabd666-ad4f-429f-b591-e33b1763b16e"
}
variable "keyvaults-ssh_keys-sku_name" {
  description = "SKu for ssh_keys KV"
  type        = string
  default     = "standard"
}
variable "keyvault_secrets" {
  description = "Key Vault Secret objects"
  type        = any
  default     = {}
}
variable "keyvault_keys" {
  description = "Key Vault Key objects"
  type        = any
  default     = {}
}
# ==================================================================
# Vnet variables
# ==================================================================
variable "virtual_networks01-vnet-address_space" {
  description = "Address space for VNET"
  type        = list(any)
  default     = ["10.51.0.0/24"]
}
variable "virtual_networks01-subnets-bastion-cidr" {
  description = "CIDR for bastion subnet"
  type        = list(any)
  default     = ["10.51.0.0/26"]
}
variable "virtual_networks01-subnets-jumpbox-cidr" {
  description = "CIDR for jumpbox subnet"
  type        = list(any)
  default     = ["10.51.0.64/26"]
}
variable "virtual_networks01-subnets-dns_resolver-cidr" {
  description = "CIDR for jumpbox subnet"
  type        = list(any)
  default     = ["10.51.0.128/26"]
}
# ==================================================================
# Routes variables
# ==================================================================
variable "jumpbox_route_table_enabled" {
  description = "Set to true to enable Jumpbox routes and route tables" 
  type        = bool
  default     = false
}
variable "routes-con-01_jumpbox-next_hop_in_ip_address" {
  description = "Next hop IP address for con-01_jumpbox route"
  type        = string
  default     = "10.50.0.132"
}
variable "routes-con-01_jumpbox2-name" {
  description = "Route name for con-01_jumpbox2"
  type        = string
  default     = "192.168.0.0"
}
variable "routes-con-01_jumpbox3-name" {
  description = "Route name for con-01_jumpbox3"
  type        = string
  default     = "10.0.0.0"
}
variable "routes-con-01_jumpbox4-name" {
  description = "Route name for con-01_jumpbox4"
  type        = string
  default     = "172.16.0.0"
}

# ==================================================================
# Networking variables
# ==================================================================
variable "virtual_hubs-vhub-address_prefix" {
  description = "Virtual hub address prefix"
  type        = string
  default     = "10.50.0.0/23"
}
variable "virtual_hubs-vhub-vnet_connections-internet_security_enabled" {
  description = "Virtual hub internet security"
  type        = bool
  default     = false
}
variable "firewall_enabled" {
  description = "Set to true to enable firewall and its policies" 
  type        = bool
  default     = false
}
variable "ddos_protection_plan_enabled" {
  description = "Set to true to enable ddos_protection_plan" 
  type        = bool
  default     = false
}
variable "firewalls-fw1-sku_tier" {
  description = "Firewall FW1 SKU tier" # TODO: Check if lower tier could work for other profiles
  type        = string
  default     = "Premium"
}
variable "firewalls-fw1-vhub-public_ip_count" {
  description = "Firewall vhub public ip count"
  type        = number
  default     = 20
}

variable "public_ip_addresses-bastion_host_rg1-sku" {
  description = "SKU for bastion host RG1 Public IP addresses" # TODO: Check if prod need to use Premium tier
  type        = string
  default     = "Standard"
}
variable "aks_dnat-stage_aks_kong_dnat_80-destination_address" {
  description = "AKS DNAT Destination IP address for Port 80"
  type        = string
  default     = "20.228.225.16"
}
variable "aks_dnat-stage_aks_kong_dnat_80-translated_address" {
  description = "AKS DNAT translated IP address for Port 80"
  type        = string
  default     = "20.121.145.14"
}
variable "aks_dnat-stage_aks_kong_dnat_443-destination_address" {
  description = "AKS DNAT Destination IP address for Port 443"
  type        = string
  default     = "20.228.225.16"
}
variable "aks_dnat-stage_aks_kong_dnat_443-translated_address" {
  description = "AKS DNAT translated IP address for Port 443"
  type        = string
  default     = "20.121.145.14"
}

variable "network_restrictions_ip_rule_list" {
  description = "List of IP rules for network restrictions"
  type        = list(string)
  default     = []
}