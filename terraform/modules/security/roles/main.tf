terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
  }
  required_version = ">= 1.3.0"
}

locals {
  roles_to_process = {
    for mapping in
    flatten(
      [                                                               # Variable
        for key_mode, all_role_mapping in var.role_mapping : [        #  built_in_role_mapping = {
          for key, role_mappings in all_role_mapping : [              #       aks_clusters = {
            for scope_key_resource, role_mapping in role_mappings : [ #         seacluster = {
              #           lz_key = "remote_lz_key" if referencing remote landing zone
              for role_definition_name, resources in role_mapping : [ #           "Azure Kubernetes Service Cluster Admin Role" = {
                for object_id_key, object_resources in resources : [  #             azuread_group_keys = {
                  #               lz_key = "remote_lz_key" if referencing remote landing zone
                  for object_id_key_resource in object_resources.keys : #               keys = [ "aks_admins" ] ----End of variable
                  {                                                     # "seacluster_Azure_Kubernetes_Service_Cluster_Admin_Role_aks_admins" = {
                    mode                    = key_mode                  #   "mode" = "built_in_role_mapping"
                    scope_resource_key      = key
                    scope_lz_key            = try(role_mapping.lz_key, null)
                    scope_key_resource      = scope_key_resource
                    role_definition_name    = role_definition_name
                    object_id_resource_type = object_id_key
                    object_id_key_resource  = object_id_key_resource #   "object_id_key_resource" = "aks_admins"
                    object_id_lz_key        = try(object_resources.lz_key, null)
                    object_id_property      = try(object_resources.property_name, "rbac_id")
                  }
                ]
              ] if role_definition_name != "lz_key"
            ]
          ]
        ]
      ]
    ) : format("%s_%s_%s_%s_%s", mapping.object_id_resource_type, mapping.scope_resource_key, mapping.scope_key_resource, replace(mapping.role_definition_name, " ", "_"), mapping.object_id_key_resource) => mapping
  }

  services_roles = merge(var.services_roles, {
    logged_in = local.logged_in
  })

  landingzone_key = coalesce(var.client_config.landingzone_key, "local")

  logged_in = tomap(
    {
      (local.landingzone_key) = {
        user = {
          rbac_id = var.client_config.logged_user_object_id
        }
        app = {
          rbac_id = var.client_config.logged_aad_app_object_id
        }
      }
    }
  )
}
