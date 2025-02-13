locals {

keyvaults = {
  vault = {
    name               = "vault"
    resource_group_key = "security_re1"
    sku_name           = "standard"
    creation_policies = {
      logged_in_identity = {
        key_permissions = [
          "Get",
          "List",
          "Create",
          "Update",
          "Import",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge",
          "Encrypt",
          "Decrypt",
          "WrapKey",
          "UnwrapKey",
          "GetRotationPolicy",
          "SetRotationPolicy"
        ]
        secret_permissions = [
          "Get",
          "List",
          "Set",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge"
        ]
        certificate_permissions = [
          "Get",
          "List",
          "Create",
          "Update",
          "Import",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge",
          "ManageContacts",
          "ManageIssuers",
          "GetIssuers",
          "ListIssuers",
          "SetIssuers",
          "DeleteIssuers",
        ]
      }
    }
    diagnostic_profiles = {
      central_logs = {
        definition_key   = "keyvault"
        destination_type = "log_analytics"
        destination_key  = "central_logs_legacy"
      }
    }
    network = {
      bypass         = "AzureServices"
      default_action = "Deny"
      ip_rules       = var.network_restrictions_ip_rule_list
    }
    private_endpoints = {
      vault_kv_pe = {
        name = "vault-kv"
        subnet = {
          subnet_key = "pvt"
        }
        private_service_connection = {
          subresource_names = ["vault"]
        }
        private_dns = {
          pe = {
            dns_zone_key = "privatelink.vaultcore.azure.net"
            lz_key       = "core_lvl2"
          }
        }
      }
    }
  },
  postgres = {
    name               = "postgres"
    resource_group_key = "security_re1"
    sku_name           = "standard"
    creation_policies = {
      logged_in_identity = {
        key_permissions = [
          "Get",
          "List",
          "Create",
          "Update",
          "Import",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge",
          "Encrypt",
          "Decrypt",
          "WrapKey",
          "UnwrapKey",
          "GetRotationPolicy",
          "SetRotationPolicy"
        ]
        secret_permissions = [
          "Get",
          "List",
          "Set",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge"
        ]
        certificate_permissions = [
          "Get",
          "List",
          "Create",
          "Update",
          "Import",
          "Delete",
          "Recover",
          "Backup",
          "Restore",
          "Purge",
          "ManageContacts",
          "ManageIssuers",
          "GetIssuers",
          "ListIssuers",
          "SetIssuers",
          "DeleteIssuers",
        ]
      }
    }
    diagnostic_profiles = {
      central_logs = {
        definition_key   = "keyvault"
        destination_type = "log_analytics"
        destination_key  = "central_logs_legacy"
      }
    }
    network = {
      bypass         = "AzureServices"
      default_action = "Deny"
      ip_rules       = var.network_restrictions_ip_rule_list
    }
    private_endpoints = {
      postgres_kv_pe = {
        name = "postgres-kv"
        subnet = {
          subnet_key = "pvt"
        }
        private_service_connection = {
          subresource_names = ["vault"]
        }
        private_dns = {
          pe = {
            dns_zone_key = "privatelink.vaultcore.azure.net"
            lz_key       = "core_lvl2"
          }
        }
      }
    }
  }

}


dynamic_keyvault_secrets = {
  hdinsight_metastore_password = {
    keyvault_key = "kafka"
    secret_name  = "hdinsight-metastore-password"
    config = {
      length           = 128
      upper            = true
      numeric          = true
      special          = true
      override_special = "$#%"
    }
  }
}

}