terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.38"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.23"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.1"
    }
  }
  required_version = ">= 1.3.0"
}
