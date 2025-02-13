locals {
roles = {
  built_in_role_mapping = {
    aks_clusters = {
      cluster_re1 = {
        "Azure Kubernetes Service RBAC Cluster Admin" = {
          azuread_groups = {
            keys = []
          }
          object_ids = {
            keys = var.rbac-aad_group-object_id
          }
        }
      }
    }
    networking = {
      "vnet-01" = {
        lz_key = "local"
        "Network Contributor" = {
          aks_clusters = {
            keys = ["cluster_re1"]
          }
        }
      }
    }
    storage_accounts = {
      cluster_private_premium_files_pvcs = {
        "Storage Account Contributor" = {
          aks_clusters = {
            property_name = "cluster_identity_rbac_id"
            keys          = ["cluster_re1"]
          }
        }
      }
      cluster_private_standard_files_pvcs = {
        "Storage Account Contributor" = {
          aks_clusters = {
            property_name = "cluster_identity_rbac_id"
            keys          = ["cluster_re1"]
          }
        }
      }
      dbmanager_storage = {
        "Storage Blob Data Contributor" = {
          managed_identities = {
            keys = ["dbmanager_wi"]
          }
        }
      }
    }
    resource_groups = merge(
      {},
      var.create-public_ip_address-kong-lb ? {
        "vnet-01" = {
          lz_key = "local"
          "Network Contributor" = {
            aks_clusters = {
              property_name = "cluster_identity_rbac_id"
              keys          = ["cluster_re1"]
            }
          }
        }
      } : {}
    )

    external_resources = {
      (var.rbac-external_resources-acr) = {
        "AcrPull" = {
          aks_clusters = {
            keys = ["cluster_re1"]
          }
        }
      }
    }
  }
}

}