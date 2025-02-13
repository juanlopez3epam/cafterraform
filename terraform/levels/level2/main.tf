terraform {}

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

provider "azuread" {

}

# Leaving "default" for backwards-compat
data "azurerm_client_config" "default" {}
data "azurerm_client_config" "current" {}
data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_object_id == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}
