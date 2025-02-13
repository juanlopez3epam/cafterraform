terraform {

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
  }
}
provider "elasticstack" {
  elasticsearch {
    endpoints = [local.consolidated_objects_elastic_cloud_deployments[local.provider_elasticstack_elasticsearch.lz_key][local.provider_elasticstack_elasticsearch.cluster_key].elasticsearch_endpoint]
    username  = local.consolidated_objects_elastic_cloud_deployments[local.provider_elasticstack_elasticsearch.lz_key][local.provider_elasticstack_elasticsearch.cluster_key].elasticsearch_username
    password  = local.consolidated_objects_elastic_cloud_deployments[local.provider_elasticstack_elasticsearch.lz_key][local.provider_elasticstack_elasticsearch.cluster_key].elasticsearch_password
  }
}

provider "azuread" {}

data "terraform_remote_state" "level4" {
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

data "azurerm_client_config" "current" {}
data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_object_id == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}
