variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
  type        = any
  default     = {}
}
variable "storage_account" {
  description = "Storage account object (see module README.md)."
  type = object({
    name                              = string
    region                            = optional(string, null)
    account_kind                      = optional(string, "StorageV2")
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "LRS")
    access_tier                       = optional(string, "Hot")
    allow_nested_items_to_be_public   = optional(bool, true)
    allowed_copy_scope                = optional(string, null)
    default_to_oauth_authentication   = optional(bool, false)
    edge_zone                         = optional(string, null)
    enable_https_traffic_only         = optional(bool, true)
    infrastructure_encryption_enabled = optional(bool, null)
    is_hns_enabled                    = optional(bool, false)
    large_file_share_enabled          = optional(bool, null)
    min_tls_version                   = optional(string, "TLS1_2")
    nfsv3_enabled                     = optional(bool, false)
    public_network_access_enabled     = optional(bool, true)
    queue_encryption_key_type         = optional(string, null)
    shared_access_key_enabled         = optional(bool, true)
    sftp_enabled                      = optional(bool, false) #requires is_hns_enabled = true
    table_encryption_key_type         = optional(string, null)
    tags                              = optional(map(string), null)
    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool, null)
    }), null)
    identity = optional(object({
      type = optional(string, "SystemAssigned") #"SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"

    }), null)
    static_website = optional(object({
      index_document     = optional(string, null)
      error_404_document = optional(string, null)
    }), null)
    network = optional(object({
      bypass         = optional(list(string), [])
      default_action = optional(string, "Deny")
      ip_rules       = optional(list(string), [])
      subnets = optional(map(object({
        remote_subnet_id = optional(string, null)
        #todo add lookup for subnet id using keys
        vnet_key   = optional(string, null)
        subnet_key = optional(string, null)
      })), null)
    }), null)
    containers = optional(map(object({
      name        = string
      access_type = optional(string, "private")
      metadata    = optional(map(string), null)
    })), {})
    data_lake_filesystems = optional(map(object({
      name        = string
      access_type = optional(string, "private")
      metadata    = optional(map(string), null)
    })), {})
    file_shares = optional(map(object({
      name             = string
      access_tier      = optional(string, null)
      quota            = optional(number, null)
      metadata         = optional(map(string), null)
      enabled_protocol = optional(string, null)
      acl = optional(map(object({
        id = string
        access_policy = optional(object({
          permissions = string
          start       = optional(string, null)
          expiry      = optional(string, null)
        }), null)
      })), {})
    })), {})
    queues = optional(map(object({
      name     = string
      metadata = optional(map(string), null)
    })), {})
    private_endpoints = optional(map(object({
      name = string
      subnet = object({
        lz_key     = optional(string, null)
        subnet_key = string
      })
      private_service_connection = object({
        is_manual_connection = optional(string, false)
        subresource_names    = list(string)
        request_message      = optional(string, null)
      })
      private_dns = map(object({
        dns_zone_key = string
        lz_key       = optional(string, null)
      }))
      tags = optional(map(string), {})
    })), null)
  })
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
#tflint-ignore: terraform_unused_declarations
variable "vnets" {
  description = "Virtual network objects (see module README.md)"
  type        = any
  default     = {}
}
variable "subnets" {
  description = "Subnets object"
  type        = any
  default     = {}
}
variable "dns_zones" {
  description = "DNS Zones Object"
  type        = any
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "resource_groups" {
  description = "Resource group objects (see module README.md)."
  type        = any
  default     = {}
}
#tflint-ignore: terraform_unused_declarations
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

#tflint-ignore: terraform_unused_declarations
variable "diagnostic_profiles" {
  description = "Diagnostic profile objects (see module README.md)"
  type        = any
  default     = {}
}

#tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  description = "Managed identity objects (see module README.md)"
  type        = any
  default     = {}
}
