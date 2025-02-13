resource "azurecaf_name" "stg" {
  name          = var.storage_account.name
  resource_type = "azurerm_storage_account"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_storage_account" "stg" {
  name                              = azurecaf_name.stg.result
  resource_group_name               = var.resource_group_name
  location                          = var.global_settings.regions[coalesce(var.storage_account.region, var.global_settings.default_region)]
  account_tier                      = var.storage_account.account_tier
  account_replication_type          = var.storage_account.account_replication_type
  account_kind                      = var.storage_account.account_kind
  access_tier                       = var.storage_account.access_tier
  allow_nested_items_to_be_public   = var.storage_account.allow_nested_items_to_be_public
  allowed_copy_scope                = var.storage_account.allowed_copy_scope
  default_to_oauth_authentication   = var.storage_account.default_to_oauth_authentication
  edge_zone                         = var.storage_account.edge_zone
  enable_https_traffic_only         = var.storage_account.enable_https_traffic_only
  infrastructure_encryption_enabled = var.storage_account.infrastructure_encryption_enabled
  is_hns_enabled                    = var.storage_account.is_hns_enabled
  large_file_share_enabled          = var.storage_account.large_file_share_enabled
  min_tls_version                   = var.storage_account.min_tls_version
  nfsv3_enabled                     = var.storage_account.nfsv3_enabled
  public_network_access_enabled     = var.storage_account.public_network_access_enabled
  queue_encryption_key_type         = var.storage_account.queue_encryption_key_type
  sftp_enabled                      = var.storage_account.sftp_enabled
  shared_access_key_enabled         = var.storage_account.shared_access_key_enabled
  table_encryption_key_type         = var.storage_account.table_encryption_key_type
  tags                              = var.storage_account.tags

  dynamic "custom_domain" {
    for_each = try(var.storage_account.custom_domain[*], [])
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "identity" {
    for_each = try(var.storage_account.identity[*], [])
    content {
      type = identity.value.type
    }
  }

  dynamic "static_website" {
    for_each = try(var.storage_account.static_website[*], [])
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  dynamic "network_rules" {
    for_each = try(var.storage_account.network[*], [])
    content {
      bypass         = network_rules.value.bypass
      default_action = network_rules.value.default_action
      ip_rules       = network_rules.value.ip_rules
      virtual_network_subnet_ids = try(network_rules.value.subnets, null) == null ? [] : [
        for key, value in network_rules.value.subnets : try(value.remote_subnet_id, null) != null ? value.remote_subnet_id : var.vnets[value.vnet_key].subnets[value.subnet_name].id
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "container" {
  source   = "./container"
  for_each = var.storage_account.containers

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "data_lake_filesystem" {
  source   = "./data_lake_filesystem"
  for_each = var.storage_account.data_lake_filesystems

  storage_account_id = azurerm_storage_account.stg.id
  settings           = each.value
}

module "file_share" {
  source   = "./file_share"
  for_each = var.storage_account.file_shares

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "queue" {
  source   = "./queue"
  for_each = var.storage_account.queues

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "private_endpoints" {
  source              = "../networking/private_endpoint"
  depends_on          = [azurerm_storage_account.stg]
  for_each            = try(var.storage_account.private_endpoints, null) != null ? var.storage_account.private_endpoints : {}
  resource_id         = azurerm_storage_account.stg.id
  global_settings     = var.global_settings
  client_config       = var.client_config
  subnets             = var.subnets
  dns_zones           = var.dns_zones
  resource_group_name = azurerm_storage_account.stg.resource_group_name
  location            = azurerm_storage_account.stg.location
  settings            = each.value
}
