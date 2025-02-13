resource "azurerm_role_definition" "castai" {
  name        = local.role_name
  description = "Role used by CAST AI"
  count       = var.cast_ai_read_only ? 1 : 1

  scope = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}"

  permissions {
    actions = [
      "Microsoft.Compute/*/read",
      "Microsoft.Compute/virtualMachines/*",
      "Microsoft.Compute/virtualMachineScaleSets/*",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/delete",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/galleries/write",
      "Microsoft.Compute/galleries/delete",
      "Microsoft.Compute/galleries/images/write",
      "Microsoft.Compute/galleries/images/delete",
      "Microsoft.Compute/galleries/images/versions/write",
      "Microsoft.Compute/galleries/images/versions/delete",
      "Microsoft.Compute/snapshots/write",
      "Microsoft.Compute/snapshots/delete",
      "Microsoft.Network/*/read",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/networkInterfaces/delete",
      "Microsoft.Network/networkInterfaces/join/action",
      "Microsoft.Network/networkSecurityGroups/join/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/applicationGateways/backendhealth/action",
      "Microsoft.Network/applicationGateways/backendAddressPools/join/action",
      "Microsoft.Network/applicationSecurityGroups/joinIpConfiguration/action",
      "Microsoft.Network/loadBalancers/backendAddressPools/write",
      "Microsoft.Network/loadBalancers/backendAddressPools/join/action",
      "Microsoft.ContainerService/*/read",
      "Microsoft.ContainerService/managedClusters/start/action",
      "Microsoft.ContainerService/managedClusters/stop/action",
      "Microsoft.ContainerService/managedClusters/runCommand/action",
      "Microsoft.ContainerService/managedClusters/agentPools/*",
      "Microsoft.Resources/*/read",
      "Microsoft.Resources/tags/write",
      "Microsoft.Authorization/locks/read",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleDefinitions/read",
      "Microsoft.ManagedIdentity/userAssignedIdentities/assign/action"
    ]
    not_actions = []
  }

  assignable_scopes = distinct(compact(flatten([
    "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}",
    "/subscriptions/${var.subscription_id}/resourceGroups/${var.aks_node_rg}",
    var.additional_resource_groups
  ])))
}


resource "azurerm_role_assignment" "castai_rg" {
  count                            = var.cast_ai_read_only ? 1 : 1
  principal_id                     = var.castai_sp_id
  role_definition_id               = azurerm_role_definition.castai[0].role_definition_resource_id
  scope                            = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}"
  skip_service_principal_aad_check = true
  description                      = "castai"
}

resource "azurerm_role_assignment" "castai_node_rg" {
  count                            = var.cast_ai_read_only ? 1 : 1
  principal_id                     = var.castai_sp_id
  role_definition_id               = azurerm_role_definition.castai[0].role_definition_resource_id
  scope                            = "/subscriptions/${var.subscription_id}/resourceGroups/${var.aks_node_rg}"
  skip_service_principal_aad_check = true
  description                      = "castai"
}

resource "azurerm_role_assignment" "castai_additional_rgs" {
  for_each                         = var.cast_ai_read_only ? toset(var.additional_resource_groups) : toset(var.additional_resource_groups)
  principal_id                     = var.castai_sp_id
  role_definition_id               = azurerm_role_definition.castai[0].role_definition_resource_id
  scope                            = each.key
  skip_service_principal_aad_check = true
  description                      = "castai" 
}

// Azure AD

# data "azuread_client_config" "current" {}

# resource "azuread_application" "castai" {
#   count        = var.cast_ai_read_only ? 0: 1
#   display_name = "test-mdm-castai"
#   owners       = [data.azuread_client_config.current.object_id]
# }

# resource "azuread_application_password" "castai" {
#     count       = var.cast_ai_read_only ? 0 : 1
#     application_object_id = azuread_application.castai[0].object_id
# }

# resource "azuread_service_principal" "castai" {
#     count       = var.cast_ai_read_only ? 0 : 1
#     application_id = azuread_application.castai[0].application_id
#     app_role_assignment_required = false
#     owners = [data.azuread_client_config.current.object_id]
# }