terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.47.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.23"
    }
  }
  required_version = ">= 1.5.0"
}
