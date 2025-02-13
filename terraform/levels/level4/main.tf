terraform {

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
  }
}

provider "azurerm" {
  alias                      = "vhub"
  skip_provider_registration = true
  features {}
  subscription_id = data.azurerm_client_config.default.subscription_id
  tenant_id       = data.azurerm_client_config.default.tenant_id
}

provider "azurerm" {
  alias                      = "gh_runner"
  skip_provider_registration = true
  features {}
  subscription_id            = var.confluent_cloud_deployments-runner_subscription_id  #subscription id where runners are hosted
}

data "azurerm_subnet" "runner_subnet" {
  provider             = azurerm.gh_runner
  name                 = "default"
  resource_group_name  = var.elastic_cloud_deployments-runner_resource_group
  virtual_network_name = var.confluent_cloud_deployments-runner_vnet
}

provider "azuread" {
}

data "azurerm_client_config" "current" {}
data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_object_id == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}

data "terraform_remote_state" "level3" {
  backend = "azurerm"
  config = {
    resource_group_name  = local.remote_state.resource_group_name
    storage_account_name = local.remote_state.storage_account_name
    container_name       = local.remote_state.container_name
    key                  = local.remote_state.key
    subscription_id      = var.global_settings.default_subscription_id
    tenant_id            = var.global_settings.tenant_id
  }
}

provider "castai" {
   api_url   = var.castai_api_url
   api_token = var.castai_api_token
 }
