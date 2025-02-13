locals {
  gateway_username        = var.settings.gateway.username
  head_node_username      = var.settings.roles.head_node.username
  worker_node_username    = var.settings.roles.worker_node.username
  zookeeper_node_username = var.settings.roles.zookeeper_node.username
}

# create public/private key pairs
resource "tls_private_key" "head_node_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "worker_node_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "zookeeper_node_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurecaf_name" "kafka" {
  name          = var.settings.name
  resource_type = "azurerm_hdinsight_kafka_cluster"
  prefixes      = try(var.settings.naming_convention.cluster_name.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.cluster_name.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.cluster_name.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.cluster_name.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.cluster_name.use_slug, try(var.global_settings.use_slug, null))
}

resource "azurerm_hdinsight_kafka_cluster" "kafka" {
  name                = azurecaf_name.kafka.result
  resource_group_name = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].name
  location            = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].location
  cluster_version     = try(var.settings.cluster_version, null)
  tier                = var.settings.tier
  tls_min_version     = var.settings.tls_min_version

  tags = local.tags

  component_version {
    kafka = try(var.settings.component_version, null)
  }

  gateway {
    username = local.gateway_username
    password = var.settings.gateway.password == null ? random_password.gateway.result : var.settings.gateway.password
  }

  storage_account {
    storage_container_id = var.storage_accounts[var.client_config.landingzone_key][var.settings.storage_account_key].containers[var.settings.container_key].url
    storage_account_key  = var.storage_accounts[var.client_config.landingzone_key][var.settings.storage_account_key].primary_access_key
    is_default           = true
  }

  # Log Analytics is optional.
  dynamic "extension" {
    for_each = try(var.settings.log_analytics_workspace_key, null) != null ? [1] : []
    content {
      log_analytics_workspace_id = var.diagnostics.log_analytics_workspaces[var.settings.log_analytics_workspace_key].workspace_id
      primary_key                = var.diagnostics.log_analytics_workspaces[var.settings.log_analytics_workspace_key].primary_shared_key
    }
  }

  # hardening, enable disk encryption (use MMK with default encyption)
  disk_encryption {
    encryption_at_host_enabled = var.settings.encryption.at_host_enabled
  }

  # hardening, ensure data transfer is encrypted as well
  encryption_in_transit_enabled = var.settings.encryption.in_transit_enabled

  roles {
    head_node {
      vm_size            = try(var.settings.roles.head_node.vm_size, null)
      username           = local.head_node_username
      ssh_keys           = [tls_private_key.head_node_key.public_key_openssh]
      virtual_network_id = var.settings.vnet_key == null ? null : var.vnets[var.settings.vnet_key].id
      subnet_id          = var.settings.vnet_subnet_key == null ? null : var.vnets[var.settings.vnet_key].subnets[var.settings.vnet_subnet_key].id
    }

    worker_node {
      vm_size                  = try(var.settings.roles.worker_node.vm_size, null)
      username                 = local.worker_node_username
      ssh_keys                 = [tls_private_key.worker_node_key.public_key_openssh]
      number_of_disks_per_node = coalesce(var.settings.roles.worker_node.number_of_disks_per_node, 3)
      target_instance_count    = coalesce(var.settings.roles.worker_node.target_instance_count, 3)
      virtual_network_id       = var.settings.vnet_key == null ? null : var.vnets[var.settings.vnet_key].id
      subnet_id                = var.settings.vnet_subnet_key == null ? null : var.vnets[var.settings.vnet_key].subnets[var.settings.vnet_subnet_key].id
    }

    zookeeper_node {
      vm_size            = try(var.settings.roles.zookeeper_node.vm_size, null)
      username           = local.zookeeper_node_username
      ssh_keys           = [tls_private_key.zookeeper_node_key.public_key_openssh]
      virtual_network_id = var.settings.vnet_key == null ? null : var.vnets[var.settings.vnet_key].id
      subnet_id          = var.settings.vnet_subnet_key == null ? null : var.vnets[var.settings.vnet_key].subnets[var.settings.vnet_subnet_key].id
    }
  }


  dynamic "metastores" {
    for_each = var.settings.metastores == null ? toset([]) : toset([1])
    content {
      dynamic "hive" {
        for_each = var.settings.metastores.hive == null ? toset([]) : toset([1])

        content {
          server        = var.mssql_servers[var.client_config.landingzone_key][var.settings.metastores.hive.server_key].fully_qualified_domain_name
          database_name = var.settings.metastores.hive.database_name
          username      = var.settings.metastores.hive.username
          password      = var.key_vault_secrets[var.settings.metastores.hive.password_keyvault_secret_key].value
        }
      }
      dynamic "oozie" {
        for_each = var.settings.metastores.oozie == null ? toset([]) : toset([1])

        content {
          server        = var.mssql_servers[var.client_config.landingzone_key][var.settings.metastores.oozie.server_key].fully_qualified_domain_name
          database_name = var.settings.metastores.oozie.database_name
          username      = var.settings.metastores.oozie.username
          password      = var.key_vault_secrets[var.settings.metastores.oozie.password_keyvault_secret_key].value
        }
      }
      dynamic "ambari" {
        for_each = var.settings.metastores.ambari == null ? toset([]) : toset([1])

        content {
          server        = var.mssql_servers[var.client_config.landingzone_key][var.settings.metastores.ambari.server_key].fully_qualified_domain_name
          database_name = var.settings.metastores.ambari.database_name
          username      = var.settings.metastores.ambari.username
          password      = var.key_vault_secrets[var.settings.metastores.ambari.password_keyvault_secret_key].value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = []
  }
  timeouts {
    create = "90m"  # default is 60 mins
  }
}

resource "random_password" "gateway" {
  length           = var.settings.administrator_password_configuration.length
  upper            = var.settings.administrator_password_configuration.upper
  numeric          = var.settings.administrator_password_configuration.numeric
  special          = var.settings.administrator_password_configuration.special
  min_lower        = var.settings.administrator_password_configuration.min_lower
  min_numeric      = var.settings.administrator_password_configuration.min_numeric
  min_special      = var.settings.administrator_password_configuration.min_special
  min_upper        = var.settings.administrator_password_configuration.min_upper
  override_special = var.settings.administrator_password_configuration.override_special
}

resource "azurerm_key_vault_secret" "gateway_password" {
  name         = format("%s-gateway-password", azurecaf_name.kafka.result)
  value        = random_password.gateway.result
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "gateway_username" {
  name         = format("%s-gateway-username", azurecaf_name.kafka.result)
  value        = local.gateway_username
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "head_node_public_ssh_key" {
  name         = format("%s-head-node-public-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.head_node_key.public_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "head_node_private_ssh_key" {
  name         = format("%s-head-node-private-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.head_node_key.private_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "head_node_username" {
  name         = format("%s-head-node-username", azurecaf_name.kafka.result)
  value        = local.head_node_username
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "worker_node_public_ssh_key" {
  name         = format("%s-worker-node-public-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.worker_node_key.public_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "worker_node_private_ssh_key" {
  name         = format("%s-worker-node-private-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.worker_node_key.private_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}


resource "azurerm_key_vault_secret" "worker_node_username" {
  name         = format("%s-worker-node-username", azurecaf_name.kafka.result)
  value        = local.worker_node_username
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "zookeeper_node_public_ssh_key" {
  name         = format("%s-zookeeper-node-public-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.zookeeper_node_key.public_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "zookeeper_node_private_ssh_key" {
  name         = format("%s-zookeeper-node-private-ssh-key-base64", azurecaf_name.kafka.result)
  value        = base64encode(tls_private_key.zookeeper_node_key.private_key_openssh)
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "zookeeper_node_username" {
  name         = format("%s-zookeeper-node-username", azurecaf_name.kafka.result)
  value        = local.zookeeper_node_username
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "random_password" "keystore" {
  length           = var.settings.administrator_password_configuration.keystore_length
  upper            = var.settings.administrator_password_configuration.upper
  numeric          = var.settings.administrator_password_configuration.numeric
  special          = var.settings.administrator_password_configuration.special
  min_lower        = var.settings.administrator_password_configuration.min_lower
  min_numeric      = var.settings.administrator_password_configuration.min_numeric
  min_special      = var.settings.administrator_password_configuration.min_special
  min_upper        = var.settings.administrator_password_configuration.min_upper
  override_special = var.settings.administrator_password_configuration.override_special
}


resource "azurerm_key_vault_secret" "keystore_password" {
  name         = format("%s-keystore-password", azurecaf_name.kafka.result)
  value        = random_password.keystore.result
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "kafka_ca_key_base64" {
  name         = "kafka-ca-key-base64"
  value        = "value"
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "kafka_ca_cert_base64" {
  name         = "kafka-ca-cert-base64"
  value        = "value"
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}
