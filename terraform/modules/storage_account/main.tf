terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39.0"
    }
  }
  required_version = ">= 1.3.7"
}
