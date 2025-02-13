terraform {

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
  }
}



provider "azuread" {

}
#tflint-ignore: terraform_unused_declarations
data "azurerm_client_config" "default" {}
